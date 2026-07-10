'From Cuis7.9 [latest update: #8037] on 10 July 2026 at 3:28:42 pm'!
'Description '!
!provides: 'SmalltalkPPL' 1 2!
SystemOrganization addCategory: #'SmalltalkPPL-Evaluation'!
SystemOrganization addCategory: #'SmalltalkPPL-Tests'!
SystemOrganization addCategory: #'SmalltalkPPL-Instructions'!
SystemOrganization addCategory: #'SmalltalkPPL-MiniPPL'!
SystemOrganization addCategory: #'SmalltalkPPL-Algorithm'!
SystemOrganization addCategory: #'SmalltalkPPL-Core'!
SystemOrganization addCategory: #'SmalltalkPPL-Runner'!
SystemOrganization addCategory: #'SmalltalkPPL-ExecutionState'!
SystemOrganization addCategory: #'SmalltalkPPL-Kernel-SSMH'!
SystemOrganization addCategory: #'SmalltalkPPL-Kernel-SMC'!


!classDefinition: #ImportanceSamplingAlgorithms category: #'SmalltalkPPL-Algorithm'!
Object subclass: #ImportanceSamplingAlgorithms
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Algorithm'!
!classDefinition: 'ImportanceSamplingAlgorithms class' category: #'SmalltalkPPL-Algorithm'!
ImportanceSamplingAlgorithms class
	instanceVariableNames: ''!

!classDefinition: #LikelihoodWeighting category: #'SmalltalkPPL-Algorithm'!
ImportanceSamplingAlgorithms subclass: #LikelihoodWeighting
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Algorithm'!
!classDefinition: 'LikelihoodWeighting class' category: #'SmalltalkPPL-Algorithm'!
LikelihoodWeighting class
	instanceVariableNames: ''!

!classDefinition: #SequentialMonteCarlo category: #'SmalltalkPPL-Algorithm'!
ImportanceSamplingAlgorithms subclass: #SequentialMonteCarlo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Algorithm'!
!classDefinition: 'SequentialMonteCarlo class' category: #'SmalltalkPPL-Algorithm'!
SequentialMonteCarlo class
	instanceVariableNames: ''!

!classDefinition: #SingleSiteMetropolisHastings category: #'SmalltalkPPL-Algorithm'!
Object subclass: #SingleSiteMetropolisHastings
	instanceVariableNames: 'chain currentRun runner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Algorithm'!
!classDefinition: 'SingleSiteMetropolisHastings class' category: #'SmalltalkPPL-Algorithm'!
SingleSiteMetropolisHastings class
	instanceVariableNames: ''!

!classDefinition: #Machine category: #'SmalltalkPPL-Core'!
Object subclass: #Machine
	instanceVariableNames: 'controlStack valueStack envVar randomGenerator logWeights callCounter'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Core'!
!classDefinition: 'Machine class' category: #'SmalltalkPPL-Core'!
Machine class
	instanceVariableNames: ''!

!classDefinition: #Signaling category: #'SmalltalkPPL-Evaluation'!
Object subclass: #Signaling
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Evaluation'!
!classDefinition: 'Signaling class' category: #'SmalltalkPPL-Evaluation'!
Signaling class
	instanceVariableNames: ''!

!classDefinition: #AlgorithmRuns category: #'SmalltalkPPL-ExecutionState'!
Object subclass: #AlgorithmRuns
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExecutionState'!
!classDefinition: 'AlgorithmRuns class' category: #'SmalltalkPPL-ExecutionState'!
AlgorithmRuns class
	instanceVariableNames: ''!

!classDefinition: #LWRun category: #'SmalltalkPPL-ExecutionState'!
AlgorithmRuns subclass: #LWRun
	instanceVariableNames: 'logWeights'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExecutionState'!
!classDefinition: 'LWRun class' category: #'SmalltalkPPL-ExecutionState'!
LWRun class
	instanceVariableNames: ''!

!classDefinition: #SMCRun category: #'SmalltalkPPL-ExecutionState'!
AlgorithmRuns subclass: #SMCRun
	instanceVariableNames: 'values'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExecutionState'!
!classDefinition: 'SMCRun class' category: #'SmalltalkPPL-ExecutionState'!
SMCRun class
	instanceVariableNames: ''!

!classDefinition: #SSMHRun category: #'SmalltalkPPL-ExecutionState'!
AlgorithmRuns subclass: #SSMHRun
	instanceVariableNames: 'trace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-ExecutionState'!
!classDefinition: 'SSMHRun class' category: #'SmalltalkPPL-ExecutionState'!
SSMHRun class
	instanceVariableNames: 'trace value'!

!classDefinition: #Closure category: #'SmalltalkPPL-Instructions'!
Object subclass: #Closure
	instanceVariableNames: 'parameters body environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!
!classDefinition: 'Closure class' category: #'SmalltalkPPL-Instructions'!
Closure class
	instanceVariableNames: ''!

!classDefinition: #Instruction category: #'SmalltalkPPL-Instructions'!
Object subclass: #Instruction
	instanceVariableNames: 'address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!
!classDefinition: 'Instruction class' category: #'SmalltalkPPL-Instructions'!
Instruction class
	instanceVariableNames: ''!

!classDefinition: #Call category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Call
	instanceVariableNames: 'count'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!
!classDefinition: 'Call class' category: #'SmalltalkPPL-Instructions'!
Call class
	instanceVariableNames: ''!

!classDefinition: #CallFunction category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #CallFunction
	instanceVariableNames: 'function arguments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!
!classDefinition: 'CallFunction class' category: #'SmalltalkPPL-Instructions'!
CallFunction class
	instanceVariableNames: ''!

!classDefinition: #Discard category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Discard
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!
!classDefinition: 'Discard class' category: #'SmalltalkPPL-Instructions'!
Discard class
	instanceVariableNames: ''!

!classDefinition: #Eval category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Eval
	instanceVariableNames: 'expression environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!
!classDefinition: 'Eval class' category: #'SmalltalkPPL-Instructions'!
Eval class
	instanceVariableNames: ''!

!classDefinition: #Fn category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Fn
	instanceVariableNames: 'parameters body'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!
!classDefinition: 'Fn class' category: #'SmalltalkPPL-Instructions'!
Fn class
	instanceVariableNames: ''!

!classDefinition: #If category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #If
	instanceVariableNames: 'condition then else environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!
!classDefinition: 'If class' category: #'SmalltalkPPL-Instructions'!
If class
	instanceVariableNames: ''!

!classDefinition: #Let category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Let
	instanceVariableNames: 'bindings index body environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!
!classDefinition: 'Let class' category: #'SmalltalkPPL-Instructions'!
Let class
	instanceVariableNames: ''!

!classDefinition: #Observe category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Observe
	instanceVariableNames: 'distribution observedValue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!
!classDefinition: 'Observe class' category: #'SmalltalkPPL-Instructions'!
Observe class
	instanceVariableNames: 'distribution observedValue'!

!classDefinition: #Sample category: #'SmalltalkPPL-Instructions'!
Instruction subclass: #Sample
	instanceVariableNames: 'distribution'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Instructions'!
!classDefinition: 'Sample class' category: #'SmalltalkPPL-Instructions'!
Sample class
	instanceVariableNames: ''!

!classDefinition: #SMCMessage category: #'SmalltalkPPL-Kernel-SMC'!
Object subclass: #SMCMessage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SMC'!
!classDefinition: 'SMCMessage class' category: #'SmalltalkPPL-Kernel-SMC'!
SMCMessage class
	instanceVariableNames: ''!

!classDefinition: #SMCDone category: #'SmalltalkPPL-Kernel-SMC'!
SMCMessage subclass: #SMCDone
	instanceVariableNames: 'address particle logIncrement value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SMC'!
!classDefinition: 'SMCDone class' category: #'SmalltalkPPL-Kernel-SMC'!
SMCDone class
	instanceVariableNames: ''!

!classDefinition: #SMCObserve category: #'SmalltalkPPL-Kernel-SMC'!
SMCMessage subclass: #SMCObserve
	instanceVariableNames: 'address particle logIncrement'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SMC'!
!classDefinition: 'SMCObserve class' category: #'SmalltalkPPL-Kernel-SMC'!
SMCObserve class
	instanceVariableNames: ''!

!classDefinition: #MHTrace category: #'SmalltalkPPL-Kernel-SSMH'!
Object subclass: #MHTrace
	instanceVariableNames: 'sampleDensities sampleValues observeDensities randomGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SSMH'!
!classDefinition: 'MHTrace class' category: #'SmalltalkPPL-Kernel-SSMH'!
MHTrace class
	instanceVariableNames: ''!

!classDefinition: #SingleSiteProposal category: #'SmalltalkPPL-Kernel-SSMH'!
Object subclass: #SingleSiteProposal
	instanceVariableNames: 'currentTrace proposedTrace selectedAddress'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Kernel-SSMH'!
!classDefinition: 'SingleSiteProposal class' category: #'SmalltalkPPL-Kernel-SSMH'!
SingleSiteProposal class
	instanceVariableNames: ''!

!classDefinition: #Distribution category: #'SmalltalkPPL-MiniPPL'!
Object subclass: #Distribution
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!
!classDefinition: 'Distribution class' category: #'SmalltalkPPL-MiniPPL'!
Distribution class
	instanceVariableNames: ''!

!classDefinition: #NormalDistribution category: #'SmalltalkPPL-MiniPPL'!
Distribution subclass: #NormalDistribution
	instanceVariableNames: 'mean standardDeviation randomGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!
!classDefinition: 'NormalDistribution class' category: #'SmalltalkPPL-MiniPPL'!
NormalDistribution class
	instanceVariableNames: ''!

!classDefinition: #Primitive category: #'SmalltalkPPL-MiniPPL'!
Object subclass: #Primitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!
!classDefinition: 'Primitive class' category: #'SmalltalkPPL-MiniPPL'!
Primitive class
	instanceVariableNames: ''!

!classDefinition: #AddPrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #AddPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!
!classDefinition: 'AddPrimitive class' category: #'SmalltalkPPL-MiniPPL'!
AddPrimitive class
	instanceVariableNames: ''!

!classDefinition: #DividePrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #DividePrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!
!classDefinition: 'DividePrimitive class' category: #'SmalltalkPPL-MiniPPL'!
DividePrimitive class
	instanceVariableNames: ''!

!classDefinition: #EqualPrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #EqualPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!
!classDefinition: 'EqualPrimitive class' category: #'SmalltalkPPL-MiniPPL'!
EqualPrimitive class
	instanceVariableNames: ''!

!classDefinition: #MultiplyPrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #MultiplyPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!
!classDefinition: 'MultiplyPrimitive class' category: #'SmalltalkPPL-MiniPPL'!
MultiplyPrimitive class
	instanceVariableNames: ''!

!classDefinition: #NormalPrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #NormalPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!
!classDefinition: 'NormalPrimitive class' category: #'SmalltalkPPL-MiniPPL'!
NormalPrimitive class
	instanceVariableNames: ''!

!classDefinition: #SubtractPrimitive category: #'SmalltalkPPL-MiniPPL'!
Primitive subclass: #SubtractPrimitive
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!
!classDefinition: 'SubtractPrimitive class' category: #'SmalltalkPPL-MiniPPL'!
SubtractPrimitive class
	instanceVariableNames: ''!

!classDefinition: #SoftMax category: #'SmalltalkPPL-MiniPPL'!
Object subclass: #SoftMax
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-MiniPPL'!
!classDefinition: 'SoftMax class' category: #'SmalltalkPPL-MiniPPL'!
SoftMax class
	instanceVariableNames: ''!

!classDefinition: #AlgorithmRunner category: #'SmalltalkPPL-Runner'!
Object subclass: #AlgorithmRunner
	instanceVariableNames: 'machine program randomNumberGenerator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!
!classDefinition: 'AlgorithmRunner class' category: #'SmalltalkPPL-Runner'!
AlgorithmRunner class
	instanceVariableNames: ''!

!classDefinition: #ImportanceSamplingRunner category: #'SmalltalkPPL-Runner'!
AlgorithmRunner subclass: #ImportanceSamplingRunner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!
!classDefinition: 'ImportanceSamplingRunner class' category: #'SmalltalkPPL-Runner'!
ImportanceSamplingRunner class
	instanceVariableNames: ''!

!classDefinition: #LWRunner category: #'SmalltalkPPL-Runner'!
ImportanceSamplingRunner subclass: #LWRunner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!
!classDefinition: 'LWRunner class' category: #'SmalltalkPPL-Runner'!
LWRunner class
	instanceVariableNames: ''!

!classDefinition: #SMCRunner category: #'SmalltalkPPL-Runner'!
ImportanceSamplingRunner subclass: #SMCRunner
	instanceVariableNames: 'particles randomNumberGenerators'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!
!classDefinition: 'SMCRunner class' category: #'SmalltalkPPL-Runner'!
SMCRunner class
	instanceVariableNames: ''!

!classDefinition: #SSMHRunner category: #'SmalltalkPPL-Runner'!
AlgorithmRunner subclass: #SSMHRunner
	instanceVariableNames: 'redrawAddress cache trace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Runner'!
!classDefinition: 'SSMHRunner class' category: #'SmalltalkPPL-Runner'!
SSMHRunner class
	instanceVariableNames: ''!

!classDefinition: #DistributionTest category: #'SmalltalkPPL-Tests'!
TestCase subclass: #DistributionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!
!classDefinition: 'DistributionTest class' category: #'SmalltalkPPL-Tests'!
DistributionTest class
	instanceVariableNames: ''!

!classDefinition: #InterpreterTest category: #'SmalltalkPPL-Tests'!
TestCase subclass: #InterpreterTest
	instanceVariableNames: 'runner machine'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!
!classDefinition: 'InterpreterTest class' category: #'SmalltalkPPL-Tests'!
InterpreterTest class
	instanceVariableNames: ''!

!classDefinition: #LWTest category: #'SmalltalkPPL-Tests'!
InterpreterTest subclass: #LWTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!
!classDefinition: 'LWTest class' category: #'SmalltalkPPL-Tests'!
LWTest class
	instanceVariableNames: ''!

!classDefinition: #MachineTest category: #'SmalltalkPPL-Tests'!
InterpreterTest subclass: #MachineTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!
!classDefinition: 'MachineTest class' category: #'SmalltalkPPL-Tests'!
MachineTest class
	instanceVariableNames: ''!

!classDefinition: #SMCTest category: #'SmalltalkPPL-Tests'!
InterpreterTest subclass: #SMCTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!
!classDefinition: 'SMCTest class' category: #'SmalltalkPPL-Tests'!
SMCTest class
	instanceVariableNames: ''!

!classDefinition: #SSMHTest category: #'SmalltalkPPL-Tests'!
InterpreterTest subclass: #SSMHTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!
!classDefinition: 'SSMHTest class' category: #'SmalltalkPPL-Tests'!
SSMHTest class
	instanceVariableNames: ''!

!classDefinition: #MainTest category: #'SmalltalkPPL-Tests'!
TestCase subclass: #MainTest
	instanceVariableNames: 'originalProgramTest'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SmalltalkPPL-Tests'!
!classDefinition: 'MainTest class' category: #'SmalltalkPPL-Tests'!
MainTest class
	instanceVariableNames: ''!


!SingleSiteProposal commentStamp: '<historical>' prior: 0!
Method Object!

!ImportanceSamplingAlgorithms methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 5:41:53 pm (UTC)'!
program: aProgram rng: aRandomNumberGenerator for: aNumberOfSteps

	self subclassResponsibility! !

!LikelihoodWeighting methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 6:10:13 pm (UTC)'!
program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps

	| runs values log_w normalized |
	runs := OrderedCollection new.
	
	1 to: aNumberOfSteps do: [:i | runs add: (LWRunner runWithProgram: aProgram withRng: aRandomNumberGenerator)].
	
	values := runs collect: [ :r | r value asFloat].
	log_w := runs collect: [ :r | r logWeights].
	
	normalized := SoftMax for: log_w.
	
	^LWRun withLogW: normalized withValue: values! !

!LikelihoodWeighting class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:00:13 pm (UTC)'!
checkPositiveNumberOfSteps: aNumberOfSteps

	aNumberOfSteps > 0 ifFalse:[Error signal: 'The number of steps should be positive'].
	
	
	! !

!LikelihoodWeighting class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 6:59:16 pm (UTC)'!
program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps

	self checkPositiveNumberOfSteps: aNumberOfSteps.
	
	^self new program: aProgram rng:aRandomNumberGenerator for: aNumberOfSteps
	
	! !

!SequentialMonteCarlo methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 6:25:48 pm (UTC)'!
program: aProgram rng:aRandomNumberGenerators for: aNumberOfSteps

	| particles |
	particles := OrderedCollection new.
	
	1 to: aNumberOfSteps do:[:i | particles add: (Machine initialMachineWithProgram: aProgram withRng: aRandomNumberGenerators )
		].
	
	^SMCRunner runWithProgram: aProgram withRng: aRandomNumberGenerators  withParticles: particles.! !

!SequentialMonteCarlo class methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 6:06:05 pm (UTC)'!
checkSizeOfRng: aRandomNumberGenerators EqualsSteps: aNumberOfSteps.

	aRandomNumberGenerators size == aNumberOfSteps  ifFalse:[Error signal: 'The number of steps must be equal the number of the Random Number Generators']! !

!SequentialMonteCarlo class methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 6:05:00 pm (UTC)'!
program: aProgram rng:aRandomNumberGenerators for: aNumberOfSteps

	self checkSizeOfRng: aRandomNumberGenerators EqualsSteps: aNumberOfSteps.
	
	^self new program: aProgram rng:aRandomNumberGenerators for: aNumberOfSteps! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 1:55:44 am (UTC)'!
checkAcceptionOf: aNewRunOfSSMH comparingWith: anOldRunOfSSMH with: aRandomNumberGenerator with: anA0
	
	| acceptanceRatio proposedTrace oldTrace proposal |
	
	proposedTrace := aNewRunOfSSMH trace.
	oldTrace := anOldRunOfSSMH trace.
	
	proposal := SingleSiteProposal from: oldTrace to: proposedTrace at: anA0.
	acceptanceRatio := proposal logAlpha.

	((aRandomNumberGenerator next ln) < acceptanceRatio) ifTrue: [ currentRun := aNewRunOfSSMH ].	
! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:30:14 pm (UTC)'!
checkPassWarmup: aNumberOfWarmups Iterations: aNumberOfIteration

	aNumberOfIteration > aNumberOfWarmups ifTrue:[chain add: currentRun value].
	


! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 11:14:52 am (UTC)'!
initialTraceOfProgram: aProgram withRng: aRandomNumberGenerator

	currentRun := runner run: aProgram withRng: aRandomNumberGenerator.

! !

!SingleSiteMetropolisHastings methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 2:49:46 pm (UTC)'!
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

!SingleSiteMetropolisHastings class methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:29:56 pm (UTC)'!
program: aProgram rng: aRandomGenerator steps: aNumberOfSteps warmup: aNumberOfWarmups

	aNumberOfSteps > 0 ifFalse: [self error: 'Steps must be greather than 0'].
	aNumberOfWarmups >= 0 ifFalse: [self error: 'Warmup must be greater than or equal to 0.'].
	
	^self new initializeProgram: aProgram rng: aRandomGenerator steps: aNumberOfSteps warmup: aNumberOfWarmups.
! !

!Machine methodsFor: 'Setters' stamp: 'L.C 10/Jul/2026, 8:24:16 am (UTC)'!
incrementLogW: aValueOfLogWToSum

	logWeights := logWeights + aValueOfLogWToSum.! !

!Machine methodsFor: 'Setters' stamp: 'L.C 10/Jul/2026, 12:23:58 pm (UTC)'!
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

!Machine methodsFor: 'runner' stamp: 'L.C 10/Jul/2026, 5:47:16 am (UTC)'!
resumeRunner: aRunner

	[controlStack notEmpty] whileTrue: [(self stepRunner: aRunner) ifRunnerSignal: [ :signal | ^signal ]].
	
	^ aRunner doneWithValue: valueStack last.! !

!Machine methodsFor: 'runner' stamp: 'L.C 10/Jul/2026, 2:27:38 am (UTC)'!
stepRunner: aRunner

	| instruction result |
	instruction := controlStack removeLast.
	
	result := instruction executeOn: self runner: aRunner.
	result == instruction ifFalse: [^result].
	^ nil! !

!Machine methodsFor: 'Initialize' stamp: 'L.C 10/Jul/2026, 8:24:16 am (UTC)'!
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

!Machine methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 6:20:38 pm (UTC)'!
forkWithRng: aRandomNumberGenerator
	
	| rng copiedControlStack copiedEnvironment copiedValueStack |
	
	rng := randomGenerator isNil 
			ifTrue: [randomGenerator ]
			ifFalse: [aRandomNumberGenerator ].

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

!Machine methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 3:45:18 am (UTC)'!
nextIndexFor: anPreAddress

	| count |
	count := callCounter at: anPreAddress ifAbsent: [0].
	
	callCounter at: anPreAddress put: count+1.
	
	^count! !

!Machine methodsFor: 'Getters' stamp: 'L.C 10/Jul/2026, 8:24:16 am (UTC)'!
logWeights

	^logWeights! !

!Machine class methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:49:18 pm (UTC)'!
initialMachineWithProgram: aParsedProgram withRng: aRandomNumberGenerator

	| initialEnv initialEval |

	initialEnv := AlgorithmRunner new initialEnvironment.
	initialEval := Eval expression: aParsedProgram withEnvironment: initialEnv andAddress: #().
	
	^ self new initMachineWithControlStack: (OrderedCollection with: initialEval)
		withValueStack: OrderedCollection new 
		withEnvVar: initialEnv
		withRng: aRandomNumberGenerator
		withLogW: 0.0.! !

!AlgorithmRuns methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 10:29:25 am (UTC)'!
value
	^value! !

!LWRun methodsFor: 'category-name' stamp: 'L.C 10/Jul/2026, 8:22:13 am (UTC)'!
logWeights
	
	^logWeights! !

!LWRun methodsFor: 'Instance Creation' stamp: 'L.C 10/Jul/2026, 8:22:13 am (UTC)'!
withLogW: aLogWValue  withValue: aReturnValue
	
	logWeights := aLogWValue.
	value := aReturnValue.! !

!LWRun class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:46:55 pm (UTC)'!
withLogW: aLogWValue  withValue: aReturnValue

	^self new withLogW: aLogWValue withValue: aReturnValue ! !

!SMCRun methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:07:45 pm (UTC)'!
withValues: aCollectionOfValues

	values := aCollectionOfValues.
	
	^self! !

!SMCRun methodsFor: 'Getters' stamp: 'jcm 10/Jul/2026, 4:05:22 pm (UTC)'!
values

	^values! !

!SMCRun class methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:07:24 pm (UTC)'!
withValues: aCollectionOfValues

	^self new withValues: aCollectionOfValues! !

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

!SSMHRun class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 11:36:05 pm (UTC)'!
withTrace: aProposedTrace withValue: aReturnValue.
	
	
	
	^self new initializeWithTrace: aProposedTrace withValue: aReturnValue ! !

!Closure methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 3:51:35 am (UTC)'!
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

!Closure class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 5:35:12 pm (UTC)'!
withParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment

	^ self new initializeWithParameters: aParametersCollection andBody: aBody andEnvironment: anEnvironment! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 1:27:43 pm (UTC)'!
address

	^ address! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 1:34:14 pm (UTC)'!
address: anAddress
	
	address := anAddress.! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 9:23:12 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnviroment andAddress: anAddress

	self subclassResponsibility! !

!Instruction methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 1:27:29 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	self subclassResponsibility! !

!Call methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 1:34:41 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	| arguments operator |
	arguments := aMachine popValues: count.
	operator := aMachine popValue.
	
	operator applyArguments: arguments onMachine: aMachine atAddress: address.

	^self! !

!Call methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 1:34:29 pm (UTC)'!
initializeExpecting: aCount at: anAddress

	count := aCount.
	address := anAddress.! !

!Call class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 6:37:59 pm (UTC)'!
expecting: aCount at: anAddress

	^ self new initializeExpecting: aCount at: anAddress! !

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

!CallFunction methodsFor: 'Instance Creation' stamp: 'L.C 10/Jul/2026, 1:40:31 pm (UTC)'!
withFunction: aFunction withArguments: aCollectionOfArguments
	
	function  := aFunction.
	arguments  := aCollectionOfArguments.
	
	^self! !

!CallFunction class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026, 5:31:38 pm (UTC)'!
withFunction: aFunction withArguments: aCollectionOfArguments

	^self new withFunction: aFunction withArguments: aCollectionOfArguments
	
		! !

!Discard methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 1:41:48 pm (UTC)'!
executeOn: aMachine runner: aRunner
	
	aMachine popValue.
	^ self! !

!Eval methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 3:29:39 am (UTC)'!
executeOn: aMachine runner: aRunner
	
	expression evalWithMachine: aMachine withEnvironment: environment andAddress: address.
	
	^ self! !

!Eval methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:01:48 pm (UTC)'!
initExpression: anExpression withEnvironment: anEnvironment andAddress: anAddress

	expression := anExpression.
	environment := anEnvironment.
	address := anAddress.
	
	^ self! !

!Eval class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:03:52 pm (UTC)'!
expression: anExpression withEnvironment: anEnvironment andAddress: anAddress
	
	^ self new initExpression: anExpression withEnvironment: anEnvironment andAddress: anAddress.! !

!Fn methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026, 3:46:26 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnvironment  andAddress: anAddress


	aMachine pushValue: (Closure withParameters: parameters andBody: body andEnvironment: anEnvironment)
	
	! !

!Fn methodsFor: 'Instance Creation' stamp: 'jcm 9/Jul/2026, 3:51:24 pm (UTC)'!
withParameters: aCollectionOfParamters andBody: aBodyFunction
	
	parameters := aCollectionOfParamters.
	body := aBodyFunction.
	
	^self ! !

!Fn class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026, 3:50:40 pm (UTC)'!
withParameters: aCollectionOfParamaters andBody: aBodyFunction

	^self new withParameters: aCollectionOfParamaters andBody: aBodyFunction
	
		! !

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

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 1:39:56 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnviroment andAddress: anAddress
		bindings isEmpty ifTrue: [
			aMachine pushBody: body withEnvironment: environment andAddress: address.
			^ self].
		
		aMachine pushControl: (Let binds: bindings withIndex: 1 andBody: body andEnvironment: anEnviroment andAddress: anAddress ).
		aMachine pushControl: (Eval expression: (bindings at: 2) withEnvironment: anEnviroment andAddress: (anAddress , {#let. 1})).
		
		^self! !

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 11:25:49 am (UTC)'!
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

!Let methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 1:02:53 pm (UTC)'!
initBinds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress
	"esto no se esta usando"
	bindings := aBindCollection.
	index := anIndex.
	body := aBody.
	environment := anEnvironment.
	address := anAddress.
	
	^ self! !

!Let class methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 2:24:35 pm (UTC)'!
binds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress

	^ self new initBinds: aBindCollection withIndex: anIndex andBody: aBody andEnvironment: anEnvironment andAddress: anAddress! !

!Let class methodsFor: 'as yet unclassified' stamp: 'jcm 8/Jul/2026, 9:41:39 pm (UTC)'!
initBinds: aBindCollection withBody: aBody 

	^self new initBinds: aBindCollection withBody: aBody ! !

!Observe methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 1:03:23 pm (UTC)'!
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

!Observe class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:08:59 am (UTC)'!
withAddress: anAddress

	^ self new initializeWithAddress: anAddress! !

!Observe class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026, 8:01:08 pm (UTC)'!
withDistribution: aDistribution withObservedValue: anObservedValue

	^self new withDistribution: aDistribution withObservedValue: anObservedValue
	
	
	! !

!Sample methodsFor: 'as yet unclassified' stamp: 'jcm 9/Jul/2026, 7:49:07 pm (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: anAddress

	address := anAddress.

	aMachine pushControl: self.
	aMachine pushControl: (Eval 
			expression: distribution
			withEnvironment: anEnvironment 
			andAddress: (address,{#d})).
	^ self! !

!Sample methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 10:03:58 am (UTC)'!
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

!Sample class methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 2:08:51 am (UTC)'!
withAddress: anAddress

	^ self new initializeWithAddress: anAddress! !

!Sample class methodsFor: 'instance creation' stamp: 'jcm 9/Jul/2026, 7:39:20 pm (UTC)'!
withDistribution: aDistribution 

	^self new withDistribution: aDistribution 
	! !

!SMCMessage methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 9:22:46 pm (UTC)'!
isDone

	^false! !

!SMCMessage methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 9:22:39 pm (UTC)'!
isObserve

	^false! !

!SMCMessage methodsFor: 'Instance Creation' stamp: 'L.C 10/Jul/2026, 5:44:21 am (UTC)'!
ifRunnerSignal: aBlock

	^aBlock value: self! !

!SMCDone methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 10:16:11 pm (UTC)'!
isDone

	^true! !

!SMCDone methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 4:03:41 pm (UTC)'!
value

	^value! !

!SMCDone methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 3:57:23 pm (UTC)'!
withValue: aReturnValue

	value := aReturnValue.
	
	^self! !

!SMCDone class methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 3:57:23 pm (UTC)'!
withValue: aReturnValue

	^self new withValue: aReturnValue! !

!SMCObserve methodsFor: 'Getters' stamp: 'jcm 7/Jul/2026, 10:03:46 pm (UTC)'!
particle

	^particle! !

!SMCObserve methodsFor: 'Instance Creation' stamp: 'jcm 7/Jul/2026, 10:16:23 pm (UTC)'!
isObserve

	^true! !

!SMCObserve methodsFor: 'Instance Creation' stamp: 'jcm 10/Jul/2026, 5:50:50 pm (UTC)'!
logIncrement

	^logIncrement ! !

!SMCObserve methodsFor: 'Instance Creation' stamp: 'jcm 7/Jul/2026, 9:45:23 pm (UTC)'!
withAddress: anAddress forParticle: aParticle withLogIncrement: aLogValue

	address  := anAddress .
	particle := aParticle .
	logIncrement := aLogValue .
	
	^self! !

!SMCObserve class methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 9:44:35 pm (UTC)'!
withAddress: anAddress forParticle: aParticle withLogIncrement: aLogValue

	^self new withAddress: anAddress forParticle: aParticle withLogIncrement: aLogValue! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:28:55 am (UTC)'!
initialize
	sampleValues := Dictionary new.
	sampleDensities := Dictionary new.
	observeDensities := Dictionary new.! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 1:56:34 am (UTC)'!
logDensityExcluding: excludedAddresses

	| density |
	
	density := 0.
	
	observeDensities valuesDo: [:prob | density := density + prob].

	sampleDensities keysAndValuesDo: [:address :prob | (excludedAddresses includes: address) ifFalse: [density := density + prob]].
	
	^ density.! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:49:14 pm (UTC)'!
observeDensities
^observeDensities! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 1:20:43 am (UTC)'!
randomSampleAdressUsing: aRandomNumberGenerator

	sampleValues isEmpty ifTrue: [self error: 'Cannot pick an address from an empty trace.'].
	^sampleValues keys atRandom: aRandomNumberGenerator.! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 6/Jul/2026, 12:49:22 pm (UTC)'!
sampleDensities
^sampleDensities! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'JCM 5/Jul/2026, 2:19:28 am (UTC)'!
sampleValues 
 ^sampleValues ! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 6:04:42 am (UTC)'!
updateObservedCacheAt: anAddress put: anObservedDensity

	(observeDensities includesKey: anAddress) ifTrue: [self error: 'Address collision at ', anAddress asString].
	
	observeDensities at: anAddress put: anObservedDensity.! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 6:03:37 am (UTC)'!
updateSampleDensitiesAt: anAddress put: aSampledDensity.

	(sampleDensities includesKey: anAddress) ifTrue: [self error: 'Address collision at ', anAddress asString].
	
	sampleDensities at: anAddress put: aSampledDensity! !

!MHTrace methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 6:03:42 am (UTC)'!
updateSampleValuesAt: anAddress put: aSampledValue.
	
	(sampleValues includesKey: anAddress) ifTrue: [self error: 'Address collision at ', anAddress asString].
	
	sampleValues at: anAddress put: aSampledValue ! !

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

!SingleSiteProposal class methodsFor: 'instance creation' stamp: 'L.C 5/Jul/2026, 2:27:00 am (UTC)'!
from: aCurrentTrace to: aProposedTrace at: anAddress
	
	^ self new initializeWith: aCurrentTrace proposed: aProposedTrace address: anAddress! !

!Distribution methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:02:28 am (UTC)'!
logarithmicProbabilityWith: aValue

	^self subclassResponsibility! !

!Distribution methodsFor: 'as yet unclassified' stamp: 'L.C 7/Jul/2026, 1:26:26 am (UTC)'!
sample
	^self subclassResponsibility! !

!NormalDistribution methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:26:48 pm (UTC)'!
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

!NormalDistribution class methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:26:43 pm (UTC)'!
withMean: aMeanValue standardDeviation: aStandardDeviation randomGenerator: aRandomNumberGenerator
	
	aStandardDeviation <= 0 ifTrue: [self error: 'Standard deviation must be positive'].

	^ self new 
		initializeWithMean: aMeanValue 
		standardDeviation: aStandardDeviation 
		randomGenerator: aRandomNumberGenerator! !

!Primitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 2:03:32 am (UTC)'!
applyArguments: arguments onMachine: aMachine atAddress: address
	
	self subclassResponsibility! !

!AddPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 2:05:49 am (UTC)'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) + (arguments at: 2).
	aMachine pushValue: result.! !

!DividePrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 2:16:21 am (UTC)'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) / (arguments at: 2). "agregar caso den es 0"
	aMachine pushValue: result.! !

!EqualPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 2:16:41 am (UTC)'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) = (arguments at: 2).
	aMachine pushValue: result.! !

!MultiplyPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 2:15:34 am (UTC)'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) * (arguments at: 2).
	aMachine pushValue: result.! !

!NormalPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:24:46 pm (UTC)'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| distribution |
	distribution := NormalDistribution 
		withMean: (arguments at: 1) 
		standardDeviation: (arguments at: 2) 
		randomGenerator: aMachine randomGenerator.
	
	aMachine pushValue: distribution.! !

!SubtractPrimitive methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 2:15:14 am (UTC)'!
applyArguments: arguments onMachine: aMachine atAddress: address

	| result |
	result := (arguments at: 1) - (arguments at: 2).
	aMachine pushValue: result.! !

!SoftMax methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 3:00:18 pm (UTC)'!
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

!SoftMax class methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 3:00:59 pm (UTC)'!
for: aCollection

	^self new for: aCollection! !

!AlgorithmRunner methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 2:19:01 am (UTC)'!
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

!AlgorithmRunner methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:48:03 pm (UTC)'!
run

	| runValue |
	
	[runValue isNil] whileTrue:[runValue := machine resumeRunner: self].
	"Termina cuando recibe un done"
	^runValue! !

!AlgorithmRunner methodsFor: 'Special Instructions' stamp: 'jcm 6/Jul/2026, 7:39:52 pm (UTC)'!
doneWithValue: aReturnValue

	self subclassResponsibility! !

!AlgorithmRunner methodsFor: 'Special Instructions' stamp: 'jcm 10/Jul/2026, 5:32:36 pm (UTC)'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	self subclassResponsibility! !

!AlgorithmRunner methodsFor: 'Special Instructions' stamp: 'jcm 10/Jul/2026, 5:33:20 pm (UTC)'!
sampleWithAddress: anAddress withDistribution: aDistribution

	self subclassResponsibility! !

!AlgorithmRunner methodsFor: 'setters' stamp: 'L.C 8/Jul/2026, 2:20:23 am (UTC)'!
machine: aMachine 
	
	machine := aMachine! !

!ImportanceSamplingRunner methodsFor: 'Special Instructions' stamp: 'jcm 10/Jul/2026, 5:36:57 pm (UTC)'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue
	
	| logIncrement |
	logIncrement := aDistribution logarithmicProbabilityWith: anObservedValue.
	
	machine incrementLogW: (aDistribution logarithmicProbabilityWith: anObservedValue).
	machine pushValue: anObservedValue.
	
	^self returnWithAddress: anAddress withLogIncrement: logIncrement withObservedValue: anObservedValue.
! !

!ImportanceSamplingRunner methodsFor: 'Special Instructions' stamp: 'jcm 10/Jul/2026, 5:33:20 pm (UTC)'!
sampleWithAddress: anAddress withDistribution: aDistribution

	^aDistribution sample.! !

!LWRunner methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:22:04 am (UTC)'!
runWithProgram: aProgram withRng: aRandomNumberGenerator

	randomNumberGenerator  := aRandomNumberGenerator.
	machine := Machine initialMachineWithProgram: aProgram withRng: randomNumberGenerator.
	program := aProgram.
	
	^self run
	
	! !

!LWRunner methodsFor: 'Special Instructions' stamp: 'L.C 10/Jul/2026, 8:23:19 am (UTC)'!
doneWithValue: aReturnValue

"Cambiar nombre aReturnValue viene de V[-1] "

	
	^LWRun withLogW: machine logWeights withValue: aReturnValue.! !

!LWRunner methodsFor: 'Special Instructions' stamp: 'jcm 10/Jul/2026, 5:37:34 pm (UTC)'!
returnWithAddress: anAddress withLogIncrement: logIncrement withObservedValue: anObservedValue

	^anObservedValue

	

	! !

!LWRunner class methodsFor: 'as yet unclassified' stamp: 'jcm 6/Jul/2026, 7:08:42 pm (UTC)'!
runWithProgram: aProgram withRng: aRandomNumberGenerator

	^self new runWithProgram: aProgram withRng: aRandomNumberGenerator! !

!SMCRunner methodsFor: 'as yet unclassified' stamp: 'jcm 7/Jul/2026, 9:51:21 pm (UTC)'!
advance: aParticle

	
	machine := aParticle.
	
	^aParticle resumeRunner: self
	

	! !

!SMCRunner methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 6:07:32 pm (UTC)'!
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

!SMCRunner methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 6:17:33 pm (UTC)'!
run

	| messages |
	
	[true] whileTrue:[
		messages := particles collect: [:particle | self advance: particle].
		
		"Chequea si todas son Done"
		(messages allSatisfy: [:msg | msg isDone]) ifTrue:[
			^SMCRun withValues: (messages collect: [:msg | msg value])
			].
		
		"Chequea si todas son Observe"
		(messages allSatisfy: [:msg | msg isObserve]) ifFalse: [
			self error: 'algorithm needs all particles to reach observe together'
		].
		
		
		particles := self resampleFromObserveMessages: messages.
		
		]

	

	! !

!SMCRunner methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 3:39:19 pm (UTC)'!
runWithProgram: aProgram withRng: aCollectionOfRandomNumberGenerators  withParticles: aCollectionOfParticles

	particles := aCollectionOfParticles.
	randomNumberGenerators  := aCollectionOfRandomNumberGenerators .
	program  := aProgram.
	
	^self run

	

	! !

!SMCRunner methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 3:44:59 pm (UTC)'!
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

!SMCRunner methodsFor: 'Special Instructions' stamp: 'jcm 10/Jul/2026, 3:57:41 pm (UTC)'!
doneWithValue: aReturnValue
	
	^SMCDone withValue: aReturnValue! !

!SMCRunner methodsFor: 'Special Instructions' stamp: 'L.C 8/Jul/2026, 6:54:17 am (UTC)'!
observeWithAddress: anAddress withDistribution: aDistribution withObservedValue: anObservedValue

	| logIncrement |
	logIncrement := aDistribution logarithmicProbabilityWith: anObservedValue.
	
	"Machine es la particula actual sobre la cual se esta avanzando, se define en el metodo advance"
	machine incrementLogW: logIncrement.
	machine pushValue: anObservedValue.
	
	^SMCObserve withAddress: anAddress forParticle: machine withLogIncrement: logIncrement! !

!SMCRunner methodsFor: 'Special Instructions' stamp: 'jcm 10/Jul/2026, 5:36:41 pm (UTC)'!
returnWithAddress: anAddress withLogIncrement: logIncrement withObservedValue: anObservedValue.
	
	^SMCObserve withAddress: anAddress forParticle: machine withLogIncrement: logIncrement! !

!SMCRunner class methodsFor: 'instance creation' stamp: 'jcm 10/Jul/2026, 6:26:52 pm (UTC)'!
runWithProgram: aProgram withRng: aCollectionOfRandomNumberGenerators withParticles: aCollectionOfParticles
	
	^self new runWithProgram: aProgram withRng: aCollectionOfRandomNumberGenerators withParticles: aCollectionOfParticles! !

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

!SSMHRunner methodsFor: 'Special Instructions' stamp: 'L.C 10/Jul/2026, 12:23:23 pm (UTC)'!
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

!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:40:24 am (UTC)'!
machine
	^machine! !

!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 11:13:32 am (UTC)'!
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

!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 3:59:46 am (UTC)'!
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

!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:40:47 pm (UTC)'!
trace

	^trace
	! !

!SSMHRunner methodsFor: 'as yet unclassified' stamp: 'L.C 8/Jul/2026, 12:39:53 am (UTC)'!
trace: aTrace
	
	trace := aTrace! !

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

!InterpreterTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:28:50 am (UTC)'!
dummyMachineWithControlStack: aControlStack

^ Machine new
		initMachineWithControlStack: aControlStack
		withValueStack: nil 
		withEnvVar: nil 
		withRng: Random new
		withLogW: 0.! !

!InterpreterTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 2:21:43 am (UTC)'!
evalAST: anAST
	
	^ self evalAST: anAST withEnvironment: runner initialEnvironment.! !

!InterpreterTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:37:24 am (UTC)'!
evalAST: anAST withEnvironment: anEnvironment
	
	machine := self dummyMachineWithControlStack: {Eval expression: anAST withEnvironment: anEnvironment andAddress: #().}.
	^ (machine resumeRunner: runner) value! !

!InterpreterTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:28:24 am (UTC)'!
setUp
	runner := SSMHRunner new.
	runner trace: MHTrace new. "PARCHE TEMPORAL"! !

!LWTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 2:23:53 pm (UTC)'!
test01SampleReturnSampledValue

	| firstResult firstWeight normalDist results sampleInst |
	"normalDist := CallFunction withFunction: #normal withArguments: {0. 1}."
	normalDist := NormalDistribution withMean: 0 standardDeviation: 1 randomGenerator: Random new.
	sampleInst := Sample withDistribution: normalDist.
	
	results := LikelihoodWeighting program: sampleInst rng: Random new for: 1.
		
	firstResult := results value first.
	firstWeight := results logWeights first.
	
	self assert: firstResult isNumber.
	self assert: firstWeight equals: 1.! !

!LWTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 2:26:19 pm (UTC)'!
test02WeightsNormalizeToOne
	
	| program results sumOfWeights weights |
	program := Sample withDistribution: (NormalDistribution withMean: 0 standardDeviation: 1 randomGenerator: Random new).
	
	results := LikelihoodWeighting program: program rng: Random new for: 100.
	
	weights := results logWeights.
	
	sumOfWeights := weights sum.
	
	self assert: ((sumOfWeights - 1.0) abs < 0.0001).! !

!LWTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 2:28:37 pm (UTC)'!
test03AddressConventionIsStable

	| program runner1 runner2 result1 result2 distribution |
	distribution := NormalDistribution withMean: 0 standardDeviation: 1 randomGenerator: Random new.
	program := Let binds: {#x . (Sample withDistribution: distribution)}
	withIndex: 1
	andBody: {(Observe withDistribution: distribution withObservedValue: 0.5)}
	andEnvironment: Dictionary new 
	andAddress: #().

	runner1 := LWRunner new.
	result1 := runner1 runWithProgram: program withRng: (Random seed: 666).
	
	runner2 := LWRunner new.
	result2 := runner2 runWithProgram: program withRng: (Random seed: 666).
	
	self assert: result1 value equals: result2 value.
	self assert: result1 logWeights equals: result2 logWeights.! !

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

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 3:51:15 am (UTC)'!
test08EvalFn
	"identidad"
	
	"self assert: (self evalAST: #((fn (#x) #x) 42)) equals: 42."
	"self assert: (self evalAST: (Fn withParameters: #(#x) andBody: #(#x 42))) equals: 42."
	self assert: 
		(self evalAST: (CallFunction withFunction: (Fn withParameters: #(#x) andBody: #(#x))
			withArguments: #(42))) 
				equals: 42.
	! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 2:24:28 am (UTC)'!
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

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 9/Jul/2026, 11:43:11 pm (UTC)'!
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

!SMCTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 4:05:04 pm (UTC)'!
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
    self assert: result values asArray equals: {1.0. 2.5. -3.0}.! !

!SMCTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 4:31:16 pm (UTC)'!
test02RejectsBrokenObserve

	| p1 p2 |
	"es insta Done"
	p1 := self dummyMachineWithControlStack: #(). 
	p1 pushValue: 1.
	

	"intercepta Observe"
	p2 := self dummyMachineWithControlStack: {Observe withAddress: #(#sigma)}.
	p2 pushValue: (NormalDistribution withMean: 0 standardDeviation: 1 randomGenerator: nil).
	p2 pushValue: 0.

	runner := SMCRunner new.

	self should: [ runner runWithProgram: nil withRng: Random new withParticles: {p1. p2}] 
        	raise: Error
        	withExceptionDo: [ :exception | self assert: exception messageText equals: 'algorithm needs all particles to reach observe together'].! !

!SMCTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 4:32:07 pm (UTC)'!
test03ObserveUpdateWeight

    | particle distribution program |

    particle := self dummyMachineWithControlStack: #().

    runner := SMCRunner new.
    runner machine: particle.

    distribution := NormalDistribution withMean: 0 standardDeviation: 1 randomGenerator: Random new.
    program := runner observeWithAddress: #sigma withDistribution: distribution withObservedValue: 0.

    self assert: program isObserve.
    self assert: program particle equals: particle.
    self assert: particle popValue equals: 0.
    self assert: particle logWeights equals: (distribution logarithmicProbabilityWith: 0).! !

!SMCTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 5:29:27 pm (UTC)'!
test04SampleReturnsSampledValue

    | particle distribution sampled |

    particle := self dummyMachineWithControlStack: #().
    runner := SMCRunner new.
    runner machine: particle.

    distribution := NormalDistribution withMean: 0 standardDeviation: 1 randomGenerator: Random new.
    sampled := runner sampleWithAddress: #mu withDistribution: distribution.

    self assert: sampled isFloat.
    self should: [ particle popValue] raise: Error.! !

!SMCTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 6:20:59 pm (UTC)'!
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

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:29:23 am (UTC)'!
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

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:31:06 am (UTC)'!
test02InitialTraceRegistersObserves

	| ast distribution result |
	distribution := NormalDistribution withMean: 0 standardDeviation: 1 randomGenerator: Random new.
	ast := Observe withDistribution: distribution withObservedValue: 5.
	
	machine := self dummyMachineWithControlStack: {Eval expression: ast withEnvironment: Dictionary new andAddress: #(#main)}.
	runner machine: machine.
	result := machine resumeRunner: runner.
	
	self assert: result class equals: SSMHRun.
	self assert: (result trace observeDensities includesKey: #(#main)).! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 2:29:45 pm (UTC)'!
test03CacheReuseAtNonRedrawAddress

	| ast cache result distribution |
	
	distribution := NormalDistribution withMean: 0 standardDeviation: 1 randomGenerator: Random new.
	ast := Sample withDistribution: distribution.
	
	cache := {#() -> 42} asDictionary.

	runner := SSMHRunner new.

	result := runner run: ast withRng: Random new redrawAddress: #(#another) withCache: cache.

	self assert: (result trace sampleValues at: #()) equals: 42.! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 1:12:37 am (UTC)'!
test04RedrawSiteForcesNewSample
	
	| ast cache distribution dummyRandom result |
	dummyRandom := ReadStream on: #(0.5 0.5).
	
	distribution := NormalDistribution withMean: 0.0 standardDeviation: 1.0 randomGenerator: dummyRandom.
	ast := Sample withDistribution: distribution.
	
	cache := {#main -> 42} asDictionary.
	
	runner := SSMHRunner new.
	result := runner run: ast withRng: dummyRandom redrawAddress: #() withCache: cache. "forzamos una muestra nueva"
	
	self assert: (result trace sampleValues at: #()) ~= 42.! !

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 1:13:20 am (UTC)'!
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

!SSMHTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 2:30:19 pm (UTC)'!
test06RandomSampleAddressWithEmptyTrace
	| trace randomGenerator |
	
	trace := MHTrace new.
	randomGenerator := Random new.
	
	self should: [trace randomSampleAdressUsing: randomGenerator] 
		raise: Error 
		withExceptionDo: [ :anException |
			self assert: anException messageText equals: 'Cannot pick an address from an empty trace.'].! !

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 12:58:02 pm (UTC)'!
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

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 9:16:36 am (UTC)'!
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

!MainTest methodsFor: 'as yet unclassified' stamp: 'jcm 10/Jul/2026, 6:24:44 pm (UTC)'!
testConjSMC
	| posteriori particles |
	
	particles := SequentialMonteCarlo 
		program: self genProgram 
		rng: {Random new. Random new}
		for: 2.
	
	posteriori := particles sum / particles size.
	
	self assert: (posteriori between: 0.9 and: 1.4).! !

!MainTest methodsFor: 'as yet unclassified' stamp: 'L.C 10/Jul/2026, 10:34:14 am (UTC)'!
testConjSSMH
	| chain posteriori |
	
	chain := SingleSiteMetropolisHastings 
		program: self genProgram
		rng: Random new 
		steps: 1000
		warmup: 200.

	posteriori := chain sum / chain size.
	
	self assert: (posteriori between: 0.9 and: 1.4).! !

!Object methodsFor: '*SmalltalkPPL-Evaluation' stamp: 'L.C 10/Jul/2026, 2:42:53 am (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: anAddress

	aMachine pushValue: self.! !

!Object methodsFor: '*SmalltalkPPL-Evaluation' stamp: 'L.C 10/Jul/2026, 12:21:21 pm (UTC)'!
ifRunnerSignal: aBlock

	^self! !

!OrderedCollection methodsFor: '*SmalltalkPPL-SoftMax' stamp: 'jcm 10/Jul/2026, 2:53:45 pm (UTC)'!
softMax

	"https://es.wikipedia.org/wiki/Funci%C3%B3n_SoftMax"
	| normalized |
	
	self isEmpty 
		ifTrue: [ normalized := self copy ]
		ifFalse: [ | expSum maxLog |
			maxLog := self inject: self first into: [:max :each | max max: each].
			expSum := self inject: 0.0 into: [:sum :each | (each-maxLog) exp + sum].
			normalized := self collect: [ :each | (each-maxLog) exp / expSum ].
		].
	
	^normalized! !

!Symbol methodsFor: '*SmalltalkPPL-Evaluation' stamp: 'L.C 10/Jul/2026, 2:44:03 am (UTC)'!
evalWithMachine: aMachine withEnvironment: anEnvironment andAddress: anAddress

	(anEnvironment includesKey: self) 
		ifTrue: [aMachine pushValue: (anEnvironment at: self)] 
		ifFalse: [self error: 'NameError: ',self asString].! !
