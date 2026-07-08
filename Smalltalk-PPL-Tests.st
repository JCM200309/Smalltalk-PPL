!classDefinition: #DistributionTest category: #'Smalltalk-PPL-Tests'!
TestCase subclass: #DistributionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Tests'!

!DistributionTest methodsFor: 'normal' stamp: 'L.C 7/7/2026 21:02:28'!
test01LogProb

	| dist prob |
	dist := NormalDistribution withMean: 0.0 standardDeviation: 1.0 randomGenerator: nil.
	
	prob := dist logarithmicProbabilityWith: 0.0.
	
	self assert: ((prob - (-0.918938)) abs < 0.0001)! !

!DistributionTest methodsFor: 'normal' stamp: 'L.C 7/6/2026 22:57:17'!
test02Sample

	| distribution randomMock sample |
	randomMock := ReadStream on: #(0.5 0.5).
	
	distribution := NormalDistribution withMean: 10.0 standardDeviation: 2.0 randomGenerator: randomMock.
	sample := distribution sample.
	
	self assert: sample class equals: SmallFloat64.! !


!classDefinition: #MachineTest category: #'Smalltalk-PPL-Tests'!
TestCase subclass: #MachineTest
	instanceVariableNames: 'runner machine'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Tests'!

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/7/2026 21:10:19'!
dummyMachineWithControlStack: aControlStack

^ Machine new
		initMachineWithControlStack: aControlStack
		withValueStack: nil 
		withEnvVar: nil 
		withRng: Random new
		withLogW: 0.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 12:09:56'!
evalAST: anAST
	
	^ self evalAST: anAST withEnvironment: Dictionary new! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/7/2026 23:16:35'!
evalAST: anAST withEnvironment: anEnvironment
	
	machine := self dummyMachineWithControlStack: {Eval expression: anAST withEnvironment: anEnvironment andAddress: #().}.
	^ (machine resumeRunner: runner) value! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/7/2026 23:23:00'!
setUp
	runner := SSMHRunner new.
	runner trace: MHTrace new. "PARCHE TEMPORAL"! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 11:54:21'!
test01EvalLiteral
	
	self assert: (self evalAST: 100) equals: 100.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 12:09:56'!
test02EvalSymbol

	self assert: (self evalAST: #y withEnvironment: {#y -> 42} asDictionary) equals: 42.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 11:55:47'!
test03EvalIfTrue

	self assert: (self evalAST: #(if true 2 1)) equals: 2.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 11:56:18'!
test04EvalIfFalse

	self assert: (self evalAST: #(if false 2 1)) equals: 1.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 11:57:51'!
test05EvalLet
	
	self assert: (self evalAST: #(let (#x 1) #x)) equals: 1.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 16:28:15'!
test06EvalLetMultipleBindings
	
	self assert: (self evalAST: #(let (#x 2 #y 5) #y)) equals: 5.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 12:07:13'!
test07EvalDiscard

	self assert: (self evalAST: #(let (#x 1) 10 99)) equals: 99.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 16:00:09'!
test08EvalFn
	"identidad"
	self assert: (self evalAST: #((fn (#x) #x) 42)) equals: 42.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 20:21:49'!
test09EvalClosure
	| ast |
	ast := #(let (#x 10) 
			#(let (#f #(fn (#y) (+ #x #y))) 
				#(f 5))).
				
	self assert: (self evalAST: ast) equals: 15.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 20:24:11'!
test10EvalHOF
	| ast |
	
	ast := #(let (#apply #(fn (#f #val) (#f #val)))
		#(#apply #(fn (#x) (* #x 2)) 21)).

	self assert: (self evalAST: ast) equals: 42.
	
	"
	(let ((apply (lambda (f val) (f val))))
		(apply (lambda (x) (* x 2)) 21))
	"
	! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/7/2026 23:21:29'!
test11EvalSample

	| ast result env |
	
	ast := #(sample #(normal 0 1)).
	
	"parche temporal"
	env := {#normal -> #normal } asDictionary.
	
	machine := self dummyMachineWithControlStack: {
		Eval expression: ast withEnvironment: env andAddress: #(#main)
	}.
	
	runner machine: machine. "PARCHE TEMPORAL, HAY QUE VERLO BIEN COMO MANEJARLO"
	result := machine resumeRunner: runner.
	
	self assert: result class equals: SSMHRun.
	self assert: result trace sampleValues size equals: 1.
	self assert: (result trace sampleValues includesKey: #(#main)).! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/8/2026 00:24:37'!
test12EvalObserve
	
	| ast result env |
	
	ast := #(observe #(normal 0 1) 5).
	
	env := {#normal -> #normal } asDictionary.
	
	machine := self dummyMachineWithControlStack: {Eval 
		expression: ast 
		withEnvironment: env
		andAddress: #(#main)
	}.
	
	runner machine: machine. "PARCHE TEMPORAL, HAY QUE VERLO BIEN COMO MANEJARLO"
	result := machine resumeRunner: runner.
	
	self assert: result class equals: SSMHRun.
	self assert: result trace observeDensities size equals: 1.
	self assert: (result trace observeDensities values first) notNil.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 20:45:53'!
test13EvalDone

	| result |
	machine := Machine new 
		initMachineWithControlStack: #()
		withValueStack: (OrderedCollection with: 99)
		withEnvVar: Dictionary new
		withRng: nil
		withLogW: 0.
		
	result := machine resumeRunner: runner.
	
	self assert: result class equals: SSMHRun.
	self assert: result value equals: 99.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/6/2026 23:34:51'!
test14EvalNormalDistribution

	| result env |

	env := {#normal -> #normal } asDictionary.
	
	machine := self dummyMachineWithControlStack: {
		Eval expression: #(normal 0.0 1.0) withEnvironment: env andAddress: #(#test)
	}.
	
	result := machine resumeRunner: runner.
	
	self assert: machine popValue class equals: NormalDistribution.
	
	self assert: machine popValue mean equals: 0.0.! !


!classDefinition: #MainTest category: #'Smalltalk-PPL-Tests'!
TestCase subclass: #MainTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Tests'!

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/8/2026 01:00:46'!
test01
	| ast runner result run |
	
	ast := #(let (#mu #(sample #(normal 0 1))) #(observe #(normal #mu 1) 2.3) #mu).

	runner := SSMHRunner new.
	run := runner 
		run: ast 
		withRng: Random new
		redrawAddress: nil 
		withCache: Dictionary new.
	
	result := run value.
	
	self assert: result isNil not.
	self assert: (result isNumber).
	"Esto NO anda bien porque estoy tomando el logProb de la primitiva y no el que deberiamos usar creo, sino es error semantico"
	self assert: (result > -3 and: [result < 3]). "tira numeros FEOS FEOS, diverge bastante"! !
(Smalltalk at: #qq__ ifAbsentPut: [OrderedCollection new]) add: (#(74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 99 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 62 61 59 56 53 112 116 104 110 108 17 94 112 117 58 57 17 61 53 57 17 95 61 59 17 86 119 108 117 39 90 116 104 115 115 123 104 115 114 39 74 118 110 98 90 119 124 121 100 39 93 84 39 98 83 112 125 108 91 128 119 112 117 110 74 118 80 117 123 108 121 119 121 108 123 108 121 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 100 17 94 112 117 107 118 126 122 17 94 112 117 58 57 39 105 124 112 115 123 39 118 117 39 84 104 121 39 39 56 39 57 55 57 60 39 55 56 65 55 59 65 57 57 39 78 84 91 39 74 118 116 119 112 115 108 121 65 39 59 53 57 53 56 39 74 118 116 119 104 123 112 105 115 108 39 74 115 104 117 110 39 63 53 55 53 56 39 47 123 104 110 122 54 89 76 83 76 72 90 76 102 63 55 56 54 109 112 117 104 115 48 17 83 112 125 108 91 128 119 112 117 110 74 118 80 117 123 108 121 119 121 108 123 108 121 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 39 124 124 112 107 65 39 57 61 104 55 55 106 105 106 52 58 56 60 107 52 59 106 108 107 52 104 108 60 105 52 61 60 55 58 60 56 56 61 58 106 58 62 39 84 104 121 39 39 56 39 57 55 57 60 17 83 112 125 108 91 128 119 112 117 110 74 118 110 112 123 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 39 124 124 112 107 65 39 57 61 104 55 55 106 105 106 52 58 56 60 107 52 59 106 108 107 52 104 108 60 105 52 61 60 55 58 60 56 56 61 58 106 58 62 39 84 104 121 39 39 56 39 57 55 57 60 17 93 84 65 39 57 55 57 60 56 55 55 61 56 64 58 59 39 111 108 121 117 104 117 71 84 104 106 73 118 118 114 52 87 121 118 52 107 108 52 79 108 121 117 104 117 52 57 53 115 118 106 104 115 65 75 118 106 124 116 108 117 123 122 54 93 84 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 39 75 104 123 108 65 39 84 118 117 39 86 106 123 39 61 39 56 57 65 58 59 65 57 56 39 57 55 57 60 39 74 118 116 116 112 123 79 104 122 111 65 39 108 107 58 60 59 63 61 39 87 115 124 110 112 117 122 65 39 57 55 57 60 56 55 55 61 56 64 58 59 39 111 108 121 117 104 117 71 84 104 106 73 118 118 114 52 87 121 118 52 107 108 52 79 108 121 117 104 117 52 57 53 115 118 106 104 115 65 75 118 106 124 116 108 117 123 122 54 93 84 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 17 179 31 215 8 17 56 62 57 53 57 59 53 57 55 63 53 56 17 94 80 85 75 86 94 90 52 80 77 55 89 59 91 55 53 116 122 111 118 116 108 53 117 108 123 17 94 80 85 75 86 94 90 52 80 77 55 89 59 91 55 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 59 91 57 56 65 56 57 65 57 62 53 63 61 62 56 58 64 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 126 117 115 118 104 107 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 53 122 123 17 59 56 62 63 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 55 65 57 62 65 55 60 53 62 62 64 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 47 60 48 53 122 123 17 58 61 55 61 56 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 55 65 57 62 65 55 62 53 64 60 62 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 52 80 117 122 123 121 124 106 123 112 118 117 122 53 122 123 17 57 56 62 61 58 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 55 65 57 62 65 55 64 53 57 64 55 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 52 84 112 117 112 87 87 83 53 122 123 17 56 57 62 55 63 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 55 65 57 62 65 56 55 53 63 58 56 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 52 91 108 122 123 122 53 122 123 17 56 59 63 61 60 17 52 52 52 52 52 52 52 52 52 52 17 17 52 52 52 52 52 52 52 52 52 52 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 59 91 57 58 65 55 55 65 60 62 53 62 58 58 64 62 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 53 122 123 17 61 62 63 62 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 55 65 60 60 65 56 64 53 62 55 55 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 119 121 118 105 104 121 53 122 123 17 60 57 55 60 56 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 56 65 58 57 65 55 57 53 61 56 56 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 123 108 122 123 53 122 123 17 60 57 62 55 62 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 62 91 57 56 65 59 62 65 56 60 53 58 55 55 60 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 53 122 123 17 60 58 55 58 58 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 63 91 55 55 65 59 58 65 58 55 53 62 57 64 59 57 60 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 53 122 123 17 60 58 59 64 64 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 63 91 55 56 65 55 56 65 59 61 53 62 55 62 59 57 60 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 53 122 123 17 60 58 60 60 64 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 63 91 55 56 65 55 56 65 60 57 53 57 57 60 59 57 60 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 118 123 121 118 90 116 104 115 115 123 104 115 114 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 52 91 108 122 123 122 53 122 123 17 61 63 55 63 17 52 52 52 52 52 52 52 52 52 52 17 17))!