toString([X], X) :-
    !.
toString([H | T], S) :-
    toString(T, S0),
    atom_concat(' ', S0, S1),
    atom_concat(H, S1, S).

tag(L0, L2) :-
    toString(L0, L1),
    length(L0, N),
    length(L2, N),
    catch(askServer(L1, L2), _, true).