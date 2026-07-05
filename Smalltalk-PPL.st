!classDefinition: #MHTrace category: #'Smalltalk-PPL'!
Object subclass: #MHTrace
	instanceVariableNames: 'sampleScores sampleValues observeScores randomGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!MHTrace methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026 23:13:50'!
randomSampleAdressUsing: aRandomNumberGenerator

	^sampleValues asArray atRandom: aRandomNumberGenerator .! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026 23:19:28'!
sampleValues 
 ^sampleValues ! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026 16:30:23'!
updateObservedCacheAt: aDistribution put: anObservedValue

	observeScores at: aDistribution put: anObservedValue.! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026 16:47:47'!
updateSampleScoresAt: anAddress put: aSampledScore.

	sampleScores at: anAddress put: aSampledScore! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026 16:47:32'!
updateSampleValuesAt: anAddress put: aSampledValue.

	sampleValues at: anAddress put: aSampledValue ! !


!classDefinition: #Machine category: #'Smalltalk-PPL'!
Object subclass: #Machine
	instanceVariableNames: 'controlStack valueStack envVar randomGenerator logW'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!Machine methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026 00:02:57'!
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

!Machine methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026 23:58:19'!
initMachineWithControlStack: aControlStack withValueStack: aValueStack withEnvVar: aDictionaryOfVariables withRng: aRandomNumberGenerator withLogW: aLogW

	controlStack := aControlStack asArray.
	
	aValueStack  isNil 
		ifTrue: [valueStack := Array new]
		ifFalse:[valueStack := aValueStack ].
		
	aDictionaryOfVariables isNil
		ifTrue:[envVar := Dictionary new]
		ifFalse:[envVar := aDictionaryOfVariables ].
		
	randomGenerator := aRandomNumberGenerator.
	
	logW := aLogW.
	
	^self
			
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Machine class' category: #'Smalltalk-PPL'!
Machine class
	instanceVariableNames: ''!

!Machine class methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026 13:10:50'!
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


!classDefinition: #PPLClosure category: #'Smalltalk-PPL'!
Object subclass: #PPLClosure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!


!classDefinition: #SSMHRun category: #'Smalltalk-PPL'!
Object subclass: #SSMHRun
	instanceVariableNames: 'trace value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!SSMHRun methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026 16:51:15'!
trace

	^trace! !

!SSMHRun methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026 16:50:16'!
withTrace: aProposedTrace withValue: aReturnValue.
	
	trace := aProposedTrace.
	value := aReturnValue.
	
	^self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SSMHRun class' category: #'Smalltalk-PPL'!
SSMHRun class
	instanceVariableNames: 'trace value'!

!SSMHRun class methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026 16:49:32'!
withTrace: aProposedTrace withValue: aReturnValue.
	
	
	
	^self new withTrace: aProposedTrace withValue: aReturnValue ! !


!classDefinition: #SSMHRunner category: #'Smalltalk-PPL'!
Object subclass: #SSMHRunner
	instanceVariableNames: 'rangeNumberGenerator redrawAddress cache machine trace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'JCM 5/Jul/2026 16:36:42'!
doneWithValue: aReturnValue

"Cambiar nombre aReturnValue viene de V[-1] "

	
	^SSMHRun withTrace: trace withValue: aReturnValue.

	
	
	! !

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'JCM 5/Jul/2026 16:45:50'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	
	trace updateObservedCacheAt: aDistribution put: (anObservedValue log_prob: anObservedValue) .
	machine send: anObservedValue.
	
	^nil.! !

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'JCM 5/Jul/2026 16:48:12'!
sampleWithAddress: anAddress withDistribution: aDistribution 

	| sampledValue |
	
	[anAddress ~= redrawAddress & (cache includes: anAddress )]
		ifTrue:[sampledValue := cache at: anAddress ]
		ifFalse:[sampledValue := aDistribution sample].
		
	trace updateSampleValuesAt: anAddress put: sampledValue.
	"Falta implementar log_probWith"
	trace updateSampleScoresAt: anAddress put: (aDistribution log_probWith: sampledValue).
	machine send: sampledValue.
	
	"Devuelvo nil para que no salga del while"
	^nil
	
	! !


!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026 16:45:36'!
run: aProgram withRng: aRandomNumberGenerator resamplingSite: aResamplingAddress withCache: aCollectionOfSampledValues

	| ssmhRunValue |
	machine := Machine initialMachineWithProgram: aProgram withRng: aRandomNumberGenerator.
	trace := MHTrace new.
	
	[ssmhRunValue isNil] whileTrue:[
		ssmhRunValue := machine resumeForAlgorithm: self modifyingTrace: trace withResamplingAddress: aResamplingAddress .
		].
	"Termina cuando recibe un done"
	^ssmhRunValue
	
	
	
! !


!classDefinition: #SingleSiteMetropolisHastings category: #'Smalltalk-PPL'!
Object subclass: #SingleSiteMetropolisHastings
	instanceVariableNames: 'value chain currentTrace machine ssmhRunner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026 22:52:25'!
checkAcceptionOf: aProposedTrace comparingWith: anOldtrace with: aRandomNumberGenerator with: anA0
	
	
	| acceptanceRatio |
	
	acceptanceRatio := self logAlphaOf: aProposedTrace comparingWith: anOldtrace andA0: anA0.
											 

	((aRandomNumberGenerator next ln) < acceptanceRatio)
            ifTrue: [
                currentTrace := aProposedTrace 
            ].
! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026 23:18:13'!
checkPassWarmup: aNumberOfWarmups Iterations: aNumberOfIteration

	aNumberOfIteration >= aNumberOfWarmups ifTrue:[chain add: currentTrace value asFloat].
	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026 15:43:48'!
initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator for: aNumberOfSteps  withWarmup: aNumberOfWarmups

	currentTrace := ssmhRunner run: aProgram withRng: aRandomNumberGenerator resamplingSite: nil withCache: OrderedDictionary new.
	chain := OrderedCollection new.


	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026 16:51:02'!
program: aProgram rng:aRandomNumberGenerator steps: aNumberOfSteps warmup: aNumberOfWarmups

	| ssmhRun |
	ssmhRunner := SSMHRunner new.
	self initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator for: aNumberOfSteps  withWarmup: aNumberOfWarmups.
	
	1 to: aNumberOfSteps + aNumberOfWarmups do:[ :i  |  | a0 proposedTrace| 
		a0 := currentTrace randomSampleAdressUsing: aRandomNumberGenerator.
		ssmhRun := ssmhRunner run: aProgram withRng: aRandomNumberGenerator resamplingSite: a0 withCache: currentTrace sampleValues.
		proposedTrace := ssmhRun trace.
	 	self checkAcceptionOf: proposedTrace comparingWith: currentTrace with: aRandomNumberGenerator with: a0.
		self checkPassWarmup: aNumberOfWarmups Iterations: i.
		].
		
	
	^chain asArray.
	
	


! !
