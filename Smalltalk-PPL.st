!classDefinition: #MHTrace category: #'Smalltalk-PPL'!
Object subclass: #MHTrace
	instanceVariableNames: 'sampleScores sampleValues observeScores randomGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!MHTrace methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026, 11:13:50 pm (UTC)'!
randomSampleAdressUsing: aRandomNumberGenerator

	^sampleValues asArray atRandom: aRandomNumberGenerator .! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026, 11:19:28 pm (UTC)'!
sampleValues 
 ^sampleValues ! !


!classDefinition: #SingleSiteMetropolisHastings category: #'Smalltalk-PPL'!
Object subclass: #SingleSiteMetropolisHastings
	instanceVariableNames: 'value chain currentTrace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL'!

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026, 10:52:25 pm (UTC)'!
checkAcceptionOf: aProposedTrace comparingWith: anOldtrace with: aRandomNumberGenerator with: anA0
	
	
	| acceptanceRatio |
	
	acceptanceRatio := self logAlphaOf: aProposedTrace comparingWith: anOldtrace andA0: anA0.
											 

	((aRandomNumberGenerator next ln) < acceptanceRatio)
            ifTrue: [
                currentTrace := aProposedTrace 
            ].
! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026, 11:18:13 pm (UTC)'!
checkPassWarmup: aNumberOfWarmups Iterations: aNumberOfIteration

	aNumberOfIteration >= aNumberOfWarmups ifTrue:[chain add: currentTrace value asFloat].
	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026, 11:29:04 pm (UTC)'!
initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator for: aNumberOfSteps  withWarmup: aNumberOfWarmups

	currentTrace := self run: aProgram withRng: aRandomNumberGenerator resamplingSite: nil withCache: OrderedDictionary new.
	chain := OrderedCollection new.


	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026, 11:29:15 pm (UTC)'!
program: aProgram rng:aRandomNumberGenerator steps: aNumberOfSteps warmup: aNumberOfWarmups

	
	self initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator for: aNumberOfSteps  withWarmup: aNumberOfWarmups.
	
	1 to: aNumberOfSteps + aNumberOfWarmups do:[ :i  |  | a0 proposedTrace| 
		a0 := currentTrace randomSampleAdressUsing: aRandomNumberGenerator.
		proposedTrace := self run: aProgram withRng: aRandomNumberGenerator resamplingSite: a0 withCache: currentTrace sampleValues.
		
	 	self checkAcceptionOf: proposedTrace comparingWith: currentTrace with: aRandomNumberGenerator with: a0.
		self checkPassWarmup: aNumberOfWarmups Iterations: i.
		].
		
	
	^chain asArray.
	
	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'JCM 4/Jul/2026, 11:35:06 pm (UTC)'!
run: aProgram withRng: aRandomNumberGenerator resamplingSite: a0 withCache: aCollectionOfSampledValues.
	


! !
