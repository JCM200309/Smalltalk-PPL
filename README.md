# Smalltalk-PPL

`Smalltalk-PPL` es un paquete desarrollado en **Cuis Smalltalk** para implementar ideas de **Programación Probabilista** usando **Programación Orientada a Objetos**. El proyecto nace a partir de la materia *Introducción a la Programación Probabilista* y toma como referencia dos notebooks:

- [Activity 5: Messaging](https://colab.research.google.com/github/jburroni/IntroPPLs26/blob/main/notebooks/Jun-26/activity-5-messaging-student.ipynb)
- [Activity: Enumeration 8-bit](https://colab.research.google.com/github/jburroni/IntroPPLs26/blob/main/notebooks/Jun-26/activity-enumeration-8bit-executed.ipynb)

La idea principal del proyecto no fue copiar directamente la lógica de los notebooks, sino **llevar esos conceptos al paradigma de objetos de Smalltalk**. Por eso, el foco está puesto en cómo se organizan las responsabilidades entre clases, cómo se comunican los objetos mediante mensajes y cómo se encapsula la ejecución de un programa probabilístico.

## Idea general

El proyecto comenzó con una estrategia **Top-Down**. Primero pensamos qué comportamiento queríamos poder expresar desde afuera del paquete y después fuimos diseñando las clases necesarias para sostenerlo.

En lugar de empezar por una función grande que enumere todos los casos posibles, la implementación se fue organizando alrededor de tres preguntas principales:

- ¿Qué objeto representa la ejecución de un programa probabilístico?
- ¿Qué objeto sabe correr un algoritmo?
- ¿Qué objeto conserva el resultado de una corrida?

A partir de esas preguntas aparecen las abstracciones principales del diseño: la **máquina**, la clase de **algoritmos**, el **runner** y el objeto que representa una **corrida**.

## Arquitectura orientada a objetos

La arquitectura separa responsabilidades para evitar que toda la lógica probabilística quede concentrada en un único método. Cada clase tiene un rol dentro de la ejecución y se comunica con las demás mediante mensajes.

### Máquina

La **máquina** es el núcleo de la implementación. Su responsabilidad es representar la ejecución de un programa probabilístico dentro del paquete.

En términos conceptuales, la máquina se encarga de:

- mantener el estado de ejecución;
- avanzar paso a paso sobre el programa o modelo;
- registrar decisiones probabilísticas;
- manejar observaciones o evidencia;
- acumular pesos o probabilidades;
- producir información que luego será usada por los algoritmos.

Esta decisión de diseño es importante porque la lógica de ejecución queda encapsulada en un objeto específico. Así, los algoritmos no necesitan conocer todos los detalles internos de cómo se representa el estado, cómo se actualiza una probabilidad o cómo se avanza en una corrida. En cambio, interactúan con la máquina a través de mensajes.

Pensar en una máquina también ayuda a separar dos niveles distintos:

- el **nivel operacional**, que responde cómo se ejecuta un programa probabilístico;
- el **nivel algorítmico**, que responde qué estrategia de inferencia se usa sobre esa ejecución.

Gracias a esta separación, la máquina funciona como una base común sobre la cual pueden construirse distintos algoritmos.

### Clase de algoritmos

La clase de **algoritmos** representa la estrategia de inferencia. Su rol no es guardar simplemente funciones auxiliares, sino modelar la idea de que existen distintas formas de correr o analizar un programa probabilístico.

En el proyecto aplicamos y modelamos distintos algoritmos de inferencia probabilística:

- **SMC (Sequential Monte Carlo):** algoritmo basado en partículas que aproxima la distribución posterior mediante múltiples ejecuciones ponderadas.
- **Likelihood Weighting:** algoritmo que incorpora evidencia asignando pesos a las ejecuciones, en lugar de descartar directamente los casos que no coinciden.
- **SSHM:** algoritmo trabajado como parte del proyecto para explorar otra estrategia de ejecución/inferencia dentro de la misma arquitectura.

Todos estos algoritmos comparten la misma idea arquitectónica: no ejecutan el programa de forma aislada, sino que interactúan con la máquina y producen una corrida representable mediante `AlgorithmRun`.

Desde el punto de vista de POO, esta clase permite encapsular decisiones como:

- qué tipo de inferencia se va a ejecutar;
- cómo se interactúa con la máquina;
- qué información se necesita de una corrida;
- cómo se transforma el resultado producido por la máquina;
- qué comportamiento podría redefinirse en futuros algoritmos.

Esta abstracción vuelve más extensible el paquete. Si más adelante se quisiera agregar otro algoritmo, no sería necesario cambiar toda la máquina ni el runner: bastaría con agregar una nueva implementación que respete la misma interfaz conceptual.

### `AlgorithmRunner`

`AlgorithmRunner` actúa como el objeto encargado de **coordinar la ejecución**. Es una capa intermedia entre el usuario del paquete y los objetos internos que realmente realizan el trabajo.

Su responsabilidad principal es preparar y lanzar una corrida. En particular, el runner puede encargarse de:

- recibir el algoritmo que se quiere ejecutar;
- inicializar la máquina o el contexto necesario;
- crear el objeto que representa la corrida;
- enviar los mensajes correspondientes para comenzar la ejecución;
- devolver un resultado uniforme al usuario o a los tests.

Esta clase evita que el usuario tenga que conocer todos los detalles internos del paquete. En vez de construir manualmente la máquina, configurar el algoritmo y organizar el resultado, se usa un objeto especializado que centraliza ese flujo.

En términos de diseño, `AlgorithmRunner` funciona como una **fachada**: ofrece una entrada clara al sistema y oculta parte de la complejidad interna.

### `AlgorithmRun`

`AlgorithmRun` representa una **corrida concreta** de un algoritmo. Esta clase es importante porque evita devolver resultados sueltos o estructuras informales.

En lugar de retornar solamente una colección, un número o una traza, una corrida puede guardar en un mismo objeto información como:

- el algoritmo utilizado;
- el estado final de la ejecución;
- los resultados obtenidos;
- las decisiones probabilísticas tomadas;
- los pesos o probabilidades acumuladas;
- información útil para debugging o tests.

Esta separación hace que el resultado de ejecutar un algoritmo sea más explícito y más fácil de inspeccionar. También ayuda a los tests, porque permite verificar partes específicas de una corrida sin depender de detalles accidentales de implementación.

## Flujo de ejecución

De forma simplificada, el flujo del paquete puede pensarse así:

1. El usuario elige o construye un algoritmo.
2. `AlgorithmRunner` prepara la ejecución.
3. Se crea una instancia de `AlgorithmRun` para representar esa corrida.
4. El algoritmo interactúa con la máquina.
5. La máquina ejecuta el programa probabilístico y actualiza el estado de la corrida.
6. El runner devuelve el `AlgorithmRun` final o el resultado derivado de esa corrida.

Este flujo permite que cada objeto tenga una responsabilidad clara. La máquina ejecuta, el algoritmo define la estrategia, el runner coordina y `AlgorithmRun` conserva lo que ocurrió.

## Por qué esta arquitectura

La principal ventaja de esta arquitectura es que aprovecha mejor el paradigma de Smalltalk. En Smalltalk, los objetos no son simples contenedores de datos: son entidades que reciben mensajes y colaboran entre sí.

Por eso, el diseño busca evitar una implementación procedural donde todo ocurra dentro de un solo método. En su lugar, el paquete distribuye responsabilidades:

- la máquina conoce la ejecución;
- los algoritmos conocen la estrategia de inferencia;
- `AlgorithmRunner` conoce el protocolo para correr un algoritmo;
- `AlgorithmRun` conoce la información producida durante una corrida;
- los tests conocen el comportamiento esperado desde la interfaz pública.

Esto mejora la legibilidad, facilita el testing y permite extender el sistema sin reescribirlo por completo.

## Rol de la enumeración

La enumeración sigue siendo una parte importante del proyecto, especialmente porque uno de los notebooks de referencia trabaja con modelos finitos de 8 bits. Sin embargo, en la arquitectura del paquete la enumeración no es el único centro del diseño.

La idea de `enumerateTraces` puede entenderse como una herramienta o mecanismo particular dentro de una estrategia de inferencia exacta. Es útil para recorrer posibilidades, construir trazas y acumular probabilidades, pero se apoya sobre una arquitectura más general:

- una máquina que sabe ejecutar;
- un algoritmo que decide cómo explorar;
- un runner que organiza la corrida;
- un objeto `AlgorithmRun` que conserva el resultado.

De esta manera, `enumerateTraces` queda como una parte adicional del sistema y no como la única abstracción importante.

## Tests

El proyecto incluye tests basados en los notebooks y tests adicionales desarrollados por nosotros.

Los tests cumplen dos funciones:

- verifican que los resultados coincidan con los ejemplos trabajados en la materia;
- validan que la arquitectura responda correctamente desde sus objetos principales.

Esto es importante porque el objetivo no era solamente obtener los valores correctos, sino también comprobar que la solución estuviera bien organizada como paquete orientado a objetos.

Algunos aspectos que los tests ayudan a validar son:

- que la máquina actualice correctamente la ejecución;
- que los algoritmos implementados, como **SMC**, **Likelihood Weighting** y **SSHM**, produzcan resultados esperados;
- que `AlgorithmRunner` coordine correctamente una corrida;
- que `AlgorithmRun` conserve la información relevante;
- que la enumeración sea consistente con los notebooks.

## Cómo correr el proyecto en Cuis Smalltalk

Para usar el paquete, primero es necesario tener una instalación funcional de **Cuis Smalltalk**.

### 1. Obtener el repositorio

Clonar este repositorio o descargarlo como archivo `.zip`:

```bash
git clone https://github.com/JCM200309/Smalltalk-PPL.git
```

Luego abrir Cuis Smalltalk desde la imagen correspondiente.

### 2. Importar el paquete

En Cuis, importar el archivo del paquete desde el entorno gráfico:

1. Abrir el menú principal de Cuis.
2. Ir a `Open...`.
3. Abrir el `File List`.
4. Navegar hasta la carpeta del repositorio.
5. Seleccionar el archivo del paquete, normalmente con extensión `.pck.st`.
6. Elegir la opción `Install Package`.

Si el paquete se encuentra en una carpeta conocida por Cuis y define una feature con el mismo nombre, también se puede cargar desde un `Workspace` con:

```smalltalk
Feature require: #'Smalltalk-PPL'.
```

> Si el nombre del archivo o de la feature difiere, usar el nombre exacto del paquete que aparece en el repositorio.

### 3. Ejecutar los tests

Una vez importado el paquete:

1. Abrir el browser de clases de Cuis.
2. Buscar las categorías o clases del paquete `Smalltalk-PPL`.
3. Abrir el runner de tests de Cuis/SUnit.
4. Ejecutar los tests incluidos en el paquete.

Los tests deberían validar tanto los ejemplos inspirados en los notebooks como los casos adicionales agregados durante el desarrollo.

## Trabajo realizado

Durante el desarrollo del proyecto:

- partimos de los notebooks como especificación inicial;
- diseñamos una solución Top-Down;
- trasladamos los conceptos probabilísticos al paradigma de objetos;
- modelamos una máquina de ejecución;
- incorporamos una separación entre algoritmo, runner y corrida;
- implementamos algoritmos como **SMC**, **Likelihood Weighting** y **SSHM**;
- implementamos mecanismos de enumeración como parte de la inferencia exacta;
- agregamos tests basados en los notebooks y tests propios.

## Conclusión

`Smalltalk-PPL` es una implementación de conceptos de Programación Probabilista en Cuis Smalltalk, pero su aporte principal está en la arquitectura orientada a objetos. La máquina, la clase de algoritmos, `AlgorithmRunner` y `AlgorithmRun` permiten separar la ejecución, la estrategia de inferencia, la coordinación y el resultado de cada corrida. Sobre esta base se integran algoritmos como **SMC**, **Likelihood Weighting** y **SSHM**.

Esta separación hace que el paquete sea más claro, testeable y extensible. Además, muestra cómo ideas probabilísticas que originalmente aparecen en notebooks pueden reinterpretarse dentro del modelo de objetos y mensajes propio de Smalltalk.