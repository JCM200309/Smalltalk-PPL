!classDefinition: #MachineTest category: #'Smalltalk-PPL-Tests'!
TestCase subclass: #MachineTest
	instanceVariableNames: 'runner machine'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Tests'!

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:59:35 am (UTC)'!
dummyMachineWithControlStack: aControlStack

^ Machine new
		initMachineWithControlStack: aControlStack
		withValueStack: nil 
		withEnvVar: nil 
		withRng: nil
		withLogW: 0.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 3:09:56 pm (UTC)'!
evalAST: anAST
	
	^ self evalAST: anAST withEnvironment: Dictionary new! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 3:09:56 pm (UTC)'!
evalAST: anAST withEnvironment: anEnvironment
	
	machine := self dummyMachineWithControlStack: {Eval expression: anAST withEnvironment: anEnvironment andAddress: #().}.
	
	^ (machine resumeRunner: runner) value! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 5/Jul/2026, 11:39:13 pm (UTC)'!
setUp
	runner := SSMHRunner new.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:54:21 pm (UTC)'!
test01EvalLiteral
	
	self assert: (self evalAST: 100) equals: 100.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 3:09:56 pm (UTC)'!
test02EvalSymbol

	self assert: (self evalAST: #y withEnvironment: {#y -> 42} asDictionary) equals: 42.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:55:47 pm (UTC)'!
test03EvalIfTrue

	self assert: (self evalAST: #(if true 2 1)) equals: 2.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:56:18 pm (UTC)'!
test04EvalIfFalse

	self assert: (self evalAST: #(if false 2 1)) equals: 1.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:57:51 pm (UTC)'!
test05EvalLet
	
	self assert: (self evalAST: #(let (#x 1) #x)) equals: 1.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:59:17 pm (UTC)'!
test06EvalLetMultipleBindings
	
	self assert: (self evalAST: #(let (#x 2 #y 5) #y)) equals: 5.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 3:07:13 pm (UTC)'!
test07EvalDiscard

	self assert: (self evalAST: #(let (#x 1) 10 99)) equals: 99.! !
