# Spin

- Typ: expliziter Modelchecker
- Modell: Guarded Commands ("Promela")
- Formeln: LTL
- weitere Funktionalität: Simulator, GUI
- Reduktionstechniken: Partial Order Reduction, BDD-ähnliche Speicherung
- URL: http://spinroot.com/spin/whatispin.html
- aktuelle Version: 6.2.5 (Mai 2013)
- Lizenz: frei für wissenschaftliche Zwecke, ansonsten [SPIN Commercial License](http://www.spinroot.com/spin/spin_license.html)

## Installation

### Alle Betriebssysteme

Die Installation von Spin sollte leicht von der Hand gehen:

    tar xfz spin625.tar.gz 
    cd Spin/Src6.2.5
    make

Es wird dann die ausführbare Datei `spin` erzeugt.

### OS X

Unter OS X kann Spin mit dem Paketmanager [Homebrew](http://brew.sh) installiert werden:

    # install Homebrew
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
    # install Spin
    brew install spin

## Beispiele

### Wechselseitiger Ausschluss

Der wechselseitige Ausschluss ist in der Promela-Datei `mutex.pml` modelliert.

Für jeden Prozess gibt es einen `proctype` mit dem Namen `user`. Dabei enthält die Variable `_pid` die jeweilige Id (hier 0 und 1), über die der Zustand im Array `pc` zugegriffen wird. Das Schlüsselwort `active [2]` besagt, dass zwei Instanzen ausgeführt werden sollen.

Innerhalb des Prozesses wird die jeweilige `pc`-Variable instanziiert und dann in einer Endlosschleife und via guarded commands der Ablauf beschrieben. Dabei wird unter den passenden Einträgen in jedem Durchlauf einer nichtdeterministisch ausgewählt. Der Bereich ist mit `atomic` umgeben, damit keine Zwischenzustände entstehen können.

Der folgende `init`-Block initialisiert globale Variablen. Anschließend können LTL-Formeln definiert werden. Hinter dem Schlüsselwort `ltl` steht dabei der Name der Formel.

Spin überprüft LTL-Formeln, indem zunächst aus dem Modell und der Formel C-Code erzeugt wird.

    $ spin -a mutex.pml
    ltl safety: [] (((pc[0]!=critical)) || ((pc[1]!=critical)))
    ltl liveness: [] ((! ((pc[0]==request))) || (<> ((pc[0]==critical))))
      the model contains 2 never claims: liveness, safety
      only one claim is used in a verification run
      choose which one with ./pan -a -N name (defaults to -N safety)

Die erzeugten Dateien `pan.*` werden dann übersetzt:

    $ make pan
    cc     pan.c   -o pan

Anschließend können die einzelnen Formeln überprüft werden:

    $ ./pan -a safety
    0: Claim safety (2), from state 6
    
    (Spin Version 6.2.5 -- 3 May 2013)
    	+ Partial Order Reduction
    
    Full statespace search for:
    	never claim         	+ (safety)
    	assertion violations	+ (if within scope of claim)
    	acceptance   cycles 	+ (fairness disabled)
    	invalid end states	- (disabled by never claim)
    
    State-vector 44 byte, depth reached 27, errors: 0
           33 states, stored
           40 states, matched
           73 transitions (= stored+matched)
            0 atomic steps
    hash conflicts:         0 (resolved)
    
    Stats on memory usage (in Megabytes):
        0.002	equivalent memory usage for states (stored*(State-vector + overhead))
        0.288	actual memory usage for states
      128.000	memory used for hash table (-w24)
        0.534	memory used for DFS stack (-m10000)
      128.730	total actual memory usage
    
    
    unreached in proctype user
    	mutex.pml:22, state 16, "-end-"
    	(1 of 16 states)
    unreached in init
    	(0 of 2 states)
    unreached in claim safety
    	_spin_nvr.tmp:8, state 10, "-end-"
    	(1 of 10 states)
    unreached in claim liveness
    	_spin_nvr.tmp:17, state 10, "(!((pc[0]==critical)))"
    	_spin_nvr.tmp:19, state 13, "-end-"
    	(2 of 13 states)
    
    pan: elapsed time 0 seconds
