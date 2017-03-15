verb(X, be) :-
    root@X -- [be],
    language@X -- english,
    PRED <> [+predicative, -zero, specified, saturated, postarg],
    theta@PRED -- predication,
    trigger(set:position@moved@PRED, (movedBefore(PRED) -> \+ (n(PRED), subjcase(PRED)); true)),
    X <> [+invertsubj],
    tverb(X, PRED).

verb(X, be) :-
    root@X -- [be],
    language@X -- english,
    trigger((finite@X, tense@X), \+ presPartForm(X)),
    finite@COMP -- participle,
    tense@COMP -- present,
    aux(X, COMP).

verb(X, begin) :-
    X <> [sverb(S)],
    S <> [toForm],
    +zero@subject@S.

verb(X, begin) :-
    tverb(X).

verb(X, buy) :-
    tverb(X).

verb(X, come) :-
    X <> [+active],
    tverb(X, ADJ),
    ADJ <> [a, theta(cost)],
    root@ADJ -- [(cheap>_):adj].

verb(X, come) :-
    iverb(X).

verb(X, do) :-
    aux(X, S),
    X <> [tensedForm],
    S <> [infinitiveForm].

verb(X, do) :-
    tverb(X).

verb(X, do) :-
    tverb(X, ADV),
    ADV <> [adv, theta(quality)].

verb(X, expect) :-
    X <> [sverb(S)],
    S <> [tensedForm].

verb(X, expect) :-
    X <> [sverb(S)],
    S <> [toForm].

verb(X, expect) :-
    tverb(X).

verb(X, get) :-
    S <> [-active, pastPartForm],
    sverb(X, S).

verb(X, get) :-
    tverb(X).

verb(X, have) :-
    aux(X, S),
    S <> [pastPart].

verb(X, have) :-
    tverb(X).
 
verb(X, have) :-
    sverb(X, S),
    S <> [s, -active, presPartForm].

verb(X, have) :-
    sverb(X, S),
    S <> [s, toForm],
    +zero@subject@S.

verb(X, make) :-
    tverb(X).

verb(X, meet) :-
    iverb(X),
    subject@X <> [plural].

verb(X, meet) :-
    tverb(X).

verb(X, use) :-
    aux(X, COMP),
    COMP <> [toForm].

verb(X, win) :-
    tverb(X).

verb(X, write) :-
    tverb(X).
verb(X, write) :-
    COMP <> [tensedForm],
    sverb(X, COMP).
