not(X) :-
    fail,
    cat@X -- negation,
    tag@X -- negationMarker,
    modifier@X -- negated,
    X <> [fulladjunct, saturated, theta(negation)],
    target@X <> [s, tensedForm].

not(X) :-
    X <> [v],
    -target@X,
    args@X -- [S],
    polarity@S -- -1,
    S <> [s, theta(negComp), tensedForm].