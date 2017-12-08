
/*
verb(X, be) :-
    root@X -- [be],
    language@X -- english,
    X <> [+invertsubj],
    cat@THERE -- there,
    NP <> [np, theta(exists)],
    tverb(X, THERE, NP, 'VB').
*/
  
verb(X, be) :-
    root@X -- [be],
    language@X -- english,
    PRED <> [+predicative, -zero, saturated, postarg],
    theta@PRED -- predication(cat@PRED),
    trigger(set:position@moved@PRED, (movedBefore(PRED) -> \+ (n(PRED), subjcase(PRED)); true)),
    trigger(start@subject@X, \+ (start@PRED > start@X, start@subject@X > start@PRED)),
    trigger(start@subject@X, \+ (start@subject@X > end@X)),
    X <> [+invertsubj],
    %% [agree] :: [X, PRED],
    tverb(X, PRED, 'VB').

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
    uverb(X).

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
    tverb(X, ADV, 'VD'),
    ADV <> [adv, theta(quality)].

verb(X, can) :-
    modal(X, S),
    X <> [inflected, presTense],
    S <> [infinitiveForm],
    -zero@subject@S.

verb(X, might) :-
    modal(X, S),
    X <> [inflected, presTense],
    S <> [infinitiveForm],
    -zero@subject@S.

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
    X <> [+specified, +def],
    S <> [pastPart].

verb(X, have) :-
    tverb(X, 'VH').

/*
verb(X, have) :-
    sverb(X, S),
    S <> [s, -active, presPartForm].

verb(X, have) :-
    sverb(X, S),
    S <> [s, toForm, -aux],
    +zero@subject@S.
*/

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

verb(X, will) :-
    aux(X, S),
    X <> [tensed, +specified, future, -def],
    S <> [infinitiveForm].

verb(X, win) :-
    tverb(X).

verb(X, write) :-
    tverb(X).
verb(X, write) :-
    COMP <> [tensedForm],
    sverb(X, COMP).
