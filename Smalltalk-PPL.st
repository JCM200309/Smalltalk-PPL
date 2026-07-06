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

!Machine methodsFor: 'runner' stamp: 'L.C 7/6/2026 00:10:52'!
ev: anInstruction

	| e env addr head  binds body |
	e := anInstruction at: 2.
	env := anInstruction at: 3.
	addr := anInstruction at: 4.
	
	e isSymbol ifTrue: [ (env includesKey: e) ifTrue: [ valueStack addLast: (env at: e) ] ifFalse: [ self error: 'NameError: ' , e asString ]. ^ self].
	
	e isCollection ifFalse: [valueStack addLast: e. ^self].
	
	head := e first.
	
	head == #if ifTrue: [
		controlStack addLast: { #ifk. (e at: 3). (e at: 4). env. addr }.
		controlStack addLast: { #ev. (e at: 2). env. (addr , {#test}) }.
		^ self
	].

	head == #let ifTrue: [
		binds := e at: 2.
		body := e copyFrom: 3 to: e size.
		
		binds isEmpty ifFalse: [
			"C.append(('letk', binds, 0, body, env, addr)); C.append(('ev', binds[1], env, addr + ('let', 0)))"
			controlStack addLast: {#letk. binds. 0. body. env. addr }.
			controlStack addLast: {#ev. (binds at: 2). env. (addr , {#let. 0})}.
			^ self
		].
		self pushBody: body env: env addr: addr.
		^ self
	].
		
	"sin este self se rompe (???)"
	^self
	! !

!Machine methodsFor: 'runner' stamp: 'L.C 7/5/2026 21:54:46'!
ifk: anInstruction

	| addr else env then branch tag |
	
	then := anInstruction at: 2.
	else := anInstruction at: 3.
	env := anInstruction at: 4.
	addr := anInstruction at: 5.
	
	(valueStack removeLast) ifTrue: [ 
		branch := then. 
		tag := #then ] 
	ifFalse: [ 
		branch := else. 
		tag := #else 
		].
	
	controlStack addLast: {#ev. branch. env. (addr , {tag})}.
	
	^ self! !

!Machine methodsFor: 'runner' stamp: 'L.C 7/6/2026 00:08:47'!
letk: anInstruction

	| addr binds body index newEnv value varName nextIndex env |
	binds := anInstruction at: 2.
	index := anInstruction at: 3.
	body := anInstruction at: 4.
	env := anInstruction at: 5.
	addr := anInstruction at: 6.
	
	value := valueStack removeLast.
	varName := binds at: (2*index)+1.
	
	newEnv := env copy. "sin esto da problemas de punteros, ver alternativas"
	newEnv at: varName put: value.
	
	nextIndex := index + 1.
	
	2 * nextIndex < binds size ifTrue: [
			controlStack addLast: { #letk. binds. nextIndex. body. newEnv. addr }.
			controlStack addLast: { #ev. (binds at: 2*nextIndex+2). newEnv. (addr , {#let. (2*nextIndex)})}
		] ifFalse: [
			self pushBody: body env: newEnv addr: addr.
		].
	
	^ self! !

!Machine methodsFor: 'runner' stamp: 'L.C 7/6/2026 00:00:24'!
pushBody: aBody env: anEnv addr: anAddress
	"DUMMY"
	controlStack addLast: { #ev. (aBody first). anEnv. (anAddress,{#body})}. ^ self! !

!Machine methodsFor: 'runner' stamp: 'L.C 7/5/2026 21:43:51'!
resumeRunner: aRunner

	[controlStack notEmpty] whileTrue: [self stepRunner: aRunner].
	
	^ aRunner doneWithValue: valueStack last! !

!Machine methodsFor: 'runner' stamp: 'L.C 7/5/2026 21:40:32'!
stepRunner: aRunner

	"100% esto es command pattern a futuro"

	| instruction tag |
	instruction := controlStack removeLast.
	tag := instruction at: 1.
	
	tag == #ev ifTrue: [^ self ev: instruction].
	tag == #ifk ifTrue: [^ self ifk: instruction].
	tag == #letk ifTrue: [^ self letk: instruction].
	tag == #discard ifTrue: [^ self discard: instruction].
	tag == #callk ifTrue: [^ self callk: instruction].
	
	tag == #samplek ifTrue: [^ self samplek: instruction withRunner: aRunner].
	tag == #observek ifTrue: [^ self observek: instruction withRunner: aRunner].! !


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

!Machine methodsFor: 'as yet unclassified' stamp: 'L.C 7/5/2026 20:23:17'!
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

!SSMHRun methodsFor: 'as yet unclassified' stamp: 'L.C 7/5/2026 20:31:40'!
value
	^value! !

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
!classDefinition: #MachineTest category: #'Smalltalk-PPL-Tests'!
TestCase subclass: #MachineTest
	instanceVariableNames: 'runner machine'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Smalltalk-PPL-Tests'!

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/5/2026 21:59:35'!
dummyMachineWithControlStack: aControlStack

^ Machine new
		initMachineWithControlStack: aControlStack
		withValueStack: nil 
		withEnvVar: nil 
		withRng: nil
		withLogW: 0.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/5/2026 20:39:13'!
setUp
	runner := SSMHRunner new.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/5/2026 22:00:16'!
test01EvalLiteral
	
	machine := self dummyMachineWithControlStack: {{#ev. 100. Dictionary new. #()}}.

	self assert: (machine resumeRunner: runner) value equals: 100.
	! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/5/2026 22:00:49'!
test02EvalSymbol
	
	| env |
	env := {#y -> 42} asDictionary.
	
	machine := self dummyMachineWithControlStack: {{#ev. #y. env. #()}}.
		
	self assert: (machine resumeRunner: runner) value equals: 42! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/5/2026 22:01:13'!
test03EvalIfTrue

	| ast |
	ast := #(if true 2 1).
	
	machine := self dummyMachineWithControlStack: {{#ev. ast. Dictionary new. #()}}.
	
	self assert: (machine resumeRunner: runner) value equals: 2.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/5/2026 22:01:31'!
test04EvalIfFalse

	| ast |
	ast := #(if false 2 1).
	
	machine := self dummyMachineWithControlStack: {{#ev. ast. Dictionary new. #()}}.
	
	self assert: (machine resumeRunner: runner) value equals: 1.! !

!MachineTest methodsFor: 'as yet unclassified' stamp: 'L.C 7/5/2026 22:01:50'!
test05EvalLet
	
	| ast |
	ast := #(let (#x 1) #x). "Se lee como let x = 1 in x, refactorizar semantica"
	
	machine := self dummyMachineWithControlStack: {{#ev. ast. Dictionary new. #()}}.
		
	self assert: (machine resumeRunner: runner) value equals: 1.! !
(Smalltalk at: #qq__ ifAbsentPut: [OrderedCollection new]) add: (#(74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 99 74 124 112 122 92 117 112 125 108 121 122 112 123 128 52 62 61 59 56 53 112 116 104 110 108 17 94 112 117 58 57 17 61 53 57 17 95 61 59 17 86 119 108 117 39 90 116 104 115 115 123 104 115 114 39 74 118 110 98 90 119 124 121 100 39 93 84 39 98 83 112 125 108 91 128 119 112 117 110 74 118 80 117 123 108 121 119 121 108 123 108 121 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 100 17 94 112 117 107 118 126 122 17 94 112 117 58 57 39 105 124 112 115 123 39 118 117 39 84 104 121 39 39 56 39 57 55 57 60 39 55 56 65 55 59 65 57 57 39 78 84 91 39 74 118 116 119 112 115 108 121 65 39 59 53 57 53 56 39 74 118 116 119 104 123 112 105 115 108 39 74 115 104 117 110 39 63 53 55 53 56 39 47 123 104 110 122 54 89 76 83 76 72 90 76 102 63 55 56 54 109 112 117 104 115 48 17 83 112 125 108 91 128 119 112 117 110 74 118 80 117 123 108 121 119 121 108 123 108 121 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 39 124 124 112 107 65 39 57 61 104 55 55 106 105 106 52 58 56 60 107 52 59 106 108 107 52 104 108 60 105 52 61 60 55 58 60 56 56 61 58 106 58 62 39 84 104 121 39 39 56 39 57 55 57 60 17 83 112 125 108 91 128 119 112 117 110 74 118 110 112 123 39 93 84 84 104 114 108 121 53 118 122 106 118 110 52 108 108 116 53 58 61 61 57 39 124 124 112 107 65 39 57 61 104 55 55 106 105 106 52 58 56 60 107 52 59 106 108 107 52 104 108 60 105 52 61 60 55 58 60 56 56 61 58 106 58 62 39 84 104 121 39 39 56 39 57 55 57 60 17 93 84 65 39 57 55 57 60 56 55 55 61 56 64 58 59 39 111 108 121 117 104 117 71 84 104 106 73 118 118 114 52 87 121 118 52 107 108 52 79 108 121 117 104 117 52 57 53 115 118 106 104 115 65 75 118 106 124 116 108 117 123 122 54 93 84 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 39 75 104 123 108 65 39 84 118 117 39 86 106 123 39 61 39 56 57 65 58 59 65 57 56 39 57 55 57 60 39 74 118 116 116 112 123 79 104 122 111 65 39 108 107 58 60 59 63 61 39 87 115 124 110 112 117 122 65 39 57 55 57 60 56 55 55 61 56 64 58 59 39 111 108 121 117 104 117 71 84 104 106 73 118 118 114 52 87 121 118 52 107 108 52 79 108 121 117 104 117 52 57 53 115 118 106 104 115 65 75 118 106 124 116 108 117 123 122 54 93 84 54 118 119 108 117 122 116 104 115 115 123 104 115 114 52 125 116 17 179 35 39 8 17 56 62 57 53 57 63 53 58 57 53 56 17 94 80 85 75 86 94 90 52 80 77 55 89 59 91 55 53 116 122 111 118 116 108 53 117 108 123 17 94 80 85 75 86 94 90 52 80 77 55 89 59 91 55 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 59 91 57 56 65 56 57 65 57 62 53 63 61 62 56 58 64 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 126 117 115 118 104 107 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 53 122 123 17 59 56 62 63 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 60 91 56 62 65 58 62 65 56 59 53 59 58 55 58 57 56 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 99 90 116 104 115 115 123 104 115 114 52 87 87 83 47 57 48 53 122 123 17 63 63 58 58 17 52 52 52 52 52 52 52 52 52 52 17 17 52 52 52 52 52 52 52 52 52 52 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 59 91 57 58 65 55 55 65 60 62 53 62 58 58 64 62 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 53 122 123 17 61 62 63 62 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 60 91 57 57 65 56 56 65 57 58 53 58 59 55 59 62 57 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 53 122 123 17 56 58 55 58 63 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 61 91 55 55 65 56 58 65 59 56 53 57 59 59 61 62 58 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 52 91 108 122 123 122 53 122 123 17 57 55 57 63 17 52 52 52 52 52 52 52 52 52 52 17 57 55 57 61 52 55 62 52 55 61 91 55 55 65 56 59 65 57 55 53 60 59 59 61 62 58 52 55 58 65 55 55 17 74 65 99 92 122 108 121 122 99 115 124 106 112 104 99 75 118 106 124 116 108 117 123 122 99 90 116 104 115 115 123 104 115 114 99 126 112 117 107 118 126 122 61 59 52 92 122 108 121 77 112 115 108 122 99 77 112 115 108 86 124 123 122 99 90 116 104 115 115 123 104 115 114 52 87 87 83 53 122 123 17 56 59 58 55 62 17 52 52 52 52 52 52 52 52 52 52 17 17))!