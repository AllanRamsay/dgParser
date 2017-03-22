

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
    X <> [suffix(tns), presTense, thirdSing, finite(tensed)].

word('', X) :-
    language@X -- english,
    X <> [suffix(tns)],
    baseForm(X).

word('s', X) :-
    language@X -- english,
    specifier@X -- generic,
    X <> [suffix(numPerson), third, plural, -target, standardcase].

word('', X) :-
    language@X -- english,
    X <> [suffix(numPerson), thirdSing, standardcase],
    specified@X -- mass@X,
    trigger(index@X, default(nmod(X))).

word('ed', X) :-
    language@X -- english,
    X <> [suffix(tns), pastTenseSuffix(PT), pastPartSuffix(PP), -target],
    trigger((PT, PP),
	    ((PT=ed, PP=ed) -> edForm(X);
	     (PT=ed -> pastTense(X);
	      PP=ed -> pastPart(X)))).

word('en', X) :-
    language@X -- english,
    -target@X,
    X <> [suffix(tns), past, pastPartSuffix(en)].

word('', X) :-
    language@X -- english,
    X <> [adj(_), suffix(adjsuffix)],
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
