'From Cuis7.5 [latest update: #7641] on 10 July 2026 at 11:03:58 am'!
'Description '!
!provides: 'SmalltalkPPL-Evaluation' 1 0!
SystemOrganization addCategory: 'SmalltalkPPL-Evaluation'!


!classDefinition: #Signaling category: 'SmalltalkPPL-Evaluation'!
Object subclass: #Signaling
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Evaluation'!
!classDefinition: 'Signaling class' category: 'SmalltalkPPL-Evaluation'!
Signaling class
	instanceVariableNames: ''!


!Object methodsFor: '*SmalltalkPPL-Evaluation' stamp: 'L.C 7/9/2026 23:42:53'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: anAddress

	aMachine pushValue: self.! !

!Object methodsFor: '*SmalltalkPPL-Evaluation' stamp: 'L.C 7/10/2026 09:21:21'!
ifRunnerSignal: aBlock

	^self! !

!Symbol methodsFor: '*SmalltalkPPL-Evaluation' stamp: 'L.C 7/9/2026 23:44:03'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: anAddress

	(anEnvironment includesKey: self) 
		ifTrue: [aMachine pushValue: (anEnvironment at: self)] 
		ifFalse: [self error: 'NameError: ',self asString].! !
