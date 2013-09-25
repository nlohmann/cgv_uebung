# Tapaal

- Typ: expliziter Modelchecker
- Modell: Zeitpetrinetze (Timed-Arc Petri Nets)
- Formeln: CTL (keine geschachtelten Formeln, nur EF, EG, AF, AG)
- weitere Eigenschaften: k-Beschränktkeit
- Reduktionstechniken: Symmetrie
- weitere Funktionalität: Grafisches Modelleriungs- und Simulationswerkzeug
- URL: http://www.tapaal.net
- aktuelle Version: 2.4.0 (September 2013)
- Lizenz: [Open Source License 3.0](http://www.opensource.org/licenses/osl-3.0.php) (GUI), [BSD License](http://www.opensource.org/licenses/bsd-license.php) (Übersetzung von TAPN in UPPAAL), [GPL v2](http://www.gnu.org/licenses/gpl-2.0.txt) (Verfikation)

![Screenshot](https://raw.github.com/nlohmann/cgv_uebung/master/Tapaal/screen.png "Screenshot")

## Installation

### Alle Betriebssysteme

Für Linux, OS X und Windows sind ausführbare Dateien vorhanden.

## Beispiele

### Wechselseitiger Ausschluss

Die Datei [`Mutex.xml`](examples/Mutex.xml) enthält das Beispiel für den wechselseitigen Ausschluss, sowie eine Formel für die Safety-Eigenschaft. Die Datei ist XML und daher nicht menschenlesbar -- sie sollte mit Tapaal geöffnet und angesehen werden.
