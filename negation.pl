not(X) :-
    cat@X -- negation,
    tag@X -- negationMarker,
    X <> [strictpremod, fulladjunct, saturated, theta(negation)],
    target@X <> [word].