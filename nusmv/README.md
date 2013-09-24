# NuSMV

- Typ: symbolischer Modelchecker
- Modell: Finite State Machine
- Formeln: CTL, LTL
- weitere Eigenschaften: LTL mit Past-Operatoren ("once", "historically", "since", "yesterday"), Real Time CTL
- Reduktionstechniken: BDDs, SAT (Bounded Model Checking für LTL)
- weitere Funktionalität: Simulator
- URL: http://nusmv.fbk.eu
- aktuelle Version: 2.5.4 (Oktober 2011)
- Lizenz: [GNU Lesser General Public License (LGPL)](https://www.gnu.org/licenses/lgpl.html)

## Installation

### OS X

Unter OS X kann NuSMV mit dem Paketmanager [Homebrew](http://brew.sh) installiert werden:

    # install Homebrew
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
    # tap science formulas
    brew tap homebrew/science 
    # install NuSMV
    brew install nusmv
