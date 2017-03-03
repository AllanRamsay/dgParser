
/*
	FEATURES.PL
	
	Basic stuff for feature handling
*/

:- assert1(recompiling).

removeDummyTrues(V, V) :-
    var(V),
    !.
removeDummyTrues((TRUE, A0), A1) :-
    TRUE == true,
    !,
    removeDummyTrues(A0, A1).
removeDummyTrues((A0, TRUE), A1) :-
    TRUE == true,
    !,
    removeDummyTrues(A0, A1).
removeDummyTrues(((A, B), C), R) :-
    !,
    removeDummyTrues((A, (B, C)), R).
removeDummyTrues((A, B0), R) :-
    !,
    removeDummyTrues(B0, B1),
    (B1 == true -> R = A; R = (A, B1)).
removeDummyTrues(R, R).

except(MSG, ARGS) :-
    with_output_to_atom(format(MSG, ARGS), EXCEPT),
    throw(EXCEPT).

_X <> [] :-
    !.
X <> [H | T] :-
    !,
    X <> H,
    X <> T.
X <> O :-
    O =.. [K, F],
    member(K, [+, -]),
    !,
    X <> (F=K).
X <> (F=K) :-
    !,
    %% NOT extractFeatures(F@X, K, _), because second argument must be a variable
    extractFeatures(F@X, V, _),
    V = K.
X <> F :-
    extractFeatures(X, Y, true),
    (belongsTo(Y, F) ->
     true;
     except('~w could not be executed~n', [X <> F])).

belongsTo(_X, []) :-
    !.
belongsTo(X, [H | T]) :-
    !,
    belongsTo(X, H),
    belongsTo(X, T).
belongsTo(X, F0) :-
    F0 =.. [P | A],
    F1 =.. [P, X | A],
    call_residue(F1, R),
    refreeze(R).

refreeze([]).
refreeze([_-prolog:when(_A, B, C) | F]) :-
    !,
    when(B, C),
    refreeze(F).
refreeze([_ | F]) :-
    !,
    refreeze(F).

X -- X.

F :: L :-
    shareFeatures(F, L, _I).

repeatedVars(X, R) :-
    repeatedVars(X, [], _L, [], R).

repeatedVars(V, V0, V1, R0, R1) :-
    var(V),
    !,
    (imember(V, V0) ->
	(V1 = V0,
	    (imember(V, R0) ->
		R1 = R0; R1 = [V | R0]));
	(V1 = [V | V0],
	    R1 = R0)).
repeatedVars(A, V, V, R, R) :-
    atomic(A),
    !.
repeatedVars([H | T], V0, V2, R0, R2) :-
    !,
    repeatedVars(H, V0, V1, R0, R1),
    repeatedVars(T, V1, V2, R1, R2).
repeatedVars(X, V0, V1, R0, R1) :-
    X =.. [_F | ARGS],
    repeatedVars(ARGS, V0, V1, R0, R1).

removeFreeVars(X0, X1) :-
    repeatedVars(X0, [], _V, [], R),
    removeFreeVars(X0, R, X1).

removeFreeVars(X, _RVARS, X) :-
    (var(X); atomic(X)),
    !.
removeFreeVars(_P=V, RVARS, _X) :-
    var(V),
    \+ imember(V, RVARS),
    !.
removeFreeVars([H0 | T0], RVARS, L) :-
    !,
    removeFreeVars(H0, RVARS, H1),
    removeFreeVars(T0, RVARS, T1),
    ((var(H1), \+ imember(H1, RVARS)) ->
	L = T1;
	L = [H1 | T1]).
removeFreeVars(X0, RVARS, X1) :-
    X0 =.. [F | ARGS0],
    removeFreeVars(ARGS0, RVARS, ARGS1),
    (ARGS1 = [] -> true; X1 =.. [F | ARGS1]).

contains(F=V0, L0, L1) :-
    nonvar(L0),
    member(X, L0),
    nonvar(X),
    X = (F=V0),
    justX(F=V0, L0, L1),
    !.
contains(F=V, L0, L1) :-
    nonvar(L0),
    member(FX=X0, L0),
    nonvar(X0),
    contains(F=V, X0, X1),
    justX(FX=X1, L0, L1).

justX(X=V0, [H=_V0 | T0], [X=V0 | T1]) :-
    nonvar(H),
    H = X,
    !,
    justX(X=V0, T0, T1).
justX(X, [_H0 | T0], [_H1 | T1]) :-
    justX(X, T0, T1).
justX(_, [], []).

makeSign(X, Y) :-
    (var(X); atomic(X)),
    !,
    X = Y.
makeSign(X=L0, S) :-
    !,
    (var(L0) ->
     L1 = [L0];
     L0 = [_ | _] ->
     makeSign(L0, L1);
     %% Here if L0 is already reconstructed
     L1 = [L0]),
    S =.. [X | L1].
makeSign([H0 | T0], [H1 | T1]) :-
    !,
    makeSign(H0, H1),
    makeSign(T0, T1).
makeSign(X0, X1) :-
    X0 =.. [F | ARGS0],
    makeSign(ARGS0, ARGS1),
    X1 =.. [F | ARGS1].

unmakeSign(X, Y) :-
    (var(X); atomic(X)),
    !,
    X = Y.
unmakeSign([H0 | T0], [H1 | T1]) :-
    !,
    unmakeSign(H0, H1),
    unmakeSign(T0, T1).
unmakeSign(X0, F=A1) :-
    X0 =.. [F | A0],
    unmakeSign(A0, A1).
    
shareFeatures([], _L, _INLINE) :-
    !.
shareFeatures([H | T], L, INLINE) :-
    !,
    shareFeature(H, L, INLINE),
    shareFeatures(T, L, INLINE).
shareFeatures(F, L, INLINE) :-
    shareFeature(F, L, INLINE).

shareFeature(F, L, INLINE) :-
    shareFeature(F, L, _V, INLINE).

shareFeature(_F, [], _V, _INLINE).
shareFeature(F, [H | T], V, INLINE) :-
    extractFeatures(F@H, V, INLINE),
    shareFeature(F, T, V, INLINE).

mergeLists(L0, L1, L0) :-
    var(L1),
    !,
    L0 = L1.
mergeLists(_, F=A, F=A) :-
    nonvar(F),
    var(A),
    !.
mergeLists([], [], []) :-
    !.
mergeLists([H0 | T0], [H1 | T1], [H | T]) :-
    !,
    mergeLists(H0, H1, H),
    mergeLists(T0, T1, T).
mergeLists(V, F=A1, F=A) :-
    length(A1, N),
    length(A0, N),
    V =.. [F | A0],
    mergeLists(A0, A1, A).
mergeLists(F=A0, F=A1, F=A) :-
    mergeLists(A0, A1, A).

reassemble(X, X) :-
    (var(X); atomic(X)),
    !.
reassemble([H0 | T0], [H1 | T1]) :-
    !,
    reassemble(H0, H1),
    reassemble(T0, T1).
reassemble(X0=A0, X1) :-
    (var(A0) ->
     true;
     (reassemble(A0, A1),
      X1 =.. [X0 | A1])).

extractFeatures(X, Y, _INLINE) :-
    (var(X); atomic(X)),
    !,
    X = Y.
extractFeatures(W ## T, L, INLINE) :-
    !,
    extractFeatures((lexEntry(W, X) :- X <> T), L, INLINE).
extractFeatures(-A@X, C, INLINE) :-
    nonvar(A),
    !,
    extractFeatures((A@X -- (-)), C, INLINE).  
extractFeatures(+A@X, C, INLINE) :-
    !,
    extractFeatures((A@X -- (+)), C, INLINE).
extractFeatures(F :: L, true, INLINE) :-
    nonvar(F),
    nonvar(L),
    !,
    shareFeatures(F, L, INLINE).
extractFeatures([]@_X, [], _INLINE) :-
    !.
extractFeatures([H0 | T0]@X, [H1 | T1], INLINE) :-
    !,
    extractFeatures(H0@X, H1, INLINE),
    extractFeatures(T0@X, T1, INLINE).
extractFeatures(A\B@X0, D, INLINE) :-
    !,
    extractFeatures(X0\B, X1, INLINE),
    extractFeatures(A@X1, D, INLINE).
extractFeatures(A@X, D, INLINE) :-
    extractFeature(A, X, D, INLINE).
extractFeatures(A@X, _C, _INLINE) :-
    !,
    format('No such feature: ~w, ~w~n', [A, X]),
    fail.
extractFeatures(signature(X=L), [signature(X=L), SIGNN], _INLINE) :-
    !,
    makeSign(X=L, SIGN0),
    functor(SIGN0, F, N),
    functor(SIGN1, F, N),
    SIGNN =.. [X, SIGN1].
extractFeatures(X0\A, Y, INLINE) :-
    (A = FEATURE:TYPE ->
	true;
	(TYPE = sign, FEATURE = A)),
    extractFeatures(X0, X1, INLINE),
    unmakeSign(X1, L1),
    signature(TYPE=L),
    contains(FEATURE=_, [TYPE=L], L0),
    mergeLists([L1], L0, L2),
    reassemble(L2, [Y]).
extractFeatures(X -- Y, GOAL, INLINE) :-
    extractFeatures(X, F0, INLINE),
    extractFeatures(Y, F1, INLINE),
    (INLINE ->
	(F0 = F1, GOAL = true);
	(GOAL = (F0 = F1))).
extractFeatures(X <> L, true, _INLINE) :-
    !,
    X <> L.
extractFeatures([H0 | T0], [H1 | T1], INLINE) :-
    !,
    extractFeatures(H0, H1, INLINE),
    extractFeatures(T0, T1, INLINE).
extractFeatures((A0 -> B0), (A1 -> B1), _INLINE) :-
    !,
    extractFeatures(A0, A1, fail),
    extractFeatures(B0, B1, fail).
extractFeatures(((A, B), C), X, INLINE) :-
    nonvar(A),
    !,
    extractFeatures((A, (B, C)), X, INLINE).
extractFeatures((CUT, A0), (CUT, A1), _INLINE) :-
    CUT == !,
    !,
    extractFeatures(A0, A1, fail).
extractFeatures((B0; C0), (B1; C1), _INLINE) :-
    !,
    extractFeatures(B0, B1, fail),
    extractFeatures(C0, C1, fail).
extractFeatures($$X, P, _INLINE) :-
    !,
    clausalForm(X, P).
extractFeatures((H0 :- G0), C, INLINE) :-
    extractFeatures(H0, H1, INLINE),
    extractFeatures(G0, G1, INLINE),
    removeDummyTrues(G1, G2),
    (G2 = true ->
	C = H1;
	C = (H1 :- G2)).
extractFeatures(X0, X1, INLINE) :-
    !,
    X0 =.. [F | L0],
    extractFeatures(L0, L1, INLINE),
    X1 =.. [F | L1].

extractFeature(A, X, D, INLINE) :-
    (A = FEATURE:TYPE ->
	true;
	(TYPE = sign, FEATURE = A)),
    extractFeatures(X, Y, INLINE),
    signature(TYPE=L0),
    contains(FEATURE=C, L0, L1),
    !,
    (var(C) ->
	(D = C, L2 = L1);
	substitute(D, FEATURE=C, L1, L2)),
    makeSign(TYPE=L2, Y).

term_expansion(P, P) :-
    recompiling,
    !.
term_expansion(P0, P1) :-
    extractFeatures(P0, P1, true).

goal_expansion(P, P) :-
    recompiling,
    !.
goal_expansion(P0, P1) :-
    extractFeatures(P0, P1, true).

:- retractall(recompiling).

% inLineExpansion: not in the notes, just the lecture

:- retractall(inLineExpansion).
:- assert1(inLineExpansion).
