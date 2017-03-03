
merge(X, Y, X, true) :-
    X == Y,
    !.
merge(X, Y, Z, when(WH, (AZ1 = AX1; AZ1 = AY1))) :-
    nonvar(X),
    nonvar(Y),
    functor(X, F, N),
    functor(Y, F, N),
    !,
    X =.. [F | AX0],
    Y =.. [F | AY0],
    functor(Z, F, N),
    Z =.. [F | AZ0],
    mergeArgs({AX0, AY0, AZ0}, {AX1, AY1, AZ1}, WH).
merge(X, Y, Z, when(nonvar(Z), (Z = X; Z=Y))).

merge(X, Y, Z) :-
    merge(X, Y, Z, when(C0, WH)),
    fixConditions(C0, C1),
    when(C1, WH).

fixConditions([X], X) :-
    !.
fixConditions([H | T0], (H; T1)) :-
    fixConditions(T0, T1).

mergeArgs({[], [], []}, {[], [], []}, []).
mergeArgs({[H0 | T0], [H1 | T1], [H1 | T]}, K, WH) :-
    H0 == H1,
    !,
    mergeArgs({T0, T1, T}, K, WH).
mergeArgs({[H0 | T0], [H1 | T1], [H | T]}, {[H0 | V0], [H1 | V1], [H | V]}, [nonvar(H) | WH]) :-
    mergeArgs({T0, T1, T}, {V0, V1, V}, WH).

mergeAll([X, Y], Z) :-
    !,
    merge(X, Y, Z).
mergeAll([H | T], Y) :-
    mergeAll(T, X1),
    merge(H, X1, Y).

