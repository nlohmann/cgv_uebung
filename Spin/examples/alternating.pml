mtype = {l, NC, CR};
mtype pc[2];
bool turn;

proctype user(int id) {
    pc[id] = l;

again:
    atomic {
        if
        :: pc[id] == l
            -> pc[id] = NC;
        :: pc[id] == NC && turn == id
            -> turn = id; pc[id] = CR;
        :: pc[id] == CR
            -> turn = 1 - id; pc[id] = l;
        fi;
    }
    goto again;
}

init {
    turn = 0;
    run user(0);
    run user(1);
}

ltl safety {
    [] (pc[0] != CR || pc[1] != CR)
}
