%%hypernym relations
%%:- ensure_loaded([hypstable]).
hyp('v','love','like').
hyp('n','man','human').

%% Parser
:- ensure_loaded([setup]).
%% setup(allwords).
%%setup(englishopen).

%%Matching two variables
match(V,V):-
    !.
%%Matching atoms
match(A0,A1):-
    atom(A0),
    !,
    hyp(_,A0,A1).
%%Numbers

match([H1|T1],[H2|T2]):-
    match(H1,H2),
    !,
    match(T1,T2).
%%skipping over random words form the first list

match([_H1|T1],L2):-
    !,
    match(T1,L2).
%%Trees
match(DT0,DT1):-
    DT0=..L0,
    DT1=..L1,
    match(L0,L1).

addVars(X0, X1) :-
    addVars(X0, X1, [], _V).

addVars(V, V, VARS, VARS) :-
    var(V),
    !.
addVars(N0, N1, VARS0, VARS1) :-
    atom(N0),
    atom_chars(N0, [C]),
    C > 65,
    C < 91,
    \+ C = 73,
    !,
    (member(N0=N1, VARS0) ->
     VARS1 = VARS0;
     VARS1 = [N0=N1 | VARS0]).
addVars(X, X, VARS, VARS) :-
    atomic(X),
    !.
addVars([H0 | T0], [H1 | T1], VARS0, VARS2) :-
    !,
    addVars(H0, H1, VARS0, VARS1),
    addVars(T0, T1, VARS1, VARS2).
addVars(X0, X1, VARS0, VARS1) :-
    X0 =.. ARGS0,
    addVars(ARGS0, ARGS1, VARS0, VARS1),
    X1 =.. ARGS1.