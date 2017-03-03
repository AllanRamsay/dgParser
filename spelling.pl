


prefix2atom([], '').
prefix2atom([H | T0], A1) :-
    prefix2atom(T0, A0),
    atom_concat(A0, H, A1).


/**
  LEFTCONTEXT:X0:RIGHTCONTEXT ==> Y0
  **/

mapchars(V, V, _VARS) :-
    (var(V); V == []),
    !.
mapchars([H0 | T0], [H1 | T1], VARS) :-
    mapchar(H0, H1, VARS),
    mapchars(T0, T1, VARS).

option(X, A/B) :-
    !,
    \+ \+ (option(X, A); option(X, B)).
option(X, X).

consonant(X) :-
    member(X, [b,c,d,f,g,h,j,k,l,m,n,p,q,r,s,t,v,w,x,y,z]).
vowel(X) :-
    member(X, [a,e,i,o,u]).

mapchar(V0, V1, _VARS) :-
    var(V0),
    !,
    V1 = V0.
mapchar(A/B, X, _VARS) :-
    !,
    trigger(X, option(X, A/B)).
mapchar((A,B), X, VARS) :-
    !,
    mapchar(A, X, VARS),
    mapchar(B, X, VARS).
mapchar(X0, X1, VARS) :-
    X0 =.. [{}, C],
    !,
    mapchar(C, X1, VARS).
mapchar(A, A, _VARS) :-
    atom(A),
    atom_chars(A, [_]),
    !.
mapchar(X, A, VARS) :-
    atom(X),
    atom_chars(X, [0'v | _N]),
    !,
    (member(X:A, VARS) -> true; extend1(VARS, X:A)),
    trigger(A, vowel(A)).
mapchar(X, A, VARS) :-
    atom(X),
    atom_chars(X, [0'c | _N]),
    !,
    (member(X:A, VARS) -> true; extend1(VARS, X:A)),
    trigger(A, consonant(A)).
mapchar(X, _, _VARS) :-
    with_output_to_atom(format('Unknown character specification: ~w', [X]), A),
    throw(A).

compileRule(LEFTCONTEXT0:X0:RIGHTCONTEXT0 ==> Y0, LEFTCONTEXTN, P0, P1) :-
    mapchars(LEFTCONTEXT0, LEFTCONTEXT1, VARS),
    mapchars(RIGHTCONTEXT0, RIGHTCONTEXT1, VARS),
    mapchars(X0, X1, VARS),
    mapchars(Y0, Y1, VARS),
    append(X1, RIGHTCONTEXT1, P0),
    append(Y1, RIGHTCONTEXT1, P1),
    reverse(LEFTCONTEXT1, LEFTCONTEXT2),
    append(LEFTCONTEXT2, _, LEFTCONTEXTN).

%% loved ==> love+ed
[c0, e]:[{C, d/r/s}]:_ ==> [+, e, C].
%% lov[]ing ==> love+ing
[c0]:[]:[i, n, g | _] ==> [e, +].
%% hit[t]ing ==> hit+ing
[v0, c1]:[c1]:[i/e | _] ==> [+].
%% watch[e]s ==> watch+s
[c/s, h]:[e]:[s] ==> [+].
%% kiss[e]s ==> kiss+s
[s, s]:[e]:[s] ==> [+].
[e, e]:[]:[d] ==> [+, e].
[z]:[e]:[s] ==> [+].
%% fr[ie]s ==> fry+s
[c1]:[i, e]:[s] ==> [y, +].
[c0]:[y]:[i, n, g] ==> [i, e, +].
[c1]:[i]:[e, d/r/s] ==> [y, +].
[c1, i, e]:[]:[d] ==> [+, e].
[c0, o]:[e]:[s] ==> [+].
[v0, x/s]:[e]:[s] ==> [+].
[w/e]:[]:[n] ==> [+, e].
[c]:[a, m, e]:[] ==> [o, m, e, +, e, d].
[u]:[]:[e, d] ==> [e, +].
[]:[v, e]:[s] ==> [f].
[v0]:[v]:[e, s] ==> [f].
[m]:[e, n]:[] ==> [a, n, +, s].
[]:[i, c, e]:[] ==> [o, u, s, e, +, s].
[u]:[]:[i, n, g] ==> [e, +].
[a]:[i]:[d] ==> [y, +, e].
[e]:[p, t]:[] ==> [e, p, +, e, d].

compileRules :-
    abolish(spellingRule/3),
    L0 ==> R0,
    compileRule(L0 ==> R0, L1, P0, P1),
    assert(spellingRule(L1, P0, P1)),
    fail.
compileRules.

:- compileRules.
