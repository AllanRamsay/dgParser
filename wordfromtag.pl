
:- op(700, xfx, <==).

X <== F:'NN' :-
    X <> noun,
    surface@X -- F.

wordsFromTags([], []).
wordsFromTags([H0 | T0], [H1 | T1]) :-
    H1 <== H0,
    wordsFromTags(T0, T1).
    