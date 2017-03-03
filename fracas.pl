
removeInflections((X>_R0):TAG, (X>_R1):TAG) :-
    !.
removeInflections(X, X) :-
    atomic(X),
    !.
removeInflections([H0 | T0], [H1 | T1]) :-
    !,
    removeInflections(H0, H1),
    removeInflections(T0, T1).
removeInflections(X0, X1) :-
    X0 =.. L0,
    removeInflections(L0, L1),
    X1 =.. L1.

xsubtree({_, X}, T) :-
    !,
    xsubtree(X, T).
xsubtree(L, L) :-
    \+ atomic(L).
xsubtree(L, Y) :-
    member(X, L),
    xsubtree(X, Y).

xsubtrees(X, TT) :-
    findall(T, xsubtree(X, T), TT).


sharedSubTrees(X, Y, S) :-
    xsubtrees(X, TTX),
    xsubtrees(Y, TTY),
    findall(K=_, (member(K, TTX), member(K, TTY)), S).

applySharedSubTrees(X0, TT, X1) :-
    member(X0=X1, TT),
    !.
applySharedSubTrees({F, X0}, TT, {F, X1}) :-
    !,
    applySharedSubTrees(X0, TT, X1).
applySharedSubTrees((R0:_)>POS, TT, (R1:_)>POS) :-
    !,
    applySharedSubTrees(R0, TT, R1).
applySharedSubTrees(X, _TT, X) :-
    atomic(X).
applySharedSubTrees([H0 | T0], TT, [H1 | T1]) :-
    !,
    applySharedSubTrees(H0, TT, H1),
    applySharedSubTrees(T0, TT, T1).
applySharedSubTrees(X0, TT, X1) :-
    X0 =.. L0,
    applySharedSubTrees(L0, TT, L1),
    X1 =.. L1.

makeRule(X0, Y0, R) :-
    removeInflections(X0, X1),
    removeInflections(Y0, Y1),
    sharedSubTrees(X1, Y1, S),
    pretty(S),
    applySharedSubTrees(X1 ==> Y1, S, R).

/**
  ([(be : verb),
  {(arg(predication) , A)},
  {(arg(subject) , [every,{arg(headnoun),B}])}]
  ==> [if,
       {(arg(antecedent),
          [(be : verb),
           {(arg(predication) , [a,{arg(headnoun),B}])},
           {(arg(subject) , [X])}])},
       {(arg(consequent),
          [(be : verb),
           {(arg(predication) , A)},
           {(arg(subject) , [X])}])}])
  **/

addGenerics(X, X) :-
    (var(X); atomic(X)),
    !.
addGenerics({arg(T, +), [(N:noun) | D0]},
	    {arg(T, +), [generic, {arg(headnoun, -), [(N:noun) | D1]}]}) :-
    !,
    addGenerics(D0, D1).
addGenerics([H0 | T0], [H1 | T1]) :-
    !,
    addGenerics(H0, H1),
    addGenerics(T0, T1).
addGenerics(X0, X1) :-
    X0 =.. L0,
    addGenerics(L0, L1),
    X1 =.. L1.

qlf(X0, Q+X1) :-
    qlf(X0, [], Q, X1).

qlf(X, Q, Q, X) :-
    (var(X); atomic(X)),
    !.
qlf([D, {arg(headnoun, -), X0}], Q0, [[D, {arg(headnoun(-), X1), V}] | Q1], V) :-
    nonvar(X0),
    !,
    qlf(X0, Q0, Q1, X1).
qlf([H0 | T0], Q0, Q2, [H1 | T1]) :-
    !,
    qlf(H0, Q0, Q1, H1),
    qlf(T0, Q1, Q2, T1).
qlf(X0, Q0, Q1, X1) :-
    X0 =.. L0,
    qlf(L0, Q0, Q1, L1),
    X1 =.. L1.