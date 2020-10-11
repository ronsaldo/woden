Class {
	#name : #WDESectorLayer,
	#superclass : #WDELevelElement,
	#instVars : [
		'sector',
		'defaultMinZ',
		'defaultMaxZ',
		'entities'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #visiting }
WDESectorLayer >> accept: visitor [
	^ visitor visitSectorLayer: self
]

{ #category : #adding }
WDESectorLayer >> addEntity: anEntity [
	self assert: anEntity sectorLayer isNil.
	entities add: anEntity.
	anEntity sectorLayer: self.
]

{ #category : #accessing }
WDESectorLayer >> children [
	^ entities
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createEntityWithClassName: className [
	^ WDEEntity new
		className: className;
		yourself
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createPointEntity: entityClassName at: entityLocation [
	| entity |
	entity := self createEntityWithClassName: entityClassName.
	entity position: entityLocation.
	self addEntity: entity
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createSolidEntity: entityClassName box: box color: color [
	| center localBox |
	center := box center.
	localBox := box translatedBy: center negated. 

	self addEntity: ((self createEntityWithClassName: entityClassName)
		position: center;
		localBoundingBox: localBox;
		addComponent: (WDEVisualComponent box: localBox color: color);
		addComponent: (WDECollisionComponent box: localBox);
		yourself)
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createSolidEntity: entityClassName rectangle: rectangle color: color [
	| center localRectangle |
	center := rectangle center.
	localRectangle := rectangle translatedBy: center negated. 

	self addEntity: ((self createEntityWithClassName: entityClassName)
		position: center;
		localBoundingRectangle: localRectangle;
		addComponent: (WDEVisualComponent rectangle: localRectangle color: color);
		addComponent: (WDECollisionComponent rectangle: localRectangle);
		yourself)
]

{ #category : #accessing }
WDESectorLayer >> defaultMaxZ [
	^ defaultMaxZ
]

{ #category : #accessing }
WDESectorLayer >> defaultMaxZ: anObject [
	defaultMaxZ := anObject
]

{ #category : #accessing }
WDESectorLayer >> defaultMinZ [
	^ defaultMinZ
]

{ #category : #accessing }
WDESectorLayer >> defaultMinZ: anObject [
	defaultMinZ := anObject
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> defaultThickness: defaultThickness [
	self
		defaultMinZ: defaultThickness * -0.5;
		defaultMaxZ: defaultThickness * 0.5
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> defaultZ [
	^ defaultMinZ + ((defaultMaxZ  - defaultMinZ) /2)
]

{ #category : #accessing }
WDESectorLayer >> entities [
	^ entities
]

{ #category : #initialization }
WDESectorLayer >> initialize [
	super initialize.
	entities := OrderedCollection new.
	defaultMinZ := -1.0.
	defaultMaxZ := -1.0.
]

{ #category : #testing }
WDESectorLayer >> isInSector2D [
	^ sector isSector2D
]

{ #category : #testing }
WDESectorLayer >> isSectorLayer [
	^ true
]

{ #category : #accessing }
WDESectorLayer >> sector [
	^ sector
]

{ #category : #accessing }
WDESectorLayer >> sector: anObject [
	sector := anObject
]