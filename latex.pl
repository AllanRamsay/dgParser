pstree(X) :-
    pstree(X, '', black).

pstree([HD | T], I0, COLOUR) :-
    (atomic(HD); HD = (_:_)),
    !,
    (I0 = '' ->
     format('~n~w\\pstree[levelsep=60pt, treesep=50pt, nodesep=5pt, linecolor=~w]{\\TR{\\textcolor{~w}{~w}}}{', [I0, COLOUR, COLOUR, HD]);
     format('~n~w\\pstree[linecolor=~w]{\\TR{\\textcolor{~w}{~w}}}{', [I0, COLOUR, COLOUR,  HD])),
    atom_concat(' ', I0, I1),
    psdtrs(T, I1, COLOUR),
    format('}', []).
pstree([H | T], I, COLOUR) :-
    pstree(H, I, COLOUR),
    pstree(T, I, COLOUR).
pstree([], _I, _COLOUR).

psdtrs(L, I, COLOUR) :-
    psdtrs(L, I, '', COLOUR).

psdtrs([], _, _, _COLOUR).
psdtrs([H | T], I, J, COLOUR) :-
    pstree(H, I, COLOUR),
    psdtrs(T, I, J, COLOUR).
    