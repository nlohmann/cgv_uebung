# Spin

- Typ: expliziter Modelchecker
- Modell: Guarded Commands ("Promela")
- Formeln: LTL
- weitere Funktionalität: Simulator, GUI
- Reduktionstechniken: Partial Order Reduction, BDD-ähnliche Speicherung
- URL: http://spinroot.com/spin/whatispin.html
- aktuelle Version: 6.2.5 (Mai 2013)
- Lizenz: frei für wissenschaftliche Zwecke, ansonsten [SPIN Commercial License](http://www.spinroot.com/spin/spin_license.html)

![Screenshot](https://raw.github.com/nlohmann/cgv_uebung/master/Spin/screen.png "Screenshot")

## Installation

Spin kann direkt aus den Quellen übersetzt werden. Allerdings sind ein paar kleine Änderungen an den Quellen notwendig. Das Ergebnis ist dann eine ausführbare Datei `spin` und ein Shellscript `ispin` für die GUI.

### Linux

```bash
tar xfz spin625.tar.gz 
cd Spin/Src6.2.5
sed -i 's/y?/spin./g' makefile
make spin.o YACC=bison
mv spin.tab.h y.tab.h
make
```

### Windows

Unter Windows kann Spin mit [Cygwin](http://www.cygwin.com) installiert werden:

```bash
tar xfz spin625.tar.gz 
cd Spin/Src6.2.5
sed -i 's/y?/spin./g' makefile
make spin.o YACC=bison
mv spin.tab.h y.tab.h
make
```

### Solaris

```bash
tar xfz spin625.tar.gz 
cd Spin/Src6.2.5
gsed -i 's/y?/spin./g' makefile
make spin.o YACC=bison
mv spin.tab.h y.tab.h
make
```

### OS X

Unter OS X kann Spin mit dem Paketmanager [Homebrew](http://brew.sh) installiert werden:

```bash
brew install spin
```

*Alternativ* kann direkt von den Quellen übersetzt werden:

```bash
tar xfz spin625.tar.gz 
cd Spin/Src6.2.5
make
```

## Beispiele

### Wechselseitiger Ausschluss

Der wechselseitige Ausschluss ist in der Promela-Datei [`mutex.pml`](examples/mutex.pml) modelliert.

Für jeden Prozess gibt es einen `proctype` mit dem Namen `user`. Dabei enthält die Variable `_pid` die jeweilige Id (hier 0 und 1), über die der Zustand im Array `pc` zugegriffen wird. Das Schlüsselwort `active [2]` besagt, dass zwei Instanzen ausgeführt werden sollen.

Innerhalb des Prozesses wird die jeweilige `pc`-Variable instanziiert und dann in einer Endlosschleife und via guarded commands der Ablauf beschrieben. Dabei wird unter den passenden Einträgen in jedem Durchlauf einer nichtdeterministisch ausgewählt. Der Bereich ist mit `atomic` umgeben, damit keine Zwischenzustände entstehen können.

Der folgende `init`-Block initialisiert globale Variablen. Anschließend können LTL-Formeln definiert werden. Hinter dem Schlüsselwort `ltl` steht dabei der Name der Formel.

Spin überprüft LTL-Formeln, indem zunächst aus dem Modell und der Formel C-Code erzeugt wird.

    $ spin -a mutex.pml
    ltl safety: [] (((pc[0]!=critical)) || ((pc[1]!=critical)))
    ltl liveness: (! ((! ([] (<> (((pc[0]==request)) && ((sem==1)))))) || ([] (<> ((pc[0]==critical)))))) || ([] ((! ((pc[0]==request))) || (<> ((pc[0]==critical)))))
      the model contains 2 never claims: liveness, safety
      only one claim is used in a verification run
      choose which one with ./pan -a -N name (defaults to -N safety)

Die erzeugten Dateien `pan.*` werden dann übersetzt:

    $ make pan
    cc     pan.c   -o pan

Anschließend können die einzelnen Formeln überprüft werden:

    $ ./pan -a -N safety
    
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
        0.282	actual memory usage for states
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
    
    pan: elapsed time 0 seconds

Für die Liveness-Eigenschaft muss weiterhin noch der Parameter `-f` übergeben werden, dass Fairness angenommen wird. **Achtung**: Es handelt sich dabei nur um schwache Fairness. Starke Fairness wird von Spin nicht direkt unterstützt und ist in der Eigenschaft (Prämisse der Implikation) codiert.

    $ ./pan -a -N liveness -f
    
    (Spin Version 6.2.5 -- 3 May 2013)
    	+ Partial Order Reduction
        
    Full statespace search for:
    	never claim         	+ (liveness)
    	assertion violations	+ (if within scope of claim)
    	acceptance   cycles 	+ (fairness enabled)
    	invalid end states	- (disabled by never claim)
        
    State-vector 44 byte, depth reached 29, errors: 0
          126 states, stored
          225 states, matched
          351 transitions (= stored+matched)
            0 atomic steps
    hash conflicts:         0 (resolved)
    
    Stats on memory usage (in Megabytes):
        0.009	equivalent memory usage for states (stored*(State-vector + overhead))
        0.282	actual memory usage for states
      128.000	memory used for hash table (-w24)
        0.534	memory used for DFS stack (-m10000)
      128.730	total actual memory usage
      
      
    unreached in proctype user
    	mutex.pml:22, state 16, "-end-"
    	(1 of 16 states)
    unreached in init
    	(0 of 2 states)
    unreached in claim liveness
    	_spin_nvr.tmp:49, state 58, "-end-"
    	(1 of 58 states)
        
    pan: elapsed time 0 seconds

Falls der Parameter `-f` weggelassen wird, erzeugt Spin ein Gegenbeispiel in der Datei `mutex.pml.trail`, das sich wie folgt angesehen werden kann:

    $ spin -t mutex.pml
    
    ltl safety: [] (((pc[0]!=critical)) || ((pc[1]!=critical)))
    ltl liveness: (! ((! ([] (<> (((pc[0]==request)) && ((sem==1)))))) || ([] (<> ((
    Never claim moves to line 16	[(!(((pc[0]==request)&&(sem==1))))]
    Never claim moves to line 35	[(!(((pc[0]==request)&&(sem==1))))]
    Never claim moves to line 34	[(((!(!((pc[0]==request)))&&!(((pc[0]==request)&
      <<<<<START OF CYCLE>>>>>
    Never claim moves to line 21	[((!(((pc[0]==request)&&(sem==1)))&&!((pc[0]==cr
    spin: trail ends after 10 steps
    #processes: 3
    		pc[0] = request
    		pc[1] = idle
    		sem = 0
     10:	proc  2 (:init:) mutex.pml:25 (state 1)
     10:	proc  1 (user) mutex.pml:9 (state 14)
     10:	proc  0 (user) mutex.pml:9 (state 14)
     10:	proc  - (liveness) _spin_nvr.tmp:20 (state 18)
    3 processes created

Alternativ zur Konsole kann auch das Werkzeug `ispin` genutzt werden, das über eine GUI die Funktionalität von Spin (incl. Simulator) anbietet.
