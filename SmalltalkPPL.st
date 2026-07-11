!classDefinition: #Signaling category: #'SmalltalkPPL-Evaluation'!
Object subclass: #Signaling
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Evaluation'!
!classDefinition: #DistributionTest category: #'SmalltalkPPL-Tests'!
TestCase subclass: #DistributionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!DistributionTest methodsFor: 'normal' stamp: 'L.C 11/Jul/2026 08:28:42'!
test01LogProb

	| dist prob |
	dist := NormalDistribution withMean: 0.0 standardDeviation: 1.0.
	
	prob := dist logarithmicProbabilityFor: 0.0.
	
	self assert: ((prob - (-0.918938)) abs < 0.0001)! !

!DistributionTest methodsFor: 'normal' stamp: 'L.C 11/Jul/2026 08:29:25'!
test02Sample

	| distribution randomMock sample |
	randomMock := ReadStream on: #(0.5 0.5).
	
	distribution := NormalDistribution withMean: 10 standardDeviation: 2.
	sample := distribution sampleUsing: randomMock.
	
	self assert: sample class equals: SmallFloat64.! !


!classDefinition: #InterpreterTest category: #'SmalltalkPPL-Tests'!
TestCase subclass: #InterpreterTest
	instanceVariableNames: 'runner machine'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!InterpreterTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 09:47:53'!
dummyMachineWithControlStack: aControlStack

^ Machine new
		initializeControlStack: aControlStack
		valueStack: nil 
		environment: nil 
		randomGenerator: Random new
		logWeight: 0.! !

!InterpreterTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 02:21:43'!
evalAST: anAST
	
	^ self evalAST: anAST withEnvironment: runner initialEnvironment.! !

!InterpreterTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:32:32'!
evalAST: anAST withEnvironment: anEnvironment
	
	machine := self dummyMachineWithControlStack: {
		Eval 
			expression: anAST 
			withEnvironment: anEnvironment 
			andAddress: AddressFactory root
		}.
		
	^ (machine resumeRunner: runner) value! !

!InterpreterTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 00:28:24'!
setUp
	runner := SSMHRunner new.
	runner trace: MHTrace new. "PARCHE TEMPORAL"! !


!classDefinition: #LWTest category: #'SmalltalkPPL-Tests'!
InterpreterTest subclass: #LWTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!LWTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 09:04:56'!
test01SampleReturnSampledValue

	| firstResult firstWeight normalDist results sampleInst |
	"normalDist := CallFunction withFunction: #normal withArguments: {0. 1}."
	normalDist := NormalDistribution withMean: 0 standardDeviation: 1.
	sampleInst := Sample withDistribution: normalDist.
	
	results := LikelihoodWeighting program: sampleInst rng: Random new for: 1.
		
	firstResult := results value first.
	firstWeight := results logWeights first.
	
	self assert: firstResult isNumber.
	self assert: firstWeight equals: 1.! !

!LWTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 08:27:01'!
test02WeightsNormalizeToOne
	
	| program results sumOfWeights weights |
	program := Sample withDistribution: (NormalDistribution withMean: 0 standardDeviation: 1).
	
	results := LikelihoodWeighting program: program rng: Random new for: 100.
	
	weights := results logWeights.
	
	sumOfWeights := weights sum.
	
	self assert: ((sumOfWeights - 1.0) abs < 0.0001).! !

!LWTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:24:44'!
test03AddressConventionIsStable

	| program runner1 runner2 result1 result2 distribution |
	distribution := NormalDistribution withMean: 0 standardDeviation: 1.
	program := Let binds: {#x . (Sample withDistribution: distribution)}
	withIndex: 1
	andBody: {(Observe withDistribution: distribution withObservedValue: 0.5)}
	andEnvironment: Dictionary new 
	andAddress: AddressFactory root.

	runner1 := LWRunner new.
	result1 := runner1 runWithProgram: program randomGenerator: (Random seed: 666).
	
	runner2 := LWRunner new.
	result2 := runner2 runWithProgram: program randomGenerator: (Random seed: 666).
	
	self assert: result1 value equals: result2 value.
	self assert: result1 logWeights equals: result2 logWeights.! !


!classDefinition: #MachineTest category: #'SmalltalkPPL-Tests'!
InterpreterTest subclass: #MachineTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 14:54:21'!
test01EvalLiteral
	
	self assert: (self evalAST: 100) equals: 100.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 15:09:56'!
test02EvalSymbol

	self assert: (self evalAST: #y withEnvironment: {#y -> 42} asDictionary) equals: 42.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026 21:18:38'!
test03EvalIfTrue

	self assert: (self evalAST: (If condition: true then: 2 else: 1)) equals: 2.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026 21:19:01'!
test04EvalIfFalse

	self assert: (self evalAST: (If condition: false then: 2 else: 1)) equals: 1.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026 22:49:58'!
test05EvalLet
	
	"Este test todavia falla"
	"self assert: (self evalAST: #(let (#x 1) #x)) equals: 1."
	self assert: (self evalAST: (Let initBinds: #(#x 1) withBody:#(#x))) equals: 1.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026 15:39:55'!
test06EvalLetMultipleBindings
	
	self assert: (self evalAST: (Let initBinds: (#(#x 2 #y 5)) withBody: #(#y))) equals: 5.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026 15:40:58'!
test07EvalDiscard
	
	
	self assert: (self evalAST: (Let initBinds: #(#x 1) withBody: #(10 99))) equals: 99.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 03:51:15'!
test08EvalFn
	"identidad"
	
	"self assert: (self evalAST: #((fn (#x) #x) 42)) equals: 42."
	"self assert: (self evalAST: (Fn withParameters: #(#x) andBody: #(#x 42))) equals: 42."
	self assert: 
		(self evalAST: (CallFunction withFunction: (Fn withParameters: #(#x) andBody: #(#x))
			withArguments: #(42))) 
				equals: 42.
	! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 02:24:28'!
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

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 9/Jul/2026 23:43:11'!
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

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:38:18'!
test11EvalSample

	| ast result env distribution |
	
	"ast := #(sample #(normal 0 1))."
	distribution := NormalDistribution withMean: 0 standardDeviation: 1.
	ast := Sample withDistribution: distribution.
	
	
	"parche temporal"
	env := {#normal -> #normal } asDictionary.
	
	machine := self dummyMachineWithControlStack: {
		Eval expression: ast withEnvironment: env andAddress: AddressFactory root
	}.
	
	runner machine: machine. "PARCHE TEMPORAL, HAY QUE VERLO BIEN COMO MANEJARLO"
	result := machine resumeRunner: runner.
	
	self assert: result class equals: SSMHRun.
	self assert: result trace sampleValues size equals: 1.
	self assert: (result trace sampleValues includesKey: AddressFactory root).! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:38:32'!
test12EvalObserve
	
	| ast result distribution |
	
	"ast := #(observe #(normal 0 1) 5)."
	distribution:= NormalDistribution withMean: 0 standardDeviation: 1.
	ast := Observe withDistribution: distribution withObservedValue: 5.
		
	machine := self dummyMachineWithControlStack: {Eval 
		expression: ast 
		withEnvironment: {#normal -> #normal} asDictionary
		andAddress: AddressFactory root
	}.
	
	runner machine: machine. "PARCHE TEMPORAL, HAY QUE VERLO BIEN COMO MANEJARLO"
	result := machine resumeRunner: runner.
	
	self assert: result class equals: SSMHRun.
	self assert: result trace observeDensities size equals: 1.
	self assert: (result trace observeDensities values first) notNil.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 09:47:53'!
test13EvalDone

	| result |
	machine := Machine new 
		initializeControlStack: #()
		valueStack: (OrderedCollection with: 99)
		environment: Dictionary new
		randomGenerator: nil
		logWeight: 0.
		
	result := machine resumeRunner: runner.
	
	self assert: result class equals: SSMHRun.
	self assert: result value equals: 99.! !


!classDefinition: #SMCTest category: #'SmalltalkPPL-Tests'!
InterpreterTest subclass: #SMCTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!SMCTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 09:04:55'!
test01DonePreservesParticleOrder

    | p1 p2 p3 result |
    p1 := self dummyMachineWithControlStack: #(). 
    p2 := self dummyMachineWithControlStack: #(). 
    p3 := self dummyMachineWithControlStack: #().

    p1 pushValue: 1.0.
    p2 pushValue: 2.5.
    p3 pushValue: -3.0.

    runner := SMCRunner new.
    result := runner runWithProgram: nil withRng: Random new withParticles: {p1. p2. p3}.

    self assert: result class equals: SMCRun.
    self assert: result value asArray equals: {1.0. 2.5. -3.0}.! !

!SMCTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 08:27:31'!
test02RejectsBrokenObserve

	| p1 p2 |
	"es insta Done"
	p1 := self dummyMachineWithControlStack: #(). 
	p1 pushValue: 1.
	

	"intercepta Observe"
	p2 := self dummyMachineWithControlStack: {Observe withAddress: #(#sigma)}.
	p2 pushValue: (NormalDistribution withMean: 0 standardDeviation: 1).
	p2 pushValue: 0.

	runner := SMCRunner new.

	self should: [ runner runWithProgram: nil withRng: Random new withParticles: {p1. p2}] 
        	raise: Error
        	withExceptionDo: [ :exception | self assert: exception messageText equals: 'algorithm needs all particles to reach observe together'].! !

!SMCTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 08:29:03'!
test03ObserveUpdateWeight

    | particle distribution program |

    particle := self dummyMachineWithControlStack: #().

    runner := SMCRunner new.
    runner machine: particle.

    distribution := NormalDistribution withMean: 0 standardDeviation: 1.
    program := runner observeWithAddress: #sigma withDistribution: distribution withObservedValue: 0.

    self assert: program isObserve.
    self assert: program particle equals: particle.
    self assert: particle popValue equals: 0.
    self assert: particle logWeights equals: (distribution logarithmicProbabilityFor: 0).! !

!SMCTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 08:27:44'!
test04SampleReturnsSampledValue

    | particle distribution sampled |

    particle := self dummyMachineWithControlStack: #().
    runner := SMCRunner new.
    runner machine: particle.

    distribution := NormalDistribution withMean: 0 standardDeviation: 1.
    sampled := runner sampleWithAddress: #mu withDistribution: distribution.

    self assert: sampled isFloat.
    self should: [ particle popValue] raise: Error.! !

!SMCTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026 18:20:59'!
test05ResamplingCopiesSelectedAncestors

    | p1 p2 p3 messages rng particles |

    p1 := self dummyMachineWithControlStack: #().
    p2 := self dummyMachineWithControlStack: #().
    p3 := self dummyMachineWithControlStack: #().
    p1 pushValue: 10.
    p2 pushValue: 11.
    p3 pushValue: 12.

    messages := {
        SMCObserve withAddress: #sigma forParticle: p1 withLogIncrement: 1.0.
        SMCObserve withAddress: #sigma forParticle: p2 withLogIncrement: 1.0.
        SMCObserve withAddress: #sigma forParticle: p3 withLogIncrement: 1.0}.

    rng := Random seed: 666.

    runner := SMCRunner new.
    runner runWithProgram: nil withRng: {rng. rng. rng} withParticles: {p1. p2. p3}.

    particles := runner resampleFromObserveMessages: messages.

    self assert: particles size equals: 3.

    particles do: [ :copiedParticle |
	self deny: copiedParticle == p1.
        self deny: copiedParticle == p2.
        self deny: copiedParticle == p3.
        self assert: copiedParticle class equals: Machine.
	 self assert: copiedParticle randomGenerator equals: rng.
        self assert: (#(10 11 12) includes: copiedParticle popValue)].! !


!classDefinition: #SSMHTest category: #'SmalltalkPPL-Tests'!
InterpreterTest subclass: #SSMHTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:38:51'!
test01InitialTraceRegistersSamples

	| ast distribution result |
	distribution := NormalDistribution withMean: 0 standardDeviation: 1.
	ast := Sample withDistribution: distribution.
	
	machine := self dummyMachineWithControlStack: {Eval expression: ast withEnvironment: Dictionary new andAddress: AddressFactory root}.
	runner machine: machine.
	result := machine resumeRunner: runner.
	
	self assert: result class equals: SSMHRun.
	self assert: (result trace sampleValues includesKey: AddressFactory root).
	self assert: (result trace sampleDensities includesKey: AddressFactory root).! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:39:15'!
test02InitialTraceRegistersObserves

	| ast distribution result |
	distribution := NormalDistribution withMean: 0 standardDeviation: 1.
	ast := Observe withDistribution: distribution withObservedValue: 5.
	
	machine := self dummyMachineWithControlStack: {Eval expression: ast withEnvironment: Dictionary new andAddress: AddressFactory root}.
	runner machine: machine.
	result := machine resumeRunner: runner.
	
	self assert: result class equals: SSMHRun.
	self assert: (result trace observeDensities includesKey: AddressFactory root).! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 11:11:01'!
test03CacheReuseAtNonRedrawAddress

	| ast cache result distribution |
	
	distribution := NormalDistribution withMean: 0 standardDeviation: 1.
	ast := Sample withDistribution: distribution.
	cache := Dictionary new.
	cache at: AddressFactory root put: 42.

	runner := SSMHRunner new.

	result := runner run: ast withRandomGenerator: Random new redrawAddress: #(#another) asAddress cache: cache.

	self assert: (result trace sampleValues at: AddressFactory root) equals: 42.! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 11:12:11'!
test04RedrawSiteForcesNewSample
	
	| ast cache distribution dummyRandom result |
	dummyRandom := ReadStream on: #(0.5 0.5).
	
	distribution := NormalDistribution withMean: 0 standardDeviation: 1.
	ast := Sample withDistribution: distribution.
	
	cache := Dictionary new.
	cache at: AddressFactory root put: 42.
	
	runner := SSMHRunner new.
	result := runner run: ast withRandomGenerator: dummyRandom redrawAddress: AddressFactory root cache: cache. "forzamos una muestra nueva"
	
	self assert: (result trace sampleValues at: AddressFactory root) ~= 42.! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 11:11:21'!
test05AbsentAddressInCacheForcesNewSample
	
	| ast cache distribution dummyRandom result |
	dummyRandom := ReadStream on: #(0.5 0.5).
	
	distribution := NormalDistribution withMean: 0 standardDeviation: 1.
	ast := Sample withDistribution: distribution.
	
	cache := Dictionary new. "cache nula"
	
	runner := SSMHRunner new.
	result := runner run: ast withRandomGenerator: dummyRandom redrawAddress: #(#another) asAddress cache: cache.
	
	self assert: (result trace sampleValues includesKey: AddressFactory root).
	self assert: (result trace sampleValues at: AddressFactory root) notNil.! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026 14:30:19'!
test06RandomSampleAddressWithEmptyTrace
	| trace randomGenerator |
	
	trace := MHTrace new.
	randomGenerator := Random new.
	
	self should: [trace randomSampleAdressUsing: randomGenerator] 
		raise: Error 
		withExceptionDo: [ :anException |
			self assert: anException messageText equals: 'Cannot pick an address from an empty trace.'].! !


!classDefinition: #MainTest category: #'SmalltalkPPL-Tests'!
TestCase subclass: #MainTest
	instanceVariableNames: 'originalProgramTest'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 12:58:02'!
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

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 11:15:43'!
testConjLW

	| results posteriori foldWeight weight |
	
	results := LikelihoodWeighting program: self genProgram rng: Random new for: 200.

	foldWeight := 0.
		
	1 to: results value size do: [ :index | 
		| thisValue | 
		thisValue := results value at: index.
		weight := results logWeights at: index.
		foldWeight := foldWeight + (thisValue * weight)].
	
	posteriori := foldWeight.
	
	self assert: (posteriori between: 0.9 and: 1.4).! !

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 11:15:39'!
testConjSMC
	| posteriori particles rng magicNumber |
	
	rng := Random seed: 666.
	
	"numero mágico para separar las seeds, random next devuelve entre 0 y 1"
	magicNumber := 222222222.
	
	particles := SequentialMonteCarlo 
		program: self genProgram 
		rng: ((1 to: 200) collect: [ :each | Random seed: (rng next * magicNumber) asInteger])
		for: 200.
	
	posteriori := particles value sum / particles value size.
	
	self assert: (posteriori between: 0.9 and: 1.4).! !

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 11:15:33'!
testConjSSMH
	| chain posteriori |
	
	chain := SingleSiteMetropolisHastings 
		program: self genProgram
		rng: Random new 
		steps: 500
		warmup: 200.

	posteriori := (chain collect: [:i | i value]) sum / chain size.
	
	self assert: (posteriori between: 0.9 and: 1.4).! !

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 11:16:48'!
testGeometric

	| geomFn program posteriori results rng bernoulli |
	
	rng := Random seed: 1.
	bernoulli := BernoulliDistribution withProbability: 0.3.
		
	geomFn := Fn withParameters: #(#geom) andBody: {
		If condition: (Sample withDistribution: bernoulli)
			then: 0 else: (CallFunction withFunction: #+ withArguments: {
				1. CallFunction withFunction: #geom withArguments: #(#geom)})}.
	
	program := Let 
		initBinds: {#geom . geomFn} 
		withBody: {CallFunction withFunction: #geom withArguments: #(#geom)}.
		
	results := LikelihoodWeighting program: program rng: rng for: 500.
	
	posteriori := results value sum / results value size.
	
	self assert: (posteriori between: 2.1 and: 2.5).! !

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 09:04:53'!
testShift

	| program results |
	
	program := Let initBinds: {
		#makeShift . Fn withParameters: #(#mu) andBody: { 
			Fn withParameters: #(#x) andBody: { 
			CallFunction withFunction: #+ withArguments: #(#x #mu)}}.
			#f . CallFunction withFunction: #makeShift withArguments: #(10)}
		withBody: {
			CallFunction withFunction: #f withArguments: #(3)}.

	results := LikelihoodWeighting program: program rng: (Random seed: 0) for: 1.
	
	self assert: results value first equals: 13.! !
!classDefinition: #Closure category: #'SmalltalkPPL-Instructions'!
Object subclass: #Closure
	instanceVariableNames: 'parameters body environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:33:07'!
applyArguments: arguments onMachine: aMachine atAddress: anAddress

	| newEnv newAddress |
	newEnv := environment copy.
	
	1 to: parameters size do: [ :i | newEnv at: (parameters at: i) put: (arguments at: i)].

	newAddress := anAddress/(aMachine nextAddressFor: anAddress).
	
	aMachine pushBody: body withEnvironment: newEnv address: newAddress.! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 17:36:17'!
body

	^body! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 17:36:07'!
environment

	^ environment 
	! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 17:35:38'!
initializeWithParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment
	
	parameters := aParametersCollection.
	body := aBody.
	environment := anEnvironment.
	
	^ self! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 17:36:01'!
parameters

	^parameters 
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Closure class' category: #'SmalltalkPPL-Instructions'!
Closure class
	instanceVariableNames: ''!

!Closure class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 17:35:12'!
withParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment

	^ self new initializeWithParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment! !


!classDefinition: #Instruction category: #'SmalltalkPPL-Instructions'!
Object subclass: #Instruction
	instanceVariableNames: 'address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 13:27:43'!
address

	^ address! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 13:34:14'!
address: anAddress
	
	address := anAddress.! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026 21:23:12'!
evalWithMachine: aMachine withEnvironment: anEnviroment andAddress: anAddress

	self subclassResponsibility! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 13:27:29'!
executeOn: aMachine runner: aRunner
	
	self subclassResponsibility! !


!classDefinition: #Call category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Call
	instanceVariableNames: 'count'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Call methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 13:34:41'!
executeOn: aMachine runner: aRunner
	
	| arguments operator |
	arguments := aMachine popValues: count.
	operator := aMachine popValue.
	
	operator applyArguments: arguments onMachine: aMachine atAddress: address.

	^self! !

!Call methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 13:34:29'!
initializeExpecting: aCount at: anAddress

	count := aCount.
	address := anAddress.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Call class' category: #'SmalltalkPPL-Instructions'!
Call class
	instanceVariableNames: ''!

!Call class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 18:37:59'!
expecting: aCount at: anAddress

	^ self new initializeExpecting: aCount at: anAddress! !


!classDefinition: #CallFunction category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #CallFunction
	instanceVariableNames: 'function arguments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!CallFunction methodsFor: 'Instance Creation' stamp: 'L.C 11/Jul/2026 10:45:16'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: anAddress

	| count baseAddress |

	count := arguments size.
	baseAddress := anAddress asAddress.

	aMachine pushControl: (Call expecting: count at: anAddress).

	arguments size to: 1 by: -1 do: [ :index |
		aMachine pushControl: (Eval
			expression: (arguments at: index)
			withEnvironment: anEnvironment
			andAddress: (anAddress/(index-1)))
	].

	aMachine pushControl: (Eval
		expression: function
		withEnvironment: anEnvironment
		andAddress: (anAddress/#operator)).

	^ self! !

!CallFunction methodsFor: 'Instance Creation' stamp: 'L.C 10/Jul/2026 13:40:31'!
withFunction: aFunction withArguments: aCollectionOfArguments
	
	function  := aFunction.
	arguments  := aCollectionOfArguments.
	
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CallFunction class' category: #'SmalltalkPPL-Instructions'!
CallFunction class
	instanceVariableNames: ''!

!CallFunction class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026 17:31:38'!
withFunction: aFunction withArguments: aCollectionOfArguments

	^self new withFunction: aFunction withArguments: aCollectionOfArguments
	
		! !


!classDefinition: #Discard category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Discard
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Discard methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 13:41:48'!
executeOn: aMachine runner: aRunner
	
	aMachine popValue.
	^ self! !


!classDefinition: #Eval category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Eval
	instanceVariableNames: 'expression environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Eval methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 03:29:39'!
executeOn: aMachine runner: aRunner
	
	expression evalWithMachine: aMachine withEnvironment: environment andAddress: address.
	
	^ self! !

!Eval methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 14:01:48'!
initExpression: anExpression withEnvironment: anEnvironment andAddress: anAddress

	expression := anExpression.
	environment := anEnvironment.
	address := anAddress.
	
	^ self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Eval class' category: #'SmalltalkPPL-Instructions'!
Eval class
	instanceVariableNames: ''!

!Eval class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 14:03:52'!
expression: anExpression withEnvironment: anEnvironment andAddress: anAddress
	
	^ self new initExpression: anExpression withEnvironment: anEnvironment andAddress: anAddress.! !


!classDefinition: #Fn category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Fn
	instanceVariableNames: 'parameters body'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Fn methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026 15:46:26'!
evalWithMachine: aMachine withEnvironment: anEnvironment  andAddress: anAddress


	aMachine pushValue: (Closure withParameters: parameters andBody: body andEnvironment: anEnvironment)
	
	! !


!Fn methodsFor: 'Instance Creation' stamp: 'jcm 9/Jul/2026 15:51:24'!
withParameters: aCollectionOfParamters andBody: aBodyFunction
	
	parameters := aCollectionOfParamters.
	body := aBodyFunction.
	
	^self ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Fn class' category: #'SmalltalkPPL-Instructions'!
Fn class
	instanceVariableNames: ''!

!Fn class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026 15:50:40'!
withParameters: aCollectionOfParamaters andBody: aBodyFunction

	^self new withParameters: aCollectionOfParamaters andBody: aBodyFunction
	
		! !


!classDefinition: #If category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #If
	instanceVariableNames: 'condition then else environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!If methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:59:13'!
evalWithMachine: aMachine withEnvironment: anEnviroment andAddress: anAddress

	| baseAddress |
	baseAddress := anAddress asAddress.
	aMachine pushControl: (If then: (self then) else: (self else) withEnvironment: anEnviroment andAddress: baseAddress).
	aMachine pushControl: (Eval expression: (self condition) withEnvironment: anEnviroment andAddress: (baseAddress/#test)).
	
	^ self! !

!If methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:29:38'!
executeOn: aMachine runner: aRunner
	
	| branch tag |
	
	aMachine popValue 
		ifTrue: [branch := then. tag := #then] 
		ifFalse: [branch := else. tag := #else].
	
	aMachine pushControl: (Eval expression: branch withEnvironment: environment andAddress: (address/tag)).
	
	^ self! !

!If methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026 20:11:47'!
initCondition: aConditionToEvaluate then: aThenExpression else: anElseExpression

	condition := aConditionToEvaluate.
	then := aThenExpression.
	else := anElseExpression.
	
	^self! !

!If methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 14:43:20'!
initThen: aThenExpression else: anElseExpression withEnvironment: anEnvironment andAddress: anAddress

	then := aThenExpression.
	else  := anElseExpression.
	environment := anEnvironment.
	address := anAddress.
	
	^ self! !


!If methodsFor: 'Getters' stamp: 'jcm 8/Jul/2026 20:03:27'!
condition

	^condition! !

!If methodsFor: 'Getters' stamp: 'jcm 8/Jul/2026 20:03:16'!
else

	^else! !

!If methodsFor: 'Getters' stamp: 'jcm 8/Jul/2026 20:03:10'!
then

	^then! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'If class' category: #'SmalltalkPPL-Instructions'!
If class
	instanceVariableNames: ''!

!If class methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026 20:11:51'!
condition: aConditionToEvaluate then: aThenExpression else: anElseExpression

	^ self new initCondition: aConditionToEvaluate then: aThenExpression else: anElseExpression! !

!If class methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026 21:10:19'!
isCollection
	"TODO: REVISAR Parche "
	^true! !

!If class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 14:41:59'!
then: aThenExpression else: anElseExpression withEnvironment: anEnvironment andAddress: anAddress

	^ self new initThen: aThenExpression else: anElseExpression withEnvironment: anEnvironment andAddress: anAddress! !


!classDefinition: #Let category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Let
	instanceVariableNames: 'bindings index body environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:58:58'!
evalWithMachine: aMachine withEnvironment: anEnviroment andAddress: anAddress

		| baseAddress |
		baseAddress := anAddress asAddress.
		
		bindings isEmpty ifTrue: [
			aMachine pushBody: body withEnvironment: environment address: address.
			^ self].
		
		aMachine pushControl: (Let binds: bindings withIndex: 1 andBody: body andEnvironment: anEnviroment andAddress: baseAddress ).
		aMachine pushControl: (Eval expression: (bindings at: 2) withEnvironment: anEnviroment andAddress: (baseAddress/#let/1)).
		
		^self! !

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:30:02'!
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
				andAddress: (address/#let/nextIndex))
		] ifFalse: [
			aMachine pushBody: body withEnvironment: newEnv address: address.
		].
	
	^ self! !

!Let methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026 21:39:57'!
initBinds: aBindCollection withBody: aBody 

	bindings := aBindCollection.
	body := aBody.
	
	^ self! !

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 13:02:53'!
initBinds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress
	"esto no se esta usando"
	bindings := aBindCollection.
	index := anIndex.
	body := aBody.
	environment := anEnvironment.
	address := anAddress.
	
	^ self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Let class' category: #'SmalltalkPPL-Instructions'!
Let class
	instanceVariableNames: ''!

!Let class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026 14:24:35'!
binds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress

	^ self new initBinds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress! !

!Let class methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026 21:41:39'!
initBinds: aBindCollection withBody: aBody 

	^self new initBinds: aBindCollection withBody: aBody ! !


!classDefinition: #Observe category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Observe
	instanceVariableNames: 'distribution observedValue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Observe methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:58:21'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: aRawAddress

	address := aRawAddress asAddress.
	
	aMachine pushControl: (Observe withAddress: address).
	
	aMachine pushControl: (Eval 
		expression: (observedValue) 
		withEnvironment: anEnvironment 
		andAddress: (address/#v)).

	aMachine pushControl: (Eval 
		expression: (distribution) 
		withEnvironment: anEnvironment 
		andAddress: (address/#d)).
	
	^ self! !

!Observe methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026 23:57:58'!
executeOn: aMachine runner: aRunner
	
	| d y |
	y := aMachine popValue.
	d := aMachine popValue.

	^ aRunner observeWithAddress: address withDistribution: d withObservedValue: y.! !

!Observe methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026 02:09:14'!
initializeWithAddress: anAddress

	address := anAddress! !


!Observe methodsFor: 'Instance Creation' stamp: 'jcm 9/Jul/2026 20:01:52'!
withDistribution: aDistribution withObservedValue: anObservedValue
	
	distribution := aDistribution.
	observedValue:= anObservedValue .
	
	^self
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Observe class' category: #'SmalltalkPPL-Instructions'!
Observe class
	instanceVariableNames: 'distribution observedValue'!

!Observe class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026 02:08:59'!
withAddress: anAddress

	^ self new initializeWithAddress: anAddress! !


!Observe class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026 20:01:08'!
withDistribution: aDistribution withObservedValue: anObservedValue

	^self new withDistribution: aDistribution withObservedValue: anObservedValue
	
	
	! !


!classDefinition: #Sample category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Sample
	instanceVariableNames: 'distribution'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!

!Sample methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 10:57:57'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: aRawAddress

	aMachine pushControl: (Sample withAddress: aRawAddress).
	aMachine pushControl: (Eval 
			expression: distribution
			withEnvironment: anEnvironment 
			andAddress: (aRawAddress asAddress/#d)).
	^ self! !

!Sample methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 10:03:58'!
executeOn: aMachine runner: aRunner

	| sampled |
	distribution := aMachine popValue.
	sampled := aRunner sampleWithAddress: address withDistribution: distribution.
	
	aMachine pushValue: sampled.
	
	^sampled.! !

!Sample methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026 02:09:20'!
initializeWithAddress: anAddress

	address := anAddress! !


!Sample methodsFor: 'Instance Creation' stamp: 'jcm 9/Jul/2026 19:40:27'!
withDistribution: aDistribution 
	
	
	distribution := aDistribution .
	
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sample class' category: #'SmalltalkPPL-Instructions'!
Sample class
	instanceVariableNames: ''!

!Sample class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026 02:08:51'!
withAddress: anAddress

	^ self new initializeWithAddress: anAddress! !


!Sample class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026 19:39:20'!
withDistribution: aDistribution 

	^self new withDistribution: aDistribution 
	! !
!classDefinition: #Distribution category: #'SmalltalkPPL-MiniPPL'!
Object subclass: #Distribution
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!Distribution methodsFor: 'sampling' stamp: 'L.C 7/Jul/2026 01:26:26'!
sample
	^self subclassResponsibility! !

!Distribution methodsFor: 'sampling' stamp: 'L.C 11/Jul/2026 08:02:00'!
sampleUsing: aRandomNumberGenerator

	^self subclassResponsibility! !


!Distribution methodsFor: 'evaluation' stamp: 'L.C 11/Jul/2026 08:05:03'!
logarithmicProbabilityFor: aValue

	^self subclassResponsibility! !


!classDefinition: #BernoulliDistribution category: #'SmalltalkPPL-MiniPPL'!
Distribution subclass: #BernoulliDistribution
	instanceVariableNames: 'randomGenerator probability'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!BernoulliDistribution methodsFor: 'sampling' stamp: 'L.C 11/Jul/2026 08:09:19'!
sample
	
	^self sampleUsing: randomGenerator.! !

!BernoulliDistribution methodsFor: 'sampling' stamp: 'L.C 11/Jul/2026 08:08:57'!
sampleUsing: aRandomGenerator
	
	^aRandomGenerator next < probability.! !


!BernoulliDistribution methodsFor: 'initialization' stamp: 'L.C 11/Jul/2026 08:15:20'!
initializeWithProbability: aProbability

	probability := aProbability asFloat.
		
	^self.! !


!BernoulliDistribution methodsFor: 'evaluation' stamp: 'L.C 11/Jul/2026 09:11:35'!
logarithmicProbabilityFor: aValue

	(aValue isKindOf: Boolean) ifFalse: [self error: 'Observed value must be boolean'].

	aValue 
		ifTrue: [^probability ln]
		ifFalse: [^(1-probability) ln].
	
	^Float negativeInfinity.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BernoulliDistribution class' category: #'SmalltalkPPL-MiniPPL'!
BernoulliDistribution class
	instanceVariableNames: ''!

!BernoulliDistribution class methodsFor: 'instance creation' stamp: 'L.C 11/Jul/2026 08:14:53'!
withProbability: aProbability

	(aProbability between: 0 and: 1) ifFalse: [self error: 'Probability must exists in [0,1]'].
	
	^self new initializeWithProbability: aProbability
! !


!classDefinition: #NormalDistribution category: #'SmalltalkPPL-MiniPPL'!
Distribution subclass: #NormalDistribution
	instanceVariableNames: 'mean standardDeviation randomGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!NormalDistribution methodsFor: 'initialization' stamp: 'L.C 11/Jul/2026 08:25:53'!
initializeWithMean: aMeanValue standardDeviation: aStandardDeviation
	
	mean := aMeanValue.
	standardDeviation := aStandardDeviation.! !


!NormalDistribution methodsFor: 'getters' stamp: 'L.C 11/Jul/2026 08:05:34'!
mean 

	^mean! !


!NormalDistribution methodsFor: 'evaluation' stamp: 'L.C 11/Jul/2026 08:05:24'!
logarithmicProbabilityFor: aValue

"z = (float(x) - self.mu) / self.sigma
        return -0.5 * (LOG2PI + z * z) - math.log(self.sigma)"

	| log2Pi normalized |
	normalized := (aValue asFloat - mean) / standardDeviation.
	log2Pi := (Float pi * 2.0) ln.
	
	^ -0.5 * (log2Pi + (normalized * normalized)) - standardDeviation ln! !


!NormalDistribution methodsFor: 'sampling' stamp: 'L.C 11/Jul/2026 08:03:32'!
sample

	^self sampleUsing: randomGenerator.! !

!NormalDistribution methodsFor: 'sampling' stamp: 'L.C 11/Jul/2026 08:02:35'!
sampleUsing: aRandomNumberGenerator

	| u1 u2 z0 |
	
	u1 := aRandomNumberGenerator next.
	u2 := aRandomNumberGenerator next.
	
	u1 = 0.0 ifTrue: [ u1 := 1.0e-10 ].
	
	z0 := (-2.0 * u1 ln) sqrt * (2.0 * Float pi * u2) cos.
	
	^ (mean + (z0 * standardDeviation)) asFloat! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NormalDistribution class' category: #'SmalltalkPPL-MiniPPL'!
NormalDistribution class
	instanceVariableNames: ''!

!NormalDistribution class methodsFor: 'instance creation' stamp: 'L.C 11/Jul/2026 08:25:30'!
withMean: aMeanValue standardDeviation: aStandardDeviation
	
	aStandardDeviation <= 0 ifTrue: [self error: 'Standard deviation must be positive'].

	^ self new 
		initializeWithMean: aMeanValue 
		standardDeviation: aStandardDeviation.! !

!NormalDistribution class methodsFor: 'instance creation' stamp: 'L.C 10/Jul/2026 12:26:43'!
withMean: aMeanValue standardDeviation: aStandardDeviation randomGenerator: aRandomNumberGenerator
	
	aStandardDeviation <= 0 ifTrue: [self error: 'Standard deviation must be positive'].

	^ self new 
		initializeWithMean: aMeanValue 
		standardDeviation: aStandardDeviation 
		randomGenerator: aRandomNumberGenerator! !


!classDefinition: #Primitive category: #'SmalltalkPPL-MiniPPL'!
Object subclass: #Primitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!Primitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 02:03:32'!
applyArguments: arguments onMachine: aMachine atAddress: address
	
	self subclassResponsibility! !


!classDefinition: #AddPrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #AddPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!AddPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 02:05:49'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) + (arguments at: 2).
	aMachine pushValue: result.! !


!classDefinition: #BernoulliPrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #BernoulliPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!BernoulliPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 08:11:42'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| distribution |
	distribution := BernoulliDistribution withProbability: (arguments at: 1).
	
	aMachine pushValue: distribution.! !


!classDefinition: #DividePrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #DividePrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!DividePrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 02:16:21'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) / (arguments at: 2). "agregar caso den es 0"
	aMachine pushValue: result.! !


!classDefinition: #EqualPrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #EqualPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!EqualPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 02:16:41'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) = (arguments at: 2).
	aMachine pushValue: result.! !


!classDefinition: #MultiplyPrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #MultiplyPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!MultiplyPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 02:15:34'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) * (arguments at: 2).
	aMachine pushValue: result.! !


!classDefinition: #NormalPrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #NormalPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!NormalPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 08:25:10'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| distribution |
	distribution := NormalDistribution 
		withMean: (arguments at: 1) 
		standardDeviation: (arguments at: 2).

	aMachine pushValue: distribution.! !


!classDefinition: #SubtractPrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #SubtractPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!SubtractPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 02:15:14'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) - (arguments at: 2).
	aMachine pushValue: result.! !


!classDefinition: #SoftMax category: #'SmalltalkPPL-MiniPPL'!
Object subclass: #SoftMax
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!

!SoftMax methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026 15:00:18'!
for: aCollection

	"https://es.wikipedia.org/wiki/Funci%C3%B3n_SoftMax"
	| normalized |
	
	aCollection isEmpty 
		ifTrue: [ normalized := aCollection copy ]
		ifFalse: [ | expSum maxLog |
			maxLog := aCollection inject: aCollection first into: [:max :each | max max: each].
			expSum := aCollection inject: 0.0 into: [:sum :each | (each-maxLog) exp + sum].
			normalized := aCollection collect: [ :each | (each-maxLog) exp / expSum ].
		].
	
	^normalized! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SoftMax class' category: #'SmalltalkPPL-MiniPPL'!
SoftMax class
	instanceVariableNames: ''!

!SoftMax class methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026 15:00:59'!
for: aCollection

	^self new for: aCollection! !
!classDefinition: #ImportanceSamplingAlgorithms category: #'SmalltalkPPL-Algorithm'!
Object subclass: #ImportanceSamplingAlgorithms
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Algorithm'!

!ImportanceSamplingAlgorithms methodsFor: 'as yet unclassified' stamp: 'JCM 11/Jul/2026 12:04:41'!
executionForProgram: aProgram randomGenerator: aRandomNumberGenerator

	self subclassResponsibility! !

!ImportanceSamplingAlgorithms methodsFor: 'as yet unclassified' stamp: 'JCM 11/Jul/2026 12:12:48'!
program: aProgram rng: randomNumberGenerators for: aNumberOfSteps

	| executions rng |

	executions := (1 to: aNumberOfSteps) collect: [ :index |
		"En LW no tenemos una lista de rngs"
		randomNumberGenerators isCollection 
			ifTrue: [rng := randomNumberGenerators at:index]
			ifFalse:[rng := randomNumberGenerators ].
		
		self
			executionForProgram: aProgram
			randomGenerator: (rng)
	].

	^ self
		resultForProgram: aProgram
		randomNumberGenerators: randomNumberGenerators
		executions: executions! !

!ImportanceSamplingAlgorithms methodsFor: 'as yet unclassified' stamp: 'JCM 11/Jul/2026 12:04:51'!
resultForProgram: aProgram randomNumberGenerators: randomNumberGenerators executions: executions

	self subclassResponsibility! !


!classDefinition: #LikelihoodWeighting category: #'SmalltalkPPL-Algorithm'!
ImportanceSamplingAlgorithms subclass: #LikelihoodWeighting
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Algorithm'!

!LikelihoodWeighting methodsFor: 'as yet unclassified' stamp: 'JCM 11/Jul/2026 12:06:57'!
executionForProgram: aProgram randomGenerator: aRandomNumberGenerator

	^ LWRunner
		runWithProgram: aProgram
		randomGenerator: aRandomNumberGenerator! !

!LikelihoodWeighting methodsFor: 'as yet unclassified' stamp: 'JCM 11/Jul/2026 12:07:22'!
resultForProgram: aProgram randomNumberGenerators: aRandomNumberGenerator executions: runs

	| values logWeights normalizedWeights |

	values := runs collect: [ :run |
		run value asFloat
	].

	logWeights := runs collect: [ :run |
		run logWeights
	].

	normalizedWeights := SoftMax for: logWeights.

	^ LWRun
		withLogWeight: normalizedWeights
		value: values! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LikelihoodWeighting class' category: #'SmalltalkPPL-Algorithm'!
LikelihoodWeighting class
	instanceVariableNames: ''!

!LikelihoodWeighting class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026 19:00:13'!
checkPositiveNumberOfSteps: aNumberOfSteps

	aNumberOfSteps > 0 ifFalse:[Error signal: 'The number of steps should be positive'].
	
	
	! !

!LikelihoodWeighting class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026 18:59:16'!
program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps

	self checkPositiveNumberOfSteps: aNumberOfSteps.
	
	^self new program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps
	
	! !


!classDefinition: #SequentialMonteCarlo category: #'SmalltalkPPL-Algorithm'!
ImportanceSamplingAlgorithms subclass: #SequentialMonteCarlo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Algorithm'!

!SequentialMonteCarlo methodsFor: 'as yet unclassified' stamp: 'JCM 11/Jul/2026 12:05:20'!
executionForProgram: aProgram randomGenerator: aRandomNumberGenerator

	^ Machine
		initialMachineWithProgram: aProgram
		randomGenerator: aRandomNumberGenerator! !

!SequentialMonteCarlo methodsFor: 'as yet unclassified' stamp: 'JCM 11/Jul/2026 12:05:35'!
resultForProgram: aProgram randomNumberGenerators: randomNumberGenerators executions: particles

	^ SMCRunner
		runWithProgram: aProgram
		withRng: randomNumberGenerators
		withParticles: particles! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SequentialMonteCarlo class' category: #'SmalltalkPPL-Algorithm'!
SequentialMonteCarlo class
	instanceVariableNames: ''!

!SequentialMonteCarlo class methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 15:52:50'!
checkSizeOfRng: aRandomNumberGenerators EqualsSteps: aNumberOfSteps.

	aRandomNumberGenerators size == aNumberOfSteps ifFalse: [Error signal: 'The number of steps must be equal the number of the Random Number Generators']! !

!SequentialMonteCarlo class methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026 18:05:00'!
program: aProgram rng:aRandomNumberGenerators for: aNumberOfSteps

	self checkSizeOfRng: aRandomNumberGenerators EqualsSteps: aNumberOfSteps.
	
	^self new program: aProgram rng:aRandomNumberGenerators for: aNumberOfSteps! !


!classDefinition: #SingleSiteMetropolisHastings category: #'SmalltalkPPL-Algorithm'!
Object subclass: #SingleSiteMetropolisHastings
	instanceVariableNames: 'chain currentRun runner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Algorithm'!

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 09:32:44'!
checkAcceptionOf: aNewRunOfSSMH comparingWith: anOldRunOfSSMH with: aRandomNumberGenerator with: anA0
	
	| acceptanceRatio proposedTrace oldTrace proposal |
	
	proposedTrace := aNewRunOfSSMH trace.
	oldTrace := anOldRunOfSSMH trace.
	
	proposal := SingleSiteProposal withCurrentTrace: oldTrace proposedTrace: proposedTrace atAddress: anA0.
	acceptanceRatio := proposal logAlpha.

	((aRandomNumberGenerator next ln) < acceptanceRatio) ifTrue: [ currentRun := aNewRunOfSSMH ].	
! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 12:30:14'!
checkPassWarmup: aNumberOfWarmups Iterations: aNumberOfIteration

	aNumberOfIteration > aNumberOfWarmups ifTrue:[chain add: currentRun value].
	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 09:51:58'!
initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator

	currentRun := runner run: aProgram withRandomGenerator: aRandomNumberGenerator.

! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 09:51:17'!
initializeProgram: aProgram rng:aRandomNumberGenerator steps: aNumberOfSteps warmup: aNumberOfWarmups

	| newRun a0 |
	
	runner := SSMHRunner new.
	chain := OrderedCollection new.
	self initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator.
	
	1 to: aNumberOfSteps + aNumberOfWarmups do: [ :i |
		a0 := currentRun trace randomSampleAdressUsing: aRandomNumberGenerator.
		newRun := runner 
			run: aProgram 
			withRandomGenerator: aRandomNumberGenerator 
			redrawAddress: a0 
			cache: currentRun trace sampleValues.
			
		self checkAcceptionOf: newRun comparingWith: currentRun with: aRandomNumberGenerator with: a0.
		self checkPassWarmup: aNumberOfWarmups Iterations: i].
	
	
	
	^chain asArray.
	
	


! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SingleSiteMetropolisHastings class' category: #'SmalltalkPPL-Algorithm'!
SingleSiteMetropolisHastings class
	instanceVariableNames: ''!

!SingleSiteMetropolisHastings class methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026 12:29:56'!
program: aProgram rng: aRandomGenerator steps: aNumberOfSteps warmup: aNumberOfWarmups

	aNumberOfSteps > 0 ifFalse: [self error: 'Steps must be greather than 0'].
	aNumberOfWarmups >= 0 ifFalse: [self error: 'Warmup must be greater than or equal to 0.'].
	
	^self new initializeProgram: aProgram rng: aRandomGenerator steps: aNumberOfSteps warmup: aNumberOfWarmups.
! !
!classDefinition: #AddressFactory category: #'SmalltalkPPL-Core'!
Object subclass: #AddressFactory
	instanceVariableNames: 'path'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Core'!

!AddressFactory methodsFor: 'getters' stamp: 'L.C 11/Jul/2026 10:45:55'!
asAddress

	^self! !

!AddressFactory methodsFor: 'getters' stamp: 'L.C 11/Jul/2026 10:08:53'!
path
	
	^path! !


!AddressFactory methodsFor: 'comparing' stamp: 'L.C 11/Jul/2026 10:11:22'!
= anotherAddress

	(anotherAddress isKindOf: self class) ifFalse: [^false].
	
	^path = anotherAddress path! !

!AddressFactory methodsFor: 'comparing' stamp: 'L.C 11/Jul/2026 10:11:54'!
hash

	^path hash! !


!AddressFactory methodsFor: 'operations' stamp: 'L.C 11/Jul/2026 10:13:17'!
/ aTag

	^self class withPath: (path copyWith: aTag)! !


!AddressFactory methodsFor: 'initialization' stamp: 'L.C 11/Jul/2026 10:08:17'!
initializeWithPath: anArray

	path := anArray.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AddressFactory class' category: #'SmalltalkPPL-Core'!
AddressFactory class
	instanceVariableNames: ''!

!AddressFactory class methodsFor: 'instance creation' stamp: 'L.C 11/Jul/2026 10:12:48'!
root

	^self withPath: #()! !

!AddressFactory class methodsFor: 'instance creation' stamp: 'L.C 11/Jul/2026 10:12:29'!
withPath: anArray

	^self new initializeWithPath: anArray! !


!classDefinition: #Environment category: #'SmalltalkPPL-Core'!
Object subclass: #Environment
	instanceVariableNames: 'bindings parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Core'!

!Environment methodsFor: 'cloning' stamp: 'L.C 11/Jul/2026 11:25:17'!
copy
	
	^self class newWithParent: self! !


!Environment methodsFor: 'testings' stamp: 'L.C 11/Jul/2026 11:25:00'!
at: aKey

	^bindings at: aKey ifAbsent: [
		parent ifNil: [PPLError signal: aKey asString ].
		parent at: aKey]! !

!Environment methodsFor: 'testings' stamp: 'L.C 11/Jul/2026 11:24:09'!
at: aKey put: aValue

	bindings at: aKey put: aValue! !

!Environment methodsFor: 'testings' stamp: 'L.C 11/Jul/2026 11:23:41'!
includesKey: aKey

	(bindings includesKey: aKey) ifTrue: [^true].
	parent ifNil: [^false].
	
	^parent includesKey: aKey! !


!Environment methodsFor: 'initialization' stamp: 'L.C 11/Jul/2026 11:21:28'!
initializeWithParent: anEnvironment

	bindings := Dictionary new.
	parent := anEnvironment.
	
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Environment class' category: #'SmalltalkPPL-Core'!
Environment class
	instanceVariableNames: ''!

!Environment class methodsFor: 'instance creation' stamp: 'L.C 11/Jul/2026 11:22:13'!
newWithParent: anEnvironment

	^self new initializeWithParent: anEnvironment! !

!Environment class methodsFor: 'instance creation' stamp: 'L.C 11/Jul/2026 11:22:31'!
root

	^self new initializeWithParent: nil! !


!classDefinition: #Machine category: #'SmalltalkPPL-Core'!
Object subclass: #Machine
	instanceVariableNames: 'controlStack valueStack environment randomGenerator logWeight callCounter'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Core'!

!Machine methodsFor: 'setters' stamp: 'L.C 11/Jul/2026 09:45:40'!
incrementLogW: aValueOfLogWToSum

	logWeight := logWeight + aValueOfLogWToSum.! !

!Machine methodsFor: 'setters' stamp: 'L.C 10/Jul/2026 12:23:58'!
randomGenerator
	^randomGenerator! !


!Machine methodsFor: 'runner' stamp: 'L.C 11/Jul/2026 10:15:18'!
nextAddressFor: anPreAddress

	| count |
	count := callCounter at: anPreAddress ifAbsent: [0].
	callCounter at: anPreAddress put: count+1.
	^anPreAddress / count! !

!Machine methodsFor: 'runner' stamp: 'L.C 6/Jul/2026 13:31:17'!
popValue
	
	^ valueStack removeLast! !

!Machine methodsFor: 'runner' stamp: 'L.C 7/Jul/2026 23:30:18'!
popValues: anIndex
	
	| values |
	values := Array new: anIndex.
	
	anIndex to: 1 by: -1 do: [:index | values at: index put: valueStack removeLast].
	
	^ values! !

!Machine methodsFor: 'runner' stamp: 'L.C 11/Jul/2026 10:22:03'!
pushBody: aBody withEnvironment: anEnvironment address: anAddress
	
	| n |
	n := aBody size.
	n = 0 ifTrue: [^self].
	
	self pushControl: (Eval expression: (aBody at: n) withEnvironment: anEnvironment andAddress: (anAddress / n)).
	
	n-1 to: 1 by: -1 do: [ :index | 
		self pushControl: Discard new.
		self pushControl: (Eval expression: (aBody at: index) withEnvironment: anEnvironment andAddress: (anAddress / index))
	].! !

!Machine methodsFor: 'runner' stamp: 'L.C 6/Jul/2026 13:32:20'!
pushControl: anInstruction

	controlStack addLast: anInstruction.
	
	^ self.! !

!Machine methodsFor: 'runner' stamp: 'L.C 6/Jul/2026 13:31:41'!
pushValue: anObject

	valueStack addLast: anObject.
	^ self! !

!Machine methodsFor: 'runner' stamp: 'L.C 10/Jul/2026 05:47:16'!
resumeRunner: aRunner

	[controlStack notEmpty] whileTrue: [(self stepRunner: aRunner) ifRunnerSignal: [ :signal | ^signal ]].
	
	^ aRunner doneWithValue: valueStack last.! !

!Machine methodsFor: 'runner' stamp: 'L.C 10/Jul/2026 02:27:38'!
stepRunner: aRunner

	| instruction result |
	instruction := controlStack removeLast.
	
	result := instruction executeOn: self runner: aRunner.
	result == instruction ifFalse: [^result].
	^ nil! !


!Machine methodsFor: 'initialize' stamp: 'L.C 11/Jul/2026 09:47:53'!
initializeControlStack: aControlStack valueStack: aValueStack environment: aDictionaryOfVariables randomGenerator: aRandomNumberGenerator logWeight: aLogWeight

	controlStack := aControlStack asOrderedCollection.
	valueStack := aValueStack ifNil: [OrderedCollection new].
	environment := aDictionaryOfVariables ifNil: [Dictionary new].		
	randomGenerator := aRandomNumberGenerator.
	logWeight := aLogWeight.
	callCounter := Dictionary new.
	
	^self
			
	! !


!Machine methodsFor: 'getters' stamp: 'L.C 11/Jul/2026 09:37:35'!
callCounter: aDictionary

	callCounter := aDictionary! !

!Machine methodsFor: 'getters' stamp: 'L.C 11/Jul/2026 09:45:40'!
logWeights

	^logWeight! !


!Machine methodsFor: 'cloning' stamp: 'L.C 11/Jul/2026 09:47:53'!
forkWithRng: aRandomNumberGenerator
	
	| rng copiedControlStack copiedEnvironment copiedValueStack copiedCallCounter newMachine |
	
	rng := aRandomNumberGenerator ifNil: [randomGenerator].

	copiedControlStack := controlStack ifNotNil: [ controlStack copy ].
	copiedValueStack := valueStack ifNotNil: [ valueStack copy ].
	copiedEnvironment := environment ifNotNil: [ environment copy ].
	copiedCallCounter := callCounter ifNotNil: [ callCounter copy ].
	
	newMachine := Machine new
		initializeControlStack: copiedControlStack 
		valueStack: copiedValueStack 
		environment:  copiedEnvironment
		randomGenerator:  rng
		logWeight: logWeight.
	
	newMachine callCounter: copiedCallCounter.

	^newMachine
		
	
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Machine class' category: #'SmalltalkPPL-Core'!
Machine class
	instanceVariableNames: ''!

!Machine class methodsFor: 'instance creation' stamp: 'L.C 11/Jul/2026 10:22:39'!
initialMachineWithProgram: aParsedProgram randomGenerator: aRandomNumberGenerator

	| initialEnv initialEval |

	initialEnv := AlgorithmRunner new initialEnvironment.
	initialEval := Eval expression: aParsedProgram withEnvironment: initialEnv andAddress: AddressFactory root.
	
	^ self new initializeControlStack: {initialEval}
		valueStack: OrderedCollection new 
		environment: initialEnv
		randomGenerator: aRandomNumberGenerator
		logWeight: 0.0.! !
!classDefinition: #AlgorithmRunner category: #'SmalltalkPPL-Runner'!
Object subclass: #AlgorithmRunner
	instanceVariableNames: 'machine program randomNumberGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!

!AlgorithmRunner methodsFor: 'running' stamp: 'L.C 10/Jul/2026 12:48:03'!
run

	| runValue |
	
	[runValue isNil] whileTrue:[runValue := machine resumeRunner: self].
	"Termina cuando recibe un done"
	^runValue! !


!AlgorithmRunner methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 11:29:09'!
initialEnvironment
	| env |
	env := Environment root.
	env at: #+ put: AddPrimitive new.
	env at: #- put: SubtractPrimitive new.
	env at: #* put: MultiplyPrimitive new.
	env at: #/ put: DividePrimitive new.
	env at: #= put: EqualPrimitive new.
	env at: #normal put: NormalPrimitive new.
	env at: #bernoulli put: BernoulliPrimitive new.
	^env! !


!AlgorithmRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026 19:39:52'!
doneWithValue: aReturnValue

	self subclassResponsibility! !

!AlgorithmRunner methodsFor: 'Special Instructions' stamp: 'jcm 10/Jul/2026 17:32:36'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	self subclassResponsibility! !

!AlgorithmRunner methodsFor: 'Special Instructions' stamp: 'jcm 10/Jul/2026 17:33:20'!
sampleWithAddress: anAddress withDistribution: aDistribution

	self subclassResponsibility! !


!AlgorithmRunner methodsFor: 'setters' stamp: 'L.C 8/Jul/2026 02:20:23'!
machine: aMachine 
	
	machine := aMachine! !


!classDefinition: #ImportanceSamplingRunner category: #'SmalltalkPPL-Runner'!
AlgorithmRunner subclass: #ImportanceSamplingRunner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!

!ImportanceSamplingRunner methodsFor: 'Special Instructions' stamp: 'L.C 11/Jul/2026 08:19:07'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue
	
	| logIncrement |
	logIncrement := aDistribution logarithmicProbabilityFor: anObservedValue.
	
	machine incrementLogW: (aDistribution logarithmicProbabilityFor: anObservedValue).
	machine pushValue: anObservedValue.
	
	^self returnWithAddress: anAddress withLogIncrement: logIncrement withObservedValue: anObservedValue.
! !

!ImportanceSamplingRunner methodsFor: 'Special Instructions' stamp: 'L.C 11/Jul/2026 08:21:23'!
sampleWithAddress: anAddress withDistribution: aDistribution

	^aDistribution sampleUsing: machine randomGenerator.! !


!classDefinition: #LWRunner category: #'SmalltalkPPL-Runner'!
ImportanceSamplingRunner subclass: #LWRunner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!

!LWRunner methodsFor: 'initialize' stamp: 'L.C 11/Jul/2026 09:53:45'!
runWithProgram: aProgram randomGenerator: aRandomNumberGenerator

	randomNumberGenerator  := aRandomNumberGenerator.
	machine := Machine initialMachineWithProgram: aProgram randomGenerator: randomNumberGenerator.
	program := aProgram.
	
	^self run
	
	! !


!LWRunner methodsFor: 'Special Instructions' stamp: 'L.C 11/Jul/2026 09:57:08'!
doneWithValue: aReturnValue

"Cambiar nombre aReturnValue viene de V[-1] "

	
	^LWRun withLogWeight: machine logWeights value: aReturnValue.! !

!LWRunner methodsFor: 'Special Instructions' stamp: 'jcm 10/Jul/2026 17:37:34'!
returnWithAddress: anAddress withLogIncrement: logIncrement withObservedValue: anObservedValue

	^anObservedValue

	

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LWRunner class' category: #'SmalltalkPPL-Runner'!
LWRunner class
	instanceVariableNames: ''!

!LWRunner class methodsFor: 'instance creation' stamp: 'L.C 11/Jul/2026 09:53:45'!
runWithProgram: aProgram randomGenerator: aRandomNumberGenerator

	^self new runWithProgram: aProgram randomGenerator: aRandomNumberGenerator! !


!classDefinition: #SMCRunner category: #'SmalltalkPPL-Runner'!
ImportanceSamplingRunner subclass: #SMCRunner
	instanceVariableNames: 'particles randomNumberGenerators'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!

!SMCRunner methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 09:55:05'!
advance: aParticle

	machine := aParticle.
	
	^aParticle resumeRunner: self
	

	! !

!SMCRunner methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026 18:07:32'!
resampleFromObserveMessages: aCollectionOfObservedMessages

	| log_w probabilities ancestors newParticles |


	log_w := aCollectionOfObservedMessages collect: [:msg | msg logIncrement].
	
	probabilities := SoftMax for: log_w.
	
	"Equivalente a la linea rng.choice(N, size=N, p=probabilities)"
	ancestors := self sampleAncestors: randomNumberGenerators size withProbabilities: probabilities.
	
	newParticles := OrderedCollection new.
	
	"Selecciona las particulas nuevas para resamplear"
	1 to: aCollectionOfObservedMessages size do: [:newIndex |
		
		| oldIndex oldParticle newParticle |
		
		oldIndex := ancestors at: newIndex.
		
		oldParticle := (aCollectionOfObservedMessages at: oldIndex) particle.
		
		newParticle := oldParticle forkWithRng: (randomNumberGenerators at: newIndex).
		
		newParticles add: newParticle
	].

	^ newParticles
		
	
	
	


	

	! !

!SMCRunner methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026 15:44:59'!
sampleAncestors: numberOfAncestors withProbabilities: probabilities

	| rng cumulativeProbabilities accumulatedProbability |

	rng := randomNumberGenerators first.

	cumulativeProbabilities := OrderedCollection new.
	accumulatedProbability := 0.

	probabilities do: [ :probability |
		accumulatedProbability := accumulatedProbability + probability.
		cumulativeProbabilities add: accumulatedProbability
	].

	^ (1 to: numberOfAncestors) collect: [ :unused |
		
		| randomValue ancestorIndex |

		randomValue := rng next.
		ancestorIndex := 1.

		[
			ancestorIndex < cumulativeProbabilities size
				and: [
					randomValue > (cumulativeProbabilities at: ancestorIndex)
				]
		] whileTrue: [
			ancestorIndex := ancestorIndex + 1
		].

		ancestorIndex
	]

	

	! !


!SMCRunner methodsFor: 'Special Instructions' stamp: 'jcm 10/Jul/2026 15:57:41'!
doneWithValue: aReturnValue
	
	^SMCDone withValue: aReturnValue! !

!SMCRunner methodsFor: 'Special Instructions' stamp: 'L.C 11/Jul/2026 08:19:15'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	| logIncrement |
	logIncrement := aDistribution logarithmicProbabilityFor: anObservedValue.
	
	"Machine es la particula actual sobre la cual se esta avanzando, se define en el metodo advance"
	machine incrementLogW: logIncrement.
	machine pushValue: anObservedValue.
	
	^SMCObserve withAddress: anAddress forParticle: machine withLogIncrement: logIncrement! !

!SMCRunner methodsFor: 'Special Instructions' stamp: 'jcm 10/Jul/2026 17:36:41'!
returnWithAddress: anAddress withLogIncrement: logIncrement withObservedValue: anObservedValue.
	
	^SMCObserve withAddress: anAddress forParticle: machine withLogIncrement: logIncrement! !


!SMCRunner methodsFor: 'running' stamp: 'L.C 11/Jul/2026 09:19:50'!
run

	| messages |
	
	[true] whileTrue:[
		messages := particles collect: [:particle | self advance: particle].
		
		"Chequea si todas son Done"
		(messages allSatisfy: [:msg | msg isDone]) 
			ifTrue:[^SMCRun withValues: (messages collect: [:msg | msg value])].
		
		"Chequea si todas son Observe"
		(messages allSatisfy: [:msg | msg isObserve]) 
			ifFalse: [self error: 'algorithm needs all particles to reach observe together'].
			
		(messages allSatisfy: [:msg | msg address = messages first address])
			ifFalse: [self error: 'requires a shared observe sequence'].
		
		particles := self resampleFromObserveMessages: messages.
	]

	

	! !

!SMCRunner methodsFor: 'running' stamp: 'jcm 10/Jul/2026 15:39:19'!
runWithProgram: aProgram withRng: aCollectionOfRandomNumberGenerators  withParticles: aCollectionOfParticles

	particles := aCollectionOfParticles.
	randomNumberGenerators  := aCollectionOfRandomNumberGenerators .
	program  := aProgram.
	
	^self run

	

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMCRunner class' category: #'SmalltalkPPL-Runner'!
SMCRunner class
	instanceVariableNames: ''!

!SMCRunner class methodsFor: 'instance creation' stamp: 'jcm 10/Jul/2026 18:26:52'!
runWithProgram: aProgram withRng: aCollectionOfRandomNumberGenerators withParticles: aCollectionOfParticles
	
	^self new runWithProgram: aProgram withRng: aCollectionOfRandomNumberGenerators withParticles: aCollectionOfParticles! !


!classDefinition: #SSMHRunner category: #'SmalltalkPPL-Runner'!
AlgorithmRunner subclass: #SSMHRunner
	instanceVariableNames: 'redrawAddress cache trace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'L.C 11/Jul/2026 09:58:48'!
doneWithValue: aReturnValue

"Cambiar nombre aReturnValue viene de V[-1] "

	
	^SSMHRun withTrace: trace value: aReturnValue.

	
	
	! !

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'L.C 11/Jul/2026 08:19:51'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	
	trace updateObservedCacheAt: anAddress put: (aDistribution logarithmicProbabilityFor: anObservedValue) .
	machine pushValue: anObservedValue.
	
	^nil.! !

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'L.C 11/Jul/2026 08:23:32'!
sampleWithAddress: anAddress withDistribution: aDistribution 

	| sampledValue |
	
	trace ifNil: [trace := MHTrace new].
	
	(anAddress ~= redrawAddress and: [cache notNil and: [cache includesKey: anAddress]])
		ifTrue:[sampledValue := cache at: anAddress ]
		ifFalse:[sampledValue := aDistribution sampleUsing: machine randomGenerator ].
		
	trace updateSampleValuesAt: anAddress put: sampledValue.
	trace updateSampleDensitiesAt: anAddress put: (aDistribution logarithmicProbabilityFor: sampledValue).
	
	^sampledValue
	
	! !


!SSMHRunner methodsFor: 'setters' stamp: 'L.C 8/Jul/2026 00:39:53'!
trace: aTrace
	
	trace := aTrace! !


!SSMHRunner methodsFor: 'getters' stamp: 'L.C 10/Jul/2026 00:40:24'!
machine
	^machine! !

!SSMHRunner methodsFor: 'getters' stamp: 'L.C 10/Jul/2026 12:40:47'!
trace

	^trace
	! !


!SSMHRunner methodsFor: 'running' stamp: 'L.C 11/Jul/2026 11:09:23'!
run: aProgram withRandomGenerator: aRandomNumberGenerator

	| env result |
	env := self initialEnvironment.
	randomNumberGenerator := aRandomNumberGenerator.
	machine := Machine new
		initializeControlStack: { Eval expression: aProgram withEnvironment: env andAddress: AddressFactory root } 
		valueStack: nil
		environment: env
		randomGenerator: aRandomNumberGenerator 
		logWeight: 0.0.
	trace := MHTrace new.
	program := aProgram.
	
	result := self run.
	
	"esto lo revisa solo si es la primera run"
	(redrawAddress isNil and: [ trace sampleValues isEmpty ]) 
		ifTrue: [self error: 'SSMH requires at least one reachable sample site.'].
	
	^result.
	
! !

!SSMHRunner methodsFor: 'running' stamp: 'L.C 11/Jul/2026 11:09:28'!
run: aProgram withRandomGenerator: aRandomNumberGenerator redrawAddress: anAddressToRedraw cache: aCollectionOfSampledValues

	| env result |
	env := self initialEnvironment.
	randomNumberGenerator := aRandomNumberGenerator.
	machine := Machine new
		initializeControlStack: { Eval expression: aProgram withEnvironment: env andAddress: AddressFactory root} 
		valueStack: nil
		environment: env
		randomGenerator: aRandomNumberGenerator 
		logWeight: 0.0.
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
!classDefinition: #AlgorithmRuns category: #'SmalltalkPPL-ExecutionState'!
Object subclass: #AlgorithmRuns
	instanceVariableNames: 'values'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExecutionState'!

!AlgorithmRuns methodsFor: 'getters' stamp: 'L.C 11/Jul/2026 09:04:53'!
value
	^values! !


!AlgorithmRuns methodsFor: 'setters' stamp: 'L.C 11/Jul/2026 10:00:29'!
withValues: aCollectionOfValues

	values := aCollectionOfValues.
	
	^self! !


!classDefinition: #LWRun category: #'SmalltalkPPL-ExecutionState'!
AlgorithmRuns subclass: #LWRun
	instanceVariableNames: 'logWeights'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExecutionState'!

!LWRun methodsFor: 'getters' stamp: 'L.C 10/Jul/2026 08:22:13'!
logWeights
	
	^logWeights! !


!LWRun methodsFor: 'Instance Creation' stamp: 'L.C 11/Jul/2026 09:56:49'!
initializeWithLogWeight: aLogWValue  value: aReturnValue
	
	logWeights := aLogWValue.
	values := aReturnValue.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LWRun class' category: #'SmalltalkPPL-ExecutionState'!
LWRun class
	instanceVariableNames: ''!

!LWRun class methodsFor: 'instance creation' stamp: 'L.C 11/Jul/2026 09:58:36'!
withLogWeight: aLogWeight  value: aReturnValue

	^self new initializeWithLogWeight: aLogWeight value: aReturnValue ! !


!classDefinition: #SMCRun category: #'SmalltalkPPL-ExecutionState'!
AlgorithmRuns subclass: #SMCRun
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExecutionState'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMCRun class' category: #'SmalltalkPPL-ExecutionState'!
SMCRun class
	instanceVariableNames: ''!

!SMCRun class methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026 22:07:24'!
withValues: aCollectionOfValues

	^self new withValues: aCollectionOfValues! !


!classDefinition: #SSMHRun category: #'SmalltalkPPL-ExecutionState'!
AlgorithmRuns subclass: #SSMHRun
	instanceVariableNames: 'trace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExecutionState'!

!SSMHRun methodsFor: 'Instance Creation' stamp: 'L.C 11/Jul/2026 08:55:12'!
initializeWithTrace: aProposedTrace withValue: aReturnValue.
	
	trace := aProposedTrace.
	values := aReturnValue.
	
	^self! !


!SSMHRun methodsFor: 'getters' stamp: 'JCM 5/Jul/2026 19:51:15'!
trace

	^trace! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SSMHRun class' category: #'SmalltalkPPL-ExecutionState'!
SSMHRun class
	instanceVariableNames: 'trace value'!

!SSMHRun class methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 09:57:35'!
withTrace: aProposedTrace value: aReturnValue.
	
	
	
	^self new initializeWithTrace: aProposedTrace withValue: aReturnValue ! !
!classDefinition: #MHTrace category: #'SmalltalkPPL-Kernel-SSMH'!
Object subclass: #MHTrace
	instanceVariableNames: 'sampleDensities sampleValues observeDensities randomGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SSMH'!

!MHTrace methodsFor: 'evaluation' stamp: 'L.C 10/Jul/2026 01:56:34'!
logDensityExcluding: excludedAddresses

	| density |
	
	density := 0.
	
	observeDensities valuesDo: [:prob | density := density + prob].

	sampleDensities keysAndValuesDo: [:address :prob | (excludedAddresses includes: address) ifFalse: [density := density + prob]].
	
	^ density.! !


!MHTrace methodsFor: 'requesting' stamp: 'L.C 11/Jul/2026 09:23:49'!
includesSampleAt: anAddress
	
	^sampleValues includesKey: anAddress! !

!MHTrace methodsFor: 'requesting' stamp: 'L.C 11/Jul/2026 09:23:27'!
randomSampleAdressUsing: aRandomNumberGenerator

	sampleValues isEmpty ifTrue: [self error: 'Cannot pick an address from an empty trace.'].
	
	^sampleValues keys atRandom: aRandomNumberGenerator.! !

!MHTrace methodsFor: 'requesting' stamp: 'L.C 11/Jul/2026 09:24:08'!
sampleValueAt: anAddress

	^sampleValues at: anAddress! !

!MHTrace methodsFor: 'requesting' stamp: 'L.C 11/Jul/2026 09:24:27'!
sampleValueAt: anAddress ifAbsent: aBlock

	^sampleValues at: anAddress ifAbsent: aBlock! !


!MHTrace methodsFor: 'getters' stamp: 'L.C 11/Jul/2026 09:21:47'!
observeDensities
	
	^observeDensities copy! !

!MHTrace methodsFor: 'getters' stamp: 'L.C 11/Jul/2026 09:31:04'!
sampleAddresses

	^sampleDensities keys asSet! !

!MHTrace methodsFor: 'getters' stamp: 'L.C 11/Jul/2026 09:21:55'!
sampleDensities

	^sampleDensities copy! !

!MHTrace methodsFor: 'getters' stamp: 'L.C 11/Jul/2026 09:22:02'!
sampleValues 
	
	^sampleValues copy ! !

!MHTrace methodsFor: 'getters' stamp: 'L.C 11/Jul/2026 09:31:14'!
samplesCount

	^sampleDensities size! !


!MHTrace methodsFor: 'updating' stamp: 'L.C 10/Jul/2026 06:04:42'!
updateObservedCacheAt: anAddress put: anObservedDensity

	(observeDensities includesKey: anAddress) ifTrue: [self error: 'Address collision at ', anAddress asString].
	
	observeDensities at: anAddress put: anObservedDensity.! !

!MHTrace methodsFor: 'updating' stamp: 'L.C 10/Jul/2026 06:03:37'!
updateSampleDensitiesAt: anAddress put: aSampledDensity.

	(sampleDensities includesKey: anAddress) ifTrue: [self error: 'Address collision at ', anAddress asString].
	
	sampleDensities at: anAddress put: aSampledDensity! !

!MHTrace methodsFor: 'updating' stamp: 'L.C 10/Jul/2026 06:03:42'!
updateSampleValuesAt: anAddress put: aSampledValue.
	
	(sampleValues includesKey: anAddress) ifTrue: [self error: 'Address collision at ', anAddress asString].
	
	sampleValues at: anAddress put: aSampledValue ! !


!MHTrace methodsFor: 'initialization' stamp: 'L.C 8/Jul/2026 00:28:55'!
initialize
	sampleValues := Dictionary new.
	sampleDensities := Dictionary new.
	observeDensities := Dictionary new.! !


!classDefinition: #SingleSiteProposal category: #'SmalltalkPPL-Kernel-SSMH'!
Object subclass: #SingleSiteProposal
	instanceVariableNames: 'currentTrace proposedTrace selectedAddress'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SSMH'!
!SingleSiteProposal commentStamp: '<historical>' prior: 0!
Method Object!


!SingleSiteProposal methodsFor: 'evaluation' stamp: 'L.C 11/Jul/2026 09:34:20'!
forwardExcludedAddresses
	
	^ {selectedAddress} union: (proposedTrace sampleAddresses difference: currentTrace sampleAddresses)! !

!SingleSiteProposal methodsFor: 'evaluation' stamp: 'L.C 5/Jul/2026 02:52:53'!
logAlpha

	| numerator denominator |
	
	numerator := proposedTrace logDensityExcluding: self forwardExcludedAddresses.
	denominator := currentTrace logDensityExcluding: self reverseExcludedAddresses.

	^ numerator - denominator + self proposalRatio.! !

!SingleSiteProposal methodsFor: 'evaluation' stamp: 'L.C 5/Jul/2026 02:35:42'!
proposalRatio

	| currentSamples proposedSamples |

	currentSamples := currentTrace sampleDensities.
	proposedSamples := proposedTrace sampleDensities.
	
	^ (currentSamples size / proposedSamples size) ln.! !

!SingleSiteProposal methodsFor: 'evaluation' stamp: 'L.C 11/Jul/2026 09:33:56'!
reverseExcludedAddresses
	
	^ {selectedAddress} union: (currentTrace sampleAddresses difference: proposedTrace sampleAddresses)! !


!SingleSiteProposal methodsFor: 'initialization' stamp: 'L.C 5/Jul/2026 02:27:51'!
initializeWith: aCurrentTrace proposed: aProposedTrace address: anAddress

	currentTrace := aCurrentTrace.
	proposedTrace := aProposedTrace.
	selectedAddress := anAddress.
	
	^self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SingleSiteProposal class' category: #'SmalltalkPPL-Kernel-SSMH'!
SingleSiteProposal class
	instanceVariableNames: ''!

!SingleSiteProposal class methodsFor: 'instance creation' stamp: 'L.C 11/Jul/2026 09:32:44'!
withCurrentTrace: aCurrentTrace proposedTrace: aProposedTrace atAddress: anAddress
	
	^ self new initializeWith: aCurrentTrace proposed: aProposedTrace address: anAddress! !
!classDefinition: #SMCMessage category: #'SmalltalkPPL-Kernel-SMC'!
Object subclass: #SMCMessage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SMC'!

!SMCMessage methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026 21:22:46'!
isDone

	^false! !

!SMCMessage methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026 21:22:39'!
isObserve

	^false! !


!SMCMessage methodsFor: 'Instance Creation' stamp: 'L.C 10/Jul/2026 05:44:21'!
ifRunnerSignal: aBlock

	^aBlock value: self! !


!classDefinition: #SMCDone category: #'SmalltalkPPL-Kernel-SMC'!
SMCMessage subclass: #SMCDone
	instanceVariableNames: 'address particle logIncrement value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SMC'!

!SMCDone methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026 22:16:11'!
isDone

	^true! !

!SMCDone methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026 16:03:41'!
value

	^value! !

!SMCDone methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026 15:57:23'!
withValue: aReturnValue

	value := aReturnValue.
	
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMCDone class' category: #'SmalltalkPPL-Kernel-SMC'!
SMCDone class
	instanceVariableNames: ''!

!SMCDone class methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026 15:57:23'!
withValue: aReturnValue

	^self new withValue: aReturnValue! !


!classDefinition: #SMCObserve category: #'SmalltalkPPL-Kernel-SMC'!
SMCMessage subclass: #SMCObserve
	instanceVariableNames: 'address particle logIncrement'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SMC'!

!SMCObserve methodsFor: 'Getters' stamp: 'L.C 11/Jul/2026 09:14:06'!
address

	^address! !

!SMCObserve methodsFor: 'Getters' stamp: 'jcm 7/Jul/2026 22:03:46'!
particle

	^particle! !


!SMCObserve methodsFor: 'Instance Creation' stamp: 'L.C 11/Jul/2026 09:13:44'!
initializeWithAddress: anAddress forParticle: aParticle withLogIncrement: aLogValue

	address  := anAddress .
	particle := aParticle .
	logIncrement := aLogValue .
	
	^self! !

!SMCObserve methodsFor: 'Instance Creation' stamp: 'jcm 7/Jul/2026 22:16:23'!
isObserve

	^true! !

!SMCObserve methodsFor: 'Instance Creation' stamp: 'jcm 10/Jul/2026 17:50:50'!
logIncrement

	^logIncrement ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMCObserve class' category: #'SmalltalkPPL-Kernel-SMC'!
SMCObserve class
	instanceVariableNames: ''!

!SMCObserve class methodsFor: 'as yet unclassified' stamp: 'L.C 11/Jul/2026 09:13:44'!
withAddress: anAddress forParticle: aParticle withLogIncrement: aLogValue

	^self new initializeWithAddress: anAddress forParticle: aParticle withLogIncrement: aLogValue! !
!classDefinition: #PPLError category: #'SmalltalkPPL-Exceptions'!
SystemOrganizer subclass: #PPLError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Exceptions'!
!PPLError commentStamp: '<historical>' prior: 0!
Habria que implementar las excepciones con subclass de PPLError signal: 'blabla'!

!classDefinition: #NameOfSubclass category: #'SmalltalkPPL-ExactEnumeration'!
Object subclass: #NameOfSubclass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExactEnumeration'!


!classDefinition: #TraceEnumerator category: #'SmalltalkPPL-ExactEnumeration'!
Object subclass: #TraceEnumerator
	instanceVariableNames: 'stack finished visited maxStates'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExactEnumeration'!

!TraceEnumerator methodsFor: 'Special Instructions' stamp: 'JCM 11/Jul/2026 12:42:40'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue! !


!TraceEnumerator methodsFor: 'Instance Creation' stamp: 'JCM 11/Jul/2026 12:31:33'!
checkBudgetNotExceeded

	visited > maxStates ifTrue:[Error signal: 'state budget exceeded']! !

!TraceEnumerator methodsFor: 'Instance Creation' stamp: 'JCM 11/Jul/2026 12:45:43'!
enumerateTracesOf: aProgram forStates: aNumberOfStates
	
	| machine runner |
	stack := self initializeStackWith: aProgram.
	finished := Array new.
	visited := 0.
	maxStates := aNumberOfStates.
	
	[stack notEmpty] whileTrue:[
		visited := visited + 1.
		self checkBudgetNotExceeded.
		machine := stack pop.
		runner := TraceEnumeratorRunner withMachine: machine.
		machine resumeRunner: self.
		].
	
	^finished
	
	^self runEnumerator! !

!TraceEnumerator methodsFor: 'Instance Creation' stamp: 'JCM 11/Jul/2026 12:22:18'!
initializeStackWith: aProgram

	^ Machine initialMachineWithProgram: aProgram randomGenerator: Random new! !

!TraceEnumerator methodsFor: 'Instance Creation' stamp: 'JCM 11/Jul/2026 12:30:52'!
runEnumerator

	| machine |
	
	[stack notEmpty] whileTrue:[
		visited := visited + 1.
		self checkBudgetNotExceeded.
		machine := stack pop.
		machine resumeRunner: self.
		].
	
	^finished! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TraceEnumerator class' category: #'SmalltalkPPL-ExactEnumeration'!
TraceEnumerator class
	instanceVariableNames: ''!

!TraceEnumerator class methodsFor: 'as yet unclassified' stamp: 'JCM 11/Jul/2026 12:18:10'!
enumerateTracesOf: aProgram forStates: aNumberOfStates

	^self new enumerateTracesOf: aProgram forStates: aNumberOfStates

	

	! !


!classDefinition: #TraceEnumeratorRunner category: #'SmalltalkPPL-ExactEnumeration'!
Object subclass: #TraceEnumeratorRunner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExactEnumeration'!
