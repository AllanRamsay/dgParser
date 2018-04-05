
%%%% PRETTY.PL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
portray(A) :-
    ?quoteAtoms,
    atom(A),
    format("'~w'", [A]).

writeList([H | T]) :-
    pwrite(H),
    (T = [] ->
	true;
     T = [_ | _] ->
	(write(', '),
	 writeList(T));
	(write(' | '), write(T))).

pwrite(V) :-
    var(V),
    !,
    write(V).
pwrite(X) :-
    atomic(X),
    !,
    format('~p', [X]).
pwrite({X}) :-
    !,
    format("~w", [{X}]).
pwrite([H | T]) :-
    !,
    write('['),
    writeList([H | T]),
    write(']').
pwrite(A=B) :-
    (B == +; B == -),
    !,
    format('~w~p', [B, A]).
pwrite(X) :-
    X =.. ['\\red' | ARGS],
    !,
    write('\\red{'),
    writeList(ARGS),
    write('}').
pwrite(X) :-
    X =.. [F, A, B],
    current_op(_, _, F),
    !,
    (?bracketOps ->
     format('(~p~w~p)', [A, F, B]);
     format('~p~w~p', [A, F, B])).
pwrite(X) :-
    X =.. [F | ARGS],
    format('~w(', [F]),
    writeList(ARGS),
    write(')').

pretty(X, _) :-
    var(X),
    !,
    write(X).
pretty(X, _) :-
    atomic(X),
    !,
    pwrite(X).
pretty(X, OFFSET) :-
    (maxwidth(M) -> true; M = 100),
    fits(X, OFFSET/_, M),
    !,
    pwrite(X).
pretty((A, B), OFFSET) :-
    !,
    write('('),
    pretty_args([A, B], OFFSET+1),
    write(')').
pretty(X, OFFSET) :-
    X = [_ | _],
    !,
    write('['),
    pretty_args(X, OFFSET+1),
    write(']').
pretty(F=D, OFFSET) :-
    !,
    plength(F, 0/FLENGTH),
    write(F),
    write('='),
    pretty(D, OFFSET+FLENGTH+1).
pretty({X}, OFFSET) :-
    !,
    write('{'),
    pretty(X, OFFSET+2),
    write('}').
pretty(X, OFFSET) :-
    X =.. [F, A, B],
    current_op(_, _, F),
    !,
    write('('),
    pretty(A, OFFSET+1),
    nl, tab(OFFSET+2),
    print(F), tab(1),
    atom_codes(F, C),
    length(C, N),
    pretty(B, OFFSET+3+N),
    write(')').
pretty(X, OFFSET) :-
    \+ X = [_ | _],
    X =.. [F, A | ARGS],
    !,
    plength(F, 0/FLENGTH),
    write(F),
    write('('),
    pretty_args([A | ARGS], OFFSET+FLENGTH+1),
    write(')').
pretty(X, _) :-
    write(X).

pretty(X) :-
    call_residue(copy_term(X, Y), _R),
    nl,
    \+ \+ ((instantiate(Y), pretty(Y, 0)); true).

cpretty(X) :-
    removeFreeVars(X, Y),
    pretty(Y).

pretty_args(L, _) :-
    var(L),
    !.
pretty_args([], _) :-
    !.
pretty_args(X, _) :-
    \+ X = [_ | _],
    !,
    pwrite(X).
pretty_args([X | L], OFFSET) :-
    pretty(X, OFFSET),
    ((var(L); L == []) ->
        true;
     \+ L = [_ | _] ->
	write(' | ');
        (write(','), nl, tab(OFFSET))),
    pretty_args(L, OFFSET).

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

treepr(X) :-
    treepr(X, '').

treepr(X) :-
    treepr(user_output, X).

treepr([H | T0], I0) :-
    format('~n~w~w', [I0, H]),
    atom_concat(I0, '    ', I1),
    sort(T0, T1),
    treeprdtrs(T1, I1).

treeprdtrs([], _I).
treeprdtrs([H | T], I) :-
    treepr(H, I),
    treeprdtrs(T, I).

minipage(GOAL) :-
    with_output_to_atom(GOAL, T1),
    format("
\\begin{minipage}[t]{0.5\\linewidth}~w
\\end{minipage}
", [T1]).

verbatim(G) :-
    with_output_to_atom(G, T1),
    format("
\\begin{Verbatim}[commandchars=\\\\\\{\\}]~w
\\end{Verbatim}
", [T1]).

hbox(G) :-
    with_output_to_atom(G, T),
    format("
\\hbox{
~w
}", [T]).