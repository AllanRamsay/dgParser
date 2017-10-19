createTerm(X, EQS, M) :-
    create_mutable({X, EQS}, M).

matchTerms(M1, M2, EQS) :-
    update(M1, X1, EQS),
    update(M2, X2, EQS),
    X1 = X2.


add(X, [X | _]) :-
    !.
add(X, [_ | T]) :-
    add(X, T).

makeEqsTable(EQS0, EQSN, MAXARITY) :-
    functor(EQSN, eqs, MAXARITY),
    splitEqsByArity(EQS0, EQSN).

makeEqsTable(EQS0, EQSN) :-
    makeEqsTable(EQS0, EQSN, 5).

splitEqsByArity([], _EQS).
splitEqsByArity([X=Y | T], EQS) :-
    (X @< Y ->
     (Y1 = X, X1 = Y);
     (Y1 = Y, X1 = X)),
    functor(X1, F, I),
    functor(XD, F, I),
    J is I+1,
    arg(J, EQS, L),
    (member([XD | FL], L) ->
     true;
     add([XD | FL], L)),
    (add(X1=Y1, FL) -> true; fail),
    splitEqsByArity(T, EQS).

applyEqs(T0, EQS, TN) :-
    functor(T0, F, I),
    (I = 0 ->
     T1 = T0;
     (T0 =.. [F | L0],
      applyEqsL(L0, EQS, L1),
      T1 =.. [F | L1])),
    J is I+1,
    arg(J, EQS, SUBEQS),
    functor(TD, F, I),
    ((member([TD | SUBSUBEQS], SUBEQS), member(T1=TN, SUBSUBEQS)) ->
     true;
     TN = T1).

applyEqsL([], _EQS, []).
applyEqsL([H0 | T0], EQS, [H1 | T1]) :-
    applyEqs(H0, EQS, H1),
    applyEqsL(T0, EQS, T1).

addEq(EQTABLE0, A0=B0, EQTABLEN) :-
    (A0 @< B0 ->
     (A1 = A0, B1 = B0);
     (A1 = B0, B1 = A0)),
    EQTABLE0 =.. [eqs | L0],
    makeEqsTable([B1=A1], NEWEQS),
    pretty(L0),
    addEq1(L0, NEWEQS, L1),
    EQTABLEN =.. [eqs | L1].

addEq1([], _E, []).
addEq1([H0 | T0], EQS, [H1 | T1]) :-
    addEq2(H0, EQS, H1),
    addEq1(T0, EQS, T1).

addEq2(V0, _EQS, _V1) :-
    var(V0),
    !.
addEq2([[D | H0] | T0], EQS, [[D | H1] | T1]) :-
    addEq3(H0, EQS, H1),
    addEq1(T0, EQS, T1).

addEq3([], _EQS, []).
addEq3([A0=B0 | T0], EQS, [X=Y | T1]) :-
    applyEqs(A0, EQS, A1),
    applyEqs(B0, EQS, B1),
    (A1 @< B1 ->
     (X = B1, Y = A1);
     (X = A1, Y = B1)),
    addEq3(T0, EQS, T1).

    