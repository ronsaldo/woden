Class {
	#name : #WDGSLevelEditorSceneView,
	#superclass : #WDASceneView,
	#instVars : [
		'panel'
	],
	#category : #'WodenEngine-LevelEditor-View'
}

{ #category : #'as yet unclassified' }
WDGSLevelEditorSceneView >> filterForCameraViewport: aCamera [
	^ [ :object | object model isNil or: [ object model visibleForView: panel ] ]
]

{ #category : #accessing }
WDGSLevelEditorSceneView >> panel [
	^ panel
]

{ #category : #accessing }
WDGSLevelEditorSceneView >> panel: anObject [
	panel := anObject
]

{ #category : #'rendering process stages' }
WDGSLevelEditorSceneView >> prepareRendering [
	panel updateCameraStateForRendering.
	super prepareRendering
]

{ #category : #'rendering process stages' }
WDGSLevelEditorSceneView >> updateForFrameDelta: delta [
	super updateForFrameDelta: delta.
	panel simulateCameraMovement: delta
]