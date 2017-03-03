
disjoinGoal(G, Y) :-
    arg(1, G, A),
    findall(X, (G, X=A), L),
    disjoin(L, Y).

disjoin([X], X) :-
    !.
disjoin(TERMS0, T1) :-
    sharedElements(TERMS0, T0),
    getAllBindings(TERMS0, T0, BINDINGS0),
    remove_#(T0, T1),
    getTriggers(T0, []/TRIGGERS0),
    mergeAllMultiVars(BINDINGS0, IDENTITIES),
    rows2cols(BINDINGS0, BCOLS0),
    removeDummyTriggers(BCOLS0, TRIGGERS0, TRIGGERS1),
    potentialTriggers(BINDINGS0, TRIGGERS1),
    realTriggers(TRIGGERS1, TRIGGERS2),
    addIdentities(IDENTITIES, TRIGGERS2, TRIGGERS3),
    (untriggered(TRIGGERS3, [T | TRIGGERS4]) ->
     (bindings2conjuncts(BINDINGS0, BINDINGS2),
      list2disjuncts(BINDINGS2, BINDINGSN),list2disjuncts([T | TRIGGERS4], TRIGGERSN),
      when(TRIGGERSN, BINDINGSN));
     true).

untriggered([], []).
untriggered([T | TRIGGERS0], [T | TRIGGERS1]) :-
    untriggered(T),
    !,
    untriggered(TRIGGERS0, TRIGGERS1).
untriggered([_T | TRIGGERS0], TRIGGERS1) :-
    untriggered(TRIGGERS0, TRIGGERS1).

untriggered((A, B)) :-
    !,
    (untriggered(A); untriggered(B)).
untriggered(nonvar(A)) :-
    var(A).

/**
  We've got a list of things: we want to find bits that
  are potentially mergeable, which means they are either
  identical or they have the same functor and no. of args,
  in which case we want to find the arguments that are
  the same. So

  | ?- sharedElements([g(a(c)), g(a(b))], X).
  X = g(a(_A)) ? 
  yes
  | ?- sharedElements([g(a(c)), g(a(b)), g(p)], X).
  X = g(_A) ? 
  
  **/
sharedElements(L, X) :-
    allSame(L, X),
    !.
sharedElements(L0, X) :-
    sameShape(L0, F, N),
    !,
    shareChildren(L0, 1, N, ARGS),
    X =.. [F | ARGS].
sharedElements(_, #(_)).

allSame([X], X).
allSame([H | T], X) :-
    allSame(T, X),
    H == X.

sameShape([], _F, _N).
sameShape([H | T], F, N) :-
    nonvar(H),
    functor(H, F, N),
    sameShape(T, F, N).

shareChildren(_L, J, N, []) :-
    J is N+1,
    !.
shareChildren(L, I, N, [H1 | T]) :-
    findall(D, (member(X, L), arg(I, X, D)), H0),
    (allSame(H0, H1) ->
     true;
     sharedElements(H0, H1)),
    J is I+1,
    shareChildren(L, J, N, T).

/**
  
  We've got a term and skeleton (from sharedElements)

  Go through the term, and where you hit a variable in
  the skeleton, make a binding for that against the element
  from the term
  
  | ?- sharedElements([g(a(c)), g(a(b))], X), getBindings(X, g(a(c)), []/B).
  B = [_A=c],
  X = g(a(_A)) ? 
  yes

  **/
getBindings(#(V), U, B/[V=U | B]):-
    var(V),
    !.
getBindings(_T, U, B/B) :-
    (var(U); atomic(U)),
    !.
getBindings([H0 | T0], [H1 | T1], B0/B2) :-
    !,
    getBindings(H0, H1, B0/B1),
    getBindings(T0, T1, B1/B2).
getBindings(X0, X1, B0/B1) :-
    X0 =.. [F | A0],
    X1 =.. [F | A1],
    getBindings(A0, A1, B0/B1).

/**
  OK, do that for all your terms
  
  | ?- L = [g(a(c)), g(a(b))], sharedElements(L, X), getAllBindings(L, X, B).
  B = [[_A=c],[_A=b]],
  L = [g(a(c)),g(a(b))],
  X = g(a(_A)) ? 
  **/

getAllBindings([], _SHARED, []).
getAllBindings([H | T], SHARED, [B | BB]) :-
    getBindings(SHARED, H, []/B),
    getAllBindings(T, SHARED, BB).

remove_#(V, V) :-
    (atomic(V); var(V)),
    !.
remove_#(#(V), V) :-
    !.
remove_#([H0 | T0], [H1 | T1]) :-
    !,
    remove_#(H0, H1),
    remove_#(T0, T1).
remove_#(X0, X1) :-
    !,
    X0 =.. [F | A0],
    remove_#(A0, A1),
    X1 =.. [F | A1].

/**
  Get all the variables on the left-hand sides of the
  bindings. These are the things where we will have to
  check a disjunction once they are bound
  **/
getTriggers(U, TRIGGERS/TRIGGERS) :-
    (var(U); atomic(U)),
    !.
getTriggers(#(T0), TRIGGERS/[nonvar(T0) | TRIGGERS]) :-
    !.
getTriggers([H0 | T0], TRIGGERS0/TRIGGERS2) :-
    !,
    getTriggers(H0, TRIGGERS0/TRIGGERS1),
    getTriggers(T0,TRIGGERS1/TRIGGERS2).
getTriggers(X0, TRIGGERS0/TRIGGERS1) :-
    X0 =.. [_F | A0],
    getTriggers(A0, TRIGGERS0/TRIGGERS1).

/**
  A variable can occur on the RIGHT hand sides of two
  equations. If that happens, we have to be ready to unify
  the left-hand sides when EITHER of them is bound
  **/

mergeAllMultiVars([], []).
mergeAllMultiVars([H0 | T0], [H1 | T1]) :-
    mergeMultiVars(H0, H1),
    mergeAllMultiVars(T0, T1).

mergeMultiVars([], []).
mergeMultiVars([X=Y | B0], [wh(WH) | BN]) :-
    OTHERS = [_ | _],
    getOthers(Y, B0, OTHERS, B1),
    !,
    WH = [X | OTHERS],
    mergeMultiVars(B1, BN).
mergeMultiVars([_H | T0], T1) :-
    mergeMultiVars(T0, T1).

getOthers(_Y, [], [], []).
getOthers(Y, [K=V | T0], [K | OTHERS], T1) :-
    V == Y,
    !,
    getOthers(Y, T0, OTHERS, T1).
getOthers(Y, [H | T0], OTHERS, [H | T1]) :-
    getOthers(Y, T0, OTHERS, T1).

/**

  We had N terms, we identified K places where they weren't
  identical: so we have N list, each with K equations.

  But for some purposes (see later) we want K lists, each
  with N equations (all N having the same left-hand side)

  This sometimes goes wrong, for reasons which I have yet to
  understand.
  
  **/
rows2cols([[] | _], []) :-
    !.
rows2cols(ROWS0, [C | COLS]) :-
    rows2col(ROWS0, ROWS1, C),
    rows2cols(ROWS1, COLS).

rows2col([], [], []) :-
    !.
rows2col([ROW0 | ROWS0], [ROW1 | ROWS1], [C | CC]) :-
    removeHd(ROW0, C, ROW1),
    !,
    rows2col(ROWS0, ROWS1, CC).
rows2col(X, Y, _) :-
    pretty(rows2col(X, Y, _)),
    nl,
    throw('rows2col failed').

removeHd([H | T], H, T).

removeDummyTriggers([], [], []).
removeDummyTriggers([B | BINDINGS0], [_T | TRIGGERS0], [dummy | TRIGGERS1]) :-
    allFree(B),
    !,
    removeDummyTriggers(BINDINGS0, TRIGGERS0, TRIGGERS1).
removeDummyTriggers([_B | BINDINGS0], [T | TRIGGERS0], [T | TRIGGERS1]) :-
    removeDummyTriggers(BINDINGS0, TRIGGERS0, TRIGGERS1).

allFree([]).
allFree([_V=X | T]) :-
    free(X),
    allFree(T).

free(V) :-
    var(V),
    frozen(V, true).

potentialTriggers([], _TRIGGERS).
potentialTriggers([H0 | T0], TRIGGERS) :-
    addTrigger(H0, TRIGGERS),
    potentialTriggers(T0, TRIGGERS).

addTrigger([], []).
addTrigger([_ | T0], [dummy | T1]) :-
    !,
    addTrigger(T0, T1).
addTrigger([V=_ | T0], [nonvar(V) | T1]) :-
    addTrigger(T0, T1).

realTriggers([], []).
realTriggers([nonvar(X) | T0], [nonvar(X) | T1]) :-
    !,
    realTriggers(T0, T1).
realTriggers([_ | T0], T1) :-
    realTriggers(T0, T1).

bindings2conjuncts([B0], [B1]) :-
    !,
    list2conjuncts(B0, B1).
bindings2conjuncts([B0 | T0], [B1 | T1]) :-
    list2conjuncts(B0, B1),
    bindings2conjuncts(T0, T1).

boundVars(V, BOUND/[V | BOUND]) :-
    var(V),
    !.
boundVars(X, BOUND0/BOUND1) :-
    functor(X, _F, N),
    boundVars(X, 0, N, BOUND0/BOUND1).

boundVars(_X, N, N, BOUND/BOUND) :-
    !.
boundVars(X, I, N, BOUND0/BOUND2) :-
    J is I+1,
    arg(J, X, A),
    boundVars(A, BOUND0/BOUND1),
    boundVars(X, J, N, BOUND1/BOUND2).

applyAllFreeBindings([], [], _BOUND).
applyAllFreeBindings([H0 | T0], [H1 | T1], BOUND) :-
    applyFreeBindings(H0, H1, BOUND),
    applyAllFreeBindings(T0, T1, BOUND).

applyFreeBindings([], [], _BOUND).
applyFreeBindings([X=Y | B0], B1, BOUND) :-
    (var(Y) -> frozen(Y, true); true),
    (var(X) -> frozen(X, true); true),
    \+ imember(X, BOUND),
    \+ imember(Y, BOUND),
    !,
    X = Y,
    applyFreeBindings(B0, B1, BOUND).
applyFreeBindings([H | T0], [H | T1], BOUND) :-
    applyFreeBindings(T0, T1, BOUND).

addIdentities([], TRIGGERS, TRIGGERS).
addIdentities([H | T], TRIGGERS0, TRIGGERS2) :-
    addIdentities(H, TRIGGERS0, TRIGGERS1),
    addIdentities(T, TRIGGERS1, TRIGGERS2).
addIdentities(wh(L), TRIGGERS, [WH | TRIGGERS]) :-
    ((member(V, L), \+ free(V)) ->
     true;
     plantIdentityTrigger(L, WH)).

plantIdentityTrigger([X], nonvar(X)) :-
    !.
plantIdentityTrigger([H | T], (nonvar(H), WH)) :-
    plantIdentityTrigger(T, WH).

plantEqualities([X, Y], X=Y) :-
    !.
plantEqualities([X, Y | Z], (X=Y, EQ)) :-
    plantEqualities([Y | Z], EQ).
    
    
    
    
