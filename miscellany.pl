
asComp(X, COMP) :-
    COMP <> [s, compact],
    -zero@subject@COMP,
    target@X <> [s],
    X <> [fulladjunct, fixedpostmod].
  
asComp(X, COMP) :-
    args@X -- [COMP],
    COMP <> [np,  objcase],
    -cat@target@X.

as(X) :-
    language@X -- english,
    cat@X -- as1,
    args@X -- [COMP],
    COMP <> [fixedpostarg, theta(asArg0), x, saturated, specified, -zero],
    trigger(index@COMP, asComp(X, COMP)),
    trigger(index@target@X, nonvar(index@COMP)).

as(X) :-
    language@X -- english,
    [cat, specifier, specified, predicative] :: [X, ARG0],
    cat@AS -- as1,
    args@X -- [ARG0, AS],
    target@X -- TARGET,
    mod :: [target@X, result@X],
    TARGET <> [saturated, x, -moved],
    syntax :: [TARGET, target@ARG0],
    trigger(index@TARGET, nonvar(index@AS)),
    AS <> [postarg, theta(asArg1), saturated, -zero],
    ARG0 <> [fixedpostarg,  saturated],
    as(X, ARG0, AS).

as(X, ARG0, AS) :-
    ARG0 <> [a],
    AS <> [fixedpostarg],
    X <> [fixedpostmod, fulladjunct].

as(X, ARG0, AS) :-
    ARG0 <> [fixedpostarg, det(_)],
    start@AS -- end@TARGET,
    X <> [det4(_)]. 