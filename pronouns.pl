whpronoun(X, WH) :-
    X <> [pronoun1, -target, -modifiable],
    wh@X -- [WH | _],
    [position, language] :: [X, WH].

whpronoun(X) :-
    X <> whpronoun(_).

relpronoun(X, WH) :-
    language@X -- english,
    zero :: [X, WH],
    X <> [whpronoun(WH)],
    WH <> [saturated, fulladjunct, -modifiable, postmod(_, _), compact],
    modifier@WH -- whmod,
    specifier@X -- *whPron,
    cat@WH -- whclause,
    target@WH <> [n, saturated],
    trigger(index@target@WH, theta@WH=rcmod).

relpronoun(X) :-
    relpronoun(X, WH),
    modified@result@WH -- 2.5.
    