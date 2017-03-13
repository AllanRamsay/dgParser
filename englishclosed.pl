
word('I', X) :-
    language@X -- english,
    X <> [pronoun, subjcase, firstSing, -target, inflected].

word('a', X) :-
    language@X -- english,
    X <> [-def, +numeric, sing],
    det1(X).

word('am', X) :-
    language@X -- english,
    be(X),
    X <> [inflected, first, sing].

word('am', X) :-
    language@X -- english,
    X <> [n, -specified, -modifiable, -target].

word('another', X) :-
    language@X -- english,
    det(X),
    X <>[-def],
    args@X -- [N],
    trigger(width@N, \+ \+ number@N=sing).

word('about', X) :-
    language@X -- english,
    X <> [prep].
    
word('above', X) :- 
    language@X -- english,
    definition@X -- 'an earlier section of a written text',
    X <> [nroot].

word('above', X) :-
    language@X -- english,
    definition@X -- 'at an earlier place',
    X <> [prep].

word('after', X) :-
    language@X -- english,
    X <> [inflected],
    tempConj(X).

word('against', X) :-
    language@X -- english,
    X <> prep.

word('ago', X) :-
    language@X -- english,
    X <> [postp].

word('all', X) :-
    all(X).

word('although', X) :-
    language@X -- english,
    X <> prep.

word('am', X) :-
    language@X -- english,
    verb(X, be),
    X <> [presTense, firstSing].

word('among', X) :-
    language@X -- english,
    X <> prep.

word('an', X) :-
    language@X -- english,
    word('a', X).

word('and', X) :-
    language@X -- english,
    conj(X),
    conjoined@X -- and.

word('as', X) :-
    language@X -- english,
    X <> [cat(as), postmod, fulladjunct],
    target@X <> [vp],
    trigger(index@target@X, nonvar(index@NP)),
    args@X -- [NP],
    NP <> [np, fixedpostarg, theta(asArg)]. 

word('or', X) :-
    language@X -- english,
    conj(X),
    conjoined@X -- or.

word('any', X) :-
    language@X -- english,
    X <> [det, -def].

word('any', X) :-
    language@X -- english,
    X <> [det([NP])],
    NP <> [pp, fixedpostarg, +def, casemarked(of), theta(arg(headnoun1))].

word('anybody', X) :-
    language@X -- english,
    X <> [pronoun, standardcase, -target].

word('anyone', X) :-
    language@X -- english,
    X <> [pronoun, standardcase, -target].

word('anything', X) :-
    language@X -- english,
    X <> [pronoun, standardcase, -target].

word('anywhere', X) :-
    language@X -- english,
    definition@X -- 'at or in or to any place',
    X <> [np, casemarked(anywhere), postmod, fulladjunct],
    target@X <> [vp],
    result@X <> [compact].

word('are', X) :-
    language@X -- english,
    verb(X, be),
    X <> [presTense, plural, inflected].

word('as', X) :-
    as(X).

word('at', X) :-
    det3(X),
    args@X -- [PREDET, NUM],
    PREDET <> [adj, fixedpostarg, theta(predet)],
    trigger(root@PREDET, (root@PREDET = ['least':_]; root@PREDET = ['most':_])),
    NUM <> [det1, +numeric, fixedpostarg],
    target@X <> [n, unspecified, saturated].

word('at', X) :-
    language@X -- english,
    X <> [prep].

word('be', X) :-
    language@X -- english,
    verb(X, be),
    trigger(finite@X, \+ finite@X = tensed),
    X <> [vroot, pastTenseSuffix(-), pastPartSuffix(en)].

word('because', X) :-
    language@X -- english,
    X <> prep.

word('before', X) :-
    language@X -- english,
    X <> [prep].

word('before', X) :-
    language@X -- english,
    X <> [inflected],
    tempConj(X).

word('behind', X) :-
    language@X -- english,
    X <> [prep].

word('beside', X) :-
    language@X -- english,
    X <> [prep].

word('both', X) :-
    language@X -- english,
    X <> [det, inflected, +def, plural].

/**
word('both', X) :-
    language@X -- english,
    X <> [inflected, saturated, fulladjunct, strictpremod],
    cat@X -- either,
    target@X -- T,
    T <> [-zero],
    trigger(used@T, conjoined@T == and).
**/

word('but', X) :-
    language@X -- english,
    args@X -- [A1, _A2],
    A1 <> [s],
    conj(X),
    conjoined@X -- and.

word('by', X) :-
    language@X -- english,
    X <> [prep, inflected].

word('can', X) :-
    language@X -- english,
    X <> [aux(S), tensed, inflected],
    S <> [infinitiveForm],
    -zero@subject@S.

word('cannot', X) :-
    language@X -- english,
    X <> prep.

word('could', X) :-
    language@X -- english,
    X <> [aux(S), tensed, inflected],
    S <> [infinitiveForm],
    -zero@subject@S.

word('did', X) :-
    language@X -- english,
    verb(X, do),
    X <> [pastTense, -target, inflected].

word('do', X) :-
    language@X -- english,
    verb(X, do),
    X <> [present, -target, vroot].

word('done', X) :-
    language@X -- english,
    verb(X, do),
    X <> [pastPart, -target, inflected].

word('during', X) :-
    language@X -- english,
    X <> prep.

word('each', X) :-
    language@X -- english,
    X <> [det([NP]), thirdSing],
    NP <> [pp, fixedpostarg, +def, plural, casemarked(of), theta(arg(headnoun))].

word('each', X) :-
    language@X -- english,
    X <> [det, thirdSing].

word('either', X) :-
    language@X -- english,
    X <> [det, -def, thirdSing].

word('either', X) :-
    language@X -- english,
    X <> [cat(either), inflected, saturated, fulladjunct, strictpremod],
    target@X -- T,
    T <> [-zero],
    trigger(width@T, conjoined@T == or).

word('else', X) :-
    language@X -- english,
    X <> prep.

word('etc', X) :-
    language@X -- english,
    X <> prep.

word('every', X) :-
    language@X -- english,
    X <> [det, thirdSing].

word('everybody', X) :-
    language@X -- english,
    X <> [pronoun, standardcase, -target].

word('everyone', X) :-
    language@X -- english,
    X <> [n, saturated, standardcase, -target].

word('everything', X) :-
    language@X -- english,
    X <> [n, saturated, standardcase, -target].

word('exactly', X) :-
    X <> [cat(exactly), saturated, fulladjunct, strictpremod],
    target@X <> [det([_], +)].

word('few', X) :-
    language@X -- english,
    few(X).

word('five', X) :-
    language@X -- english,
    number(X, 5).

word('six', X) :-
    language@X -- english,
    number(X, 6).

word('seven', X) :-
    language@X -- english,
    number(X, 7).

word('eight', X) :-
    language@X -- english,
    number(X, 8).

word('nine', X) :-
    language@X -- english,
    number(X, 9).

word('ten', X) :-
    language@X -- english,
    number(X, 10).

word('eleven', X) :-
    language@X -- english,
    number(X, 11).

word('twelve', X) :-
    language@X -- english,
    number(X, 12).

word('twenty', X) :-
    language@X -- english,
    number(X, 10).

word('twice', X) :-
    language@X -- english,
    times(X, 2).

word('for', X) :-
    language@X -- english,
    X <> [prep, inflected].

word('fro', X) :-
    language@X -- english,
    X <> [prep([])].

word('from', X) :-
    language@X -- english,
    X <> [prep, inflected].

word('four', X) :-
    language@X -- english,
    number(X, 4).

word('had', X) :-
    language@X -- english,
    verb(X, have),
    X <> [past, -target, inflected].

word('half', X) :-
    language@X -- english,
    X <> [det1([NP])],
    NP <> [np].

word('has', X) :-
    language@X -- english,
    verb(X, have),
    X <> [presTense, thirdSing, inflected].

word('have', X) :-
    language@X -- english,
    verb(X, have),
    X <> [vroot, present].

word('he', X) :-
    language@X -- english,
    X <> [subjpronoun, thirdSing, -target, inflected].

word('her', X) :-
    language@X -- english,
    X <> [det, inflected, +def].

word('her', X) :-
    language@X -- english,
    X <> [objpronoun, -target, inflected].

word('here', X) :-
    language@X -- english,
    X <> [adv1(T), postmod(T), +predicative],
    T <> s,
    trigger((set:position@moved@T, start@hd@T),
	    (movedBefore(T, +) -> end@X < start@hd@T; true)).

word('herself', X) :-
    language@X -- english,
    X <> [pronoun, objcase, -target].

word('hi', X) :- 
    language@X -- english,
    definition@X -- 'an expression of greeting',
    X <> [cat(greeting), saturated, strictpremod(S), inflected],
    S <> [s].

word('him', X) :-
    language@X -- english,
    X <> [objpronoun, inflected, third, sing].

word('himself', X) :-
    language@X -- english,
    X <> [pronoun, objcase, -target].

word('his', X) :-
    language@X -- english,
    X <> [det, inflected],
    +def@result@X.

word('how', X) :-
    whmod(X).

word('if', X) :-
    language@X -- english,
    X <> [cat(if), postarg, fulladjunct, theta(condition)],
    target@X <> [s, compact],
    args@X -- [ANTECEDENT],
    ANTECEDENT <> [s, compact, fixedpostarg, theta(antecedent)].

word('in', X) :-
    language@X -- english,
    prep(X).

word('in', X) :-
    language@X -- english,
    prep(X, []),
    X <> [movedBefore(-)].

word('into', X) :-
    language@X -- english,
    X <> [prep].

word('is', X) :-
    language@X -- english,
    verb(X, be),
    X <> [presTense, thirdSing].

word('it', X) :-
    language@X -- english,
    X <> [-target, inflected],
    pronoun(X).

word('its', X) :-
    language@X -- english,
    X <> [det, inflected, +def].

word('itself', X) :-
    language@X -- english,
    X <> [objcase, -target],
    pronoun(X).

word('less', X) :-
    language@X -- english,
    X <> [det, inflected].

word('less', X) :-
    language@X -- english,
    X <> [det([THAN, NUM, NN]), inflected],
    THAN <> [cat(than), fixedpostarg, word, theta(than)],
    NUM <> [fixedpostarg, word, theta(num)],
    trigger(used@NUM, \+ \+ number(NUM, _)),
    NN <> [fixedpostarg, n, saturated, unspecified, theta(headnoun)].

word('less', X) :-
    language@X -- english,
    definition@X -- 'used to form the comparative of some adjectives and adverbs',
    X <> [adv],
    target@X <> [a].

word('least', X) :-
    language@X -- english,
    X <> [det([NP])],
    NP <> [pp, fixedpostarg, +def, casemarked(of), theta(arg(headnoun1))].

word('least', X) :-
    language@X -- english,
    X <> [det, inflected].

word('least', X) :-
    language@X -- english,
    X <> [adj, inflected].

word('many', X) :-
    language@X -- english,
    X <> [det([NP])],
    NP <> [pp, fixedpostarg, +def, casemarked(of), theta(arg(headnoun1))].

word('many', X) :-
    language@X -- english,
    X <> [det, inflected].

word('may', X) :-
    language@X -- english,
    X <> [aux(S), tensed, inflected],
    S <> [infinitiveForm],
    -zero@subject@S.

word('me', X) :-
    language@X -- english,
    X <> [pronoun, objcase, -target].

word('might', X) :-
    language@X -- english,
    X <> [aux(S), tensed, inflected],
    S <> [infinitiveForm],
    -zero@subject@S.

word('more', X) :-
    language@X -- english,
    X <> [det, inflected].

word('more', X) :-
    language@X -- english,
    X <> [det([THAN, NUM, NN]), inflected],
    THAN <> [cat(than), fixedpostarg, word, theta(than)],
    NUM <> [fixedpostarg, word, theta(num)],
    trigger(used@NUM, \+ \+ number(NUM, _)),
    NN <> [fixedpostarg, n, saturated, unspecified, theta(headnoun)].

word('more', X) :-
    language@X -- english,
    definition@X -- 'used to form the comparative of some adjectives and adverbs',
    X <> [adv],
    target@X <> [a].

word('most', X) :-
    language@X -- english,
    X <> [det([NP])],
    NP <> [pp, fixedpostarg, +def, casemarked(of), theta(arg(headnoun1))].

word('most', X) :-
    language@X -- english,
    X <> [det, inflected].

word('most', X) :-
    language@X -- english,
    X <> [adj, inflected].

word('my', X) :-
    language@X -- english,
    X <> [det, inflected, +def].

word('myself', X) :-
    language@X -- english,
    X <> [pronoun, objcase, -target].

word('neither', X) :-
    language@X -- english,
    X <> [det, -def, thirdSing].

word('no', X) :-
    language@X -- english,
    X <> [det, -def].

word('nor', X) :-
    language@X -- english,
    X <> prep.

word('not', X) :-
    language@X -- english,
    definition@X -- 'negation of a word or group of words',
    not(X).

word('o', X) :-
    language@X -- english,
    X <> [n, specified(-), -target, inflected],
    args@X -- [APOS, CLOCK],
    APOS <> [word, fixedpostarg],
    root@APOS -- ['APOS':_],
    CLOK <> [word, fixedpostarg],
    root@CLOCK -- [('clock'>''):noun].

word('of', X) :-
    language@X -- english,
    X <> [prep([NN])],
    NN <> [n, saturated, postarg],
    target@X <> noun.

word('on', X) :-
    language@X -- english,
    X <> [prep].

word('one', X) :-
    language@X -- english,
    number(X, 1).

word('one', X) :-
    language@X -- english,
    X <> [nroot(_)].

word('only', X) :-
    language@X -- english,
    X <> [cat(only), strictpremod(T), fulladjunct],
    number(T, _).

word('oneself', X) :-
    language@X -- english,
    X <> [pronoun, objcase, -target].

word('onto', X) :-
    language@X -- english,
    X <> prep.

word('other', X) :-
    language@X -- english,
    definition@X -- 'belonging to the distant past',
    X <> [nroot].

word('other', X) :-
    X <> [n, -specified, inflected, -target],
    args@X -- [NN],
    NN <> [n, +specified, fixedpostarg, saturated, theta(othercomp)].

word('our', X) :-
    language@X -- english,
    X <> [det, inflected, +def].

word('ourselves', X) :-
    language@X -- english,
    X <> [pronoun, objcase, -target].

word('out', X) :-
    language@X -- english,
    X <> [prep([])],
    target@X <> [vp].

word('out', X) :-
    language@X -- english,
    NP <> [np, casemarked(of), -zero],
    trigger(index@target@X, nonvar(index@NP)),
    prep(X, [NP]).

/*
word('out', X) :-
    language@X -- english,
    definition@X -- 'to state openly and publicly one SS homosexuality',
    X <> [vroot, regularPast],
    tverb(X).
                    
word('out', X) :- 
    language@X -- english,
    definition@X -- 'a failure by a batter or runner to reach a base safely in baseball',
    X <> [nroot, -target].
*/

word('over', X) :-
    language@X -- english,
    X <> [prep].

word('per', X) :-
    language@X -- english,
    X <> prep.

word('s', X) :-
    language@X -- english,
    X <> [det([NP]), strictprearg(NP), inflected],
    NP <> [np],
    +def@result@X.

word('several', X) :-
    language@X -- english,
    X <> [det, -def].

word('several', X) :-
    language@X -- english,
    X <> [det([NP])],
    NP <> [pp, fixedpostarg, +def, casemarked(of), theta(arg(headnoun1))].

word('she', X) :-
    language@X -- english,
    X <> [subjpronoun, thirdSing, -target].

word('should', X) :-
    language@X -- english,
    X <> [aux(S), tensed, inflected],
    S <> [infinitiveForm],
    -zero@subject@S.

word('since', X) :-
    language@X -- english,
    X <> prep.

word('so', X) :-
    language@X -- english,
    X <> [vp, infinitiveForm],
    subject@X <> [theta(subject), -zero].

word('some', X) :-
    language@X -- english,
    some(X).

word('someone', X) :-
    language@X -- english,
    X <> [pronoun, standardcase, -target].

word('something', X) :-
    language@X -- english,
    X <> [pronoun, standardcase, -target].

word('than', X) :-
    language@X -- english,
    X <> [cat(than), fixedpostmod(T), fulladjunct],
    args@X -- [NP],
    NP <> [np, fixedpostarg],
    T <> [adj],
    degree@T -- comparative.

word('that', X) :-
    language@X -- english,
    -predicative@X,
    X <> det.

word('that', X) :-
    language@X -- english,
    X <> [pronoun, -target].

word('that', X) :-
    language@X -- english,
    X <> [adjunct1, strictpremod, -comp, saturated],
    target@X -- S,
    S <> [s, tensedForm, -zero, notMoved],
    theta@X -- comp,
    end@X -- xstart@S,
    result@X -- R,
    -target@R,
    comp@R -- *(that).

/**
word('that', X) :-
    language@X -- english,
    X <> [v, -target, -predicative, -modifiable],
    comp@X -- *(that),
    args@X -- [S],
    S <> [s, tensedForm, -zero, -comp, notMoved],
    theta@S -- comp,
    end@X -- xstart@S,
    syntax@X\args\comp\hd -- syntax@S,
    dir@S <> after.
**/

word('that', X) :-
    relpronoun(X).

word('th', X) :-
    language@X -- english,
    X <> [inflected, n, -specified, -target, +predicative],
    args@X -- [N],
    N <> [fixedprearg, number(_), -zero].

word('the', X) :-
    language@X -- english,
    det(X),
    X <> [+def].

word('their', X) :-
    language@X -- english,
    X <> [det, inflected, +def].

word('theirselves', X) :-
    language@X -- english,
    X <> [pronoun, objcase, -target].

word('them', X) :-
    language@X -- english,
    X <> [objpronoun].

word('themselves', X) :-
    language@X -- english,
    X <> [pronoun, objcase, -target].

word('then', X) :-
    language@X -- english,
    X <> [prep([])],
    target@X <> [vp].

word('there', X) :-
    language@X -- english,
    X <> [prep([])],
    target@X <> [vp].

word('these', X) :-
    language@X -- english,
    X <> [pronoun, third, plural, -target].

word('they', X) :-
    language@X -- english,
    X <> [subjpronoun].

word('think', X) :-
    language@X -- english,
    X <> [sverb(S), vroot, present],
    S <> tensedForm.

word('this', X) :-
    language@X -- english,
    X <> np,
    -target@X.

word('those', X) :-
    language@X -- english,
    X <> [pronoun, third, plural, -target].

word('three', X) :-
    language@X -- english,
    number(X, 3).

word('to', X) :-
    language@X -- english,
    X <> [inflected, toForm, -target],
    COMP <> [infinitiveForm],
    aux(X, COMP),
    M <> [cat(toGerund), fulladjunct, fixedpostmod, saturated, compact, movedAfter(-)],
    target@M <> [x, saturated],
    trigger(n:xbar@cat@target@M, (n(target@M) -> (unspecified(target@M), notMoved(M)); true)),
    trigger(index@M, notMoved(M)),
    altview@M -- toAsMod,
    trigger(zero@subject@X, (+zero@subject@X -> addExternalView(X, M))).

word('to', X) :-
    language@X -- english,
    X <> [inflected],
    prep(X).

word('too', X) :-
    language@X -- english,
    X <> [adv, inflected].

word('toward', X) :-
    language@X -- english,
    X <> prep.

word('towards', X) :-
    language@X -- english,
    X <> prep.

word('two', X) :-
    language@X -- english,
    number(X, 2).

word('until', X) :-
    language@X -- english,
    X <> prep.

word('up', X) :-
    language@X -- english,
    X <> [prep].

word('upon', X) :-
    language@X -- english,
    X <> prep.

word('us', X) :-
    language@X -- english,
    X <> [objpronoun, second, plural].

word('very', X) :-
    language@X -- english,
    start@T -- end@X,
    tag@X -- adverb,
    X <> [adv1(T), premod(T)],
    T <> [a].

word('via', X) :-
    language@X -- english,
    X <> prep.

word('was', X) :-
    language@X -- english,
    verb(X, be),
    X <> [pastTense, sing, inflected].

word('were', X) :-
    language@X -- english,
    verb(X, be),
    X <> [pastTense, plural, inflected].

word('what', X) :-
    language@X -- english,
    X <> [whpronoun(WH)],
    WH <> [np, -target].

word('whatever', X) :-
    language@X -- english,
    X <> [whpronoun(WH)],
    WH <> [np, -target].

word('when', X) :-
    whmod(X).

word('whenever', X) :-
    whmod(X),
    target@X <> [s].

word('where', X) :-
    whmod(X).

word('whereby', X) :-
    language@X -- english,
    X <> prep.

word('wherein', X) :-
    language@X -- english,
    X <> prep.

word('wherever', X) :-
    whmod(X).

word('whether', X) :-
    language@X -- english,
    X <> prep.

word('which', X) :-
    language@X -- english,
    X <> [det],
    [start, end] :: [X, WH],
    wh@X -- [WH | _],
    WH <> [s, -target].

word('which', X) :-
    relpronoun(X).

word('while', X) :-
    language@X -- english,
    X <> prep([S]),
    S <> [s, tensedForm, -zero, fixedpostarg],
    target@X <> [vp].

word('who', X) :-
    language@X -- english,
    relpronoun(X).

word('whom', X) :-
    language@X -- english,
    relpronoun(X),
    X <> [objcase].

word('whose', X) :-
    language@X -- english,
    X <> [det, inflected],
    setWHItem(X).

word('why', X) :-
    whmod(X).

word('will', X) :-
    language@X -- english,
    X <> [aux(S), tensed, inflected],
    S <> [infinitiveForm],
    -zero@subject@S.

word('with', X) :-
    language@X -- english,
    X <> [prep].

word('within', X) :-
    language@X -- english,
    X <> [prep].

word('without', X) :-
    language@X -- english,
    X <> prep.

word('would', X) :-
    language@X -- english,
    X <> [aux(S), tensed, inflected],
    S <> [infinitiveForm],
    -zero@subject@S.

word('you', X) :-
    language@X -- english,
    X <> [second, plural, -target],
    pronoun(X).

word('your', X) :-
    language@X -- english,
    X <> [det, inflected, +def].

word('yourself', X) :-
    language@X -- english,
    X <> [pronoun, objcase, -target].

word('.', X) :-
    language@X -- english,
    cat@X -- utterance,
    tag@X -- punct,
    X <> [+specified, -target],
    args@X -- [S],
    S <> [x, saturated, fixedprearg, tensedForm, theta(THETAS), +specified, compact],
    trigger(v:xbar@cat@S, (v(S) -> THETAS = claim; THETAS = frag)),
    start@S -- 0.

word('?', X) :-
    language@X -- english,
    cat@X -- utterance,
    -target@X,
    args@X -- [S],
    S <> [x, saturated, -zero, prearg, tensedForm, theta(THETAS)],
    trigger(SV, (v(S) -> THETAS = query; THETAS = frag)),
    start@S -- 0.

word(',', X) :-
    language@X -- english,
    comma(X).

word('#', X) :-
    language@X -- english,
    cat@X -- hash,
    X <> [fixedpostmod, adjunct],
    target@X <> [n, unspecified],
    result@X <> [specified],
    args@X -- [N],
    N <> [number(_), fixedpostarg, theta(numberAsId)].

word(':', X) :-
    cat@X -- punct,
    X <> [saturated, strictpostmod(T), inflected, fulladjunct],
    T <> [x, saturated].

word('-', X) :-
    cat@X -- punct,
    X <> [saturated, strictpostmod, inflected, adjunct1, theta(dash)],
    target@X -- T,
    result@X -- R,
    T <> [x, saturated, word],
    [syntax\hd\target] :: [R, T],
    [syntax, moved, dir] :: [target@R, target@T].

word('May', X) :-
    language@X -- english,
    month(X).

word('APOS', X) :-
    word('SSS', X).

word('SSS', X) :-
    X <> [specified(+)],
    det(X, [OWNER, THING]),
    OWNER <> [np, fixedprearg, theta(arg(owner)), compact, -zero],
    THING <> [n, unspecified, fixedpostarg, theta(arg(headnoun)), saturated],
    trigger((xstart@OWNER, xend@OWNER), (C is (xend@OWNER-xstart@OWNER)*0.2, incCost(X, C))).

:- include(englishaffixes).

