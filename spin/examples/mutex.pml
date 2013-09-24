mtype = {idle, request, critical};
mtype pc[2];
int sem;

active [2] proctype user() {
    pc[_pid] = idle;

again:
    atomic {
        if
        :: pc[_pid] == idle
            -> pc[_pid] = idle;
        :: pc[_pid] == idle
            -> pc[_pid] = request;
        :: pc[_pid] == request && sem == 1
            -> sem = 0; pc[_pid] = critical;
        :: pc[_pid] == critical
            -> sem = 1; pc[_pid] = idle;
        fi;
    }
    goto again;
}

init {
    sem = 1;
}

ltl safety {
    [] (pc[0] != critical || pc[1] != critical)
}

ltl liveness {
    [] ((pc[0] == request) -> (<> (pc[0] == critical)))
}
