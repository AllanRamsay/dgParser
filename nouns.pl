
month(X) :-
    language@X -- english,
    X <> [n, saturated, -target, inflected].
month(X) :-
    language@X -- english,
    X <> [n, -target, inflected],
    args@X -- [Y],
    Y <> [fixedpostarg, number(_)].