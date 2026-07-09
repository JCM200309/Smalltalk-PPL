!classDefinition: #Closure category: #'Smalltalk-PPL-Instructions'!
Object subclass: #Closure
	instanceVariableNames: 'parameters body environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 7:39:18 am (UTC)'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| newEnv |
	newEnv := environment copy.
	
	1 to: arguments size do: [:index | newEnv at: (parameters at: index) put: (arguments at: index)].
	
	aMachine pushBody: body withEnvironment: newEnv andAddress: address.! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 5:36:17 pm (UTC)'!
body

	^body! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 5:36:07 pm (UTC)'!
environment

	^ environment 
	! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 5:35:38 pm (UTC)'!
initializeWithParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment
	
	parameters := aParametersCollection.
	body := aBody.
	environment := anEnvironment.
	
	^ self! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 5:36:01 pm (UTC)'!
parameters

	^parameters 
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Closure class' category: #'Smalltalk-PPL-Instructions'!
Closure class
	instanceVariableNames: ''!

!Closure class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 5:35:12 pm (UTC)'!
withParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment

	^ self new initializeWithParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment! !


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

!Instruction methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 9:23:12 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnviroment andAddress: anAddress

	self subclassResponsibility! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 1:27:29 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	self subclassResponsibility! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 10:03:20 pm (UTC)'!
isCollection

	^true! !


!classDefinition: #Call category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Call
	instanceVariableNames: 'count'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Call methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026, 7:50:55 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	| arguments operator |
	arguments := aMachine popValues: count.
	operator := aMachine popValue.
	
	"primitivas"
	operator isSymbol ifTrue: [ aMachine pushValue: (aMachine executePrimitive: operator withArguments: arguments). ^self].
	
	operator applyArguments: arguments onMachine: aMachine atAddress: address.

	^self! !

!Call methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 6:38:43 pm (UTC)'!
initializeExpecting: aCount at: anAddress

	count := aCount.
	address := anAddress.
	
	^ self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Call class' category: #'Smalltalk-PPL-Instructions'!
Call class
	instanceVariableNames: ''!

!Call class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 6:37:59 pm (UTC)'!
expecting: aCount at: anAddress

	^ self new initializeExpecting: aCount at: anAddress! !


!classDefinition: #CallFunction category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #CallFunction
	instanceVariableNames: 'function arguments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!CallFunction methodsFor: 'Instance Creation' stamp: 'jcm 9/Jul/2026, 5:33:54 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: anAddress

	| count |

	count := arguments size.

	aMachine pushControl: (Call expecting: count at: anAddress).

	arguments size to: 1 by: -1 do: [ :index |
		aMachine pushControl: (Eval
			expression: (arguments at: index)
			withEnvironment: anEnvironment
			andAddress: (anAddress , {index - 1}))
	].

	aMachine pushControl: (Eval
		expression: function
		withEnvironment: anEnvironment
		andAddress: (anAddress , {#operator})).

	^ self! !

!CallFunction methodsFor: 'Instance Creation' stamp: 'jcm 9/Jul/2026, 5:32:15 pm (UTC)'!
withFunction: aFunction withArguments: aCollectionOfArguments
	
	function  := aFunction.
	arguments  := aCollectionOfArguments ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CallFunction class' category: #'Smalltalk-PPL-Instructions'!
CallFunction class
	instanceVariableNames: ''!

!CallFunction class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026, 5:31:38 pm (UTC)'!
withFunction: aFunction withArguments: aCollectionOfArguments

	^self new withFunction: aFunction withArguments: aCollectionOfArguments
	
		! !


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

!Eval methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026, 7:59:41 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	"| binds body count head parameters |"
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
	
	expression evalWithMachine: aMachine withEnvironment: environment  andAddress: address.
	^self
	
	"
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
	^ self "
	! !

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


!classDefinition: #Fn category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Fn
	instanceVariableNames: 'parameters body'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Fn methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026, 3:46:26 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnvironment  andAddress: anAddress


	aMachine pushValue: (Closure withParameters: parameters andBody: body andEnvironment: anEnvironment)
	
	! !


!Fn methodsFor: 'Instance Creation' stamp: 'jcm 9/Jul/2026, 3:51:24 pm (UTC)'!
withParameters: aCollectionOfParamters andBody: aBodyFunction
	
	parameters := aCollectionOfParamters.
	body := aBodyFunction.
	
	^self ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Fn class' category: #'Smalltalk-PPL-Instructions'!
Fn class
	instanceVariableNames: ''!

!Fn class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026, 3:50:40 pm (UTC)'!
withParameters: aCollectionOfParamaters andBody: aBodyFunction

	^self new withParameters: aCollectionOfParamaters andBody: aBodyFunction
	
		! !


!classDefinition: #If category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #If
	instanceVariableNames: 'condition then else environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!If methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 8:54:50 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnviroment andAddress: anAddress

	aMachine pushControl: (If then: (self then) else: (self else) withEnvironment: anEnviroment andAddress: anAddress).
	aMachine pushControl: (Eval expression: (self condition) withEnvironment: anEnviroment andAddress: (anAddress , {#test})).
	
	^ self! !

!If methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:40:14 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	| branch tag |
	
	aMachine popValue 
		ifTrue: [branch := then. tag := #then] 
		ifFalse: [branch := else. tag := #else].
	
	aMachine pushControl: (Eval expression: branch withEnvironment: environment andAddress: (address , {tag})).
	
	^ self! !

!If methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 8:11:47 pm (UTC)'!
initCondition: aConditionToEvaluate then: aThenExpression else: anElseExpression

	condition := aConditionToEvaluate.
	then := aThenExpression.
	else := anElseExpression.
	
	^self! !

!If methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:43:20 pm (UTC)'!
initThen: aThenExpression else: anElseExpression withEnvironment: anEnvironment andAddress: anAddress

	then := aThenExpression.
	else  := anElseExpression.
	environment := anEnvironment.
	address := anAddress.
	
	^ self! !


!If methodsFor: 'Getters' stamp: 'jcm 8/Jul/2026, 8:03:27 pm (UTC)'!
condition

	^condition! !

!If methodsFor: 'Getters' stamp: 'jcm 8/Jul/2026, 8:03:16 pm (UTC)'!
else

	^else! !

!If methodsFor: 'Getters' stamp: 'jcm 8/Jul/2026, 8:03:10 pm (UTC)'!
then

	^then! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'If class' category: #'Smalltalk-PPL-Instructions'!
If class
	instanceVariableNames: ''!

!If class methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 8:11:51 pm (UTC)'!
condition: aConditionToEvaluate then: aThenExpression else: anElseExpression

	^ self new initCondition: aConditionToEvaluate then: aThenExpression else: anElseExpression! !

!If class methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 9:10:19 pm (UTC)'!
isCollection
	"TODO: REVISAR Parche "
	^true! !

!If class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:41:59 pm (UTC)'!
then: aThenExpression else: anElseExpression withEnvironment: anEnvironment andAddress: anAddress

	^ self new initThen: aThenExpression else: anElseExpression withEnvironment: anEnvironment andAddress: anAddress! !


!classDefinition: #Let category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Let
	instanceVariableNames: 'bindings index body environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Let methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 9:35:59 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnviroment andAddress: anAddress

		bindings isEmpty ifFalse: [
			aMachine pushControl: (Let binds: bindings withIndex: 1 andBody: body andEnvironment: anEnviroment andAddress: anAddress ).
			aMachine pushControl: (Eval expression: (bindings at: 2) withEnvironment: anEnviroment andAddress: (anAddress , {#let. 1})).
			^ self
		].
		aMachine pushBody: body withEnvironment: environment andAddress: address.
		^ self! !

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 3:21:13 am (UTC)'!
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

!Let methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 9:39:57 pm (UTC)'!
initBinds: aBindCollection withBody: aBody 

	bindings := aBindCollection.
	body := aBody.
	
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

!Let class methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 9:41:39 pm (UTC)'!
initBinds: aBindCollection withBody: aBody 

	^self new initBinds: aBindCollection withBody: aBody ! !


!classDefinition: #Observe category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Observe
	instanceVariableNames: 'distribution observedValue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Observe methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026, 8:04:23 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: anAddress

	address := anAddress.
	
	aMachine pushControl: (Observe withAddress: address).
		aMachine pushControl: (Eval 
			expression: (observedValue) 
			withEnvironment: anEnvironment 
			andAddress: (address , {#v})).
		aMachine pushControl: (Eval 
			expression: (distribution) 
			withEnvironment: anEnvironment 
			andAddress: (address , {#d})).
		^ self! !

!Observe methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 11:57:58 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	| d y |
	y := aMachine popValue.
	d := aMachine popValue.

	^ aRunner observeWithAddress: address withDistribution: d withObservedValue: y.! !

!Observe methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:09:14 am (UTC)'!
initializeWithAddress: anAddress

	address := anAddress! !


!Observe methodsFor: 'Instance Creation' stamp: 'jcm 9/Jul/2026, 8:01:52 pm (UTC)'!
withDistribution: aDistribution withObservedValue: anObservedValue
	
	distribution := aDistribution.
	observedValue:= anObservedValue .
	
	^self
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Observe class' category: #'Smalltalk-PPL-Instructions'!
Observe class
	instanceVariableNames: 'distribution observedValue'!

!Observe class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:08:59 am (UTC)'!
withAddress: anAddress

	^ self new initializeWithAddress: anAddress! !


!Observe class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026, 8:01:08 pm (UTC)'!
withDistribution: aDistribution withObservedValue: anObservedValue

	^self new withDistribution: aDistribution withObservedValue: anObservedValue
	
	
	! !


!classDefinition: #Sample category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Sample
	instanceVariableNames: 'distribution'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Sample methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026, 7:49:07 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: anAddress

	address := anAddress.

	aMachine pushControl: self.
	aMachine pushControl: (Eval 
			expression: distribution
			withEnvironment: anEnvironment 
			andAddress: (address,{#d})).
	^ self! !

!Sample methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 11:58:09 pm (UTC)'!
executeOn: aMachine runner: aRunner

	^ aRunner sampleWithAddress: address withDistribution: aMachine popValue.! !

!Sample methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:09:20 am (UTC)'!
initializeWithAddress: anAddress

	address := anAddress! !


!Sample methodsFor: 'Instance Creation' stamp: 'jcm 9/Jul/2026, 7:40:27 pm (UTC)'!
withDistribution: aDistribution 
	
	
	distribution := aDistribution .
	
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sample class' category: #'Smalltalk-PPL-Instructions'!
Sample class
	instanceVariableNames: ''!

!Sample class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:08:51 am (UTC)'!
withAddress: anAddress

	^ self new initializeWithAddress: anAddress! !


!Sample class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026, 7:39:20 pm (UTC)'!
withDistribution: aDistribution 

	^self new withDistribution: aDistribution 
	! !
