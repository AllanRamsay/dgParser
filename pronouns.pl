whpronoun(X, WH) :-
    X <> [pronoun, -target],
    wh@X -- [WH | _],
    [position, language] :: [X, WH].

whpronoun(X) :-
    X <> whpronoun(_).

relpronoun(X, WH) :-
    language@X -- english,
    zero :: [X, WH],
    X <> [whpronoun(WH)],
    WH <> [saturated, fulladjunct, -modifiable, fixedpostmod, compact],
    cat@WH -- whclause,
    target@WH <> [n, unspecified, saturated],
    trigger(index@target@WH, theta@WH=rcmod).

relpronoun(X) :-
    relpronoun(X, 2.5).
    