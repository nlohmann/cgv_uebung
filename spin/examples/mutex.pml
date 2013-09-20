mtype = {idle, request, critical};
mtype pc[2];
int sem;

proctype user(int id) {
    pc[id] = idle;

    atomic {
        do
        :: pc[id] == idle
            -> pc[id] = idle; break;
        :: pc[id] == idle
            -> pc[id] = request; break;
        :: pc[id] == request && sem == 1
            -> sem = 0; pc[id] = critical; break;
        :: pc[id] == critical
            -> sem = 1; pc[id] = idle; break;
        od
    }
}

init {
    sem = 1;
    atomic {
        run user(0);
        run user(1);
    }
}
