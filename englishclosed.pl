
word('I', X) :-
    language@X -- english,
    X <> [subjpronoun, firstSing, -target, inflected].

word('European', X) :-
    language@X -- english,
    X <> [nroot].

word('a', X) :-
    language@X -- english,
    aa(X).

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
    be(X),
    X <> [inflected, first, sing].

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

word('another', X) :-
    language@X -- english,
    word('a', X).

word('and', X) :-
    language@X -- english,
    conj(X),
    conjoined@X -- and.

word('another', X) :-
    language@X -- english,
    det(X, 10),
    X <>[-def],
    args@X -- [N],
    trigger(width@N, \+ \+ number@N=sing).

word('any', X) :-
    language@X -- english,
    any(X).

word('or', X) :-
    language@X -- english,
    conj(X),
    conjoined@X -- or.

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
    det3(X, 10),
    target@X <> [-zero],
    args@X -- [PREDET, NUM],
    PREDET <> [word, fixedpostarg, theta(predet), adv],
    trigger(root@PREDET, (root@PREDET = ['least':_]; root@PREDET = ['most':_])),
    NUM <> [det1(_), +numeric, fixedpostarg, theta(num)],
    target@X <> [n, -specified, saturated],
    trigger(index@target@X, nonvar(index@NUM)).

word('at', X) :-
    language@X -- english,
    prep(X).

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

word('best', X) :-
    language@X -- english,
    definition@X -- 'having the most positive qualities',
    X <> [aroot].
                    
word('best', X) :- 
    language@X -- english,
    definition@X -- 'the supreme effort one can make',
    X <> [nroot, -target].

word('best', X) :-
    language@X -- english,
    definition@X -- 'in a most excellent way or manner',
    X <> [adv].

word('best', X) :-
    language@X -- english,
    definition@X -- 'get the better of',
    X <> [vroot, regularPast],
    tverb(X).

word('both', X) :-
    language@X -- english,
    X <> [det(11), inflected, +def, plural].

/**
word('both', X) :-
    language@X -- english,
    X <> [inflected, saturated, fulladjunct, strictpremod],
    cat@X -- either,
    target@X -- T,
    T <> [-zero],
    trigger(used@T, conjoined@T == and).
**/

word('broke', X) :-
    language@X -- english,
    X <> [adj].

word('broke', X) :-
    X <> [verb, pastTense],
    uverb(X).

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
    verb(X, can).

/**
word('can', X) :-
    language@X -- english,
    X <> [nroot].
**/

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
    standardDet(X).

word('either', X) :-
    language@X -- english,
    X <> [det(10), -def, thirdSing].

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
    every(X).

word('exactly', X) :-
    X <> [cat(exactly), saturated, fulladjunct, strictpremod],
    target@X <> [det1(_), saturated].

word('few', X) :-
    language@X -- english,
    few(X).

word('five', X) :-
    language@X -- english,
    number(X, 5).

word('former', X) :-
    language@X -- english,
    X <> [adj].

word('former', X) :-
    language@X -- english,
    X <> [nroot].

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
    X <> [past, -target, inflected],
    edForm(X).

word('half', X) :-
    language@X -- english,
    X <> [det1(10)],
    standardDet(X).

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
    X <> [det(10), inflected, +def].

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
    X <> [objpronoun, -target].

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
    X <> [objpronoun, -target].

word('his', X) :-
    language@X -- english,
    possessive(X).

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
    X <> [movedBefore(-)],
    target@X <> [s].

word('into', X) :-
    language@X -- english,
    X <> [prep].

word('is', X) :-
    language@X -- english,
    verb(X, be),
    -target@X,
    X <> [presTense, thirdSing, inflected].

word('it', X) :-
    language@X -- english,
    X <> [pronoun, -target, inflected].

word('its', X) :-
    language@X -- english,
    X <> [det(10), inflected, +def].

word('itself', X) :-
    language@X -- english,
    X <> [-target],
    objpronoun(X).

word('less', X) :-
    less(X).

word('less', X) :-
    language@X -- english,
    definition@X -- 'used to form the comparative of some adjectives and adverbs',
    X <> [adv],
    target@X <> [a].

word('least', X) :-
    language@X -- english,
    X <> [adj, inflected].

word('like', X) :-
    language@X -- english,
    prep(X).

word('like', X) :-
    language@X -- english,
    X <> [vroot],
    uverb(X).

word('many', X) :-
    language@X -- english,
    many(X).

word('may', X) :-
    language@X -- english,
    X <> [aux(S), tensed, inflected],
    S <> [infinitiveForm],
    -zero@subject@S.

word('me', X) :-
    language@X -- english,
    X <> [objpronoun, -target].

word('might', X) :-
    language@X -- english,
    verb(X, might).

word('more', X) :-
    language@X -- english,
    X <> [det(8), inflected],
    standardDet(X).

/**
word('more', X) :-
    language@X -- english,
    X <> [det([THAN, NUM, NN]), inflected],
    THAN <> [cat(than), fixedpostarg, word, theta(than)],
    NUM <> [fixedpostarg, word, theta(num)],
    trigger(used@NUM, \+ \+ number(NUM, _)),
    NN <> [fixedpostarg, n, saturated, unspecified, theta(headnoun)].
**/

word('more', X) :-
    language@X -- english,
    definition@X -- 'used to form the comparative of some adjectives and adverbs',
    X <> [adv],
    target@X <> [a].

word('most', X) :-
    language@X -- english,
    most(X).

word('my', X) :-
    language@X -- english,
    X <> [det(10), inflected],
    result@X <> [+def].

word('myself', X) :-
    language@X -- english,
    X <> [objpronoun, -target].

word('neither', X) :-
    language@X -- english,
    X <> [det(10), -def, thirdSing].

word('no', X) :-
    language@X -- english,
    no(X).

word('none', X) :-
    language@X -- english,
    none(X).

word('nor', X) :-
    language@X -- english,
    X <> prep.

word('not', X) :-
    language@X -- english,
    not(X).

word('now', X) :-
    language@X -- english,
    X <> [np, fulladjunct, premod, objcase],
    target@X <> [s, -zero].

word('o', X) :-
    language@X -- english,
    X <> [n, unspecified, -target, inflected],
    args@X -- [APOS, CLOCK],
    APOS <> [word, fixedpostarg],
    root@APOS -- ['APOS':_],
    CLOK <> [word, fixedpostarg],
    root@CLOCK -- [('clock'>''):noun].

word('of', X) :-
    language@X -- english,
    prep(X),
    target@X <> [n].

word('on', X) :-
    language@X -- english,
    prep(X).

word('one', X) :-
    language@X -- english,
    number(X, 1).

word('one', X) :-
    language@X -- english,
    X <> [nroot, -target].

word('only', X) :-
    language@X -- english,
    X <> [cat(only), strictpremod(T), fulladjunct],
    number(T, _).

word('oneself', X) :-
    language@X -- english,
    X <> [objpronoun, -target].

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
    X <> [det(10), inflected, +def].

word('ourselves', X) :-
    language@X -- english,
    X <> [objpronoun, -target].

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

word('outside', X) :-
    language@X -- english,
    prep(X).

word('over', X) :-
    language@X -- english,
    X <> [prep].

word('own', X) :-
    language@X -- english,
    X <> [vroot],
    uverb(X).

word('own', X) :-
    language@X -- english,
    X <> [adj].

word('per', X) :-
    language@X -- english,
    X <> prep.

/**
word('s', X) :-
    language@X -- english,
    X <> [det([NP]), strictprearg(NP), inflected],
    NP <> [np],
    +def@result@X.
**/

word('same', X) :-
    language@X -- english,
    X <> [adj].

word('several', X) :-
    language@X -- english,
    X <> [det1(10), -def],
    standardDet(X).

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
    X <> [subjobjpronoun, standardcase, -target].

word('something', X) :-
    language@X -- english,
    X <> [subjobjpronoun, standardcase, -target].

word('than', X) :-
    language@X -- english,
    X <> [cat(than), fixedpostmod(T), fulladjunct],
    args@X -- [NP],
    NP <> [np, fixedpostarg],
    T <> [adj],
    degree@T -- comparative.

word('that', X) :-
    language@X -- english,
    det2(X, 10),
    target@X <> [standardcase],
    result@X <> [third, sing, +def].

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
    the(X).

word('their', X) :-
    language@X -- english,
    X <> [det(10), inflected, +def].

word('theirselves', X) :-
    language@X -- english,
    X <> [objpronoun, -target].

word('them', X) :-
    language@X -- english,
    X <> [objpronoun].

word('themselves', X) :-
    language@X -- english,
    X <> [objpronoun, -target].

word('then', X) :-
    language@X -- english,
    X <> [prep([])],
    target@X <> [vp].

word('there', X) :-
    language@X -- english,
    X <> [prep([])],
    target@X <> [vp].

word('there', X) :-
    language@X -- english,
    X <> [saturated, -target, casemarked(*(_)), -predicative],
    cat@X -- there.

word('these', X) :-
    language@X -- english,
    det2(X, 10),
    target@X <> [standardcase],
    result@X <> [third, plural, +def].

word('they', X) :-
    language@X -- english,
    X <> [subjpronoun].

word('this', X) :-
    language@X -- english,
    det2(X, 10),
    target@X <> [standardcase],
    result@X <> [third, sing, +def].

word('those', X) :-
    language@X -- english,
    X <> [subjobjpronoun, third, plural, -target].

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
    end@target@M -- start@X,
    trigger(n:xbar@cat@target@M, (n(target@M) -> (unspecified(target@M), notMoved(M)); true)),
    trigger(index@M, notMoved(M)),
    altview@M -- toAsMod,
    trigger(zero@subject@X, ((+zero@subject@X, -zero@COMP) -> addExternalView(X, M))),
    [subject] :: [X, COMP].

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
    X <> [adv1(T), premod(T)],
    T <> [a].

word('via', X) :-
    language@X -- english,
    X <> prep.

word('was', X) :-
    language@X -- english,
    verb(X, be),
    X <> [pastTense, sing, inflected].

word('we', X) :-
    language@X -- english,
    X <> [subjpronoun, first, plural, -target, inflected].

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
    X <> [det(10)],
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
    X <> [det(10), inflected],
    setWHItem(X).

word('why', X) :-
    whmod(X).

word('will', X) :-
    language@X -- english,
    verb(X, will).

word('with', X) :-
    language@X -- english,
    prep(X).

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
    subjobjpronoun(X).

word('your', X) :-
    language@X -- english,
    X <> [det(10), inflected, +def].

word('yourself', X) :-
    language@X -- english,
    X <> [objpronoun, -target].

word('.', X) :-
    language@X -- english,
    cat@X -- utterance,
    X <> [-target],
    args@X -- [S],
    S <> [x, saturated, fixedprearg, tensedForm, theta(THETAS), compact],
    trigger(v:xbar@cat@S, (v(S) -> THETAS = claim; THETAS = frag)),
    start@S -- 0.

word('?', X) :-
    language@X -- english,
    cat@X -- utterance,
    X <> [-target],
    args@X -- [S],
    S <> [x, saturated, fixedprearg, tensedForm, theta(THETAS), compact],
    trigger(v:xbar@cat@S, (v(S) -> THETAS = query; THETAS = frag)),
    start@S -- 0.

word(',', X) :-
    language@X -- english,
    comma(X).

/**
word('#', X) :-
    language@X -- english,
    cat@X -- hash,
    X <> [fixedpostmod, adjunct],
    target@X <> [n, unspecified],
    result@X <> [specified],
    args@X -- [N],
    N <> [number(_), fixedpostarg, theta(numberAsId)].
  **/

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
    X <> [specified],
    det3(X),
    -zero@target@X,
    +specified@result@X,
    args@X -- [OWNER],
    OWNER <> [np, fixedprearg, theta(arg(owner)), compact, -zero],
    trigger(index@target@X, nonvar(index@OWNER)),
    trigger((xstart@OWNER, xend@OWNER), (C is (xend@OWNER-xstart@OWNER)*0.2, incCost(X, C))).

word('ORD', X) :-
    language@X -- english,
    X <> [adj].

word('AJ', X) :-
    language@X -- english,
    X <> [aroot].

word('AV', X) :-
    language@X -- english,
    X <> [adv].

word('NN', X) :-
    language@X -- english,
    X <> [nroot].

word('NN1', X) :-
    word('NN', X).

word('NN2', X) :-
    word('NN', X).

word('VV', X) :-
    language@X -- english,
    X <> [vroot],
    uverb(X).

word('CRD', X) :-
    language@X -- english,
    number(X, _).

word('PRP', X) :-
    language@X -- english,
    X <> [prep].
    
:- include(englishaffixes).

