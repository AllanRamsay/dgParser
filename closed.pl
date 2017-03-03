

word('AC', X) :-S+
    cat@X -- case,
    theta@X -- case,
    X <> [fulladjunct, saturated, strictpostmod],
    +n:xbar@cat@target@X,
    target@X <> [word],
    result@X <> objcase,
    trigger(index@target@X, (n(X) -> arabicNoun(result@X); true)).

word('AGR', X) :-
    cat@X -- agr,
    X <> [saturated, strictpostmod, adjunct],
    args :: [target@X, result@X],
    theta@X -- agr,
    target@X <> [n].

word('ART', X) :-
    X <> det,
    -def@target@X,
    +def@result@X.

word('DET', X) :-
    X <> det,
    -def@target@X,
    +def@result@X.

word('AUX', X) :-
    X <> aux.

word('CC', X) :-
    trigger(start@X, (start@X = 0 -> conj1(X); conj(X))).

word('CD', X) :-
    X <> det,
    -def@target@X,
    +def@result@X.

word('CO', X) :-
    cat@X -- comp,
    X <> [saturated, strictpremod],
    -zero@target@X,
    target@X <> [s, -def],
    result@X <> [s, +predicative, fulladjunct, strictpostmod, +def],
    TR -- target@result@X,
    target@result@X <> [n, saturated],
    theta@X -- comp,
    comp@result@X -- *(MARK),
    MSUBJ -- moved@subject@target@X,
    trigger(MSUBJ, (MSUBJ == - -> MARK = 'An1'; MARK = 'An2')),
    trigger(index@TR, theta@result@X = advcl).

word('COMMA', X) :-
    conj(X).

word('DEF', X) :-
    noun(X),
    +def@X.

word('DQUOTE', X) :-
    cat@X -- closingDQuote,
    X <> [saturated, -target].

word('DQUOTE', X) :-
    cat@X -- openingDQuote,
    args@X -- [P, CDASH],
    P <> [x, saturated, compact, -zero],
    X <> [fulladjunct, strictpostarg(P)],
    theta@P -- parenthetical,
    start@CDASH -- end@P,
    cat@CDASH -- closingDQuote,
    dir@CDASH <> after,
    -moved@CDASH,
    theta@CDASH -- closer,
    target@X <> [x, saturated],
    trigger(index@target@X, nonvar(index@CDASH)),
    theta@X -- quote.

word('DT', X) :-
    language@X -- arabic,
    X <> [n, saturated, specified, +def],
    setnpred(X),
    -target@X.

word('EMOJ', X) :-
    X <> [emoticon].
word('EMOJP', X) :-
    word('EMOJ', X).

word('EMOT', X) :-
    X <> [emoticon].
word('emot', X) :-
    X <> [emoticon].

word('FUT', X) :-
    X <> [fulladjunct, strictpremod, saturated],
    cat@X -- future,
    theta@X -- future,
    cat@target@X -- tensemarker.

word('IN', X) :-
    X <> prep.

word('FW', X) :-
    word('NN', X).

word('TO', X) :-
    word('IN', X).

word('INDEF', X) :-
    noun(X),
    -def@X.

word('JJ', X) :-
    language@X -- arabic,
    word('NN', X).
word('JJ', X) :-
    language@X -- english,
    X <> adj.

word('LINK', X) :-
    X <> [n, saturated, fulladjunct],
    trigger(index@target@X, theta@X = linkmod),
    dtrs@target@X -- [].
word('link', X) :-
    X <> [n, saturated, fulladjunct],
    trigger(index@target@X, theta@X = linkmod),
    dtrs@target@X -- [].

word('MEN', X) :-
    X <> [mention].

word('NEG', X) :-
    cat@X -- neg,
    X <> [saturated, fulladjunct],
    target@X <> [v, saturated],
    theta@X -- advmod,
    dir@target@X <> after.

word('NN', X) :-
    noun(X),
    -def@X.

word('NNS', X) :-
    noun(X),
    -specified@X.

word('NNP', X) :-
    language@X -- L,
    noun(X),
    trigger(L,
	    (L = arabic ->
	     (+def@X, plantVocative(X));
	     L = english ->
	     true)).

word('PRP', X) :-
    subjpronoun(X),
    +pronominal@X.

word('RB', X) :-
    X <> adv.

word('REP', X) :-
    reply(X).

word('RET', X) :-
    X <> [retweet, presTense, thirdSing].

word('RET', X) :-
    cat@X -- apology,
    X <> [saturated, fulladjunct],
    target@X <> s,
    theta@X -- recip,
    dir@X <> before,
    end@X -- start@target@X.

word('RP', X) :-
    cat@X -- rp,
    X <> [saturated, fulladjunct],
    target@X <> [v, saturated],
    theta@X -- advmod,
    dir@target@X <> after.

word('SPRP', X) :-
    -moved@X,
    objpronoun(X).

word('UH', X) :-
    cat@X -- interjection,
    X <> [saturated, fulladjunct],
    target@X <> s,
    theta@X -- int,
    dir@X <> before,
    end@X -- start@target@X.

word('USERN', X) :-
    X <> [np, +def],
    -target@X.
word('username', X) :-
    X <> [np, +def],
    -target@X.

word('IV', X) :-
    X <> [presTense],
    iverb(X),
    -target@X.

word('TV', X) :-
    X <> [presTense],
    tverb(X),
    -target@X.

word('SV', X) :-
    X <> [presTense],
    sverb(X),
    -target@X.

word('VB', X) :-
    X <> [present],
    uverb(X),
    -target@X.

word('VM', X) :-
    X <> [aux(COMP), tensed],
    COMP <> infinitiveForm.

word('VVS', X) :-
    X <> [uverb, tensed].

word('WP', X) :-
    X <> [np],
    -target@X,
    wh@X -- [WH | _],
    language@WH -- english,
    WH <> [saturated, fulladjunct, -modifiable, strictpostmod, compact],
    cat@WH -- whclause,
    end@target@WH -- start@X,
    modified@result@WH -- 2.5,
    target@WH <> [n, unspecified],
    trigger(index@target@WH, theta@WH=rcmod).

word('WRB', X) :-
    whmod(X, WH),
    WH <> [fulladjunct, strictpostmod, saturated, -predicative],
    modified@result@WH -- 6,
    cat@WH -- whmod,
    target@WH <> [n, saturated],
    theta@WH -- whmod,
    theta@X -- advmod.

word('WRP', X) :-
    whmod(X, WH),
    WH <> [fulladjunct, strictpostmod, saturated, -predicative],
    modified@result@WH -- 6,
    cat@WH -- whmod,
    target@WH <> [n, saturated],
    theta@WH -- whmod,
    theta@X -- advmod.

word(PUNC, X) :-
    language@X -- arabic,
    member(PUNC, ['.', '?', 'MPUNC', 'PUNC', 'PUNC.']),
    cat@X -- utterance,
    -target@X,
    args@X -- [S],
    S <> [x, saturated, -zero, prearg, tensedForm],
    theta@S -- THETAS,
    trigger(SV, (v(S) -> THETAS = scomp; THETAS = frag)),
    start@S -- 0.