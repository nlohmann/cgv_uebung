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

LoLA kann am besten direkt aus den Quellen übersetzt werden:

    tar xfz lola-1.17.tar.gz
    cd lola-1.17
    ./configure
    make all-configs

Es werden dann verschiedene Konfigurationen im Verzeichnis `lola-1.17/src` erzeugt.

