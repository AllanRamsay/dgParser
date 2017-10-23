
/*******************************************

  A tree is either a word or a list whose head is a word and whose
  tail is a list of label:subtree pairs

  That's a bit of mess, but it's what I'm currently making. Perhaps I
  should tidy that up first!
  
********************************************/

psTree(L:X, INDENT) :-
    (atomic(X); X = (_ > _); x = *(_, _); x = *(_)),
    !,
    format('~w\\TR{$~w$}\\nbput{\\scriptsize ~w}~n', [INDENT, X, L]).
psTree(L:(_X=Y), INDENT) :-
    !,
    psTree(L:Y, INDENT).
psTree(L:[X | DTRS], I0) :-
    psHd(X, L, I0, ''),
    atom_concat(I0, '  ', I1),
    format("{~n", []),
    psDtrs(DTRS, I1),
    format("~w}~n", [I0]).
psTree([X | DTRS], I0) :-
    psHd(X, '', I0, '[levelsep=45pt, nodesep=2pt,treesep=70pt, nrot=:D]'),
    atom_concat(I0, '  ', I1),
    format("~w{~n", [I0]),
    psDtrs(DTRS, I1),
    format("~w}~n", [I0]).

psHd(X, L0, I, ARGS) :-
    (atomic(X); var(X); X = *(_); x = *(_, _); X = (_ > _); (X = [A], atomic(A))),
    ((L0 = arg(L1); L0 = mod(L1)) -> true; L1 = L0),
    format('~w\\pstree~w{\\TR{$~w$}\\nbput{\\scriptsize ~w}}', [I, ARGS, X, L1]).

psDtrs(D, I) :-
    length(D, N),
    psDtrs(D, I, 0, N).

psDtrs([], _I, _J, _N).
psDtrs([H | T], I, J, N) :-
    psTree(H, I),
    psDtrs(T, I, J+1, N).

psTree(T) :-
    nl, 
    psTree(T, '').

psbox(X, SPEC, BOX) :-
    ((SPEC = ''; (SPEC = *V, var(V))) ->
     with_output_to_atom(format('\\begin{tabular}{|c|}\\hline$~w$\\\\ \\hline\\end{tabular}', [X]), BOX);
     with_output_to_atom(format('\\begin{tabular}{|c|}\\hline$~w$\\\\ \\hline\\~w\\\\\\hline\\end{tabular}', [X, SPEC]), BOX)).

npsTree([X | DTRS], ARGS, SPEC, LABELS, I0) :-
    \+ DTRS = [],
    psbox(X, SPEC, BOX),
    !,
    format('~n~w\\pstree~w{\\TR{~w}\\nbput{~w}}{', [I0, ARGS, BOX, LABELS]),
    atom_concat(I0, ' ', I1),
    npsDtrs(DTRS, I1),
    format('~w}~n', [I0]).
npsTree(X, _ARGS, SPEC, LABELS, I0) :-
    psbox(X, SPEC, BOX),
    format('~n~w\\TR{~w}\\nbput{~w}', [I0, BOX, LABELS]).

npsDtr(arg(THETA, SPEC, T), ARGS, I) :-
    npsTree(T, ARGS, SPEC, THETA, I).
npsDtr(modifier(M, T), ARGS, I) :-
    (M = '' -> true; true),
    (T = arg(A, B, C) ->
     npsTree([B | C], ARGS, A, M, I);
     npsTree(T, ARGS, _, M, I)).

npsDtr(X, I) :-
    npsDtr(X, '', I).

npsDtrs([], _I).
npsDtrs([H | T], I) :-
    npsDtr(H, I),
    npsDtrs(T, I).

npsTree(X) :-
    nl,
    npsTree(X, '[levelsep=80pt, nodesep=2pt,treesep=70pt, nrot=:D]', _SPEC, '', '').

