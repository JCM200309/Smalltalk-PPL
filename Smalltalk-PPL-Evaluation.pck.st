'From Cuis7.5 [latest update: #7641] on 10 July 2026 at 12:07:08 am'!
'Description '!
!provides: 'Smalltalk-PPL-Evaluation' 1 1!
SystemOrganization addCategory: #'Smalltalk-PPL-Evaluation'!


!classDefinition: #Signaling category: #'Smalltalk-PPL-Evaluation'!
Object subclass: #Signaling
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Evaluation'!
!classDefinition: 'Signaling class' category: #'Smalltalk-PPL-Evaluation'!
Signaling class
	instanceVariableNames: ''!


!Object methodsFor: '*Smalltalk-PPL-Evaluation' stamp: 'L.C 7/9/2026 23:42:53'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: anAddress

	aMachine pushValue: self.! !

!Symbol methodsFor: '*Smalltalk-PPL-Evaluation' stamp: 'L.C 7/9/2026 23:44:03'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: anAddress

	(anEnvironment includesKey: self) 
		ifTrue: [aMachine pushValue: (anEnvironment at: self)] 
		ifFalse: [self error: 'NameError: ',self asString].! !
