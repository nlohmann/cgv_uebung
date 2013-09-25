# LoLA

- Typ: expliziter Modelchecker
- Modell: Petrinetze (Platz/Transitionsnetze, algebraische Petrinetze)
- Formeln: CTL, LTL (kein geschachtelten Formeln, nur F, GF, FG)
- weitere Eigenschaften: Deadlocks, Beschränktheit, Reversibilität
- Reduktionstechniken: Partial Order Reduction, Symmetrie, Sweep Line
- URL: http://wwwteo.informatik.uni-rostock.de/tpp/lola/
- aktuelle Version: 1.17 (September 2013)
- Lizenz: [GNU Affero GPL](http://www.gnu.org/licenses/agpl-3.0.html)

![Screenshot](https://raw.github.com/nlohmann/cgv_uebung/master/LoLA/screen.png "Screenshot")

## Installation

### Alle Betriebssysteme

LoLA kann direkt aus den Quellen übersetzt werden:

```bash
tar xfz lola-1.17.tar.gz
cd lola-1.17
./configure
make all-configs
```

Es werden dann verschiedene Konfigurationen im Verzeichnis `lola-1.17/src` erzeugt.

### OS X

Unter OS X kann LoLA mit dem Paketmanager [Homebrew](http://brew.sh) installiert werden:

```bash
brew tap homebrew/science 
brew install lola
```

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
  
  Statt der Forderung, dass einer der Prozesse nicht im kritischen Zustand ist, hätte auch überprüft werden können, ob es einen Zustand gibt, in dem beide Prozesse im kritischen Bereich sind.

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
  
  Wegen eines kleinen Bugs in der Formelsprache kann die Originalformel nicht mit einer Implikation ausgedrückt werden. Stattdessen wurde sie mit einer Disjunktion ausgedrückt.

- `mutex-gf.formula`

  Dieses Zustandsprädikat sagt aus dass sich kein Prozess im kritischen Zustand befindet. Wir wollen überprüfen, ob dies unendlich oft gilt, also den LTL-Operator GF nutzen:

        $ lola-fairprop mutex_hl.lola --analysis=mutex-gf.formula 
        lola: 7 places
        lola: 8 transitions
        lola: 4 significant places
        lola: Formula with 3 subformula(s) (WITHFORMULA)
        lola: GF phi holds!
        lola: >>>>> 8 States, 20 Edges, 8 Hash table entries
  
  Der LTL-GF-Operator ist also fest im Aufruf `lola-fairprop` verdrahtet und muss nicht in der Formeldatei als `ALWAYS EVENTUALLY` angegeben werden. Für die Überprüfung sind die Fairness-Angaben in der Netzdatei wichtig, da ohne sie evtl. "unfaire" Gegenbeispiele gefunden werden.
