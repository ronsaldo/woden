Class {
	#name : #WDELevelEditorSelection,
	#superclass : #Object,
	#instVars : [
		'selectedItems'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #requirements }
WDELevelEditorSelection class >> empty [
	^ self new
]

{ #category : #'instance creation' }
WDELevelEditorSelection class >> for: selectedItems [
	^ self new selectedItems: selectedItems
]

{ #category : #initialization }
WDELevelEditorSelection >> initialize [
	super initialize.
	selectedItems := #().
]

{ #category : #accessing }
WDELevelEditorSelection >> selectedItems [
	^ selectedItems
]

{ #category : #accessing }
WDELevelEditorSelection >> selectedItems: anObject [
	selectedItems := anObject
]