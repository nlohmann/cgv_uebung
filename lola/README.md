# LoLA

- Typ: expliziter Modelchecker
- Modell: Petrinetze (Platz/Transitionsnetze, algebraische Petrinetze)
- Formeln: CTL, LTL (kein geschachtelten Formeln, nur F, GF, FG)
- weitere Eigenschaften: Deadlocks, Beschränktheit, Reversibilität
- Reduktionstechniken: Partial Order Reduction, Symmetrie, Sweep Line
- URL: http://wwwteo.informatik.uni-rostock.de/tpp/lola/
- aktuelle Version: 1.16 (Juni 2011)
- Lizenz: AGPL

## Installation

### Alle Betriebssysteme

LoLA kann am besten direkt aus den Quellen übersetzt werden:

    tar xfz lola-1.17.tar.gz
    cd lola-1.17
    ./configure
    make all-configs

Es werden dann verschiedene Konfigurationen im Verzeichnis `lola-1.17/src` erzeugt.

### OS X

Unter OS X kann LoLA mit dem Paketmanager [Homebrew](http://brew.sh) installiert werden:

    # install Homebrew
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
    # tap science formulas
    brew tap homebrew/science 
    # install LoLA
    brew install lola

## Beispiele

### Wechselseitiger Ausschluss

Die Datei `mutex.lola` enthält ein Petrinetz, dass das Modell für den wechselseitige Auschluss modelliert. Die Datei `mutex_hl.lola` enthält ein äquivalentes Modell in High-Level-Notation, bei dem die Prozess-Anzahl beliebig eingestellt werden kann.

Zu diesem Netz gibt es verschiedene folgende Formel-Dateien, die mit unterschiedlichen Modi von LoLA ausgewertet werden können:

- `mutex-safety.formula`
  
  Diese CTL-Formel drückt aus, dass nur ein Prozess gleichzeitig im kritischen Zustand sein kann.
  
      $ lola-modelchecking mutex.lola --analysis=mutex-safety.formula
      lola: 7 places
      lola: 8 transitions
      lola: 4 significant places
     
      Formula with 
      4 subformulas
      and 1 temporal operators.
     
      result: true
      lola: >>>>> 6 States, 10 Edges, 6 Hash table entries

- `mutex-liveness.formula`

  Diese CTL-Formel drückt aus, dass jeder Prozess, der den kritischen Zustand betreten will, ihn auch irgendwann betritt.

      $ lola-modelchecking mutex.lola --analysis=mutex-liveness.formula
      lola: 7 places
      lola: 8 transitions
      lola: 4 significant places
    
      Formula with 
      5 subformulas
      and 2 temporal operators.
    
      result: true
      lola: >>>>> 8 States, 22 Edges, 8 Hash table entries

- `mutex-gf.formula`

  Dieses Zustandsprädikat sagt aus dass sich kein Prozess im kritischen Zustand befindet. Wir wollen überprüfen, ob dies unendlich oft gilt, also den LTL-Operator *GF* nutzen:

      $ lola-fairprop mutex_hl.lola --analysis=mutex-gf.formula 
      lola: 7 places
      lola: 8 transitions
      lola: 4 significant places
      lola: Formula with 3 subformula(s) (WITHFORMULA)
      lola: GF phi holds!
      lola: >>>>> 8 States, 20 Edges, 8 Hash table entries
