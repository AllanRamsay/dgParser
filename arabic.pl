:- include(closed).

word('%', X) :-
    language@X -- arabic,
    noun(X),
    -def@X.

word('..', X) :-
    tag@X -- 'MPUNC',
    X <> [saturated, fulladjunct, strictpostmod],
    theta@X -- ellip,
    -predicative@X,
    cat@X -- ellip.

word('...', X) :-
    tag@X -- 'MPUNC',
    X <> [saturated, fulladjunct, strictpostmod],
    theta@X -- ellip,
    -predicative@X,
    cat@X -- ellip.

word('....', X) :-
    tag@X -- 'MPUNC',
    X <> [saturated, fulladjunct, strictpostmod],
    theta@X -- ellip,
    cat@X -- ellip.

word('#', X) :-
    language@X -- arabic,
    X <> [hashtag].

word(':', X) :-
    language@X -- arabic,
    cat@X -- colon,
    args@X -- [COMP],
    X <> [strictpostarg(COMP), strictpostmod, adjunct],
    COMP <> [s, compact, fulladjunct],
    theta@COMP -- comp,
    target@X <> [s, compact],
    trigger(index@target@X,
	    (nonvar(index@COMP), theta@X -- colonmod)).

word('-', X) :-
    language@X -- arabic,
    cat@X -- closingDash,
    X <> [saturated, -target].

word('-', X) :-
    language@X -- arabic,
    cat@X -- openingDash,
    args@X -- [P, CDASH],
    P <> [x, saturated, compact],
    X <> [fulladjunct, strictpostarg(P)],
    theta@P -- parenthetical,
    start@CDASH -- end@P,
    cat@CDASH -- closingDash,
    dir@CDASH <> after,
    -moved@CDASH,
    theta@CDASH -- closer,
    target@X <> [x, saturated],
    trigger(index@target@X, nonvar(index@CDASH)),
    theta@X -- parmod.

word('>nA', X) :-
    language@X -- arabic,
    subjpronoun(X),
    X <> [-modifiable],
    setresumption(X).

word('>nt', X) :-
    language@X -- arabic,
    subjpronoun(X).

word('A', X) :-
    X <> [posttensemarker, first].

%% Imperative
word('A', X) :-
    X <> [pretensemarker, second].

%% Indicative
word('wA', X) :-
    X <> [posttensemarker, third, plural].

%% Imperative
word('wA', X) :-
    X <> [posttensemarker, second, plural].

/**
word('Aby', X) :-
    X <> [first, present],
    uverb(X),
    -target@X.
   **/

word('Aby', X) :-
    word('VB', X),
    X <> first.

word('>by', X) :-
    word('VB', X),
    X <> first.

word('Al', X) :-
    X <> [det, third],
    -def@target@X,
    +def@result@X.

word('AlHyn', X) :-
    language@X -- arabic,
    X <> [p, saturated],
    target@X <> s,
    theta@X -- ppmod.
    
word('AnA', X) :-
    language@X -- arabic,
    subjpronoun(X).

word('AnY', X) :-
    language@X -- arabic,
    subjpronoun(X).

word('Ant', X) :-
    language@X -- arabic,
    subjpronoun(X).

word('HynmA', X) :-
    word('WRB', X).

word('fy', X) :-
    language@X -- arabic,
    prep(X).

word('hAy', X) :-
    language@X -- arabic,
    subjpronoun(X),
    setresumption(X).

word('hw', X) :-
    language@X -- arabic,
    subjpronoun(X).

/**
word('lA', X) :-
    language@X -- arabic,
    tag@X -- 'PRP',
    subjpronoun(X).
  **/

word('lh', X) :-
    language@X -- arabic,
    subjpronoun(X).

word('lhm', X) :-
    language@X -- arabic,
    subjpronoun(X).

word('lk', X) :-
    language@X -- arabic,
    subjpronoun(X).

word('lkm', X) :-
    language@X -- arabic,
    subjpronoun(X).

word('lnA', X) :-
    language@X -- arabic,
    subjpronoun(X).

word('fyh', X) :-
    language@X -- arabic,
    X <> [np, -case, +def],
    trigger(moved@X, \+ moved@X = after),
    -target@X,
    setnpred(X).

%% This isn't an NP, it's a PP or an adverb or something like that.
word('wyn', X) :-
    language@X -- arabic,
    X <> [adv, saturated, +predicative],
    whmod(X, WH),
    WH <> [strictpostmod, -predicative].

word('mty', X) :-
    language@X -- arabic,
    whpron(X, WH),
    position :: [X, WH],
    WH <> [np, adjunct, strictpostmod],
    theta@WH -- advmod,
    -predicative@WH,
    target@WH <> [n, saturated],
    result@WH <> [n, saturated].

word('mfy$', X) :-
    X <> [verb],
    -target@X,
    args@X -- [SUBJ, ADJ, MN],
    SUBJ <> [np],
    dir@SUBJ <> after,
    +zero@SUBJ,
    theta@SUBJ -- dummy,
    ADJ <> [adj],
    -zero@ADJ,
    theta@ADJ -- comp,
    dir@ADJ <> after,
    -moved@ADJ,
    MN <> [pp],
    dir@MN <> after,
    -zero@MN,
    theta@MN -- sup,
    surface@MN -- mn,
    -moved@MN.

word('mn', X) :-
    language@X -- arabic,
    prep(X).

word('ymA', X) :-
    language@X -- arabic,
    trigger(start@X, start@X = 0),
    X <> vocative.

word('mAmA', X) :-
    language@X -- arabic,
    trigger(start@X, (start@X = 0 -> vocative(X); word('NN', X))).

word('yA', X) :-
    language@X -- arabic,
    cat@X -- vocative,
    args@X -- [N],
    N <> [n, saturated],
    X <> [adjunct, strictpostmod, strictpostarg(N)],
    theta@X -- voc,
    theta@N -- addressee,
    target@X <> s,
    trigger(index@target@X, nonvar(index@N)).

word('mA', X) :-
    language@X -- arabic,
    cat@X -- negationMarker,
    X <> [saturated, adjunct],
    result@X <> compact,
    theta@X -- negated,
    target@X <> [s].

word('lA', X) :-
    language@X -- arabic,
    cat@X -- sentenceMarker,
    X <> [-modifiable, saturated, fulladjunct],
    xstart@target@X -- end@X,
    theta@X -- negationMarker,
    target@X <> [s, imperative].
    
word('<y', X) :-
    language@X -- arabic,
    cat@X -- sentenceMarker,
    X <> [saturated, adjunct, strictpremod],
    theta@X -- affirm,
    xstart@target@X -- end@X,
    target@X <> [x, saturated, +terminal, compact].

word('w', X) :-
    language@X -- arabic,
    X <> [x, -target, indicative, strictpostarg(X2)],
    args@X -- [X1, X2],
    head\hd :: [X, X1, X2],
    theta@X1 -- conj1,
    X1 <> [x, compact, -moved],
    end@X1 -- start@X,
    dir@X1 <> before,
    trigger(start@X1, (start@X == 0 -> (verb(X), zero@X1 = +); zero@X1 = -)),
    theta@X2 -- conj2,
    dir@X2 <> after,
    X2 <> [x, compact, -moved, -zero].

word('w', X) :-
    language@X -- arabic,
    trigger(start@X, start@X > 0),
    cat@X -- particle,
    X <> [strictpostarg(X1), adjunct, strictpostmod],
    args@X -- [X1],
    X1 <> [s, -zero],
    theta@X1 -- wcomp,
    theta@X -- wmod,
    target@X <> [s, imperative].
    
word('TNS', X) :-
    X <> pretensemarker.

word('PERS', X) :-
    X <> posttensemarker.

word('Hq', X) :-
    language@X -- arabic,
    X <> prep.

word('mAl', X) :-
    language@X -- arabic,
    X <> prep,
    target@X <> [noun, -def].

    