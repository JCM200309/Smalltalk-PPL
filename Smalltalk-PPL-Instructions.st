!classDefinition: #Closure category: #'Smalltalk-PPL-Instructions'!
Object subclass: #Closure
	instanceVariableNames: 'parameters body environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 7/8/2026 04:39:18'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| newEnv |
	newEnv := environment copy.
	
	1 to: arguments size do: [:index | newEnv at: (parameters at: index) put: (arguments at: index)].
	
	aMachine pushBody: body withEnvironment: newEnv andAddress: address.! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 14:36:17'!
body

	^body! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 14:36:07'!
environment

	^ environment 
	! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 14:35:38'!
initializeWithParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment
	
	parameters := aParametersCollection.
	body := aBody.
	environment := anEnvironment.
	
	^ self! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 14:36:01'!
parameters

	^parameters 
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Closure class' category: #'Smalltalk-PPL-Instructions'!
Closure class
	instanceVariableNames: ''!

!Closure class methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 14:35:12'!
withParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment

	^ self new initializeWithParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment! !


!classDefinition: #Instruction category: #'Smalltalk-PPL-Instructions'!
Object subclass: #Instruction
	instanceVariableNames: 'address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 10:27:43'!
address

	^ address! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 10:28:01'!
address: anAddress
	
	address := anAddress.
	^ self! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 10:27:29'!
executeOn: aMachine runner: aRunner
	
	self subclassResponsibility! !


!classDefinition: #Call category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Call
	instanceVariableNames: 'count'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Call methodsFor: 'as yet unclassified' stamp: 'L.C 7/8/2026 14:53:34'!
executeOn: aMachine runner: aRunner
	
	| arguments operator |
	
	arguments := aMachine popValues: count.
	operator := aMachine popValue.
	
	"primitivas"
	operator isSymbol ifTrue: [ aMachine pushValue: (aMachine executePrimitive: operator withArguments: arguments). ^self].
	
	operator applyArguments: arguments onMachine: aMachine atAddress: address.

	^self! !

!Call methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 15:38:43'!
initializeExpecting: aCount at: anAddress

	count := aCount.
	address := anAddress.
	
	^ self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Call class' category: #'Smalltalk-PPL-Instructions'!
Call class
	instanceVariableNames: ''!

!Call class methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 15:37:59'!
expecting: aCount at: anAddress

	^ self new initializeExpecting: aCount at: anAddress! !


!classDefinition: #Discard category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Discard
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Discard methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 10:41:48'!
executeOn: aMachine runner: aRunner
	
	aMachine popValue.
	^ self! !


!classDefinition: #Eval category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Eval
	instanceVariableNames: 'expression environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Eval methodsFor: 'as yet unclassified' stamp: 'L.C 7/8/2026 15:04:26'!
executeOn: aMachine runner: aRunner

	| head binds body parameters count |

	expression isSymbol ifTrue: [	
		(environment includesKey: expression) 
			ifTrue: [aMachine pushValue: (environment at: expression)] 
			ifFalse: [
				(#(+ - * / = #normal) includes: expression) "FALTAN PRIMITIVAS están en miniPPL"
					ifTrue: [ aMachine pushValue: expression]
					ifFalse: [ self error: 'NameError: ' , expression asString]
				]. 
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
			aMachine pushControl: (Let binds: binds withIndex: 1 andBody: body andEnvironment: environment andAddress: address).
			aMachine pushControl: (Eval expression: (binds at: 2) withEnvironment: environment andAddress: (address , {#let. 1})).
			^ self
		].
		aMachine pushBody: body withEnvironment: environment andAddress: address.
		^ self
	].
	
	head == #fn ifTrue: [
		parameters := expression at: 2.
		body := expression copyFrom: 3 to: expression size.
		aMachine pushValue: (Closure withParameters: parameters andBody: body andEnvironment: environment).
		^ self.
	].

	head == #sample ifTrue: [
		aMachine pushControl: (Sample withAddress: address).
		aMachine pushControl: (Eval 
			expression: (expression at: 2) 
			withEnvironment: environment 
			andAddress: (address,{#d})).
		^ self ].

	head == #observe ifTrue: [
		aMachine pushControl: (Observe withAddress: address).
		aMachine pushControl: (Eval 
			expression: (expression at: 3) 
			withEnvironment: environment 
			andAddress: (address , {#v})).
		aMachine pushControl: (Eval 
			expression: (expression at: 2) 
			withEnvironment: environment 
			andAddress: (address , {#d})).
		^ self].


	count := expression size-1.
	aMachine pushControl: (Call expecting: count at: address).
	
	expression size to: 2 by: -1 do: [ :index |
		aMachine pushControl: (Eval 
			expression: (expression at: index) 
			withEnvironment: environment 
			andAddress: (address , {index-2}))].
		
	aMachine pushControl: (Eval 
		expression: expression first
		withEnvironment: environment
		andAddress: (address , {#fn})).
	^ self! !

!Eval methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 11:01:48'!
initExpression: anExpression withEnvironment: anEnvironment andAddress: anAddress

	expression := anExpression.
	environment := anEnvironment.
	address := anAddress.
	
	^ self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Eval class' category: #'Smalltalk-PPL-Instructions'!
Eval class
	instanceVariableNames: ''!

!Eval class methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 11:03:52'!
expression: anExpression withEnvironment: anEnvironment andAddress: anAddress
	
	^ self new initExpression: anExpression withEnvironment: anEnvironment andAddress: anAddress.! !


!classDefinition: #If category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #If
	instanceVariableNames: 'then else environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!If methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 11:40:14'!
executeOn: aMachine runner: aRunner
	
	| branch tag |
	
	aMachine popValue 
		ifTrue: [branch := then. tag := #then] 
		ifFalse: [branch := else. tag := #else].
	
	aMachine pushControl: (Eval expression: branch withEnvironment: environment andAddress: (address , {tag})).
	
	^ self! !

!If methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 11:43:20'!
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

!If class methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 11:41:59'!
then: aThenExpression else: anElseExpression withEnvironment: anEnvironment andAddress: anAddress

	^ self new initThen: aThenExpression else: anElseExpression withEnvironment: anEnvironment andAddress: anAddress! !


!classDefinition: #Let category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Let
	instanceVariableNames: 'bindings index body environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 7/8/2026 00:21:13'!
executeOn: aMachine runner: aRunner

	| newEnv nextIndex value varName |
	value := aMachine popValue.
	varName := bindings at: index.
	
	newEnv := environment copy.
	newEnv at: varName put: value.
	
	nextIndex := index+2.
	
	nextIndex <= bindings size ifTrue: [
			aMachine pushControl: (Let 
				binds: bindings 
				withIndex: nextIndex 
				andBody: body 
				andEnvironment: newEnv 
				andAddress: address).
			
			aMachine pushControl: (Eval 
				expression: (bindings at: (nextIndex+1))
				withEnvironment: newEnv 
				andAddress: (address,{#let. nextIndex}))
		] ifFalse: [
			aMachine pushBody: body withEnvironment: newEnv andAddress: address.
		].
	
	^ self! !

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 11:26:08'!
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

!Let class methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 11:24:35'!
binds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress

	^ self new initBinds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress! !


!classDefinition: #Observe category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Observe
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Observe methodsFor: 'as yet unclassified' stamp: 'L.C 7/7/2026 20:57:58'!
executeOn: aMachine runner: aRunner
	
	| d y |
	y := aMachine popValue.
	d := aMachine popValue.

	^ aRunner observeWithAddress: address withDistribution: d withObservedValue: y.! !

!Observe methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 23:09:14'!
initializeWithAddress: anAddress

	address := anAddress! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Observe class' category: #'Smalltalk-PPL-Instructions'!
Observe class
	instanceVariableNames: ''!

!Observe class methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 23:08:59'!
withAddress: anAddress

	^ self new initializeWithAddress: anAddress! !


!classDefinition: #Sample category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Sample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Sample methodsFor: 'as yet unclassified' stamp: 'L.C 7/7/2026 20:58:09'!
executeOn: aMachine runner: aRunner

	^ aRunner sampleWithAddress: address withDistribution: aMachine popValue.! !

!Sample methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 23:09:20'!
initializeWithAddress: anAddress

	address := anAddress! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sample class' category: #'Smalltalk-PPL-Instructions'!
Sample class
	instanceVariableNames: ''!

!Sample class methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 23:08:51'!
withAddress: anAddress

	^ self new initializeWithAddress: anAddress! !
(Smalltalk at: #qq__ ifAbsentPut: [OrderedCollection new]) add: (#(74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 99 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 62 61 59 56 53 112 116 104 110 108 17 94 112 117 58 57 17 61 53 57 17 95 61 59 17 86 119 108 117 39 90 116 104 115 115 123 104 115 114 39 74 118 110 98 90 119 124 121 100 39 93 84 39 98 83 112 125 108 91 128 119 112 117 110 74 118 80 117 123 108 121 119 121 108 123 108 121 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 100 17 94 112 117 107 118 126 122 17 94 112 117 58 57 39 105 124 112 115 123 39 118 117 39 84 104 121 39 39 56 39 57 55 57 60 39 55 56 65 55 59 65 57 57 39 78 84 91 39 74 118 116 119 112 115 108 121 65 39 59 53 57 53 56 39 74 118 116 119 104 123 112 105 115 108 39 74 115 104 117 110 39 63 53 55 53 56 39 47 123 104 110 122 54 89 76 83 76 72 90 76 102 63 55 56 54 109 112 117 104 115 48 17 83 112 125 108 91 128 119 112 117 110 74 118 80 117 123 108 121 119 121 108 123 108 121 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 39 124 124 112 107 65 39 57 61 104 55 55 106 105 106 52 58 56 60 107 52 59 106 108 107 52 104 108 60 105 52 61 60 55 58 60 56 56 61 58 106 58 62 39 84 104 121 39 39 56 39 57 55 57 60 17 83 112 125 108 91 128 119 112 117 110 74 118 110 112 123 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 39 124 124 112 107 65 39 57 61 104 55 55 106 105 106 52 58 56 60 107 52 59 106 108 107 52 104 108 60 105 52 61 60 55 58 60 56 56 61 58 106 58 62 39 84 104 121 39 39 56 39 57 55 57 60 17 93 84 65 39 57 55 57 60 56 55 55 61 56 64 58 59 39 111 108 121 117 104 117 71 84 104 106 73 118 118 114 52 87 121 118 52 107 108 52 79 108 121 117 104 117 52 57 53 115 118 106 104 115 65 75 118 106 124 116 108 117 123 122 54 93 84 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 39 75 104 123 108 65 39 84 118 117 39 86 106 123 39 61 39 56 57 65 58 59 65 57 56 39 57 55 57 60 39 74 118 116 116 112 123 79 104 122 111 65 39 108 107 58 60 59 63 61 39 87 115 124 110 112 117 122 65 39 57 55 57 60 56 55 55 61 56 64 58 59 39 111 108 121 117 104 117 71 84 104 106 73 118 118 114 52 87 121 118 52 107 108 52 79 108 121 117 104 117 52 57 53 115 118 106 104 115 65 75 118 106 124 116 108 117 123 122 54 93 84 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 17 179 38 231 8 17 56 62 57 53 58 56 53 57 57 59 53 56 17 94 80 85 75 86 94 90 52 80 77 55 89 59 91 55 53 116 122 111 118 116 108 53 117 108 123 17 94 80 85 75 86 94 90 52 80 77 55 89 59 91 55 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 59 91 57 56 65 56 57 65 57 62 53 63 61 62 56 58 64 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 126 117 115 118 104 107 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 53 122 123 17 59 56 62 63 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 55 65 57 62 65 55 60 53 62 62 64 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 47 60 48 53 122 123 17 58 61 55 61 56 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 55 65 57 62 65 55 62 53 64 60 62 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 52 80 117 122 123 121 124 106 123 112 118 117 122 53 122 123 17 57 56 62 61 58 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 55 65 57 62 65 55 64 53 57 64 55 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 52 84 112 117 112 87 87 83 53 122 123 17 56 57 62 55 63 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 55 65 57 62 65 56 55 53 63 58 56 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 52 91 108 122 123 122 53 122 123 17 56 59 63 61 60 17 52 52 52 52 52 52 52 52 52 52 17 17 52 52 52 52 52 52 52 52 52 52 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 59 91 57 58 65 55 55 65 60 62 53 62 58 58 64 62 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 53 122 123 17 61 62 63 62 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 55 65 60 60 65 56 64 53 62 55 55 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 119 121 118 105 104 121 53 122 123 17 60 57 55 60 56 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 56 65 58 57 65 55 57 53 61 56 56 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 123 108 122 123 53 122 123 17 60 57 62 55 62 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 56 65 59 62 65 56 60 53 58 55 55 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 53 122 123 17 60 58 55 58 58 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 63 91 55 55 65 59 58 65 58 55 53 62 57 64 59 57 60 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 53 122 123 17 60 58 59 64 64 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 63 91 56 60 65 55 62 65 56 57 53 61 57 56 58 55 64 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 53 122 123 17 60 58 58 59 61 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 63 91 56 60 65 55 62 65 56 62 53 56 63 61 58 55 64 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 52 91 108 122 123 122 53 122 123 17 61 55 64 61 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 63 91 56 60 65 55 62 65 57 57 53 60 55 55 58 55 64 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 52 80 117 122 123 121 124 106 123 112 118 117 122 53 122 123 17 56 57 57 59 60 17 52 52 52 52 52 52 52 52 52 52 17 17))!