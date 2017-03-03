swap(+, -).
swap(-, +).

qff(A0, A1) :-
    qff(A0, A1, [], +).

qff(A0 & B0, A1 & B1, S, P) :-
    !,
    qff(A0, A1, S, P),
    qff(B0, B1, S, P).
qff(A0 or B0, A1 or B1, S, P) :-
    !,
    qff(A0, A1, S, P),
    qff(B0, B1, S, P).
qff(not(A0), QFF, S, P) :-
    !,
    qff(A0 => absurd, QFF, S, P).
qff(forall(X, A0), A1, S, +) :-
    !,
    qff(A0, A1, [X | S], +).
qff(exists(X, A0), A1, S, +) :-
    !,
    gensym(sk, SK),
    X = [SK | S],
    qff(A0, A1, S, +).
qff(exists(X, A0), A1, S, -) :-
    !,
    qff(A0, A1, [X | S], -).
qff(forall(X, A0), A1, S, -) :-
    !,
    gensym(sk, SK),
    X = [SK | S],
    qff(A0, A1, S, -).
qff(A0 => B0, A1 => B1, S, P0) :-
    !,
    swap(P0, P1),
    qff(A0, A1, S, P1),
    qff(B0, B1, S, P0).
qff(A, A, _, _).