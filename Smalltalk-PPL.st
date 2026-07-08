!classDefinition: #AlgorithmRunner category: #'Smalltalk-PPL'!
Object subclass: #AlgorithmRunner
	instanceVariableNames: 'machine program randomNumberGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!AlgorithmRunner methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 8:04:22 am (UTC)'!
initialEnvironment
	| env |
	env := Dictionary new.
	env at: #+ put: #+.
	env at: #- put: #-.
	env at: #* put: #*.
	env at: #normal put: #normal.
	^env! !

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


!AlgorithmRunner methodsFor: 'setters' stamp: 'L.C 8/Jul/2026, 2:20:23 am (UTC)'!
machine: aMachine 
	
	machine := aMachine! !


!classDefinition: #LWRunner category: #'Smalltalk-PPL'!
AlgorithmRunner subclass: #LWRunner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!LWRunner methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:22:04 am (UTC)'!
runWithProgram: aProgram withRng: aRandomNumberGenerator

	randomNumberGenerator  := aRandomNumberGenerator.
	machine := Machine initialMachineWithProgram: aProgram withRng: randomNumberGenerator.
	program := aProgram.
	
	^self run
	
	! !


!LWRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026, 7:45:05 pm (UTC)'!
doneWithValue: aReturnValue

"Cambiar nombre aReturnValue viene de V[-1] "

	
	^LWRun withLogW: machine logW  withValue: aReturnValue.! !

!LWRunner methodsFor: 'Special Instructions' stamp: 'L.C 8/Jul/2026, 6:54:08 am (UTC)'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	
	machine incrementLogW: (aDistribution logarithmicProbabilityWith: anObservedValue).
	machine pushValue: anObservedValue.
	
	^nil.! !

!LWRunner methodsFor: 'Special Instructions' stamp: 'L.C 8/Jul/2026, 6:54:02 am (UTC)'!
sampleWithAddress: anAddress withDistribution: aDistribution

	
	machine pushValue: (aDistribution sample).
	
	^nil! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LWRunner class' category: #'Smalltalk-PPL'!
LWRunner class
	instanceVariableNames: ''!

!LWRunner class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:08:42 pm (UTC)'!
runWithProgram: aProgram withRng: aRandomNumberGenerator

	^self new runWithProgram: aProgram withRng: aRandomNumberGenerator! !


!classDefinition: #SMCRunner category: #'Smalltalk-PPL'!
AlgorithmRunner subclass: #SMCRunner
	instanceVariableNames: 'particles'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

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


!classDefinition: #SSMHRunner category: #'Smalltalk-PPL'!
AlgorithmRunner subclass: #SSMHRunner
	instanceVariableNames: 'redrawAddress cache trace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

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

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'L.C 8/Jul/2026, 9:26:19 am (UTC)'!
sampleWithAddress: anAddress withDistribution: aDistribution 

	| sampledValue |
	
	trace ifNil: [ trace := MHTrace new ]. "volver a verificar esto"
	
	(anAddress ~= redrawAddress and: [cache notNil and: [cache includesKey: anAddress]])
		ifTrue:[sampledValue := cache at: anAddress ]
		ifFalse:[sampledValue := aDistribution sample ]. "hay que ver esto, randomGenerator tira nil con sampleWith"
		
	trace updateSampleValuesAt: anAddress put: sampledValue.
	trace updateSampleScoresAt: anAddress put: (aDistribution logarithmicProbabilityWith: sampledValue).
	machine pushValue: sampledValue.
	
	"Devuelvo nil para que no salga del while"
	^nil
	
	! !


!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 3:31:55 am (UTC)'!
initialEnvironment
	| env |
	env := Dictionary new.
	env at: #+ put: #+.
	env at: #- put: #-.
	env at: #* put: #*.
	env at: #normal put: #normal.
	^env! !

!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 3:32:56 am (UTC)'!
run: aProgram withRng: aRandomNumberGenerator redrawAddress: anAddressToRedraw withCache: aCollectionOfSampledValues

	| env |
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
	
	^self run
	
	
	
	
! !

!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:39:53 am (UTC)'!
trace: aTrace
	
	trace := aTrace! !


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

!LWRun methodsFor: 'Instance Creation' stamp: 'L.C 8/Jul/2026, 7:46:10 am (UTC)'!
logW

	^logW! !

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


!classDefinition: #SMCRun category: #'Smalltalk-PPL'!
AlgorithmRuns subclass: #SMCRun
	instanceVariableNames: 'values'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!SMCRun methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:07:45 pm (UTC)'!
withValues: aCollectionOfValues

	values := aCollectionOfValues.
	
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMCRun class' category: #'Smalltalk-PPL'!
SMCRun class
	instanceVariableNames: ''!

!SMCRun class methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:07:24 pm (UTC)'!
withValues: aCollectionOfValues

	^self new withValues: aCollectionOfValues! !


!classDefinition: #SSMHRun category: #'Smalltalk-PPL'!
AlgorithmRuns subclass: #SSMHRun
	instanceVariableNames: 'trace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

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

!classDefinition: 'SSMHRun class' category: #'Smalltalk-PPL'!
SSMHRun class
	instanceVariableNames: 'trace value'!

!SSMHRun class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 11:36:05 pm (UTC)'!
withTrace: aProposedTrace withValue: aReturnValue.
	
	
	
	^self new initializeWithTrace: aProposedTrace withValue: aReturnValue ! !


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

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:28:55 am (UTC)'!
initialize
	sampleValues := Dictionary new.
	sampleDensities := Dictionary new.
	observeDensities := Dictionary new.! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 5/Jul/2026, 2:52:20 am (UTC)'!
logDensityExcluding: excludedAddresses

	| density |
	
	density := 0.
	
	observeDensities valuesDo: [:prob | density := density + prob].

	sampleDensities keysAndValuesDo: [:address :prob | (excludedAddresses includes: address) ifFalse: [density := density + prob]]   
	
	^ density.! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:49:14 pm (UTC)'!
observeDensities
^observeDensities! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 7:34:21 am (UTC)'!
randomSampleAdressUsing: aRandomNumberGenerator

	^sampleValues keys atRandom: aRandomNumberGenerator.! !

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

!Machine methodsFor: 'runner' stamp: 'L.C 7/Jul/2026, 11:30:18 pm (UTC)'!
popValues: anIndex
	
	| values |
	values := Array new: anIndex.
	
	anIndex to: 1 by: -1 do: [:index | values at: index put: valueStack removeLast].
	
	^ values! !

!Machine methodsFor: 'runner' stamp: 'L.C 8/Jul/2026, 3:15:11 am (UTC)'!
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

!Machine methodsFor: 'runner' stamp: 'L.C 8/Jul/2026, 1:56:08 am (UTC)'!
resumeRunner: aRunner

	"En el caso de que aRunner sea SMC:
	Si es observe devuelve SMCObserve
	Si es done devuelve SMCDone"
	| step |
	[controlStack notEmpty] whileTrue: [
		step := self stepRunner: aRunner.
		step notNil ifTrue: [^step].
	].
	
	^ aRunner doneWithValue: valueStack last.
	! !

!Machine methodsFor: 'runner' stamp: 'L.C 8/Jul/2026, 2:54:58 am (UTC)'!
stepRunner: aRunner

	| instruction result |
	instruction := controlStack removeLast.
	"PARCHE TEMPORAL"
	(instruction isArray) ifTrue: [
		instruction := Eval 
			expression: instruction 
			withEnvironment: Dictionary new 
			andAddress: #()].
	
	result := instruction executeOn: self runner: aRunner.
	result == instruction ifFalse: [^result].
	^ nil
	"Solo cuando el runner es SMC va a devolver un SMCMessage"
	"TODO: Se podria quitar el isKindOf"
	"(result isKindOf: SMCMessage) ifTrue: [
		^ result
	].
	
	^ self.
	"! !

!Machine methodsFor: 'runner' stamp: 'L.C 8/Jul/2026, 1:49:13 am (UTC)'!
translateToInstruction: aForm

	| tag |
	(aForm isArray) ifFalse: [ ^ Eval value: aForm ].
	
	tag := aForm first.! !


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


!Machine methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 7:51:53 am (UTC)'!
executePrimitive: anOperator withArguments: anArguments

	anOperator == #+ ifTrue: [^(anArguments at: 1) + (anArguments at: 2)].
	anOperator == #* ifTrue: [^(anArguments at: 1) * (anArguments at: 2)].
	anOperator == #- ifTrue: [^(anArguments at: 1) - (anArguments at: 2)].
	anOperator == #/ ifTrue: [^(anArguments at: 1) / (anArguments at: 2)].
	anOperator == #= ifTrue: [^(anArguments at: 1) = (anArguments at: 2)].
	anOperator == #normal ifTrue: [^NormalDistribution
			withMean: (anArguments at: 1) 
			standardDeviation: (anArguments at: 2) 
			randomGenerator: randomGenerator].
	
	^self error: 'Not Implemented: ' , anOperator asString.! !

!Machine methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:20:11 am (UTC)'!
forkWithRng: aRandomNumberGenerator
	
	| rng |
	
	rng := randomGenerator isNil 
			ifTrue:[^aRandomNumberGenerator]
			ifFalse:[^randomGenerator ].

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

!Machine class methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 1:33:23 am (UTC)'!
initialMachineWithProgram: aParsedProgram withRng: aRandomNumberGenerator

	| genV main |
	genV := Dictionary new.
	main := nil.
	
	"parsedProgram por ahora seria un objeto que sabe responder next y da la proxima expresion del programa parseado."
	
	aParsedProgram do: [ :form | (form isArray and: [ form first = 'defn' ])
		ifTrue: [genV at: (form at: 2) 
					put: (Closure 
						withParameters: (form at: 3) 
						andBody: (form at:4) 
						andEnvironment: genV)]
		ifFalse:[main := form]].
	
	
	^self new 
		initMachineWithControlStack:  { { #ev. main. genV. #() } } 
		withValueStack: nil 
		withEnvVar: genV 
		withRng: aRandomNumberGenerator 
		withLogW: 0.0! !


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

!Likelihood_weighting methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 5:52:38 pm (UTC)'!
program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps

	| runs values log_w normalized |
	runner := LWRunner.
	runs := OrderedCollection new.
	
	1 to: aNumberOfSteps do: [:i | runs add: (runner runWithProgram: aProgram withRng: aRandomNumberGenerator).].
	
	values := runs collect: [ :r | r value asFloat ].
	log_w := runs collect: [ :r | r logW ].
	
	"https://es.wikipedia.org/wiki/Funci%C3%B3n_SoftMax"
	log_w isEmpty 
		ifTrue: [ normalized := log_w copy ]
		ifFalse: [ | expSum maxLog |
			maxLog := log_w inject: log_w first into: [:max :each | max max: each].
			expSum := log_w inject: 0.0 into: [:sum :each | (each-maxLog) exp + sum].
			normalized := log_w collect: [ :each | (each-maxLog) exp / expSum ].
		].
	
	^LWResult values: values withLogW: normalized! !

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


!classDefinition: #SequentialMonteCarlo category: #'Smalltalk-PPL'!
PPLAlgorithm subclass: #SequentialMonteCarlo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!SequentialMonteCarlo methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 9:49:55 pm (UTC)'!
program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps

	
	| particles |
	runner := SMCRunner.
	particles := OrderedCollection new.
	
	1 to: aNumberOfSteps do:[
		particles add: (Machine initialMachineWithProgram: aProgram withRng: aRandomNumberGenerator )
		].
	
	^runner runWithProgram: aProgram withRng: aRandomNumberGenerator  withParticles: particles.! !


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

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 9:04:58 am (UTC)'!
checkPassWarmup: aNumberOfWarmups Iterations: aNumberOfIteration

	aNumberOfIteration >= aNumberOfWarmups ifTrue:[chain add: currentRun value asFloat].
	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 8:12:08 pm (UTC)'!
initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator for: aNumberOfSteps  withWarmup: aNumberOfWarmups

	currentRun := runner run: aProgram withRng: aRandomNumberGenerator redrawAddress: nil withCache: OrderedDictionary new.
	chain := OrderedCollection new.


	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 9:34:04 am (UTC)'!
program: aProgram rng:aRandomNumberGenerator steps: aNumberOfSteps warmup: aNumberOfWarmups

	| newRun |
	runner := SSMHRunner new.
	self initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator for: aNumberOfSteps  withWarmup: aNumberOfWarmups.
	
	1 to: aNumberOfSteps + aNumberOfWarmups do:[ :i  |  | a0 proposedTrace currentTrace|
		currentTrace := currentRun trace.
		a0 := currentRun trace randomSampleAdressUsing: aRandomNumberGenerator.
		newRun := runner run: aProgram withRng: aRandomNumberGenerator redrawAddress: a0 withCache: currentRun trace sampleValues.
		proposedTrace := newRun trace.
	 	self checkAcceptionOf: newRun comparingWith: currentRun with: aRandomNumberGenerator with: a0.
		self checkPassWarmup: aNumberOfWarmups Iterations: i.
		].
		
	
	^chain asArray.
	
	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026, 11:35:06 pm (UTC)'!
run: aProgram withRng: aRandomNumberGenerator resamplingSite: a0 withCache: aCollectionOfSampledValues.
	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 9:02:40 am (UTC)'!
sumOfObserveDensities: observeDensities andSampleDensities: sampleDensities excluding: excludedAddresses

	"esto se puede polimorfear para que tome la densidad de una traza directamente con excluding: forwardEA/reverseEA"

	| density |

	density := 0.0.
	observeDensities valuesDo: [:prob | density := density+prob].

	sampleDensities keysAndValuesDo: [:address :prob | (excludedAddresses includes: address) ifFalse: [ density := density + prob ]].

	^ density! !


!SingleSiteMetropolisHastings methodsFor: 'logProb (densities)' stamp: 'L.C 6/Jul/2026, 12:50:04 pm (UTC)'!
excludedAddressesFrom: densities and: anotherDensities withAddress: anAddress

	^ (densities keys asSet difference: anotherDensities keys asSet) union: {anAddress}.! !

!SingleSiteMetropolisHastings methodsFor: 'logProb (densities)' stamp: 'L.C 6/Jul/2026, 12:50:31 pm (UTC)'!
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

!SingleSiteMetropolisHastings methodsFor: 'logProb (densities)' stamp: 'L.C 6/Jul/2026, 12:50:42 pm (UTC)'!
logRatioBetween: currentSamples and: proposedSamples

	^ (currentSamples size / proposedSamples size) ln! !

!SingleSiteMetropolisHastings methodsFor: 'logProb (densities)' stamp: 'L.C 5/Jul/2026, 2:42:49 am (UTC)'!
sumOfDensitiesFor: aTrace  excluding: excludedAddresses

	| density |
	
	density := aTrace observeDensities sum.
	
	aTrace sampleDensities keysAndValuesDo: [:address :prob | (excludedAddresses includes: address) ifFalse: [ density := density + prob ]].
	
	^ density! !


!classDefinition: #PPLClosure category: #'Smalltalk-PPL'!
Object subclass: #PPLClosure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!


!classDefinition: #SMCMessage category: #'Smalltalk-PPL'!
Object subclass: #SMCMessage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!SMCMessage methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 9:22:46 pm (UTC)'!
isDone

	^false! !

!SMCMessage methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 9:22:39 pm (UTC)'!
isObserve

	^false! !


!classDefinition: #SMCDone category: #'Smalltalk-PPL'!
SMCMessage subclass: #SMCDone
	instanceVariableNames: 'address particle logIncrement value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!SMCDone methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:14:57 pm (UTC)'!
doneWithValue: aReturnValue

	value := aReturnValue.
	
	^self! !

!SMCDone methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:16:11 pm (UTC)'!
isDone

	^true! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SMCDone class' category: #'Smalltalk-PPL'!
SMCDone class
	instanceVariableNames: ''!

!SMCDone class methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:15:31 pm (UTC)'!
doneWithValue: aReturnValue

	^self new doneWithValue: aReturnValue! !


!classDefinition: #SMCObserve category: #'Smalltalk-PPL'!
SMCMessage subclass: #SMCObserve
	instanceVariableNames: 'address particle logIncrement'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

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

!classDefinition: 'SMCObserve class' category: #'Smalltalk-PPL'!
SMCObserve class
	instanceVariableNames: ''!

!SMCObserve class methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 9:44:35 pm (UTC)'!
withAddress: anAddress forParticle: aParticle withLogIncrement: aLogValue

	^self new withAddress: anAddress forParticle: aParticle withLogIncrement: aLogValue! !


!classDefinition: #SingleSiteProposal category: #'Smalltalk-PPL'!
Object subclass: #SingleSiteProposal
	instanceVariableNames: 'currentTrace proposedTrace selectedAddress'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!
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

!classDefinition: 'SingleSiteProposal class' category: #'Smalltalk-PPL'!
SingleSiteProposal class
	instanceVariableNames: ''!

!SingleSiteProposal class methodsFor: 'instance creation' stamp: 'L.C 5/Jul/2026, 2:27:00 am (UTC)'!
from: aCurrentTrace to: aProposedTrace at: anAddress
	
	^ self new initializeWith: aCurrentTrace proposed: aProposedTrace address: anAddress! !
!classDefinition: #DistributionTest category: #'Smalltalk-PPL-Tests'!
TestCase subclass: #DistributionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Tests'!

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


!classDefinition: #MachineTest category: #'Smalltalk-PPL-Tests'!
TestCase subclass: #MachineTest
	instanceVariableNames: 'runner machine'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Tests'!

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:10:19 am (UTC)'!
dummyMachineWithControlStack: aControlStack

^ Machine new
		initMachineWithControlStack: aControlStack
		withValueStack: nil 
		withEnvVar: nil 
		withRng: Random new
		withLogW: 0.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 3:09:56 pm (UTC)'!
evalAST: anAST
	
	^ self evalAST: anAST withEnvironment: Dictionary new! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 2:16:35 am (UTC)'!
evalAST: anAST withEnvironment: anEnvironment
	
	machine := self dummyMachineWithControlStack: {Eval expression: anAST withEnvironment: anEnvironment andAddress: #().}.
	^ (machine resumeRunner: runner) value! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 2:23:00 am (UTC)'!
setUp
	runner := SSMHRunner new.
	runner trace: MHTrace new. "PARCHE TEMPORAL"! !

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

!MachineTest methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 10:51:18 pm (UTC)'!
test06EvalLetMultipleBindings
	"(Let initBinds: #(#x 1) withBody:#(#x))"
	"#(let (#x 2 #y 5) #y)"
	self assert: (self evalAST: (Let initBinds: (#(#x 2 #y 5)) withBody: #(#y))) equals: 5.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 3:07:13 pm (UTC)'!
test07EvalDiscard

	self assert: (self evalAST: #(let (#x 1) 10 99)) equals: 99.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 7:00:09 pm (UTC)'!
test08EvalFn
	"identidad"
	self assert: (self evalAST: #((fn (#x) #x) 42)) equals: 42.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 11:21:49 pm (UTC)'!
test09EvalClosure
	| ast |
	ast := #(let (#x 10) 
			#(let (#f #(fn (#y) (+ #x #y))) 
				#(f 5))).
				
	self assert: (self evalAST: ast) equals: 15.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 11:24:11 pm (UTC)'!
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

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 2:21:29 am (UTC)'!
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

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 3:24:37 am (UTC)'!
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


!classDefinition: #MainTest category: #'Smalltalk-PPL-Tests'!
TestCase subclass: #MainTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Tests'!

!MainTest methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 6:59:03 pm (UTC)'!
test01
	| ast chain posteriori |
	
	ast := #(let (#mu #(sample #(normal 0 1))) #(observe #(normal #mu 1) 2.3) #mu).

	chain :=  (SingleSiteMetropolisHastings new) program: ast rng: Random new steps: 1000 warmup: 200.

	posteriori := (chain sum)/(chain size).
	
	self assert: (posteriori between: 0.9 and: 1.4).! !
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

!Call methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 5:53:34 pm (UTC)'!
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

!Eval methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 10:03:07 pm (UTC)'!
executeOn: aMachine runner: aRunner

	

	
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
	^ self"
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
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Observe methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 11:57:58 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	| d y |
	y := aMachine popValue.
	d := aMachine popValue.

	^ aRunner observeWithAddress: address withDistribution: d withObservedValue: y.! !

!Observe methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:09:14 am (UTC)'!
initializeWithAddress: anAddress

	address := anAddress! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Observe class' category: #'Smalltalk-PPL-Instructions'!
Observe class
	instanceVariableNames: ''!

!Observe class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:08:59 am (UTC)'!
withAddress: anAddress

	^ self new initializeWithAddress: anAddress! !


!classDefinition: #Sample category: #'Smalltalk-PPL-Instructions'!
Instruction subclass: #Sample
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Instructions'!

!Sample methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 11:58:09 pm (UTC)'!
executeOn: aMachine runner: aRunner

	^ aRunner sampleWithAddress: address withDistribution: aMachine popValue.! !

!Sample methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:09:20 am (UTC)'!
initializeWithAddress: anAddress

	address := anAddress! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sample class' category: #'Smalltalk-PPL-Instructions'!
Sample class
	instanceVariableNames: ''!

!Sample class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:08:51 am (UTC)'!
withAddress: anAddress

	^ self new initializeWithAddress: anAddress! !
!classDefinition: #Distribution category: #'Smalltalk-PPL-MiniPPL'!
Object subclass: #Distribution
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-MiniPPL'!

!Distribution methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:02:28 am (UTC)'!
logarithmicProbabilityWith: aValue

	^self subclassResponsibility! !

!Distribution methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 1:26:26 am (UTC)'!
sample
	^self subclassResponsibility! !


!classDefinition: #NormalDistribution category: #'Smalltalk-PPL-MiniPPL'!
Distribution subclass: #NormalDistribution
	instanceVariableNames: 'mean standardDeviation randomGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-MiniPPL'!

!NormalDistribution methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 1:22:15 am (UTC)'!
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

!classDefinition: 'NormalDistribution class' category: #'Smalltalk-PPL-MiniPPL'!
NormalDistribution class
	instanceVariableNames: ''!

!NormalDistribution class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 1:21:34 am (UTC)'!
withMean: aMeanValue standardDeviation: aStandardDeviation randomGenerator: aRandomNumberGenerator

	^ self new 
		initializeWithMean: aMeanValue 
		standardDeviation: aStandardDeviation 
		randomGenerator: aRandomNumberGenerator! !
