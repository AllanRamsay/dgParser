
compare(X, X) :-
    !.
compare(A0, A1) :-
    (atomic(A0); atomic(A1)),
    !,
    pretty(compare(A0, A1)).
compare([H0 | T0], [H1 | T1]) :-
    !,
    compare(H0, H1),
    compare(T0, T1).
compare(X0, X1) :-
    functor(X0, F, N),
    functor(X1, F, N),
    !,
    X0 =.. [F | A0],
    X1 =.. [F | A1],
    compare(A0, A1).
compare(X0 X1) :-
    pretty(compare(X0, X1)).

compareEdges(index@X, index@Y) :-
    call(X),
    call(Y),
    compare(X, Y).
    