

word(':', X) :-
    cat@X -- punct,
    X <> [saturated, strictpostmod(T), inflected, fulladjunct],
    T <> [x, saturated].

word('ing', X) :-
    language@X -- english,
    X <> [suffix(tns)],
    presPart(X).

word('s', X) :-
    language@X -- english,
    -target@X,
    X <> [suffix(tns), presTense, thirdSing, finite(tensed), -def].

word('', X) :-
    language@X -- english,
    X <> [suffix(tns)],
    baseForm(X).

word('s', X) :-
    language@X -- english,
    X <> [specifier(SPEC), suffix(numPerson), third, plural, -target, standardcase],
    def@X -- D,
    root@X -- plural,
    trigger(SPEC, (SPEC = *(existential=10), D = -)).

word('', X) :-
    language@X -- english,
    X <> [suffix(numPerson), thirdSing, standardcase, movedAfter(-), unspecified, -specifier],
    root@X -- singular,
    trigger(index@X, default(nmod(X))).

word('ed1', X) :-
    language@X -- english,
    X <> [suffix(tns), pastTenseSuffix(ed), -target],
    pastTense(X).

word('ed2', X) :-
    language@X -- english,
    X <> [suffix(tns), pastPartSuffix(ed), -target],
    pastPart(X).

word('ed', X) :-
    word(ed1, X).

word('ed', X) :-
    word(ed2, X).

word('en', X) :-
    language@X -- english,
    -target@X,
    X <> [suffix(tns), past, pastPartSuffix(en)].

word('', X) :-
    language@X -- english,
    adj(X, _),
    X <> [suffix(adjsuffix)],
    degree@X -- simple,
    -zero@target@X.

word('er', X) :-
    language@X -- english,
    degree@X -- comparative,
    X <> [adj(_), suffix(adjsuffix)],
    -zero@target@X.

word('est', X) :-
    language@X -- english,
    degree@X -- superlative,
    X <> [adj(_), suffix(adjsuffix), +def].

word('ly', X) :-
    language@X -- english,
    X <> [suffix(adjsuffix), adv].
