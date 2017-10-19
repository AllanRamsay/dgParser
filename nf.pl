:- op(32, xfy, '\IN').

revpolarity(P0, P1) :-
    (P0 = + -> P1 = -; P1 = -).

denest([[H | T0] | T1], D) :-
    !,
    append(T0, T1, T),
    denest([H | T], D).
denest([H0 | T0], [H1 | T1]) :-
    !,
    denest(H0, H1),
    denest(T0, T1).
denest(_A=B, C) :-
    !,
    denest(B, C).
denest(arg(A, B, D0), arg(A, B, D1)) :-
    !,
    denest(D0, D1).
denest(modifier(A, B0), modifier(A, B1)) :-
    !,
    denest(B0, B1).
denest(X, X).

nfTree(X, X) :-
    (var(X); atomic(X)),
    !.
nfTree([_X, arg(identity, SPECX, [Y | ARGS])], N) :-
    !,
    nfTree(arg(Y, SPECX, ARGS), N).
nfTree([X, arg(THETAX, SPECX, [_I, arg(_SPECY, identity, D)])], N) :-
    !,
    nfTree([X, arg(THETAX, SPECX, D)], N).
nfTree(arg(A, B, D0), arg(A, B, D1)) :-
    !,
    nfTree(D0, D1).
nfTree([modifier(identity, _D0) | T0], T1) :-
    !,
    nfTree(T0, T1).
nfTree([modifier(A, D0) | T0], [modifier(A, D1) |T1]) :-
    !,
    nfTree(D0, D1),
    nfTree(T0, T1).
nfTree([X0 | T0], [X1 | T1]) :-
    !,
    nfTree(X0, X1),
    nfTree(T0, T1).
nfTree(X, X).

nfDtrs([], []).
nfDtrs([H0 | T0], [H1 | T1]) :-
    nfTree(H0, H1),
    nfDtrs(T0, T1).

justRoots(X, X) :-
    (var(X); atomic(X)),
    !.
justRoots(A > _, A) :-
    !.
justRoots([H0 | T0], [H1 | T1]) :-
    !,
    justRoots(H0, H1),
    justRoots(T0, T1).
justRoots(X0, X1) :-
    X0 =.. L0,
    justRoots(L0, L1),
    X1 =.. L1.

%% qq(Q, T) means: add Q to the QSTACK and subsequently apply it to the
%% core, leave T where it is. We will write {P:X} for P(X) because we
%% can't write P(X). We might later convert these, but probably not because
%% I will want to do asymmetric unification on predicates as well as terms.
qlf(X, X) :-
    (var(X); atomic(X)),
    !.
qlf(arg(claim, *(tense(TNS, REF)), [EVENT | ARGS]),
    claim(opaque(qq(tense(REF)::{TNS, V}, at(V, opaque(qq(indefinite :: E, {QLF, E}))))))) :-
    !,
    qlf([EVENT | ARGS], QLF).
qlf(arg(query, *(tense(TNS, REF)), [EVENT | ARGS]),
    query(opaque(qq(tense(REF)::{TNS, V}, at(V, opaque(qq(indefinite :: E, {QLF, E}))))))) :-
    !,
    qlf([EVENT | ARGS], QLF).
qlf(arg(xcomp, *SPEC, X0), {xcomp, opaque(X1)}) :-
    var(SPEC),
    !,
    qlf(X0, X1).
qlf(arg(THETA, *SPEC, X0), {THETA, X1}) :-
    var(SPEC),
    !,
    qlf(X0, X1).
qlf(arg(THETA, *generic, X0), {generic, {THETA, V}, {X1, V}}) :-
    !,
    qlf(X0, X1).
qlf(arg(THETA, *name, [X0:'NP']), QLF) :-
    !,
    qlf(arg(THETA, *(the), name(X0)), QLF).
qlf(arg(THETA, *lambda, _X0), qq(lambda::V, {THETA, V})) :-
    !.
qlf(arg(THETA, *SPEC, X0), qq(SPEC::{X1, V}, {THETA, V})) :-
    !,
    qlf(X0, X1).
qlf(['.', X0], X1) :-
    !,
    qlf(X0, X1).
qlf(['?', X0], X1) :-
    !,
    qlf(X0, X1).
qlf([H0 | T0], [H1 | T1]) :-
    !,
    qlf(H0, H1),
    qlf(T0, T1).
qlf(X0, X1) :-
    X0 =.. L0,
    qlf(L0, L1),
    X1 =.. L1.

extractQQ(X, X, Q, Q) :-
    (atomic(X); var(X)),
    !.
extractQQ(opaque(X0), X1, Q, Q) :-
    !,
    fixQuants(X0, X1).
extractQQ(qq(Q0, T0), T1, QS0, [Q1 | QS2]) :-
    !,
    extractQQ(Q0, Q1, QS0, QS1),
    extractQQ(T0, T1, QS1, QS2).
extractQQ([H0 | T0], [H1 | T1], Q0, Q2) :-
    !,
    extractQQ(H0, H1, Q0, Q1),
    extractQQ(T0, T1, Q1, Q2).
extractQQ(X0, X1, Q0, Q1) :-
    X0 =.. L0,
    extractQQ(L0, L1, Q0, Q1),
    X1 =.. L1.

extractQQ(X0, X1, QSTACK) :-
    extractQQ(X0, X1, [], QSTACK).

fixQuants(X0, X2) :-
    extractQQ(X0, X1, QSTACK),
    applyQuants(QSTACK, X1, X2).

applyQuants([], X, X).
applyQuants([Q0::V | QQ], X0, XN) :-
    var(V),
    !,
    (member(Q0, [indefinite]) ->
     Q1 = exists;
     member(Q0, [universal]) ->
     Q1 = forall;
     Q0 = tense(REF) ->
     ((REF = -) -> Q1 = exists; Q1 = the);
     Q1 = Q0),
    applyQuants(QQ, X0, X1),
    XN =.. [Q1, V, X1].
applyQuants([Q0::{R, V} | QQ], X0, XN) :-
    (member(Q0, [indefinite]) ->
     Q1 = exists;
     member(Q0, [universal]) ->
     Q1 = forall;
     Q0 = tense(REF) ->
     ((REF = -) -> Q1 = exists; Q1 = the);
     Q1 = Q0),
    applyQuants(QQ, X0, X1),
    XN =.. [Q1, V::{R, V}, X1].

curry(A, A) :-
    (atomic(A); var(A)),
    !.
curry({X0, V}, Xn) :-
    !,
    curryAll(X0, V, Xn).
curry(V :: {X0}, V :: {X1}) :-
    !,
    curry({X0}, X1).
curry([H0 | T0], [H1 | T1]) :-
    !,
    curry(H0, H1),
    curry(T0, T1).
curry(X0, X1) :-
    X0 =.. L0,
    curry(L0, L1),
    X1 =.. L1.

curryAll([], _V, []) :-
    !.
curryAll([H0 | T0], V, [H2 | T1]) :-
    !,
    curry(H0, H1),
    H1 =.. [F | A0],
    curry(A0, A1),
    H2 =.. [F, V | A1],
    curryAll(T0, V, T1).
curryAll(H0, V, H1) :-
    H0 =.. [F | A0],
    curry(A0, A1),
    H1 =.. [F, V | A1].

generics(X, X) :-
    (atomic(X); var(X)),
    !.
generics(generic(E, (THETA0, R)), THETA1 => R) :-
    !,
    THETA0 =.. [T | A],
    THETA1 =.. [T, E | A].
generics([H0 | T0], [H1 | T1]) :-
    !,
    generics(H0, H1),
    generics(T0, T1).
generics(X0, X1) :-
    X0 =.. L0,
    generics(L0, L1),
    X1 =.. L1.

simplify(X, X) :-
    (var(X); atomic(X)),
    !.
simplify([STOP, X0], X1) :-
    STOP == '.',
    !,
    simplify(X0, X1).
simplify(be(X)& (predication(X, A, xbar(v(-), n(+))) & subject(X, B)), B=A) :-
    ?simplifyEQ,
    !.
simplify(be(X) & ((predication(X,B,xbar(v(-),n(+)))=>P0) & subject(X, A)), P1) :-
    ?simplifyEQ,
    !,
    P0 =.. [F, B],
    P1 =.. [F, A].
simplify(present(A), now=A) :-
    !.
simplify([H0 | T0], [H1 | T1]) :-
    !,
    simplify(H0, H1),
    simplify(T0, T1).
simplify((A0, B0), (A1, B1)) :-
    !,
    simplify(A0, A1),
    simplify(B0, B1).
simplify(A0:B0, S) :-
    !,
    simplify(A0, A1),
    simplify(B0, B1),
    (A1 = (X:Y) ->
     simplify(X:(Y:B1), S);
     S = A1:B1).
simplify(X0, X1) :-
    X0 =.. L0,
    simplify(L0, L1),
    X1 =.. L1.

skolem(X, L) :-
    gensym('#', S),
    X =.. [S | L].

qff(X, X, _QSTACK, _POLARITY) :-
    (var(X); atomic(X)),
    !.
qff(the(X :: {P0}, Q0), Q2, QSTACK, POLARITY) :-
    !,
    qff(Q0, Q1, QSTACK, POLARITY),
    substitute(ref(X, {P0}, QSTACK), X, Q1, Q2).
qff(forall(X, P0), P2, QSTACK, +) :-
    var(X),
    !,
    substitute(Y, X, P0, P1),
    qff(P1, P2, [Y | QSTACK], +).
qff(forall(X, P0), P2, QSTACK, -) :-
    var(X),
    !,
    qff(exists(X, P0), P2, QSTACK, +).
qff(forall(X :: {P0}, Q0), QFF, QSTACK, POLARITY) :-
    !,
    qff(forall(X, {P0} => Q0), QFF, QSTACK, POLARITY).
qff(no(X :: {P0}, Q0), QFF, QSTACK, POLARITY) :-
    !,
    qff(forall(X :: {P0}, not(Q0)), QFF, QSTACK, POLARITY).
qff(generic(X :: {P0}, Q0), QFF, QSTACK, POLARITY) :-
    !,
    qff(forall(X, Q0 => P0), QFF, QSTACK, POLARITY).
qff(exists(X, P0), P2, QSTACK, +) :-
    var(X),
    !,
    skolem(X, QSTACK),
    qff(P0, P2, QSTACK, +).
qff(exists(X, P0), P2, QSTACK, -) :-
    var(X),
    !,
    qff(P0, P2, [X | QSTACK], -).
qff(exists(X :: {P0}, Q0), QFF, QSTACK, POLARITY) :-
    !,
    qff(exists(X, {P0} & Q0), QFF, QSTACK, POLARITY).
qff(at(V, X0), QFF, QSTACK, POLARITY) :-
    ?fixContexts,
    !,
    qff(X0 '\IN' V, QFF, QSTACK, POLARITY).
qff(claim(X0), claim(X1), QSTACK, POLARITY) :-
    ?fixContexts,
    !,
    qff((X0 '\IN' bel(speaker)) '\IN' now, X1, QSTACK, POLARITY).
qff(claim(X0), claim(X1), QSTACK, POLARITY0) :-
    !,
    qff(X0, X1, QSTACK, POLARITY0).
qff(query(X0), query(X1), QSTACK, POLARITY0) :-
    ?fixContexts,
    !,
    revpolarity(POLARITY0, POLARITY1),
    qff((X0 '\IN' bel(hearer)) '\IN' now, X1, QSTACK, POLARITY1).
qff(query(X0), query(X1), QSTACK, POLARITY0) :-
    !,
    revpolarity(POLARITY0, POLARITY1),
    qff(X0, X1, QSTACK, POLARITY1).
qff([H0 | T0], [H1 | T1], QSTACK, POLARITY) :-
    !,
    qff(H0, H1, QSTACK, POLARITY),
    qff(T0, T1, QSTACK, POLARITY).
qff((A0, B0), (A1, B1), QSTACK, POLARITY) :-
    !,
    qff(A0, A1, QSTACK, POLARITY),
    qff(B0, B1, QSTACK, POLARITY).
qff(X0, X1, QSTACK, POLARITY) :-
    X0 =.. L0,
    qffArgs(L0, L1, QSTACK, POLARITY),
    X1 =.. L1.

qffArgs([], [], _QSTACK, _POLARITY).
qffArgs([H0 | T0], [H1 | T1], QSTACK, POLARITY) :-
    qff(H0, H1, QSTACK, POLARITY),
    qffArgs(T0, T1, QSTACK, POLARITY).

qff(X0, X1) :-
    qff(X0, X1, [], +).

list2conj(X, X) :-
    (var(X); atomic(X)),
    !.
list2conj([X], X) :-
    !.
list2conj([H0 | T0], H1 & T1) :-
    !,
    list2conj(H0, H1),
    list2conj(T0, T1).
list2conj(X0, X1) :-
    X0 =.. L0,
    list2conjAll(L0, L1),
    X1 =.. L1.

list2conjAll([], []).
list2conjAll([H0 | T0], [H1 | T1]) :-
    list2conj(H0, H1),
    list2conjAll(T0, T1).

elimEQ(X, X, _, _, _) :-
    \+ ?elimEQ,
    !.
elimEQ(X, X, EQ, EQ, _POLARITY) :-
    (var(X); atomic(X)),
    !.
elimEQ([H0 | T0], [H1 | T1], EQ0, EQ2, POLARITY) :-
    !,
    elimEQ(H0, H1, EQ0, EQ1, POLARITY),
    elimEQ(T0, T1, EQ1, EQ2, POLARITY).
elimEQ((A=B) & C1, C2, EQ0, [A=B | EQ1], +) :-
    !,
    elimEQ(C1, C2, EQ0, EQ1, +).
elimEQ(C1 & (A=B), C2, EQ0, [A=B | EQ1], +) :-
    !,
    elimEQ(C1, C2, EQ0, EQ1, +).
elimEQ((A & B) & C, E, EQ0, EQ1, POLARITY) :-
    !,
    elimEQ(A & (B & C), E, EQ0, EQ1, POLARITY).
elimEQ(A0 => B0, A1 => B1, EQ0, EQ2, POLARITY) :-
    !,
    revpolarity(POLARITY, REVPOLARITY),
    elimEQ(A0, A1, EQ0, EQ1, REVPOLARITY),
    elimEQ(B0, B1, EQ1, EQ2, POLARITY).
elimEQ((A0, B0), (A1, B1), EQ0, EQ2, POLARITY) :-
    !,
    elimEQ(A0, A1, EQ0, EQ1, POLARITY),
    elimEQ(B0, B1, EQ1, EQ2, POLARITY).
elimEQ(X0, X1, EQ0, EQ1, POLARITY) :-
    X0 =.. L0,
    elimEQ(L0, L1, EQ0, EQ1, POLARITY),
    X1 =.. L1.

applyEQ([], X, X).
applyEQ([A=B | EQ0], X0, X2) :-
    substitute(A, B, X0, X1),
    substitute(A, B, EQ0, EQ1),
    applyEQ(EQ1, X1, X2).

elimEQ(X0, X2) :-
    elimEQ(X0, X1, [], EQ, +),
    applyEQ(EQ, X1, X2).

flattenLabels(X, X) :-
    (var(X); atomic(X)),
    !.
flattenLabels((X0 '\IN' L1) '\IN' L0, X1 '\IN' [L0 | L2]) :-
    !,
    flattenLabels(X0 '\IN' L1, X1 '\IN' L2).
flattenLabels(X0 '\IN' L, X1 '\IN' [L]) :-
    !,
    flattenLabels(X0, X1).
flattenLabels([H0 | T0], [H1 | T1]) :-
    !,
    flattenLabels(H0, H1),
    flattenLabels(T0, T1).
flattenLabels(X0, X1) :-
    X0 =.. L0,
    flattenLabels(L0, L1),
    X1 =.. L1.

nf(X, FLATTENLABELS) :-
    denest(dtree@X, DN),
    justRoots(DN, JR),
    (?printing -> (nl, pretty(justRoots(JR))); true),
    nfTree(JR, NF),
    (?printing -> (pretty(nf(NF))); true),
    qlf(NF, QLF),
    (?printing -> (nl, pretty(qlf(QLF))); true),
    (true -> fixQuants(QLF, FQ); true),
    (?printing -> (nl, pretty(fixQuants(FQ))); true),
    (true -> qff(FQ, QFF); true),
    (?printing -> (nl, pretty(qff(QFF))); true),
    curry(QFF, CURRIED),
    (?printing -> (nl, pretty(curried(CURRIED))); true),
    generics(CURRIED, GENERICS),
    (?printing -> (nl, pretty(generics(GENERICS))); true),
    list2conj(GENERICS, LIST2CONJ),
    (true -> simplify(LIST2CONJ, SIMP); SIMP = LIST2CONJ),
    (?printing -> (pretty(simplify(LIST2CONJ, SIMP))); true),
    (true -> elimEQ(SIMP, ELIMEQ); ELIMEQ = QFF),
    (?printing -> (pretty(elimEQ(SIMP, ELIMEQ))); true),
    flattenLabels(ELIMEQ, FLATTENLABELS).
