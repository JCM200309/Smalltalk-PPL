!classDefinition: #AlgorithmRunner category: #'Smalltalk-PPL'!
Object subclass: #AlgorithmRunner
	instanceVariableNames: 'machine program randomNumberGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!AlgorithmRunner methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:28:24 pm (UTC)'!
run

	| runValue |
	
	[runValue isNil] whileTrue:[
		runValue := machine resumeRunner: self.
		].
	"Termina cuando recibe un done"
	^runValue! !


!AlgorithmRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026, 7:39:52 pm (UTC)'!
doneWithValue: aReturnValue

	self subclassResponsibility! !

!AlgorithmRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026, 7:39:52 pm (UTC)'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	self subclassResponsibility! !

!AlgorithmRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026, 7:39:53 pm (UTC)'!
sampleWithAddress: anAddress withDistribution: aDistribution

	self subclassResponsibility! !


!classDefinition: #LWRunner category: #'Smalltalk-PPL'!
AlgorithmRunner subclass: #LWRunner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!LWRunner methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:42:51 pm (UTC)'!
runWithProgram: aProgram withRng: aRandomNumberGenerator

	machine := Machine initialMachineWithProgram: aProgram withRng: aRandomNumberGenerator.
	randomNumberGenerator  := aRandomNumberGenerator.
	program := aProgram.
	
	^self run
	
	! !


!LWRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026, 7:45:05 pm (UTC)'!
doneWithValue: aReturnValue

"Cambiar nombre aReturnValue viene de V[-1] "

	
	^LWRun withLogW: machine logW  withValue: aReturnValue.! !

!LWRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026, 7:37:43 pm (UTC)'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	
	machine incrementLogW: (aDistribution log_prob: anObservedValue).
	machine send: anObservedValue.
	
	^nil.! !

!LWRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026, 7:43:26 pm (UTC)'!
sampleWithAddress: anAddress withDistribution: aDistribution

	
	machine send: (aDistribution sampleWith: randomNumberGenerator).
	
	^nil! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LWRunner class' category: #'Smalltalk-PPL'!
LWRunner class
	instanceVariableNames: ''!

!LWRunner class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:08:42 pm (UTC)'!
runWithProgram: aProgram withRng: aRandomNumberGenerator

	^self new runWithProgram: aProgram withRng: aRandomNumberGenerator! !


!classDefinition: #SSMHRunner category: #'Smalltalk-PPL'!
AlgorithmRunner subclass: #SSMHRunner
	instanceVariableNames: 'redrawAddress cache trace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'JCM 5/Jul/2026, 7:36:42 pm (UTC)'!
doneWithValue: aReturnValue

"Cambiar nombre aReturnValue viene de V[-1] "

	
	^SSMHRun withTrace: trace withValue: aReturnValue.

	
	
	! !

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026, 7:37:10 pm (UTC)'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	
	trace updateObservedCacheAt: aDistribution put: (aDistribution log_prob: anObservedValue) .
	machine send: anObservedValue.
	
	^nil.! !

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026, 7:42:51 pm (UTC)'!
sampleWithAddress: anAddress withDistribution: aDistribution 

	| sampledValue |
	
	[anAddress ~= redrawAddress & (cache includes: anAddress )]
		ifTrue:[sampledValue := cache at: anAddress ]
		ifFalse:[sampledValue := aDistribution sampleWith: randomNumberGenerator ].
		
	trace updateSampleValuesAt: anAddress put: sampledValue.
	"Falta implementar log_probWith"
	trace updateSampleScoresAt: anAddress put: (aDistribution log_probWith: sampledValue).
	machine send: sampledValue.
	
	"Devuelvo nil para que no salga del while"
	^nil
	
	! !


!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:42:51 pm (UTC)'!
run: aProgram withRng: aRandomNumberGenerator redrawAddress: anAddressToRedraw withCache: aCollectionOfSampledValues

	
	machine := Machine initialMachineWithProgram: aProgram withRng: aRandomNumberGenerator.
	trace := MHTrace new.
	redrawAddress  := anAddressToRedraw.
	cache := aCollectionOfSampledValues.
	randomNumberGenerator := aRandomNumberGenerator.
	program := aProgram.
	
	^self run
	
	
	
	
! !


!classDefinition: #AlgorithmRuns category: #'Smalltalk-PPL'!
Object subclass: #AlgorithmRuns
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!AlgorithmRuns methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:49:01 pm (UTC)'!
value
	^value! !


!classDefinition: #LWRun category: #'Smalltalk-PPL'!
AlgorithmRuns subclass: #LWRun
	instanceVariableNames: 'logW'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!LWRun methodsFor: 'Instance Creation' stamp: 'jcm 6/Jul/2026, 7:47:50 pm (UTC)'!
withLogW: aLogWValue  withValue: aReturnValue
	
	logW := aLogWValue.
	value := aReturnValue.
	
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LWRun class' category: #'Smalltalk-PPL'!
LWRun class
	instanceVariableNames: ''!

!LWRun class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:46:55 pm (UTC)'!
withLogW: aLogWValue  withValue: aReturnValue

	^self new withLogW: aLogWValue withValue: aReturnValue ! !


!classDefinition: #SSMHRun category: #'Smalltalk-PPL'!
AlgorithmRuns subclass: #SSMHRun
	instanceVariableNames: 'trace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!SSMHRun methodsFor: 'Instance Creation' stamp: 'JCM 5/Jul/2026, 7:50:16 pm (UTC)'!
withTrace: aProposedTrace withValue: aReturnValue.
	
	trace := aProposedTrace.
	value := aReturnValue.
	
	^self! !


!SSMHRun methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026, 7:51:15 pm (UTC)'!
trace

	^trace! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SSMHRun class' category: #'Smalltalk-PPL'!
SSMHRun class
	instanceVariableNames: 'trace value'!

!SSMHRun class methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026, 7:49:32 pm (UTC)'!
withTrace: aProposedTrace withValue: aReturnValue.
	
	
	
	^self new withTrace: aProposedTrace withValue: aReturnValue ! !


!classDefinition: #LWResult category: #'Smalltalk-PPL'!
Object subclass: #LWResult
	instanceVariableNames: 'values log_ws'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!LWResult methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 8:26:45 pm (UTC)'!
values: aCollectionOfvalues withLogW: aCollectionOfLogW

	values := aCollectionOfvalues.
	log_ws := aCollectionOfLogW.
	
	^self.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LWResult class' category: #'Smalltalk-PPL'!
LWResult class
	instanceVariableNames: ''!

!LWResult class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 8:26:12 pm (UTC)'!
values: aCollectionOfvalues withLogW: aCollectionOfLogW

	^self new values: aCollectionOfvalues withLogW: aCollectionOfLogW! !


!classDefinition: #MHTrace category: #'Smalltalk-PPL'!
Object subclass: #MHTrace
	instanceVariableNames: 'sampleDensities sampleValues observeDensities randomGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:49:14 pm (UTC)'!
observeDensities
^observeDensities! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026, 2:13:50 am (UTC)'!
randomSampleAdressUsing: aRandomNumberGenerator

	^sampleValues asArray atRandom: aRandomNumberGenerator .! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:49:22 pm (UTC)'!
sampleDensities
^sampleDensities! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026, 2:19:28 am (UTC)'!
sampleValues 
 ^sampleValues ! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:48:59 pm (UTC)'!
updateObservedCacheAt: aDistribution put: anObservedValue

	observeDensities at: aDistribution put: anObservedValue.! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:48:51 pm (UTC)'!
updateSampleScoresAt: anAddress put: aSampledScore.

	sampleDensities at: anAddress put: aSampledScore! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026, 7:47:32 pm (UTC)'!
updateSampleValuesAt: anAddress put: aSampledValue.

	sampleValues at: anAddress put: aSampledValue ! !


!classDefinition: #Machine category: #'Smalltalk-PPL'!
Object subclass: #Machine
	instanceVariableNames: 'controlStack valueStack envVar randomGenerator logW'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!Machine methodsFor: 'Setters' stamp: 'jcm 6/Jul/2026, 7:38:30 pm (UTC)'!
incrementLogW: aValueOfLogWToSum

	logW := logW + aValueOfLogWToSum.! !


!Machine methodsFor: 'runner' stamp: 'L.C 6/Jul/2026, 1:31:17 pm (UTC)'!
popValue
	
	^ valueStack removeLast! !

!Machine methodsFor: 'runner' stamp: 'L.C 6/Jul/2026, 3:01:23 pm (UTC)'!
pushBody: aBody withEnvironment: anEnv andAddress: anAddress

	| seq|
	seq := OrderedCollection new.
	
	aBody allButLast withIndexDo: [ :b :index | 
		seq addLast: (Eval expression: b withEnvironment: anEnv andAddress: (anAddress , {#body. index})).
		seq addLast: Discard new
	].

	seq addLast: (Eval expression: aBody last withEnvironment: anEnv andAddress: (anAddress , {#body. aBody size})).
	
	seq reverseDo: [:item | self pushControl: item].! !

!Machine methodsFor: 'runner' stamp: 'L.C 6/Jul/2026, 1:32:20 pm (UTC)'!
pushControl: anInstruction

	controlStack addLast: anInstruction.
	
	^ self.! !

!Machine methodsFor: 'runner' stamp: 'L.C 6/Jul/2026, 1:31:41 pm (UTC)'!
pushValue: anObject

	valueStack addLast: anObject.
	^ self! !

!Machine methodsFor: 'runner' stamp: 'L.C 6/Jul/2026, 12:43:51 am (UTC)'!
resumeRunner: aRunner

	[controlStack notEmpty] whileTrue: [self stepRunner: aRunner].
	
	^ aRunner doneWithValue: valueStack last! !

!Machine methodsFor: 'runner' stamp: 'L.C 6/Jul/2026, 1:48:49 pm (UTC)'!
stepRunner: aRunner

	| instruction |
	instruction := controlStack removeLast.
	instruction executeOn: self runner: aRunner.
	
	^ self.
	
	
	"tag := instruction at: 1.
	
	tag == #ev ifTrue: [^ self ev: instruction].
	tag == #ifk ifTrue: [^ self ifk: instruction].
	tag == #letk ifTrue: [^ self letk: instruction].
	tag == #discard ifTrue: [^ self discard: instruction].
	tag == #callk ifTrue: [^ self callk: instruction].
	
	tag == #samplek ifTrue: [^ self samplek: instruction withRunner: aRunner].
	tag == #observek ifTrue: [^ self observek: instruction withRunner: aRunner]."! !


!Machine methodsFor: 'Initialize' stamp: 'L.C 5/Jul/2026, 11:23:17 pm (UTC)'!
initMachineWithControlStack: aControlStack withValueStack: aValueStack withEnvVar: aDictionaryOfVariables withRng: aRandomNumberGenerator withLogW: aLogW

	controlStack := aControlStack asOrderedCollection.
	
	aValueStack  isNil 
		ifTrue: [valueStack := OrderedCollection new]
		ifFalse:[valueStack := aValueStack ].
		
	aDictionaryOfVariables isNil
		ifTrue:[envVar := Dictionary new]
		ifFalse:[envVar := aDictionaryOfVariables ].
		
	randomGenerator := aRandomNumberGenerator.
	
	logW := aLogW.
	
	^self
			
	! !


!Machine methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026, 3:02:57 am (UTC)'!
forkWithRng: aRandomNumberGenerator
	
	| rng |
	
	rng := randomGenerator isNil 
			ifTrue:[^randomGenerator]
			ifFalse:[^aRandomNumberGenerator ].

	^Machine 
		initMachineWithControlStack: controlStack 
		withValueStack: valueStack 
		withEnvVar:  envVar 
		withRng:  rng
		withLogW: logW.
			
	! !


!Machine methodsFor: 'Getters' stamp: 'jcm 6/Jul/2026, 7:45:52 pm (UTC)'!
logW

	^logW ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Machine class' category: #'Smalltalk-PPL'!
Machine class
	instanceVariableNames: ''!

!Machine class methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026, 4:10:50 pm (UTC)'!
initialMachineWithProgram: aProgram withRng: aRandomNumberGenerator

	| form genV main parsedProgram |
	genV := Dictionary new.
	main := nil.
	
	"parsedProgram por ahora seria un objeto que sabe responder next y da la proxima expresion del programa parseado.
	Lo hice asi para no meterme con logicas de listas y demas cosas"
	parsedProgram := MiniPPL new parse: aProgram. "Devuelve una instancia de ParsedProgram"
	form := parsedProgram next.
	
	[form notNil] whileTrue: [
		(form isArray and: ( form at: 1 == 'defn') )
			ifTrue: [
				genV at: (form at: 2) put: (PPLClosure WithParams: (form at: 3) withBody: (form at:4) withGenV: genV)
				]
			ifFalse:[
				main := form	
				].
			form := parsedProgram next.
		].
	
	
	^self new initMachineWithControlStack:  { { #ev. main. genV. #() } } withValueStack: nil withEnvVar: genV withRng: aRandomNumberGenerator withLogW: 0.0! !


!classDefinition: #MiniPPL category: #'Smalltalk-PPL'!
Object subclass: #MiniPPL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!


!classDefinition: #PPLAlgorithm category: #'Smalltalk-PPL'!
Object subclass: #PPLAlgorithm
	instanceVariableNames: 'runner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!


!classDefinition: #Likelihood_weighting category: #'Smalltalk-PPL'!
PPLAlgorithm subclass: #Likelihood_weighting
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!Likelihood_weighting methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 8:24:36 pm (UTC)'!
program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps

	| run values log_w|
	runner := LWRunner.
	values := OrderedCollection new.
	log_w := OrderedCollection new.
	
	1 to: aNumberOfSteps do: [
		run := runner runWithProgram: aProgram withRng: aRandomNumberGenerator.
		values add: run value asFloat.
		log_w add: run logW.
		].
	
	
	"softmax no fue implementado aun"
	^LWResult values: values withLogW: log_w softmax! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Likelihood_weighting class' category: #'Smalltalk-PPL'!
Likelihood_weighting class
	instanceVariableNames: ''!

!Likelihood_weighting class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:00:13 pm (UTC)'!
checkPositiveNumberOfSteps: aNumberOfSteps

	aNumberOfSteps > 0 ifFalse:[Error signal: 'The number of steps should be positive'].
	
	
	! !

!Likelihood_weighting class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 6:59:16 pm (UTC)'!
program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps

	self checkPositiveNumberOfSteps: aNumberOfSteps.
	
	^self new program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps
	
	! !


!classDefinition: #SingleSiteMetropolisHastings category: #'Smalltalk-PPL'!
PPLAlgorithm subclass: #SingleSiteMetropolisHastings
	instanceVariableNames: 'chain currentRun'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 8:14:44 pm (UTC)'!
checkAcceptionOf: aNewRunOfSSMH comparingWith: anOldRunOfSSMH with: aRandomNumberGenerator with: anA0
	
	
	| acceptanceRatio proposedTrace newValue oldTrace |
	
	proposedTrace := aNewRunOfSSMH trace.
	newValue := aNewRunOfSSMH value.
	oldTrace := anOldRunOfSSMH trace.
	acceptanceRatio := self logAlphaOf: proposedTrace comparingWith: oldTrace withSelectedAddress: anA0.
											 

	((aRandomNumberGenerator next ln) < acceptanceRatio)
            ifTrue: [
		  "Dado que tengo que guardar tanto traza nueva como valor nuevo, de una guardo toda la corrida de SSMH"
                currentRun := aNewRunOfSSMH 
            ].
! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 8:15:30 pm (UTC)'!
checkPassWarmup: aNumberOfWarmups Iterations: aNumberOfIteration

	aNumberOfIteration >= aNumberOfWarmups ifTrue:[chain add: currentRun trace value asFloat].
	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:50:04 pm (UTC)'!
excludedAddressesFrom: densities and: anotherDensities withAddress: anAddress

	^ (densities keys asSet difference: anotherDensities keys asSet) union: {anAddress}.! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 8:12:08 pm (UTC)'!
initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator for: aNumberOfSteps  withWarmup: aNumberOfWarmups

	currentRun := runner run: aProgram withRng: aRandomNumberGenerator redrawAddress: nil withCache: OrderedDictionary new.
	chain := OrderedCollection new.


	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:50:31 pm (UTC)'!
logAlphaOf: aProposedTrace comparingWith: aCurrentTrace withSelectedAddress: aSiteAddress

	| forwardExcludedAddresses 
	reverseExcludedAddresses 
	numerator 
	denominator 
	currentObserveDensities 
	currentSampleDensities 
	proposedObserveDensities 
	proposedSampleDensities 
	proposal |

	currentSampleDensities := aCurrentTrace sampleDensities.
	proposedSampleDensities := aProposedTrace sampleDensities.
	currentObserveDensities := aCurrentTrace observeDensities.
	proposedObserveDensities := aProposedTrace observeDensities.

	forwardExcludedAddresses := self 
		excludedAddressesFrom: proposedSampleDensities 
		and: currentSampleDensities 
		withAddress: aSiteAddress.

	reverseExcludedAddresses := self 
		excludedAddressesFrom: currentSampleDensities 
		and: proposedSampleDensities
		withAddress: aSiteAddress.

	numerator := self 
		sumOfObserveDensities: proposedObserveDensities 
		andSampleDensities: proposedSampleDensities
		excluding: forwardExcludedAddresses.

	denominator := self 
		sumOfObserveDensities: currentObserveDensities 
		andSampleDensities: currentSampleDensities
		excluding: reverseExcludedAddresses.

	proposal := self logRatioBetween: currentSampleDensities and: proposedSampleDensities.

	^ numerator - denominator + proposal! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:50:42 pm (UTC)'!
logRatioBetween: currentSamples and: proposedSamples

	^ (currentSamples size / proposedSamples size) ln! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 8:13:52 pm (UTC)'!
program: aProgram rng:aRandomNumberGenerator steps: aNumberOfSteps warmup: aNumberOfWarmups

	| newRun |
	runner := SSMHRunner new.
	self initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator for: aNumberOfSteps  withWarmup: aNumberOfWarmups.
	
	1 to: aNumberOfSteps + aNumberOfWarmups do:[ :i  |  | a0 proposedTrace currentTrace|
		currentTrace := currentRun .
		a0 := currentTrace randomSampleAdressUsing: aRandomNumberGenerator.
		newRun := runner run: aProgram withRng: aRandomNumberGenerator redrawAddress: a0 withCache: currentTrace sampleValues.
		proposedTrace := newRun trace.
	 	self checkAcceptionOf: newRun comparingWith: currentRun with: aRandomNumberGenerator with: a0.
		self checkPassWarmup: aNumberOfWarmups Iterations: i.
		].
		
	
	^chain asArray.
	
	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:51:07 pm (UTC)'!
sumOfObserveDensities: observeDensities andSampleDensities: sampleDensities excluding: excludedAddresses

	"esto se puede polimorfear para que tome la densidad de una traza directamente con excluding: forwardEA/reverseEA"

	| density |

	density := 0.

	density := observeDensities sum.

	sampleDensities keysAndValuesDo: [:address :prob | (excludedAddresses includes: address) ifFalse: [ density := density + prob ]].

	^ density! !


!classDefinition: #PPLClosure category: #'Smalltalk-PPL'!
Object subclass: #PPLClosure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!
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
