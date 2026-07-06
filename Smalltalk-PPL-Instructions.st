!classDefinition: #Instruction category: #'Smalltalk-PPL-Instructions'!
Object subclass: #Instruction
	instanceVariableNames: 'address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 1:27:43 pm (UTC)'!
address

	^ address! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 1:28:01 pm (UTC)'!
address: anAddress
	
	address := anAddress.
	^ self! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 1:27:29 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	self subclassResponsibility! !


!classDefinition: #Discard category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Discard
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Discard methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 1:41:48 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	aMachine popValue.
	^ self! !


!classDefinition: #Eval category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Eval
	instanceVariableNames: 'expression environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Eval methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 3:00:49 pm (UTC)'!
executeOn: aMachine runner: aRunner

	| head binds body|

	expression isSymbol ifTrue: [
		(environment includesKey: expression) 
			ifTrue: [aMachine pushValue: (environment at: expression)] 
			ifFalse: [self error: 'NameError: ' , expression asString]. 
		^ self].
	
	expression isCollection ifFalse: [
		aMachine pushValue: expression. 
		^ self
	].
	
	head := expression first.
	
	head == #if ifTrue: [
		aMachine pushControl: (If then: (expression at: 3) else: (expression at: 4) withEnvironment: environment andAddress: address).
		aMachine pushControl: (Eval expression: (expression at: 2) withEnvironment: environment andAddress: (address , {#test})).
		^ self
	].

	head == #let ifTrue: [
		binds := expression at: 2.
		body := expression copyFrom: 3 to: expression size.
		
		binds isEmpty ifFalse: [
			aMachine pushControl: (Let binds: binds withIndex: 0 andBody: body andEnvironment: environment andAddress: address).
			aMachine pushControl: (Eval expression: (binds at: 2) withEnvironment: environment andAddress: (address , {#let. 0})).
			^ self
		].
		self pushBody: body withEnvironment: environment andAddress: address.
		^ self
	].

	^ self! !

!Eval methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:01:48 pm (UTC)'!
initExpression: anExpression withEnvironment: anEnvironment andAddress: anAddress

	expression := anExpression.
	environment := anEnvironment.
	address := anAddress.
	
	^ self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Eval class' category: #'Smalltalk-PPL-Instructions'!
Eval class
	instanceVariableNames: ''!

!Eval class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:03:52 pm (UTC)'!
expression: anExpression withEnvironment: anEnvironment andAddress: anAddress
	
	^ self new initExpression: anExpression withEnvironment: anEnvironment andAddress: anAddress.! !


!classDefinition: #If category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #If
	instanceVariableNames: 'then else environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!If methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:40:14 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	| branch tag |
	
	aMachine popValue 
		ifTrue: [branch := then. tag := #then] 
		ifFalse: [branch := else. tag := #else].
	
	aMachine pushControl: (Eval expression: branch withEnvironment: environment andAddress: (address , {tag})).
	
	^ self! !

!If methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:43:20 pm (UTC)'!
initThen: aThenExpression else: anElseExpression withEnvironment: anEnvironment andAddress: anAddress

	then := aThenExpression.
	else  := anElseExpression.
	environment := anEnvironment.
	address := anAddress.
	
	^ self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'If class' category: #'Smalltalk-PPL-Instructions'!
If class
	instanceVariableNames: ''!

!If class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:41:59 pm (UTC)'!
then: aThenExpression else: anElseExpression withEnvironment: anEnvironment andAddress: anAddress

	^ self new initThen: aThenExpression else: anElseExpression withEnvironment: anEnvironment andAddress: anAddress! !


!classDefinition: #Let category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Let
	instanceVariableNames: 'bindings index body environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:34:29 pm (UTC)'!
executeOn: aMachine runner: aRunner

	| newEnv nextIndex value varName |
	value := aMachine popValue.
	varName := bindings at: (2*index)+1.
	
	newEnv := environment copy.
	newEnv at: varName put: value.
	
	nextIndex := index+1.
	
	2*nextIndex < bindings size ifTrue: [
			aMachine pushControl: (Let 
				binds: bindings 
				withIndex: nextIndex 
				andBody: body 
				andEnvironment: newEnv 
				andAddress: address).
			
			aMachine pushControl: (Eval 
				expression: (bindings at: (nextIndex*2)+2) 
				withEnvironment: newEnv 
				andAddress: (address,{#let. (nextIndex*2)}))
		] ifFalse: [
			aMachine pushBody: body withEnvironment: newEnv andAddress: address.
		].
	
	^ self! !

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:26:08 pm (UTC)'!
initBinds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress

	bindings := aBindCollection.
	index := anIndex.
	body := aBody.
	environment := anEnvironment.
	address := anAddress.
	
	^ self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Let class' category: #'Smalltalk-PPL-Instructions'!
Let class
	instanceVariableNames: ''!

!Let class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:24:35 pm (UTC)'!
binds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress

	^ self new initBinds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress! !
