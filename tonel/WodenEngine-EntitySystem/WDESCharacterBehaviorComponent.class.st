Class {
	#name : #WDESCharacterBehaviorComponent,
	#superclass : #WDESBehaviorComponent,
	#traits : 'TEnvironmentSensitiveBehavior',
	#classTraits : 'TEnvironmentSensitiveBehavior classTrait',
	#instVars : [
		'headAngle',
		'linearVelocity',
		'linearAcceleration',
		'linearViscosity',
		'collisionShape',
		'ghostObject',
		'physicsCharacterController',
		'headOrientation',
		'bodyOrientation',
		'headAngularVelocity',
		'walkingInGround',
		'running',
		'isUnderwater',
		'isHeadUnderwater'
	],
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #accessing }
WDESCharacterBehaviorComponent class >> halfExtent [
	^ WMVector3D x: 0.3 y: 0.9 z: 0.3
]

{ #category : #accessing }
WDESCharacterBehaviorComponent class >> headPosition [
	^ WMVector3F y: self halfExtent y * 0.9
]

{ #category : #notifications }
WDESCharacterBehaviorComponent >> addedToPhysicsWorld: physicsWorld [
	physicsWorld addGhostObject: self validGhostObject.
	physicsWorld addCharacterController: self validPhysicsCharacterController.
	ghostObject sceneNode: ownerEntity.
	
]

{ #category : #testing }
WDESCharacterBehaviorComponent >> canFly [
	^ false
]

{ #category : #testing }
WDESCharacterBehaviorComponent >> canSwim [
	^ true
]

{ #category : #initialization }
WDESCharacterBehaviorComponent >> createCollisionShape [
	collisionShape := WDPhyCapsuleYCollisionShape new halfExtent: self halfExtent; yourself
]

{ #category : #initialization }
WDESCharacterBehaviorComponent >> createGhostObject [
	ghostObject := WDPhyGhostObjectWithPairCache new.
	ghostObject
		makeCharacterCollisionObject;
		shape: self validCollisionShape
]

{ #category : #initialization }
WDESCharacterBehaviorComponent >> createPhysicsCharacterController [
	physicsCharacterController := WDPhyCharacterController new
		ghostObject: ghostObject;
		shape: collisionShape;
		preSimulationAction: [ :delta |
			self prePhysicsTick: delta
		];
		postSimulationAction: [ :delta :body |
			self postPhysicsTick: delta
		];
		yourself.
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> globalHeadPosition [
	^ ownerEntity globalTransform transformPosition3: self headPosition
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> halfExtent [
	^ self class halfExtent
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> headPosition [
	^ self class headPosition
]

{ #category : #initialization }
WDESCharacterBehaviorComponent >> initialize [
	super initialize.
	headAngle := WMVector3F zero.
	headAngularVelocity := WMVector3F zero.
	
	bodyOrientation := WMMatrix3F identity.
	headOrientation := WMMatrix3F identity.
	
	linearViscosity := 10.0.
	linearVelocity := WMVector3F zero.
	linearAcceleration := WMVector3F zero.
	walkingInGround := true.
	running := false.
	isUnderwater := false.
	isHeadUnderwater := false.
]

{ #category : #testing }
WDESCharacterBehaviorComponent >> isCharacterBehaviorComponent [
	^ true
]

{ #category : #simulation }
WDESCharacterBehaviorComponent >> isCurrentlyWalking [
	(self canSwim and: [isUnderwater]) ifTrue: [ ^ false ].
	
	^ walkingInGround
]

{ #category : #testing }
WDESCharacterBehaviorComponent >> isTickingComponent [
	^ true
]

{ #category : #actions }
WDESCharacterBehaviorComponent >> jump [
	physicsCharacterController jump
]

{ #category : #events }
WDESCharacterBehaviorComponent >> onUnderwaterVolume: underwaterVolumeComponent [
	isUnderwater := true.
	isHeadUnderwater := isHeadUnderwater or: [underwaterVolumeComponent ownerEntity sceneNode globalBoundingBox includesPoint: self globalHeadPosition].
]

{ #category : #simulation }
WDESCharacterBehaviorComponent >> postPhysicsTick: delta [
	ownerEntity transform: (WMReversibleAffineTransformF identity
		orthonormal: bodyOrientation translation: ghostObject position).
	
	ownerEntity findCameraSceneNodeComponentOrNil ifNotNil: [ :cameraNodeComponent |
		cameraNodeComponent validSceneNode
			transform: (WMReversibleAffineTransformF identity
				orthonormal: headOrientation translation: self headPosition)
	].
]

{ #category : #simulation }
WDESCharacterBehaviorComponent >> prePhysicsTick: delta [
	| accel speedMultiplier |
	headAngle := headAngle + (headAngularVelocity * delta).
	headAngle x: (headAngle x min: Float halfPi max: Float halfPi negated).
	
	self isCurrentlyWalking ifTrue: [ 
		bodyOrientation := WMMatrix3F yrot: headAngle y.
		headOrientation := WMMatrix3F xrot: headAngle x.
		linearAcceleration y: 0.0.
	] ifFalse: [ 
		bodyOrientation := (WMMatrix3F yrot: headAngle y) * (WMMatrix3F xrot: headAngle x).
		headOrientation := WMMatrix3F identity.
	].

	speedMultiplier := running ifTrue: [ 4.0 ] ifFalse: [ 2.0 ].
	accel := (bodyOrientation transformVector3: linearAcceleration*linearViscosity*speedMultiplier).
	accel := accel - (linearVelocity*linearViscosity).
	
	linearVelocity := linearVelocity + (accel*delta).

	ghostObject
		orientation: bodyOrientation;
		position: ownerEntity transform translation.
	physicsCharacterController
		buoyancy: (isUnderwater ifTrue: [ 8.8 ] ifFalse: [0.0]);
		linearVelocity: linearVelocity.

	"If we are underwater, then before the postPhysicsTick, this will be set to true."
	isUnderwater := false.
	isHeadUnderwater := false.
]

{ #category : #notifications }
WDESCharacterBehaviorComponent >> removedFromPhysicsWorld: physicsWorld [
	ghostObject ifNotNil: [ physicsWorld removeGhostObject: ghostObject ].
	physicsCharacterController ifNotNil: [ physicsWorld removeCharacterController: physicsCharacterController ].
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> running [
	^ running
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> running: anObject [
	running := anObject
]

{ #category : #simulation }
WDESCharacterBehaviorComponent >> tick: delta [

]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> validCollisionShape [
	collisionShape ifNil: [self createCollisionShape].
	^ collisionShape
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> validGhostObject [
	ghostObject ifNil: [ self createGhostObject ].
	^ ghostObject
]

{ #category : #accessing }
WDESCharacterBehaviorComponent >> validPhysicsCharacterController [
	physicsCharacterController ifNil: [self createPhysicsCharacterController].
	^ physicsCharacterController
]