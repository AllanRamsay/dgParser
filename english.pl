
word('ing', X) :-
    language@X -- english,
    X <> [suffix(tns), presPart, inflected].

word('s', X) :-
    language@X -- english,
    -target@X,
    X <> [suffix(tns), presTense, thirdSing, inflected].

word('', X) :-
    language@X -- english,
    X <> [suffix(tns), inflected],
    baseForm(X).

word('s', X) :-
    language@X -- english,
    X <> [suffix(numPerson), third, plural, inflected, -target, notprepcase, -def, +unspecified].

word('', X) :-
    language@X -- english,
    X <> [suffix(numPerson), thirdSing, inflected, specified(-), strictpremod],
    target@X <> [n, +unspecified, -specified].

word('ed', X) :-
    language@X -- english,
    -target@X,
    X <> [suffix(tns), past, tensed, inflected].
    
word('.', X) :-
    theta@X -- utterance,
    args@X -- [S],
    S <> [s, specified(+)].

word(a, X) :-
    language@X -- english,
    X <> [det, thirdSing],
    -def@result@X.

word(all, X) :-
    language@X -- english,
    X <> [det, thirdPlural],
    -def@result@X.

word(all, X) :-
    language@X -- english,
    X <> [n, specified(+), unspecified(-), -target, -def],
    args@X -- [NP],
    dir@NP <> after,
    NP <> [np, +def, -moved, -zero],
    trigger(case@NP, (notprepcase(NP); casemarked(NP, of))).

word(an, X) :-
    language@X -- english,
    X <> [det, thirdSing],
    -def@result@X.

word(and, X) :-
    language@X -- english,
    X <> [conj].

word(are, X) :-
    language@X -- english,
    be(X),
    X <> [presTense, plural, inflected].

word(every, X) :-
    language@X -- english,
    X <> [det, thirdPlural].

word(be, X) :-
    language@X -- english,
    be(X),
    X <> [baseForm].

word(be, X) :-
    language@X -- english,
    be(X),
    X <> [vroot].

word(been, X) :-
    language@X -- english,
    be(X),
    X <> [pastPart].

word(believe, X) :-
    language@X -- english,
    X <> [sverb(S), vroot],
    S <> tensedForm.

word(by, X) :-
    language@X -- english,
    X <> [prep, inflected].

word(every, X) :-
    language@X -- english,
    X <> [det, thirdSing].

word(for, X) :-
    language@X -- english,
    X <> [prep, inflected].

word(had, X) :-
    language@X -- english,
    have(X),
    X <> [past, -target, inflected].

word(has, X) :-
    language@X -- english,
    have(X),
    X <> [presTense, thirdSing].

word(have, X) :-
    language@X -- english,
    have(X),
    X <> [presTense, notThirdSing].
    
word(he, X) :-
    language@X -- english,
    X <> [pronoun, subjcase, thirdSing, -target].

word(her, X) :-
    language@X -- english,
    X <> [objpronoun, -target, inflected].

word(her, X) :-
    language@X -- english,
    X <> [det, inflected],
    +def@result@X.

word(him, X) :-
    language@X -- english,
    X <> [objpronoun, inflected].

word(his, X) :-
    language@X -- english,
    X <> [det, inflected],
    +def@result@X.

word('I', X) :-
    language@X -- english,
    X <> [subjpronoun, firstSing, inflected].

word('John', X) :-
    language@X -- english,
    X <> [np, thirdSing, -target].

word(in, X) :-
    language@X -- english,
    X <> [prep].

word(is, X) :-
    language@X -- english,
    be(X),
    X <> [presTense, thirdSing].

word(it, X) :-
    language@X -- english,
    X <> [pronoun, -target].

word('London', X) :-
    language@X -- english,
    X <> [np, -target].

word(me, X) :-
    language@X -- english,
    X <> [pronoun, objcase, -target].

word(most, X) :-
    language@X -- english,
    X <> [det, inflected],
    target@X <> saturated,
    -def@result@X.

word(most, X) :-
    language@X -- english,
    X <> [n, specified(+), unspecified(-), -target],
    args@X -- [NP],
    dir@NP <> after,
    NP <> [np, +def, casemarked(of), -moved].

word(my, X) :-
    language@X -- english,
    X <> [det, inflected],
    target@X <> saturated,
    +def@result@X.

word(of, X) :-
    language@X -- english,
    X <> [prep],
    target@X <> noun.

word(on, X) :-
    language@X -- english,
    X <> [prep].

word(she, X) :-
    language@X -- english,
    X <> [pronoun, subjcase, thirdSing, -target].

word(some, X) :-
    language@X -- english,
    X <> det,
    -def@result@X.

word(that, X) :-
    language@X -- english,
    X <> [v, -target, -predicative, -modifiable],
    comp@X -- *(that),
    args@X -- [S],
    S <> [s, tensedForm, -zero],
    -comp@S,
    -moved@S,
    theta@S -- comp,
    end@X -- xstart@S,
    syntax@X\args\comp\hd -- syntax@S,
    dir@S <> after.

word(that, X) :-
    language@X -- english,
    -predicative@X,
    X <> det.

word(that, X) :-
    language@X -- english,
    X <> [np, -target, +pronominal].

word(that, X) :-
    language@X -- english,
    X <> [np],
    -target@X,
    wh@X -- [WH | _],
    [start, end] :: [X, WH],
    language@WH -- english,
    cat@WH -- whclause,
    WH <> [saturated, adjunct, -modifiable, compact],
    dir@target@WH <> before,
    -moved@target@WH,
    end@target@WH -- start@X,
    modified@result@WH -- 1.5,
    spec :: [target@WH, result@WH],
    target@WH <> noun,
    trigger(index@target@WH, theta@WH=rcmod).

word(the, X) :-
    language@X -- english,
    X <> [det, inflected],
    target@X <> saturated,
    +def@result@X.

word(them, X) :-
    language@X -- english,
    X <> [objpronoun].

word(there, X) :-
    language@X -- english,
    X <> adv(T),
    T <> s.

word(they, X) :-
    language@X -- english,
    X <> [subjpronoun].

word(think, X) :-
    language@X -- english,
    X <> [sverb(S), vroot, present],
    S <> tensedForm.

word(this, X) :-
    language@X -- english,
    X <> np,
    -target@X.

word(to, X) :-
    language@X -- english,
    X <> [prep, inflected].

toAsMod(X, S) :-
    nonvar(index@S),
    +zero@subject@S,
    theta@X -- toMod,
    -moved@X,
    start@X -- end@target@X,
    (noun(target@X); s(target@X)),
    var(shifted@X),
    incCost(target@X, 1).

word(to, X) :-
    language@X -- english,
    X <> [v, toForm, fulladjunct, inflected],
    comp@X -- *(to),
    args@X -- [S],
    theta@S -- comp,
    target@X <> [x, saturated],
    dir@target@X <> before,
    trigger(index@target@X, toAsMod(X, S)),
    S <> [s, infinitive, -zero, -comp, specified(+)],
    syntax@X\args\comp\hd\finite\mod -- syntax@S,
    end@subject@X -- start@X,
    dir@S <> after.

word(very, X) :-
    language@X -- english,
    start@T -- end@X,
    X <> adv(T),
    T <> a.

word(was, X) :-
    language@X -- english,
    be(X),
    X <> [pastTense, inflected].

word(what, X) :-
    language@X -- english,
    X <> [np, whpronoun],
    -target@X.
 
word(which, X) :-
    fail,
    language@X -- english,
    X <> det,
    wh@X -- [WH | _],
    WH <> s.

word(which, X) :-
    language@X -- english,
    X <> [np],
    -target@X,
    wh@X -- [WH | _],
    language@WH -- english,
    WH <> [saturated, fulladjunct, -modifiable, strictpostmod, compact],
    cat@WH -- whclause,
    end@target@WH -- start@X,
    modified@result@WH -- 2.5,
    target@WH <> [n, +unspecified],
    trigger(index@target@WH, theta@WH=rcmod).

word(who, X) :-
    language@X -- english,
    X <> [np, inflected],
    [start, end] :: [X, WH],
    -target@X,
    wh@X -- [WH | _],
    language@WH -- english,
    WH <> [np, adjunct, -modifiable, compact],
    dir@target@WH <> before,
    -moved@target@WH,
    end@target@WH -- start@X,
    modified@result@WH -- 1.5,
    spec :: [target@WH, result@WH],
    target@WH <> noun,
    trigger(index@target@WH, theta@WH=rcmod).

word(with, X) :-
    language@X -- english,
    X <> [prep].

word(you, X) :-
    language@X -- english,
    X <> [pronoun, second, plural, -target].

:- include(closed).