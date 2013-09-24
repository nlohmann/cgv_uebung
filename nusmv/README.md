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

![Screenshot](https://raw.github.com/nlohmann/cgv_uebung/master/nusmv/screen.png "Screenshot")

## Installation

### Alle Betriebssysteme

Die Installation von NuSMV ist nicht trivial, da es von den Paketen CuDD (für BDDs) und ZChaff (für SAT-Checking) abhängt. Mit folgenden Befehlen funktioniert die Installation beispielhaft für OS X:

    tar xfz NuSMV-2.5.4.tar.gz
    cd NuSMV-2.5.4
    gsed -i 's/O6/O2/g' cudd-2.4.1.1/Makefile_os_x_64bit
    make -C cudd-2.4.1.1 --file=Makefile_os_x_64bit
    cd zchaff ; ./build.sh ; cd ..
    make -C zchaff/zchaff64
    cd nusmv && ./configure --enable-zchaff ; make

Es wird dann die ausführbare Datei `NuSMV` erzeugt.

### OS X

Unter OS X kann NuSMV mit dem Paketmanager [Homebrew](http://brew.sh) installiert werden:

    # install Homebrew
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
    # tap science formulas
    brew tap homebrew/science 
    # install NuSMV
    brew install nusmv

## Beispiele

### Wechselseitiger Ausschluss

Die Datei `mutex.smv` enthält eine Beschreibung des wechselseitigen Ausschlusses zusammen mit mehreren LTL-Formeln.

Die Prozesse werden mit dem Schlüsselwort `process` als asynchrone Prozesse definiert. Da dieses Schlüsselwort veraltet ist (und asynchrone Prozesse in Zukunft nicht mehr unterstützt werden sollen), wird NuSMV beim Start eine Warnung ausgeben. Innerhalb des Prozesses wird das Verhalten in Form einer Zustandsmaschine definiert. Dabei wird ein Anfangszustand (`init`) und die Zustandsübergänge (`next`) angegeben. Die Variable `sem` wird dabei von allen Prozessen geteilt.

Es werden zwei Fairness-Annahmen gemacht:

    FAIRNESS
        running;

Dies legt fest, dass eine implizite lokale Boolesche Variable `running` in jedem Prozess unendlich oft wahr ist. Dies bedeutet, dass kein Prozess einfach stehen bleiben darf. Dies entspricht schwacher Fairness für alle Zustandsübergänge.

Die Angabe

    COMPASSION
        (pc = request, pc = critical);

bedeutet, dass wenn `pc = request` unendlich oft auf fairen Pfaden wahr ist, dann auch `pc = critical`. Dies entspricht starker Fairness für den Übergang in den kritischen Bereich.

Die Formeln im Modell können dann überprüft werden:

    $ NuSMV mutex.smv 
    *** This is NuSMV 2.5.4 (compiled on Tue Sep 24 06:14:15 UTC 2013)
    *** Enabled addons are: compass 
    *** For more information on NuSMV see <http://nusmv.fbk.eu>
    *** or email to <nusmv-users@list.fbk.eu>.
    *** Please report bugs to <nusmv-users@fbk.eu>
    
    *** Copyright (c) 2010, Fondazione Bruno Kessler
    
    *** This version of NuSMV is linked to the CUDD library version 2.4.1
    *** Copyright (c) 1995-2004, Regents of the University of Colorado
    
    WARNING *** This version of NuSMV is linked to the zchaff SAT         ***
    WARNING *** solver (see http://www.princeton.edu/~chaff/zchaff.html). ***
    WARNING *** Zchaff is used in Bounded Model Checking when the         ***
    WARNING *** system variable "sat_solver" is set to "zchaff".          ***
    WARNING *** Notice that zchaff is for non-commercial purposes only.   ***
    WARNING *** NO COMMERCIAL USE OF ZCHAFF IS ALLOWED WITHOUT WRITTEN    ***
    WARNING *** PERMISSION FROM PRINCETON UNIVERSITY.                     ***
    WARNING *** Please contact Sharad Malik (malik@ee.princeton.edu)      ***
    WARNING *** for details.                                              ***
    
    WARNING *** Processes are still supported, but deprecated.      ***
    WARNING *** In the future processes may be no longer supported. ***
    
    WARNING *** The model contains COMPASSION declarations.        ***
    WARNING *** Full fairness is not yet fully supported in NuSMV. ***
    WARNING *** Currently, COMPASSION declarations are only        ***
    WARNING *** supported for BDD-based LTL Model Checking.        ***
    WARNING *** Results of CTL Model Checking and of Bounded       ***
    WARNING *** Model Checking may be wrong.                       ***
    WARNING *** The model contains PROCESSes or ISAs. ***
    WARNING *** The HRC hierarchy will not be usable. ***
    -- specification  G (proc1.pc != critical | proc2.pc != critical)  is true
    -- specification  G (proc1.pc = request ->  F proc1.pc = critical)  is true
    -- specification  G ( F proc1.pc != critical)  is true
    -- specification ( G ( F (proc1.pc = request & sem = 1)) ->  G ( F proc1.pc = critical))  is true
