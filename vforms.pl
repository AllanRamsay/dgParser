
gerundAsMod(V, X, T) :-
    shifted@V -- [],
    V <> [unspecified],
    var(wh@T),
    theta@X -- gerundAsMod,
    T <> [standardcase],
    (xend@X-xstart@X > 1 ->
     strictpostmod(X, T);
     strictpremod(X, T)),
    ((noun(T), unspecified(T)); vp(T)),
    incCost(T, 1),
    modified@result@X -- 2.1.

gerund(X, G) :-
    altview@G -- gerund,
    language@G -- english,
    [specified] :: [X, G],
    G <> [n, saturated, fulladjunct, -predicative, -modifiable, compact],
    target@G -- T,
    T <> [x, -aux],
    language :: [G, target@G],
    trigger(used@X, nonvar(wh@X)),
    trigger(index@target@G,
	    ((var(shifted@X), var(wh@X)) -> gerundAsMod(X, G, T); fail)),
    addExternalView(X, G).

addGerund(X) :-
    zero@subject@X -- Z,
    language :: [X, G],
    trigger(Z, (Z = + -> gerund(X, G); true)).

present(X) :-
    tense@X -- present.

past(X) :-
    tense@X -- past.

future(X) :-
    tense@X -- future.

finite(X, finite@X).

presPartForm(X) :-
    X <> [present, -target, finite(participle), aspect(prog)],
    trigger(specified@X, (specified(X, 0) -> true; objcase(subject@X))).

pastPartForm(X) :-
    X <> [past, -target, +active, finite(participle), aspect(perfect)].

pastPartForm(X) :-
    X <> [present, -target, -active, finite(participle)].

pastPart(X) :-
    pastPartForm(X),
    trigger(specified@X, (specified(X, 0) -> true; objcase(subject@X))),
    trigger(active@X, (-active@X -> addGerund(X); zero@subject@X = -)).
    
presPart(X) :-
    X <> [presPartForm, +active],
    addGerund(X).

tensedForm(X) :-
    X <> [finite(tensed)],
    -zero@subject@X,
    agree :: [X, subject@X].

tensed(X) :-
    trigger(language@X, (language@X = english -> -zero@subject@X; true)),
    X <> [tensedForm, +active, -target, vspec],
    subject@X <> subjcase.

presTenseForm(X) :-
    X <> [tensedForm, present].

presTense(X) :-
    X <> [tensed, present, aspect(simple), +specified].

pastTenseForm(X) :-
    X <> [tensedForm, past].

pastTense(X) :-
    X <> [tensed, past, aspect(simple), +specified].

edForm(X) :-
    X <> [past, -target, +active],
    -zero@subject@X,
    trigger(specified@X, (pastTense(X); partPart(X))).
edForm(X) :-
    X <> [-active, pastPart].

infinitiveForm(X) :-
    finite@X -- infinitive,
    -target@X.

infinitive(X) :-
    X <> [infinitiveForm].

toForm(X) :-
    finite@X -- to.

baseForm(X) :-
    X <> [-target, +active],
    subject@X <> [standardcase(SCASE)],
    trigger(zero@subject@X, (+zero@subject@X -> infinitive(X); true)),
    trigger(finite@X,
	    ((tensed(X), notThirdSing(X)); infinitive(X))).

subjunctive(X) :-
    mood@X -- subjunctive.

indicative(X) :-
    mood@X -- indicative.

imperative(X) :-
    mood@X -- imperative,
    X <> [second].