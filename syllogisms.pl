addToItems(X, I0/I1, S0/S1) :-
    (member(X=_V0, S0) ->
     (S1 = S0, I1 = I0);
     member(X, I0) ->
     (S1 = [X=_V1 | S0], I1 = I0);
     (I1 = [X | I0], S1 = S0)).

sharedItems(X, ITEMS/ITEMS, SHARED/SHARED) :-
    (atomic(X); var(X)),
    !.
sharedItems(WORD>_AFFIXES, ITEMS, SHARED) :-
    nonvar(WORD),
    !,
    addToItems(WORD, ITEMS, SHARED).
sharedItems(WORD:'NP', ITEMS, SHARED) :-
    nonvar(WORD),
    !,
    addToItems(WORD, ITEMS, SHARED).
sharedItems([H | T], ITEMS0/ITEMS2, SHARED0/SHARED2) :-
    !,
    sharedItems(H, ITEMS0/ITEMS1, SHARED0/SHARED1),
    sharedItems(T, ITEMS1/ITEMS2, SHARED1/SHARED2).
sharedItems(X, I0/I2, S0/S2) :-
    X =.. L,
    addToItems(X, I0/I1, S0/S1),
    sharedItems(L, I1/I2, S1/S2).

shareItems(X, V, SHARED) :-
    member(X=V, SHARED),
    !.
shareItems(X, X, _SHARED) :-
    (atomic(X); var(X)),
    !.
shareItems(WORD>_AFFIXES, V, SHARED) :-
    nonvar(WORD),
    member(WORD=V, SHARED),
    !.
shareItems(WORD:'NP', V, SHARED) :-
    nonvar(WORD),
    member(WORD=V, SHARED),
    !.
shareItems([H0 | T0], [H1 | T1], SHARED) :-
    !,
    shareItems(H0, H1, SHARED),
    shareItems(T0, T1, SHARED).
shareItems(X0, X1, SHARED) :-
    X0 =.. L0,
    shareItems(L0, L1, SHARED),
    X1 =.. L1.

shareItems(X0, X1) :-
    sharedItems(X0, []/_ITEMS, []/SHARED),
    shareItems(X0, X1, SHARED).

