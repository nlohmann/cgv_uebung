# Spin

- Typ: expliziter Modelchecker
- Modell: Guarded Commands ("Promela")
- Formeln: LTL
- weitere Funktionalität: Simulator, GUI
- Reduktionstechniken: Partial Order Reduction, BDD-ähnliche Speicherung
- URL: http://spinroot.com/spin/whatispin.html
- aktuelle Version: 6.2.5 (Mai 2013)

## Installation

### OS X

Unter OS X kann Spin mit dem Paketmanager [Homebrew](http://brew.sh) installiert werden:

    # install Homebrew
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
    # install Spin
    brew install spin
