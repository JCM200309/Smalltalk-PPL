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
