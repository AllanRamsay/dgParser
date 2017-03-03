
%%%% PRETTY.PL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
portray(A) :-
    ?quoteAtoms,
    atom(A),
    format("'~w'", [A]).

writeList(STREAM, [H | T]) :-
    pwrite(STREAM, H),
    (T = [] ->
	true;
     T = [_ | _] ->
	(write(STREAM, ', '),
	 writeList(STREAM, T));
	(write(STREAM, ' | '), write(STREAM, T))).

pwrite(STREAM, V) :-
    var(V),
    !,
    write(STREAM, V).
pwrite(STREAM, X) :-
    atomic(X),
    !,
    format(STREAM, '~p', [X]).
pwrite(STREAM, {X}) :-
    !,
    write(STREAM, '{'),
    pwrite(STREAM, X),
    write(STREAM, '}').
pwrite(STREAM, [H | T]) :-
    !,
    write(STREAM, '['),
    writeList(STREAM, [H | T]),
    write(STREAM, ']').
pwrite(STREAM, A=B) :-
    (B == +; B == -),
    !,
    format(STREAM, '~w~p', [B, A]).
pwrite(STREAM, X) :-
    X =.. ['\\red' | ARGS],
    !,
    write(STREAM, '\\red{'),
    writeList(STREAM, ARGS),
    write(STREAM, '}').
pwrite(STREAM, X) :-
    X =.. [F, A, B],
    current_op(_, _, F),
    !,
    format(STREAM, '(~p ~w ~p)', [A, F, B]).
pwrite(STREAM, X) :-
    X =.. [F | ARGS],
    format(STREAM, '~w(', [F]),
    writeList(STREAM, ARGS),
    write(STREAM, ')').

pretty(STREAM, X, _) :-
    var(X),
    !,
    write(STREAM, X).
pretty(STREAM, X, _) :-
    atomic(X),
    !,
    pwrite(STREAM, X).
pretty(STREAM, X, OFFSET) :-
    (maxwidth(M) -> true; M = 100),
    fits(X, OFFSET/_, M),
    !,
    pwrite(STREAM, X).
pretty(STREAM, (A, B), OFFSET) :-
    !,
    write(STREAM, '('),
    pretty_args(STREAM, [A, B], OFFSET+1),
    write(STREAM, ')').
pretty(STREAM, X, OFFSET) :-
    X = [_ | _],
    !,
    write(STREAM, '['),
    pretty_args(STREAM, X, OFFSET+1),
    write(STREAM, ']').
pretty(STREAM, F=D, OFFSET) :-
    !,
    plength(F, 0/FLENGTH),
    write(STREAM, F),
    write(STREAM, '='),
    pretty(STREAM, D, OFFSET+FLENGTH+1).
pretty(STREAM, {X}, OFFSET) :-
    !,
    write(STREAM, '{'),
    pretty(STREAM, X, OFFSET+2),
    write(STREAM, '}').
pretty(STREAM, X, OFFSET) :-
    X =.. [F, A, B],
    current_op(_, _, F),
    !,
    write(STREAM, '('),
    pretty(STREAM, A, OFFSET+1),
    nl(STREAM), tab(STREAM, OFFSET+2),
    print(STREAM, F), tab(STREAM, 1),
    atom_codes(F, C),
    length(C, N),
    pretty(STREAM, B, OFFSET+3+N),
    write(STREAM, ')').
pretty(STREAM, X, OFFSET) :-
    \+ X = [_ | _],
    X =.. [F, A | ARGS],
    !,
    plength(F, 0/FLENGTH),
    write(STREAM, F),
    write(STREAM, '('),
    pretty_args(STREAM, [A | ARGS], OFFSET+FLENGTH+1),
    write(STREAM, ')').
pretty(STREAM, X, _) :-
    write(STREAM, X).

pretty(STREAM, X) :-
    nl(STREAM),
    call_residue(copy_term(X, Y), _R),
    \+ \+ ((instantiate(Y), pretty(STREAM, Y, 0)); true).

pretty(X) :-
    pretty(user_output, X).

cpretty(STREAM, X) :-
    removeFreeVars(X, Y),
    pretty(STREAM, Y).

cpretty(X) :-
    cpretty(user_output, X).

pretty_args(_STREAM, L, _) :-
    var(L),
    !.
pretty_args(_STREAM, [], _) :-
    !.
pretty_args(STREAM, X, _) :-
    \+ X = [_ | _],
    !,
    pwrite(STREAM, X).
pretty_args(STREAM, [X | L], OFFSET) :-
    pretty(STREAM, X, OFFSET),
    ((var(L); L == []) ->
        true;
     \+ L = [_ | _] ->
	write(STREAM, ' | ');
        (write(STREAM, ','), nl(STREAM), tab(STREAM, OFFSET))),
    pretty_args(STREAM, L, OFFSET).

plength(V, I/O) :-
    var(V),
    !,
    O is I+3.
plength(X, I/O) :-
    atom(X), !,
    name(X, L),
    length(L, N),
    O is I+N.
plength(X, I/O) :-
    integer(X),
    !,
    O is I+1.
plength([X | L], I/O) :-
    !,
    plength(X, I/T1),
    plength(L, T1/T2),
    O is T2+3.
plength(T, I/O) :-
    T =.. [F | ARGS],
    plength(F, I/T1),
    argslength(ARGS, T1/O).

argslength([], N/N).
argslength([H | T], N0/N2) :-
    plength(H, N0/N1),
    argslength(T, N1/N2).

fits(V, I/O, MAX) :-
    var(V), !,
    O is I+1,
    O < MAX.
fits(X, I/O, MAX) :-
    latex,
    member(X, [lambda, exists, exists1, forall, subset]),
    !,
    O is I+1,
    O < MAX.
fits(X, I/O, MAX) :-
    atom(X), !,
    atom_chars(X, L),
    length(L, N),
    O is I+N,
    O < MAX.
fits(X, I/O, MAX) :-
    number(X), !,
    O is I+1,
    O < MAX.
fits([X | L], I/O, MAX) :-
    !,
    fits(X, I/T1, MAX),
    fits(L, T1/T2, MAX),
    O is T2+3,
    O < MAX.
fits(T, I/O, MAX) :-
    T =.. [F | ARGS],
    fits(F, I/T1, MAX),
    fits(ARGS, T1/O, MAX).

instantiate(X) :-
    instantiate(X, 1, _N).

makeVar(I, V) :-
    I < 26,
    !,
    J is I+64,
    atom_chars(V, [J]).
makeVar(I, V) :-
    J is I//26,
    K is I-(26*J)+1,
    makeVar(J, V0),
    makeVar(K, V1),
    atom_concat(V0, V1, V).
    
instantiate(V, I, J) :-
    var(V),
    !,
    makeVar(I, V),
    J is I+1.
instantiate(X, I, I) :-
    atomic(X),
    !.
instantiate([H | T], I, K) :-
    !,
    instantiate(H, I, J),
    instantiate(T, J, K).
instantiate(X, I, J) :-
    X =.. L,
    instantiate(L, I, J).

treepr(STREAM, X) :-
    treepr(STREAM, X, '').

treepr(X) :-
    treepr(user_output, X).

treepr(STREAM, [H | T0], I0) :-
    format(STREAM, '~n~w~w', [I0, H]),
    atom_concat(I0, '    ', I1),
    sort(T0, T1),
    treeprdtrs(STREAM, T1, I1).

treeprdtrs(_STREAM, [], _I).
treeprdtrs(STREAM, [H | T], I) :-
    treepr(STREAM, H, I),
    treeprdtrs(STREAM, T, I).
