!classDefinition: #Signaling category: 'SmalltalkPPL-Evaluation'!
Object subclass: #Signaling
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Evaluation'!
!classDefinition: #DistributionTest category: 'SmalltalkPPL-Tests'!
TestCase subclass: #DistributionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!DistributionTest methodsFor: 'normal' stamp: 'L.C 8/Jul/2026, 12:02:28 am (UTC)'!
test01LogProb

	| dist prob |
	dist := NormalDistribution withMean: 0.0 standardDeviation: 1.0 randomGenerator: nil.
	
	prob := dist logarithmicProbabilityWith: 0.0.
	
	self assert: ((prob - (-0.918938)) abs < 0.0001)! !

!DistributionTest methodsFor: 'normal' stamp: 'L.C 7/Jul/2026, 1:57:17 am (UTC)'!
test02Sample

	| distribution randomMock sample |
	randomMock := ReadStream on: #(0.5 0.5).
	
	distribution := NormalDistribution withMean: 10.0 standardDeviation: 2.0 randomGenerator: randomMock.
	sample := distribution sample.
	
	self assert: sample class equals: SmallFloat64.! !


!classDefinition: #InterpreterTest category: 'SmalltalkPPL-Tests'!
TestCase subclass: #InterpreterTest
	instanceVariableNames: 'runner machine'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!InterpreterTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 21:28:50'!
dummyMachineWithControlStack: aControlStack

^ Machine new
		initMachineWithControlStack: aControlStack
		withValueStack: nil 
		withEnvVar: nil 
		withRng: Random new
		withLogW: 0.! !

!InterpreterTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 23:21:43'!
evalAST: anAST
	
	^ self evalAST: anAST withEnvironment: runner initialEnvironment.! !

!InterpreterTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 21:37:24'!
evalAST: anAST withEnvironment: anEnvironment
	
	machine := self dummyMachineWithControlStack: {Eval expression: anAST withEnvironment: anEnvironment andAddress: #().}.
	^ (machine resumeRunner: runner) value! !

!InterpreterTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 21:28:24'!
setUp
	runner := SSMHRunner new.
	runner trace: MHTrace new. "PARCHE TEMPORAL"! !


!classDefinition: #LWTest category: 'SmalltalkPPL-Tests'!
InterpreterTest subclass: #LWTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!LWTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 07:09:23'!
test01SampleReturnSampledValue

	| firstResult firstWeight normalDist results sampleInst |
	normalDist := CallFunction withFunction: #normal withArguments: {0. 1}.
	sampleInst := Sample withDistribution: normalDist.
	
	results := LikelihoodWeighting program: sampleInst rng: Random new for: 1.
		
	firstResult := results value first.
	firstWeight := results logWeights first.
	
	self assert: firstResult isNumber.
	self assert: firstWeight equals: 1.! !

!LWTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 09:36:45'!
test02WeightsNormalizeToOne
	
	| program results sumOfWeights weights |
	program := Sample withDistribution: (CallFunction withFunction: #normal withArguments: {0. 1}).
	
	results := LikelihoodWeighting program: program rng: Random new for: 100.
	
	weights := results logWeights.
	
	sumOfWeights := weights sum.
	
	self assert: ((sumOfWeights - 1.0) abs < 0.0001).! !

!LWTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 10:54:06'!
test03AddressConventionIsStable

	| program runner1 runner2 result1 result2 |
	program := Let binds: {#x . (Sample withDistribution: (CallFunction withFunction: #normal withArguments: {0. 1}))}
	withIndex: 1
	andBody: {(Observe withDistribution: (CallFunction withFunction: #normal withArguments: {0. 1}) withObservedValue: 0.5)}
	andEnvironment: Dictionary new 
	andAddress: #().

	runner1 := LWRunner new.
	result1 := runner1 runWithProgram: program withRng: (Random seed: 666).
	
	runner2 := LWRunner new.
	result2 := runner2 runWithProgram: program withRng: (Random seed: 666).
	
	self assert: result1 value equals: result2 value.
	self assert: result1 logWeights equals: result2 logWeights.! !


!classDefinition: #MachineTest category: 'SmalltalkPPL-Tests'!
InterpreterTest subclass: #MachineTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:54:21 pm (UTC)'!
test01EvalLiteral
	
	self assert: (self evalAST: 100) equals: 100.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 3:09:56 pm (UTC)'!
test02EvalSymbol

	self assert: (self evalAST: #y withEnvironment: {#y -> 42} asDictionary) equals: 42.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 9:18:38 pm (UTC)'!
test03EvalIfTrue

	self assert: (self evalAST: (If condition: true then: 2 else: 1)) equals: 2.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 9:19:01 pm (UTC)'!
test04EvalIfFalse

	self assert: (self evalAST: (If condition: false then: 2 else: 1)) equals: 1.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 10:49:58 pm (UTC)'!
test05EvalLet
	
	"Este test todavia falla"
	"self assert: (self evalAST: #(let (#x 1) #x)) equals: 1."
	self assert: (self evalAST: (Let initBinds: #(#x 1) withBody:#(#x))) equals: 1.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026, 3:39:55 pm (UTC)'!
test06EvalLetMultipleBindings
	
	self assert: (self evalAST: (Let initBinds: (#(#x 2 #y 5)) withBody: #(#y))) equals: 5.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026, 3:40:58 pm (UTC)'!
test07EvalDiscard
	
	
	self assert: (self evalAST: (Let initBinds: #(#x 1) withBody: #(10 99))) equals: 99.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 00:51:15'!
test08EvalFn
	"identidad"
	
	"self assert: (self evalAST: #((fn (#x) #x) 42)) equals: 42."
	"self assert: (self evalAST: (Fn withParameters: #(#x) andBody: #(#x 42))) equals: 42."
	self assert: 
		(self evalAST: (CallFunction withFunction: (Fn withParameters: #(#x) andBody: #(#x))
			withArguments: #(42))) 
				equals: 42.
	! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 23:24:28'!
test09EvalClosure
	| function let1 let2 |
	"ast := #(let (#x 10) 
			#(let (#f #(fn (#y) (+ #x #y))) 
				#(f 5)))."
	function := (Fn withParameters: { #y } 
				andBody: {CallFunction withFunction: #+ withArguments: { #x. #y }}).
				
	let2 := Let initBinds: { #f. function} withBody: { CallFunction withFunction: #f withArguments: { 5 }}.
	
	let1 := Let initBinds: { #x. 10 }withBody: {let2}.
	
	self assert: (self evalAST: let1 withEnvironment: runner initialEnvironment) equals: 15.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 20:43:11'!
test10EvalHOF
	| function1 function2 function3 program |
	
	"(lambda (f val) (f val))"	
	function1 := Fn withParameters: #(#f #val) andBody: {CallFunction withFunction: #f withArguments: #(#val)}.
	
	"(lambda (x) (* x 2))"
	function2 := CallFunction withFunction: #* withArguments: #(#x 2).
	function3 := Fn withParameters: #(#x) andBody: {function2}.
	
	"(apply function3 21)"
	program := { CallFunction withFunction: #apply withArguments: {function3. 21}}.	

	self assert: (self evalAST: (Let initBinds: {#apply. function1} withBody: program)) equals: 42.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026, 7:38:51 pm (UTC)'!
test11EvalSample

	| ast result env distribution |
	
	"ast := #(sample #(normal 0 1))."
	distribution := NormalDistribution withMean: 0 standardDeviation: 1 randomGenerator: Random new.
	ast := Sample withDistribution: distribution.
	
	
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

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026, 8:05:35 pm (UTC)'!
test12EvalObserve
	
	| ast result env distribution |
	
	"ast := #(observe #(normal 0 1) 5)."
	distribution:= NormalDistribution withMean: 0 standardDeviation: 1 randomGenerator: Random new.
	ast := Observe withDistribution: distribution withObservedValue: 5.
	
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

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 11:45:53 pm (UTC)'!
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


!classDefinition: #SSMHTest category: 'SmalltalkPPL-Tests'!
InterpreterTest subclass: #SSMHTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 21:29:23'!
test01InitialTraceRegistersSamples

	| ast distribution result |
	distribution := NormalDistribution withMean: 0 standardDeviation: 1 randomGenerator: Random new.
	ast := Sample withDistribution: distribution.
	
	machine := self dummyMachineWithControlStack: {Eval expression: ast withEnvironment: Dictionary new andAddress: #(#main)}.
	runner machine: machine.
	result := machine resumeRunner: runner.
	
	self assert: result class equals: SSMHRun.
	self assert: (result trace sampleValues includesKey: #(#main)).
	self assert: (result trace sampleDensities includesKey: #(#main)).! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 21:31:06'!
test02InitialTraceRegistersObserves

	| ast distribution result |
	distribution := NormalDistribution withMean: 0 standardDeviation: 1 randomGenerator: Random new.
	ast := Observe withDistribution: distribution withObservedValue: 5.
	
	machine := self dummyMachineWithControlStack: {Eval expression: ast withEnvironment: Dictionary new andAddress: #(#main)}.
	runner machine: machine.
	result := machine resumeRunner: runner.
	
	self assert: result class equals: SSMHRun.
	self assert: (result trace observeDensities includesKey: #(#main)).! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 07:28:42'!
test03CacheReuseAtNonRedrawAddress

	| ast cache result instruction |
	instruction := CallFunction withFunction: #normal withArguments: {0. 1}.
	ast := Sample withDistribution: instruction.
	
	cache := {#() -> 42} asDictionary.

	runner := SSMHRunner new.

	result := runner run: ast withRng: Random new redrawAddress: #(#another) withCache: cache.

	self assert: (result trace sampleValues at: #()) equals: 42.! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 22:12:37'!
test04RedrawSiteForcesNewSample
	
	| ast cache distribution dummyRandom result |
	dummyRandom := ReadStream on: #(0.5 0.5).
	
	distribution := NormalDistribution withMean: 0.0 standardDeviation: 1.0 randomGenerator: dummyRandom.
	ast := Sample withDistribution: distribution.
	
	cache := {#main -> 42} asDictionary.
	
	runner := SSMHRunner new.
	result := runner run: ast withRng: dummyRandom redrawAddress: #() withCache: cache. "forzamos una muestra nueva"
	
	self assert: (result trace sampleValues at: #()) ~= 42.! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 22:13:20'!
test05AbsentAddressInCacheForcesNewSample
	
	| ast cache distribution dummyRandom result |
	dummyRandom := ReadStream on: #(0.5 0.5).
	
	distribution := NormalDistribution withMean: 0.0 standardDeviation: 1.0 randomGenerator: dummyRandom.
	ast := Sample withDistribution: distribution.
	
	cache := Dictionary new. "cache nula"
	
	runner := SSMHRunner new.
	result := runner run: ast withRng: dummyRandom redrawAddress: #(#another) withCache: cache.
	
	self assert: (result trace sampleValues includesKey: #()).
	self assert: (result trace sampleValues at: #()) notNil.! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 22:29:39'!
test06RandomSampleAddressWithEmptyTrace
	| trace randomGenerator |
	trace := MHTrace new.
	randomGenerator := Random new.
	
	self should: [trace randomSampleAdressUsing: randomGenerator] 
		raise: Error 
		withExceptionDo: [ :anException |
			self assert: anException messageText equals: 'Cannot pick an address from an empty trace.'].! !


!classDefinition: #MainTest category: 'SmalltalkPPL-Tests'!
TestCase subclass: #MainTest
	instanceVariableNames: 'originalProgramTest'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 09:58:02'!
genProgram
	"(let ((mu (sample (normal 0 1)))) (observe (normal mu 1) 2.3) mu)"
	| letInstance muSample normalDistribution1 normalDistribution2 observeInstance program |
	
	"normal 0 1"
	normalDistribution1 := CallFunction withFunction: #normal withArguments: {0. 1}.
	"normal mu 1"
	normalDistribution2 := CallFunction withFunction: #normal withArguments: {#mu. 1}.
	"mu (sample normalDist1)"
	muSample := Sample withDistribution: normalDistribution1.
	"observe normalDist2 2.3"
	observeInstance := Observe withDistribution: normalDistribution2 withObservedValue: 2.3.
	"observeInstance mu"
	program := {observeInstance. #mu}.
	"let muSample program"
	letInstance := Let initBinds: {#mu. muSample} withBody: program.
	
	 ^letInstance.! !

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 06:16:36'!
testConjLW

	| results posteriori foldWeight weight |
	
	results := LikelihoodWeighting program: self genProgram rng: Random new for: 2000.

	foldWeight := 0.
		
	1 to: results value size do: [ :index | 
		| thisValue | 
		thisValue := results value at: index.
		weight := results logWeights at: index.
		foldWeight := foldWeight + (thisValue * weight)].
	
	posteriori := foldWeight.
	
	self assert: (posteriori between: 0.9 and: 1.4).! !

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 05:26:47'!
testConjSMC
	"| posteriori particles |
	
	particles := SequentialMonteCarlo new 
		program: originalProgramTest 
		rng: Random new
		for: 20000.
	
	posteriori := particles sum / particles size.
	
	self assert: (posteriori between: 0.9 and: 1.4)."! !

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 07:34:14'!
testConjSSMH
	| chain posteriori |
	
	chain := SingleSiteMetropolisHastings 
		program: self genProgram
		rng: Random new 
		steps: 1000
		warmup: 200.

	posteriori := chain sum / chain size.
	
	self assert: (posteriori between: 0.9 and: 1.4).! !
!classDefinition: #Closure category: 'SmalltalkPPL-Instructions'!
Object subclass: #Closure
	instanceVariableNames: 'parameters body environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 00:51:35'!
applyArguments: arguments onMachine: aMachine atAddress: anAddress

	| newEnv newAddress |
	newEnv := environment copy.
	
	1 to: parameters size do: [ :i | newEnv at: (parameters at: i) put: (arguments at: i)].

	newAddress := anAddress,{aMachine nextIndexFor: anAddress}.
	
	aMachine pushBody: body withEnvironment: newEnv andAddress: newAddress.! !

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

!classDefinition: 'Closure class' category: 'SmalltalkPPL-Instructions'!
Closure class
	instanceVariableNames: ''!

!Closure class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 5:35:12 pm (UTC)'!
withParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment

	^ self new initializeWithParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment! !


!classDefinition: #Instruction category: 'SmalltalkPPL-Instructions'!
Object subclass: #Instruction
	instanceVariableNames: 'address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 1:27:43 pm (UTC)'!
address

	^ address! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 10:34:14'!
address: anAddress
	
	address := anAddress.! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 9:23:12 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnviroment andAddress: anAddress

	self subclassResponsibility! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 1:27:29 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	self subclassResponsibility! !


!classDefinition: #Call category: 'SmalltalkPPL-Instructions'!
Instruction subclass: #Call
	instanceVariableNames: 'count'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Call methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 10:34:41'!
executeOn: aMachine runner: aRunner
	
	| arguments operator |
	arguments := aMachine popValues: count.
	operator := aMachine popValue.
	
	operator applyArguments: arguments onMachine: aMachine atAddress: address.

	^self! !

!Call methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 10:34:29'!
initializeExpecting: aCount at: anAddress

	count := aCount.
	address := anAddress.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Call class' category: 'SmalltalkPPL-Instructions'!
Call class
	instanceVariableNames: ''!

!Call class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 6:37:59 pm (UTC)'!
expecting: aCount at: anAddress

	^ self new initializeExpecting: aCount at: anAddress! !


!classDefinition: #CallFunction category: 'SmalltalkPPL-Instructions'!
Instruction subclass: #CallFunction
	instanceVariableNames: 'function arguments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

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

!CallFunction methodsFor: 'Instance Creation' stamp: 'L.C 7/10/2026 10:40:31'!
withFunction: aFunction withArguments: aCollectionOfArguments
	
	function  := aFunction.
	arguments  := aCollectionOfArguments.
	
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CallFunction class' category: 'SmalltalkPPL-Instructions'!
CallFunction class
	instanceVariableNames: ''!

!CallFunction class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026, 5:31:38 pm (UTC)'!
withFunction: aFunction withArguments: aCollectionOfArguments

	^self new withFunction: aFunction withArguments: aCollectionOfArguments
	
		! !


!classDefinition: #Discard category: 'SmalltalkPPL-Instructions'!
Instruction subclass: #Discard
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Discard methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 1:41:48 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	aMachine popValue.
	^ self! !


!classDefinition: #Eval category: 'SmalltalkPPL-Instructions'!
Instruction subclass: #Eval
	instanceVariableNames: 'expression environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Eval methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 00:29:39'!
executeOn: aMachine runner: aRunner
	
	expression evalWithMachine: aMachine withEnvironment: environment andAddress: address.
	
	^ self! !

!Eval methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:01:48 pm (UTC)'!
initExpression: anExpression withEnvironment: anEnvironment andAddress: anAddress

	expression := anExpression.
	environment := anEnvironment.
	address := anAddress.
	
	^ self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Eval class' category: 'SmalltalkPPL-Instructions'!
Eval class
	instanceVariableNames: ''!

!Eval class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:03:52 pm (UTC)'!
expression: anExpression withEnvironment: anEnvironment andAddress: anAddress
	
	^ self new initExpression: anExpression withEnvironment: anEnvironment andAddress: anAddress.! !


!classDefinition: #Fn category: 'SmalltalkPPL-Instructions'!
Instruction subclass: #Fn
	instanceVariableNames: 'parameters body'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

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

!classDefinition: 'Fn class' category: 'SmalltalkPPL-Instructions'!
Fn class
	instanceVariableNames: ''!

!Fn class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026, 3:50:40 pm (UTC)'!
withParameters: aCollectionOfParamaters andBody: aBodyFunction

	^self new withParameters: aCollectionOfParamaters andBody: aBodyFunction
	
		! !


!classDefinition: #If category: 'SmalltalkPPL-Instructions'!
Instruction subclass: #If
	instanceVariableNames: 'condition then else environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

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

!classDefinition: 'If class' category: 'SmalltalkPPL-Instructions'!
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


!classDefinition: #Let category: 'SmalltalkPPL-Instructions'!
Instruction subclass: #Let
	instanceVariableNames: 'bindings index body environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 10:39:56'!
evalWithMachine: aMachine withEnvironment: anEnviroment andAddress: anAddress
		bindings isEmpty ifTrue: [
			aMachine pushBody: body withEnvironment: environment andAddress: address.
			^ self].
		
		aMachine pushControl: (Let binds: bindings withIndex: 1 andBody: body andEnvironment: anEnviroment andAddress: anAddress ).
		aMachine pushControl: (Eval expression: (bindings at: 2) withEnvironment: anEnviroment andAddress: (anAddress , {#let. 1})).
		
		^self! !

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 08:25:49'!
executeOn: aMachine runner: aRunner

	| newEnv nextIndex value varName |
	value := aMachine popValue.
	varName := bindings at: index.
	
	newEnv := environment copy.
	newEnv at: varName put: value.
	"value isNil ifTrue: [ self halt ]."
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

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 10:02:53'!
initBinds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress
	"esto no se esta usando"
	bindings := aBindCollection.
	index := anIndex.
	body := aBody.
	environment := anEnvironment.
	address := anAddress.
	
	^ self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Let class' category: 'SmalltalkPPL-Instructions'!
Let class
	instanceVariableNames: ''!

!Let class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:24:35 pm (UTC)'!
binds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress

	^ self new initBinds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress! !

!Let class methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 9:41:39 pm (UTC)'!
initBinds: aBindCollection withBody: aBody 

	^self new initBinds: aBindCollection withBody: aBody ! !


!classDefinition: #Observe category: 'SmalltalkPPL-Instructions'!
Instruction subclass: #Observe
	instanceVariableNames: 'distribution observedValue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Observe methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 10:03:23'!
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

!classDefinition: 'Observe class' category: 'SmalltalkPPL-Instructions'!
Observe class
	instanceVariableNames: 'distribution observedValue'!

!Observe class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:08:59 am (UTC)'!
withAddress: anAddress

	^ self new initializeWithAddress: anAddress! !


!Observe class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026, 8:01:08 pm (UTC)'!
withDistribution: aDistribution withObservedValue: anObservedValue

	^self new withDistribution: aDistribution withObservedValue: anObservedValue
	
	
	! !


!classDefinition: #Sample category: 'SmalltalkPPL-Instructions'!
Instruction subclass: #Sample
	instanceVariableNames: 'distribution'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Sample methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026, 7:49:07 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: anAddress

	address := anAddress.

	aMachine pushControl: self.
	aMachine pushControl: (Eval 
			expression: distribution
			withEnvironment: anEnvironment 
			andAddress: (address,{#d})).
	^ self! !

!Sample methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 07:03:58'!
executeOn: aMachine runner: aRunner

	| sampled |
	distribution := aMachine popValue.
	sampled := aRunner sampleWithAddress: address withDistribution: distribution.
	
	aMachine pushValue: sampled.
	
	^sampled.! !

!Sample methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:09:20 am (UTC)'!
initializeWithAddress: anAddress

	address := anAddress! !


!Sample methodsFor: 'Instance Creation' stamp: 'jcm 9/Jul/2026, 7:40:27 pm (UTC)'!
withDistribution: aDistribution 
	
	
	distribution := aDistribution .
	
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sample class' category: 'SmalltalkPPL-Instructions'!
Sample class
	instanceVariableNames: ''!

!Sample class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:08:51 am (UTC)'!
withAddress: anAddress

	^ self new initializeWithAddress: anAddress! !


!Sample class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026, 7:39:20 pm (UTC)'!
withDistribution: aDistribution 

	^self new withDistribution: aDistribution 
	! !
!classDefinition: #Distribution category: 'SmalltalkPPL-MiniPPL'!
Object subclass: #Distribution
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!Distribution methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:02:28 am (UTC)'!
logarithmicProbabilityWith: aValue

	^self subclassResponsibility! !

!Distribution methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 1:26:26 am (UTC)'!
sample
	^self subclassResponsibility! !


!classDefinition: #NormalDistribution category: 'SmalltalkPPL-MiniPPL'!
Distribution subclass: #NormalDistribution
	instanceVariableNames: 'mean standardDeviation randomGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!NormalDistribution methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 09:26:48'!
initializeWithMean: aMeanValue standardDeviation: aStandardDeviation randomGenerator: aRandomNumberGenerator
	
	mean := aMeanValue.
	standardDeviation := aStandardDeviation.
	randomGenerator := aRandomNumberGenerator.! !

!NormalDistribution methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:02:28 am (UTC)'!
logarithmicProbabilityWith: aValue

"z = (float(x) - self.mu) / self.sigma
        return -0.5 * (LOG2PI + z * z) - math.log(self.sigma)"

	| log2Pi normalized |
	normalized := (aValue asFloat - mean) / standardDeviation.
	log2Pi := (Float pi * 2.0) ln.
	
	^ -0.5 * (log2Pi + (normalized * normalized)) - standardDeviation ln! !

!NormalDistribution methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:35:23 am (UTC)'!
mean 

^mean! !

!NormalDistribution methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 1:50:15 am (UTC)'!
sample

	"https://es.wikipedia.org/wiki/M%C3%A9todo_de_Box-Muller" 

	| u1 u2 z0 |
	
	u1 := randomGenerator next.
	u2 := randomGenerator next.
	
	u1 = 0.0 ifTrue: [ u1 := 1.0e-10 ]. "emula el limite de u1 teniendo a 0"
	
	z0 := (-2.0 * u1 ln) sqrt * (2.0 * Float pi * u2) cos.
	
	^ (mean + (z0 * standardDeviation)) asFloat! !

!NormalDistribution methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:04:55 am (UTC)'!
sampleWith: aRandomNumberGenerator

	| u1 u2 z0 |
	
	u1 := aRandomNumberGenerator next.
	u2 := aRandomNumberGenerator next.
	
	u1 = 0.0 ifTrue: [ u1 := 1.0e-10 ].
	
	z0 := (-2.0 * u1 ln) sqrt * (2.0 * Float pi * u2) cos.
	
	^ (mean + (z0 * standardDeviation)) asFloat! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NormalDistribution class' category: 'SmalltalkPPL-MiniPPL'!
NormalDistribution class
	instanceVariableNames: ''!

!NormalDistribution class methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 09:26:43'!
withMean: aMeanValue standardDeviation: aStandardDeviation randomGenerator: aRandomNumberGenerator
	
	aStandardDeviation <= 0 ifTrue: [self error: 'Standard deviation must be positive'].

	^ self new 
		initializeWithMean: aMeanValue 
		standardDeviation: aStandardDeviation 
		randomGenerator: aRandomNumberGenerator! !


!classDefinition: #Primitive category: 'SmalltalkPPL-MiniPPL'!
Object subclass: #Primitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!Primitive methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 23:03:32'!
applyArguments: arguments onMachine: aMachine atAddress: address
	
	self subclassResponsibility! !


!classDefinition: #AddPrimitive category: 'SmalltalkPPL-MiniPPL'!
Primitive subclass: #AddPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!AddPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 23:05:49'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) + (arguments at: 2).
	aMachine pushValue: result.! !


!classDefinition: #DividePrimitive category: 'SmalltalkPPL-MiniPPL'!
Primitive subclass: #DividePrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!DividePrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 23:16:21'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) / (arguments at: 2). "agregar caso den es 0"
	aMachine pushValue: result.! !


!classDefinition: #EqualPrimitive category: 'SmalltalkPPL-MiniPPL'!
Primitive subclass: #EqualPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!EqualPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 23:16:41'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) = (arguments at: 2).
	aMachine pushValue: result.! !


!classDefinition: #MultiplyPrimitive category: 'SmalltalkPPL-MiniPPL'!
Primitive subclass: #MultiplyPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!MultiplyPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 23:15:34'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) * (arguments at: 2).
	aMachine pushValue: result.! !


!classDefinition: #NormalPrimitive category: 'SmalltalkPPL-MiniPPL'!
Primitive subclass: #NormalPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!NormalPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 09:24:46'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| distribution |
	distribution := NormalDistribution 
		withMean: (arguments at: 1) 
		standardDeviation: (arguments at: 2) 
		randomGenerator: aMachine randomGenerator.
	
	aMachine pushValue: distribution.! !


!classDefinition: #SubtractPrimitive category: 'SmalltalkPPL-MiniPPL'!
Primitive subclass: #SubtractPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!SubtractPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 23:15:14'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) - (arguments at: 2).
	aMachine pushValue: result.! !
!classDefinition: #LikelihoodWeighting category: 'SmalltalkPPL-Algorithm'!
Object subclass: #LikelihoodWeighting
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Algorithm'!

!LikelihoodWeighting methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 06:59:40'!
program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps

	| runs values log_w normalized |
	runner := LWRunner.
	runs := OrderedCollection new.
	
	1 to: aNumberOfSteps do: [:i | runs add: (runner runWithProgram: aProgram withRng: aRandomNumberGenerator)].
	
	values := runs collect: [ :r | r value asFloat].
	log_w := runs collect: [ :r | r logWeights].
	
	"https://es.wikipedia.org/wiki/Funci%C3%B3n_SoftMax"
	log_w isEmpty 
		ifTrue: [ normalized := log_w copy ]
		ifFalse: [ | expSum maxLog |
			maxLog := log_w inject: log_w first into: [:max :each | max max: each].
			expSum := log_w inject: 0.0 into: [:sum :each | (each-maxLog) exp + sum].
			normalized := log_w collect: [ :each | (each-maxLog) exp / expSum ].
		].
	
	^LWRun withLogW: normalized withValue: values! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LikelihoodWeighting class' category: 'SmalltalkPPL-Algorithm'!
LikelihoodWeighting class
	instanceVariableNames: ''!

!LikelihoodWeighting class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:00:13 pm (UTC)'!
checkPositiveNumberOfSteps: aNumberOfSteps

	aNumberOfSteps > 0 ifFalse:[Error signal: 'The number of steps should be positive'].
	
	
	! !

!LikelihoodWeighting class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 6:59:16 pm (UTC)'!
program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps

	self checkPositiveNumberOfSteps: aNumberOfSteps.
	
	^self new program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps
	
	! !


!classDefinition: #SequentialMonteCarlo category: 'SmalltalkPPL-Algorithm'!
Object subclass: #SequentialMonteCarlo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Algorithm'!

!SequentialMonteCarlo methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 9:49:55 pm (UTC)'!
program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps

	
	| particles |
	runner := SMCRunner.
	particles := OrderedCollection new.
	
	1 to: aNumberOfSteps do:[
		particles add: (Machine initialMachineWithProgram: aProgram withRng: aRandomNumberGenerator )
		].
	
	^runner runWithProgram: aProgram withRng: aRandomNumberGenerator  withParticles: particles.! !


!classDefinition: #SingleSiteMetropolisHastings category: 'SmalltalkPPL-Algorithm'!
Object subclass: #SingleSiteMetropolisHastings
	instanceVariableNames: 'chain currentRun'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Algorithm'!

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 22:55:44'!
checkAcceptionOf: aNewRunOfSSMH comparingWith: anOldRunOfSSMH with: aRandomNumberGenerator with: anA0
	
	| acceptanceRatio proposedTrace oldTrace proposal |
	
	proposedTrace := aNewRunOfSSMH trace.
	oldTrace := anOldRunOfSSMH trace.
	
	proposal := SingleSiteProposal from: oldTrace to: proposedTrace at: anA0.
	acceptanceRatio := proposal logAlpha.

	((aRandomNumberGenerator next ln) < acceptanceRatio) ifTrue: [ currentRun := aNewRunOfSSMH ].	
! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 09:30:14'!
checkPassWarmup: aNumberOfWarmups Iterations: aNumberOfIteration

	aNumberOfIteration > aNumberOfWarmups ifTrue:[chain add: currentRun value].
	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 08:14:52'!
initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator

	currentRun := runner run: aProgram withRng: aRandomNumberGenerator.

! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 08:10:36'!
initializeProgram: aProgram rng:aRandomNumberGenerator steps: aNumberOfSteps warmup: aNumberOfWarmups

	| newRun a0 |
	runner := SSMHRunner new.
	chain := OrderedCollection new.
	self initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator.
	
	1 to: aNumberOfSteps + aNumberOfWarmups do: [ :i |
		a0 := currentRun trace randomSampleAdressUsing: aRandomNumberGenerator.
		newRun := runner 
			run: aProgram 
			withRng: aRandomNumberGenerator 
			redrawAddress: a0 
			withCache: currentRun trace sampleValues.
			
		self checkAcceptionOf: newRun comparingWith: currentRun with: aRandomNumberGenerator with: a0.
		self checkPassWarmup: aNumberOfWarmups Iterations: i].
	
	
	
	^chain asArray.
	
	


! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SingleSiteMetropolisHastings class' category: 'SmalltalkPPL-Algorithm'!
SingleSiteMetropolisHastings class
	instanceVariableNames: ''!

!SingleSiteMetropolisHastings class methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 09:29:56'!
program: aProgram rng: aRandomGenerator steps: aNumberOfSteps warmup: aNumberOfWarmups

	aNumberOfSteps > 0 ifFalse: [self error: 'Steps must be greather than 0'].
	aNumberOfWarmups >= 0 ifFalse: [self error: 'Warmup must be greater than or equal to 0.'].
	
	^self new initializeProgram: aProgram rng: aRandomGenerator steps: aNumberOfSteps warmup: aNumberOfWarmups.
! !
!classDefinition: #Machine category: 'SmalltalkPPL-Core'!
Object subclass: #Machine
	instanceVariableNames: 'controlStack valueStack envVar randomGenerator logWeights callCounter'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Core'!

!Machine methodsFor: 'Setters' stamp: 'L.C 7/10/2026 05:24:16'!
incrementLogW: aValueOfLogWToSum

	logWeights := logWeights + aValueOfLogWToSum.! !

!Machine methodsFor: 'Setters' stamp: 'L.C 7/10/2026 09:23:58'!
randomGenerator
	^randomGenerator! !


!Machine methodsFor: 'runner' stamp: 'L.C 6/Jul/2026, 1:31:17 pm (UTC)'!
popValue
	
	^ valueStack removeLast! !

!Machine methodsFor: 'runner' stamp: 'L.C 7/Jul/2026, 11:30:18 pm (UTC)'!
popValues: anIndex
	
	| values |
	values := Array new: anIndex.
	
	anIndex to: 1 by: -1 do: [:index | values at: index put: valueStack removeLast].
	
	^ values! !

!Machine methodsFor: 'runner' stamp: 'jcm 9/Jul/2026, 7:28:57 pm (UTC)'!
pushBody: aBody withEnvironment: anEnv andAddress: anAddress
	
	| n |
	n := aBody size.
	n = 0 ifTrue: [^self].
	
	self pushControl: (Eval expression: (aBody at: n) withEnvironment: anEnv andAddress: (anAddress , {n})).
	
	n-1 to: 1 by: -1 do: [ :index | 
		self pushControl: Discard new.
		self pushControl: (Eval expression: (aBody at: index) withEnvironment: anEnv andAddress: (anAddress, {index}))
	].! !

!Machine methodsFor: 'runner' stamp: 'L.C 6/Jul/2026, 1:32:20 pm (UTC)'!
pushControl: anInstruction

	controlStack addLast: anInstruction.
	
	^ self.! !

!Machine methodsFor: 'runner' stamp: 'L.C 6/Jul/2026, 1:31:41 pm (UTC)'!
pushValue: anObject

	valueStack addLast: anObject.
	^ self! !

!Machine methodsFor: 'runner' stamp: 'L.C 7/10/2026 02:47:16'!
resumeRunner: aRunner

	[controlStack notEmpty] whileTrue: [(self stepRunner: aRunner) ifRunnerSignal: [ :signal | ^signal ]].
	
	^ aRunner doneWithValue: valueStack last.! !

!Machine methodsFor: 'runner' stamp: 'L.C 7/9/2026 23:27:38'!
stepRunner: aRunner

	| instruction result |
	instruction := controlStack removeLast.
	
	result := instruction executeOn: self runner: aRunner.
	result == instruction ifFalse: [^result].
	^ nil! !


!Machine methodsFor: 'Initialize' stamp: 'L.C 7/10/2026 05:24:16'!
initMachineWithControlStack: aControlStack withValueStack: aValueStack withEnvVar: aDictionaryOfVariables withRng: aRandomNumberGenerator withLogW: aLogW

	controlStack := aControlStack asOrderedCollection.
	
	aValueStack  isNil 
		ifTrue: [valueStack := OrderedCollection new]
		ifFalse:[valueStack := aValueStack ].
		
	aDictionaryOfVariables isNil
		ifTrue:[envVar := Dictionary new]
		ifFalse:[envVar := aDictionaryOfVariables ].
		
	randomGenerator := aRandomNumberGenerator.
	
	logWeights := aLogW.
	
	callCounter := Dictionary new.
	
	^self
			
	! !


!Machine methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 10:43:10'!
forkWithRng: aRandomNumberGenerator
	
	| rng copiedControlStack copiedEnvironment copiedValueStack |
	
	rng := randomGenerator isNil 
			ifTrue: [aRandomNumberGenerator]
			ifFalse: [randomGenerator].

	copiedControlStack := controlStack ifNotNil: [ controlStack copy ].
	copiedValueStack := valueStack ifNotNil: [ valueStack copy ].
	copiedEnvironment := envVar ifNotNil: [ envVar copy ].

	^Machine new
		initMachineWithControlStack: copiedControlStack 
		withValueStack: copiedValueStack 
		withEnvVar:  copiedEnvironment
		withRng:  rng
		withLogW: logWeights.
			
	! !

!Machine methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 00:45:18'!
nextIndexFor: anPreAddress

	| count |
	count := callCounter at: anPreAddress ifAbsent: [0].
	
	callCounter at: anPreAddress put: count+1.
	
	^count! !


!Machine methodsFor: 'Getters' stamp: 'L.C 7/10/2026 05:24:16'!
logWeights

	^logWeights! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Machine class' category: 'SmalltalkPPL-Core'!
Machine class
	instanceVariableNames: ''!

!Machine class methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 09:49:18'!
initialMachineWithProgram: aParsedProgram withRng: aRandomNumberGenerator

	| initialEnv initialEval |

	initialEnv := AlgorithmRunner new initialEnvironment.
	initialEval := Eval expression: aParsedProgram withEnvironment: initialEnv andAddress: #().
	
	^ self new initMachineWithControlStack: (OrderedCollection with: initialEval)
		withValueStack: OrderedCollection new 
		withEnvVar: initialEnv
		withRng: aRandomNumberGenerator
		withLogW: 0.0.! !
!classDefinition: #AlgorithmRunner category: 'SmalltalkPPL-Runner'!
Object subclass: #AlgorithmRunner
	instanceVariableNames: 'machine program randomNumberGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!

!AlgorithmRunner methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 23:19:01'!
initialEnvironment
	| env |
	env := Dictionary new.
	env at: #+ put: AddPrimitive new.
	env at: #- put: SubtractPrimitive new.
	env at: #* put: MultiplyPrimitive new.
	env at: #/ put: DividePrimitive new.
	env at: #= put: EqualPrimitive new.
	env at: #normal put: NormalPrimitive new.
	^env! !

!AlgorithmRunner methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 09:48:03'!
run

	| runValue |
	
	[runValue isNil] whileTrue:[runValue := machine resumeRunner: self].
	"Termina cuando recibe un done"
	^runValue! !


!AlgorithmRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026, 7:39:52 pm (UTC)'!
doneWithValue: aReturnValue

	self subclassResponsibility! !

!AlgorithmRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026, 7:39:52 pm (UTC)'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	self subclassResponsibility! !

!AlgorithmRunner methodsFor: 'Special Instructions' stamp: 'L.C 7/10/2026 09:47:39'!
sampleWithAddress: anAddress withDistribution: aDistribution

	self subclassResponsibility! !


!AlgorithmRunner methodsFor: 'setters' stamp: 'L.C 8/Jul/2026, 2:20:23 am (UTC)'!
machine: aMachine 
	
	machine := aMachine! !


!classDefinition: #LWRunner category: 'SmalltalkPPL-Runner'!
AlgorithmRunner subclass: #LWRunner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!

!LWRunner methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:22:04 am (UTC)'!
runWithProgram: aProgram withRng: aRandomNumberGenerator

	randomNumberGenerator  := aRandomNumberGenerator.
	machine := Machine initialMachineWithProgram: aProgram withRng: randomNumberGenerator.
	program := aProgram.
	
	^self run
	
	! !


!LWRunner methodsFor: 'Special Instructions' stamp: 'L.C 7/10/2026 05:23:19'!
doneWithValue: aReturnValue

"Cambiar nombre aReturnValue viene de V[-1] "

	
	^LWRun withLogW: machine logWeights withValue: aReturnValue.! !

!LWRunner methodsFor: 'Special Instructions' stamp: 'L.C 8/Jul/2026, 6:54:08 am (UTC)'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	
	machine incrementLogW: (aDistribution logarithmicProbabilityWith: anObservedValue).
	machine pushValue: anObservedValue.
	
	^nil.! !

!LWRunner methodsFor: 'Special Instructions' stamp: 'L.C 7/10/2026 09:47:02'!
sampleWithAddress: anAddress withDistribution: aDistribution

	^aDistribution sample.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LWRunner class' category: 'SmalltalkPPL-Runner'!
LWRunner class
	instanceVariableNames: ''!

!LWRunner class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:08:42 pm (UTC)'!
runWithProgram: aProgram withRng: aRandomNumberGenerator

	^self new runWithProgram: aProgram withRng: aRandomNumberGenerator! !


!classDefinition: #SMCRunner category: 'SmalltalkPPL-Runner'!
AlgorithmRunner subclass: #SMCRunner
	instanceVariableNames: 'particles'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!

!SMCRunner methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 9:51:21 pm (UTC)'!
advance: aParticle

	
	machine := aParticle.
	
	^aParticle resumeRunner: self
	

	! !

!SMCRunner methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:03:15 pm (UTC)'!
resampleFromObserveMessages: aCollectionOfObservedMessages

	| logWeights probabilities ancestors newParticles |


	logWeights := aCollectionOfObservedMessages collect: [:msg | msg logIncrement].
	
	probabilities := logWeights softMax.
	
	"TODO: Equivalente a la linea rng.choice(N, size=N, p=probabilities) todavia no fue implementado"
	
	ancestors := self sampleAncestors: aCollectionOfObservedMessages size withProbabilities: probabilities.
	
	newParticles := OrderedCollection new.
	
	"Selecciona las particulas nuevas para resamplear"
	1 to: aCollectionOfObservedMessages size do: [:newIndex |
		
		| oldIndex oldParticle newParticle |
		
		oldIndex := ancestors at: newIndex.
		
		oldParticle := (aCollectionOfObservedMessages at: oldIndex) particle.
		
		newParticle := oldParticle forkWithRng: randomNumberGenerator.
		
		newParticles add: newParticle
	].

	^ newParticles
		
	
	
	


	

	! !

!SMCRunner methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:07:00 pm (UTC)'!
run

	| messages |
	
	true whileTrue:[
		messages := particles collect: [:particle | self advance: particle].
		
		"Chequea si todas son Done"
		(messages allSatisfy: [:msg | msg isDone]) ifTrue:[
			^SMCRun withValues: (messages collect: [:msg | msg value])
			].
		
		"Chequea si todas son Observe"
		(messages allSatisfy: [:msg | msg isObserve]) ifFalse: [
			self error: 'SMC needs all particles to reach observe together'
		].
		
		
		particles := self resampleFromObserveMessages: messages.
		
		]

	

	! !

!SMCRunner methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 9:03:07 pm (UTC)'!
runWithProgram: aProgram withRng: aRandomNumberGenerator  withParticles: aCollectionOfParticles

	particles := aCollectionOfParticles.
	randomNumberGenerator  := aRandomNumberGenerator .
	program  := aProgram.
	
	^self run

	

	! !


!SMCRunner methodsFor: 'Special Instructions' stamp: 'L.C 8/Jul/2026, 6:54:17 am (UTC)'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	| logIncrement |
	logIncrement := aDistribution logarithmicProbabilityWith: anObservedValue.
	
	"Machine es la particula actual sobre la cual se esta avanzando, se define en el metodo advance"
	machine incrementLogW: logIncrement.
	machine pushValue: anObservedValue.
	
	^SMCObserve withAddress: anAddress forParticle: machine withLogIncrement: logIncrement! !

!SMCRunner methodsFor: 'Special Instructions' stamp: 'L.C 8/Jul/2026, 6:54:20 am (UTC)'!
sampleWithAddress: anAddress withDistribution: aDistribution

	
	machine pushValue: (aDistribution sample).
	
	^nil! !


!classDefinition: #SSMHRunner category: 'SmalltalkPPL-Runner'!
AlgorithmRunner subclass: #SSMHRunner
	instanceVariableNames: 'redrawAddress cache trace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'L.C 7/Jul/2026, 11:42:52 pm (UTC)'!
doneWithValue: aReturnValue

"Cambiar nombre aReturnValue viene de V[-1] "

	
	^SSMHRun withTrace: trace withValue: aReturnValue.

	
	
	! !

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'L.C 8/Jul/2026, 5:51:46 pm (UTC)'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	
	trace updateObservedCacheAt: anAddress put: (aDistribution logarithmicProbabilityWith: anObservedValue) .
	machine pushValue: anObservedValue.
	
	^nil.! !

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'L.C 7/10/2026 09:23:23'!
sampleWithAddress: anAddress withDistribution: aDistribution 

	| sampledValue |
	
	trace ifNil: [ trace := MHTrace new ].
	
	(anAddress ~= redrawAddress and: [cache notNil and: [cache includesKey: anAddress]])
		ifTrue:[sampledValue := cache at: anAddress ]
		ifFalse:[sampledValue := aDistribution sample ].
		
	trace updateSampleValuesAt: anAddress put: sampledValue.
	trace updateSampleDensitiesAt: anAddress put: (aDistribution logarithmicProbabilityWith: sampledValue).
	
	^sampledValue
	
	! !


!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 21:40:24'!
machine
	^machine! !

!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 08:13:32'!
run: aProgram withRng: aRandomNumberGenerator

	| env result |
	env := self initialEnvironment.
	randomNumberGenerator := aRandomNumberGenerator.
	machine := Machine new
		initMachineWithControlStack: { Eval expression: aProgram withEnvironment: env andAddress: #() } 
		withValueStack: nil
		withEnvVar: env
		withRng: aRandomNumberGenerator 
		withLogW: 0.0.
	trace := MHTrace new.
	program := aProgram.
	
	result := self run.
	
	"esto lo revisa solo si es la primera run"
	(redrawAddress isNil and: [ trace sampleValues isEmpty ]) 
		ifTrue: [self error: 'SSMH requires at least one reachable sample site.'].
	
	^result.
	
! !

!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 00:59:46'!
run: aProgram withRng: aRandomNumberGenerator redrawAddress: anAddressToRedraw withCache: aCollectionOfSampledValues

	| env result |
	env := self initialEnvironment.
	randomNumberGenerator := aRandomNumberGenerator.
	machine := Machine new
		initMachineWithControlStack: { Eval expression: aProgram withEnvironment: env andAddress: #() } 
		withValueStack: nil
		withEnvVar: env
		withRng: aRandomNumberGenerator 
		withLogW: 0.0.
	trace := MHTrace new.
	redrawAddress  := anAddressToRedraw.
	cache := aCollectionOfSampledValues.
	program := aProgram.
	
	result := self run.
	
	"esto lo revisa solo si es la primera run"
	(redrawAddress isNil and: [ trace sampleValues isEmpty ]) 
		ifTrue: [self error: 'SSMH requires at least one reachable sample site.'].
	
	^result.
	
! !

!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 09:40:47'!
trace

	^trace
	! !

!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:39:53 am (UTC)'!
trace: aTrace
	
	trace := aTrace! !
!classDefinition: #AlgorithmRuns category: 'SmalltalkPPL-ExecutionState'!
Object subclass: #AlgorithmRuns
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExecutionState'!

!AlgorithmRuns methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 07:29:25'!
value
	^value! !


!classDefinition: #LWRun category: 'SmalltalkPPL-ExecutionState'!
AlgorithmRuns subclass: #LWRun
	instanceVariableNames: 'logWeights'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExecutionState'!

!LWRun methodsFor: 'category-name' stamp: 'L.C 7/10/2026 05:22:13'!
logWeights
	
	^logWeights! !


!LWRun methodsFor: 'Instance Creation' stamp: 'L.C 7/10/2026 05:22:13'!
withLogW: aLogWValue  withValue: aReturnValue
	
	logWeights := aLogWValue.
	value := aReturnValue.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LWRun class' category: 'SmalltalkPPL-ExecutionState'!
LWRun class
	instanceVariableNames: ''!

!LWRun class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:46:55 pm (UTC)'!
withLogW: aLogWValue  withValue: aReturnValue

	^self new withLogW: aLogWValue withValue: aReturnValue ! !


!classDefinition: #SMCRun category: 'SmalltalkPPL-ExecutionState'!
AlgorithmRuns subclass: #SMCRun
	instanceVariableNames: 'values'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExecutionState'!

!SMCRun methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:07:45 pm (UTC)'!
withValues: aCollectionOfValues

	values := aCollectionOfValues.
	
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMCRun class' category: 'SmalltalkPPL-ExecutionState'!
SMCRun class
	instanceVariableNames: ''!

!SMCRun class methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:07:24 pm (UTC)'!
withValues: aCollectionOfValues

	^self new withValues: aCollectionOfValues! !


!classDefinition: #SSMHRun category: 'SmalltalkPPL-ExecutionState'!
AlgorithmRuns subclass: #SSMHRun
	instanceVariableNames: 'trace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExecutionState'!

!SSMHRun methodsFor: 'Instance Creation' stamp: 'L.C 7/Jul/2026, 11:36:17 pm (UTC)'!
initializeWithTrace: aProposedTrace withValue: aReturnValue.
	
	trace := aProposedTrace.
	value := aReturnValue.
	
	^self! !

!SSMHRun methodsFor: 'Instance Creation' stamp: 'JCM 5/Jul/2026, 7:50:16 pm (UTC)'!
withTrace: aProposedTrace withValue: aReturnValue.
	
	trace := aProposedTrace.
	value := aReturnValue.
	
	^self! !


!SSMHRun methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026, 7:51:15 pm (UTC)'!
trace

	^trace! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SSMHRun class' category: 'SmalltalkPPL-ExecutionState'!
SSMHRun class
	instanceVariableNames: 'trace value'!

!SSMHRun class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 11:36:05 pm (UTC)'!
withTrace: aProposedTrace withValue: aReturnValue.
	
	
	
	^self new initializeWithTrace: aProposedTrace withValue: aReturnValue ! !
!classDefinition: #MHTrace category: 'SmalltalkPPL-Kernel-SSMH'!
Object subclass: #MHTrace
	instanceVariableNames: 'sampleDensities sampleValues observeDensities randomGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SSMH'!

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:28:55 am (UTC)'!
initialize
	sampleValues := Dictionary new.
	sampleDensities := Dictionary new.
	observeDensities := Dictionary new.! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 22:56:34'!
logDensityExcluding: excludedAddresses

	| density |
	
	density := 0.
	
	observeDensities valuesDo: [:prob | density := density + prob].

	sampleDensities keysAndValuesDo: [:address :prob | (excludedAddresses includes: address) ifFalse: [density := density + prob]].
	
	^ density.! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:49:14 pm (UTC)'!
observeDensities
^observeDensities! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 7/9/2026 22:20:43'!
randomSampleAdressUsing: aRandomNumberGenerator

	sampleValues isEmpty ifTrue: [self error: 'Cannot pick an address from an empty trace.'].
	^sampleValues keys atRandom: aRandomNumberGenerator.! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:49:22 pm (UTC)'!
sampleDensities
^sampleDensities! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026, 2:19:28 am (UTC)'!
sampleValues 
 ^sampleValues ! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 03:04:42'!
updateObservedCacheAt: anAddress put: anObservedDensity

	(observeDensities includesKey: anAddress) ifTrue: [self error: 'Address collision at ', anAddress asString].
	
	observeDensities at: anAddress put: anObservedDensity.! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 03:03:37'!
updateSampleDensitiesAt: anAddress put: aSampledDensity.

	(sampleDensities includesKey: anAddress) ifTrue: [self error: 'Address collision at ', anAddress asString].
	
	sampleDensities at: anAddress put: aSampledDensity! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 7/10/2026 03:03:42'!
updateSampleValuesAt: anAddress put: aSampledValue.
	
	(sampleValues includesKey: anAddress) ifTrue: [self error: 'Address collision at ', anAddress asString].
	
	sampleValues at: anAddress put: aSampledValue ! !


!classDefinition: #SingleSiteProposal category: 'SmalltalkPPL-Kernel-SSMH'!
Object subclass: #SingleSiteProposal
	instanceVariableNames: 'currentTrace proposedTrace selectedAddress'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SSMH'!
!SingleSiteProposal commentStamp: '<historical>' prior: 0!
Method Object!


!SingleSiteProposal methodsFor: 'as yet unclassified' stamp: 'L.C 5/Jul/2026, 2:32:53 am (UTC)'!
forwardExcludedAddresses
	
	^ {selectedAddress} union: (proposedTrace sampleDensities keys asSet difference: (currentTrace sampleDensities keys asSet))! !

!SingleSiteProposal methodsFor: 'as yet unclassified' stamp: 'L.C 5/Jul/2026, 2:27:51 am (UTC)'!
initializeWith: aCurrentTrace proposed: aProposedTrace address: anAddress

	currentTrace := aCurrentTrace.
	proposedTrace := aProposedTrace.
	selectedAddress := anAddress.
	
	^self.! !

!SingleSiteProposal methodsFor: 'as yet unclassified' stamp: 'L.C 5/Jul/2026, 2:52:53 am (UTC)'!
logAlpha

	| numerator denominator |
	
	numerator := proposedTrace logDensityExcluding: self forwardExcludedAddresses.
	denominator := currentTrace logDensityExcluding: self reverseExcludedAddresses.

	^ numerator - denominator + self proposalRatio.! !

!SingleSiteProposal methodsFor: 'as yet unclassified' stamp: 'L.C 5/Jul/2026, 2:35:42 am (UTC)'!
proposalRatio

	| currentSamples proposedSamples |

	currentSamples := currentTrace sampleDensities.
	proposedSamples := proposedTrace sampleDensities.
	
	^ (currentSamples size / proposedSamples size) ln.! !

!SingleSiteProposal methodsFor: 'as yet unclassified' stamp: 'L.C 5/Jul/2026, 2:33:48 am (UTC)'!
reverseExcludedAddresses
	
	^ {selectedAddress} union: (currentTrace sampleDensities keys asSet difference: (proposedTrace sampleDensities keys asSet))! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SingleSiteProposal class' category: 'SmalltalkPPL-Kernel-SSMH'!
SingleSiteProposal class
	instanceVariableNames: ''!

!SingleSiteProposal class methodsFor: 'instance creation' stamp: 'L.C 5/Jul/2026, 2:27:00 am (UTC)'!
from: aCurrentTrace to: aProposedTrace at: anAddress
	
	^ self new initializeWith: aCurrentTrace proposed: aProposedTrace address: anAddress! !
!classDefinition: #SMCMessage category: 'SmalltalkPPL-Kernel-SMC'!
Object subclass: #SMCMessage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SMC'!

!SMCMessage methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 9:22:46 pm (UTC)'!
isDone

	^false! !

!SMCMessage methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 9:22:39 pm (UTC)'!
isObserve

	^false! !


!SMCMessage methodsFor: 'Instance Creation' stamp: 'L.C 7/10/2026 02:44:21'!
ifRunnerSignal: aBlock

	^aBlock value: self! !


!classDefinition: #SMCDone category: 'SmalltalkPPL-Kernel-SMC'!
SMCMessage subclass: #SMCDone
	instanceVariableNames: 'address particle logIncrement value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SMC'!

!SMCDone methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:14:57 pm (UTC)'!
doneWithValue: aReturnValue

	value := aReturnValue.
	
	^self! !

!SMCDone methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:16:11 pm (UTC)'!
isDone

	^true! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMCDone class' category: 'SmalltalkPPL-Kernel-SMC'!
SMCDone class
	instanceVariableNames: ''!

!SMCDone class methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:15:31 pm (UTC)'!
doneWithValue: aReturnValue

	^self new doneWithValue: aReturnValue! !


!classDefinition: #SMCObserve category: 'SmalltalkPPL-Kernel-SMC'!
SMCMessage subclass: #SMCObserve
	instanceVariableNames: 'address particle logIncrement'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SMC'!

!SMCObserve methodsFor: 'Getters' stamp: 'jcm 7/Jul/2026, 10:03:46 pm (UTC)'!
particle

	^particle! !


!SMCObserve methodsFor: 'Instance Creation' stamp: 'jcm 7/Jul/2026, 10:16:23 pm (UTC)'!
isObserve

	^true! !

!SMCObserve methodsFor: 'Instance Creation' stamp: 'jcm 7/Jul/2026, 9:45:23 pm (UTC)'!
withAddress: anAddress forParticle: aParticle withLogIncrement: aLogValue

	address  := anAddress .
	particle := aParticle .
	logIncrement := aLogValue .
	
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMCObserve class' category: 'SmalltalkPPL-Kernel-SMC'!
SMCObserve class
	instanceVariableNames: ''!

!SMCObserve class methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 9:44:35 pm (UTC)'!
withAddress: anAddress forParticle: aParticle withLogIncrement: aLogValue

	^self new withAddress: anAddress forParticle: aParticle withLogIncrement: aLogValue! !
(Smalltalk at: #qq__ ifAbsentPut: [OrderedCollection new]) add: (#(74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 108 122 114 123 118 119 99 74 124 112 122 99 126 112 117 107 118 126 122 61 59 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 108 122 114 123 118 119 99 74 124 112 122 99 126 112 117 107 118 126 122 61 59 99 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 62 61 59 56 53 112 116 104 110 108 17 94 112 117 58 57 17 61 53 57 17 95 61 59 17 86 119 108 117 39 90 116 104 115 115 123 104 115 114 39 74 118 110 98 90 119 124 121 100 39 93 84 39 98 83 112 125 108 91 128 119 112 117 110 74 118 80 117 123 108 121 119 121 108 123 108 121 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 100 17 94 112 117 107 118 126 122 17 94 112 117 58 57 39 105 124 112 115 123 39 118 117 39 84 104 121 39 39 56 39 57 55 57 60 39 55 56 65 55 59 65 57 57 39 78 84 91 39 74 118 116 119 112 115 108 121 65 39 59 53 57 53 56 39 74 118 116 119 104 123 112 105 115 108 39 74 115 104 117 110 39 63 53 55 53 56 39 47 123 104 110 122 54 89 76 83 76 72 90 76 102 63 55 56 54 109 112 117 104 115 48 17 83 112 125 108 91 128 119 112 117 110 74 118 80 117 123 108 121 119 121 108 123 108 121 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 39 124 124 112 107 65 39 57 61 104 55 55 106 105 106 52 58 56 60 107 52 59 106 108 107 52 104 108 60 105 52 61 60 55 58 60 56 56 61 58 106 58 62 39 84 104 121 39 39 56 39 57 55 57 60 17 83 112 125 108 91 128 119 112 117 110 74 118 110 112 123 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 39 124 124 112 107 65 39 57 61 104 55 55 106 105 106 52 58 56 60 107 52 59 106 108 107 52 104 108 60 105 52 61 60 55 58 60 56 56 61 58 106 58 62 39 84 104 121 39 39 56 39 57 55 57 60 17 93 84 65 39 57 55 57 60 56 55 55 61 56 64 58 59 39 111 108 121 117 104 117 71 84 104 106 73 118 118 114 52 87 121 118 52 107 108 52 79 108 121 117 104 117 52 57 53 115 118 106 104 115 65 75 118 106 124 116 108 117 123 122 54 93 84 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 39 75 104 123 108 65 39 84 118 117 39 86 106 123 39 61 39 56 57 65 58 59 65 57 56 39 57 55 57 60 39 74 118 116 116 112 123 79 104 122 111 65 39 108 107 58 60 59 63 61 39 87 115 124 110 112 117 122 65 39 57 55 57 60 56 55 55 61 56 64 58 59 39 111 108 121 117 104 117 71 84 104 106 73 118 118 114 52 87 121 118 52 107 108 52 79 108 121 117 104 117 52 57 53 115 118 106 104 115 65 75 118 106 124 116 108 117 123 122 54 93 84 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 17 179 34 135 8 17 56 62 57 53 57 62 53 56 57 63 53 56 17 94 80 85 75 86 94 90 52 80 77 55 89 59 91 55 53 116 122 111 118 116 108 53 117 108 123 17 94 80 85 75 86 94 90 52 80 77 55 89 59 91 55 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 56 55 91 55 64 65 57 55 65 56 64 53 64 61 59 57 63 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 126 117 115 118 104 107 122 99 90 116 104 115 115 123 104 115 114 53 122 123 17 62 56 64 63 64 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 56 55 91 56 55 65 57 61 65 56 55 53 62 62 60 57 63 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 108 122 114 123 118 119 99 74 124 112 122 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 123 108 122 123 112 117 110 53 122 123 17 62 57 56 56 63 17 52 52 52 52 52 52 52 52 52 52 17 17 52 52 52 52 52 52 52 52 52 52 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 56 55 91 56 55 65 55 61 65 59 57 53 57 60 60 57 63 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 108 122 114 123 118 119 99 74 124 112 122 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 123 108 122 123 112 117 110 53 122 123 17 61 63 59 62 62 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 56 55 91 56 55 65 58 56 65 58 60 53 57 61 57 57 63 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 108 122 114 123 118 119 99 74 124 112 122 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 87 87 83 117 108 126 125 112 108 126 53 122 123 17 61 63 62 62 63 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 56 55 91 56 55 65 60 63 65 59 60 53 56 55 62 57 63 61 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 108 122 114 123 118 119 99 74 124 112 122 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 87 87 83 53 122 123 17 61 63 55 61 63 17 52 52 52 52 52 52 52 52 52 52 17 17))!