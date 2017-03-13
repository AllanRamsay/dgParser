    
all(X) :-
    language@X -- english,
    X <> [det([NP])],
    NP <> [pp, fixedpostarg, +def, casemarked(of), theta(arg(headnoun1))].

all(X) :-
    language@X -- english,
    X <> [det, thirdPlural, -def].

all(X) :-
    cat@X -- all,
    X <> [saturated, fulladjunct, premod, theta(allAsMod)],
    target@X <> [np, +def],
    trigger(set:position@moved@X, (notMoved(X) -> true; (movedAfter(X), subjcase(target@X)))).

number(X, N) :-
    tag@X -- num,
    trigger(N, catch((N > 1, plural(N)), _, true)),
    /**
      It could just be an NP. "I saw him in 1989".
      It could be just a noun: "He bought a red one", "I wanted two of them"
      
      **/
    X <> [n, -target, +numeric, -specified, saturated, inflected, plural, -modifiable].
number(X, N) :-
    X <> [det1, +numeric, specified],
    setNumber(N, X).
number(X, N) :-
    tag@X -- num,
    X <> [det1([NP]), +numeric],
    NP <> [pp, fixedpostarg, +def, plural, casemarked(PREP), theta(headnoun)],
    setNumber(N, NP),
    trigger(PREP, (PREP = of; PREP = out)).

number(X, N0) :-
    tag@X -- num,
    catch((atom_chars(N0, NCHARS),
	   number_chars(N1, NCHARS),
	   N1 > 1000,
	   N1 < 3000,
	   np(X),
	   -target@X),
	  _,
	  fail).

times(X, N) :-
    tag@X -- twice,
    X <> [n, specified(+), postmod, fulladjunct],
    target@X <> [vp],
    trigger(index@target@X, nonvar(index@AS)),
    args@X -- [AS],
    cat@AS -- as,
    AS <> [saturated, fixedpostarg, -zero].

times(X, _N) :-
    X <> [adv],
    target@X <> [vp].

as(X) :-
    language@X -- english,
    cat@X -- as,
    X <> [postmod, fulladjunct, inflected],
    target@X <> [vp],
    trigger(index@target@X, nonvar(index@NP)),
    args@X -- [NP],
    NP <> [np, fixedpostarg, theta(asArg)]. 

as(X) :-
    language@X -- english,
    X <> [adj([ADJ, AS]), inflected],
    adj(ADJ),
    trigger(index@target@X, nonvar(index@AS)),
    cat@AS -- as,
    AS <> [fixedpostarg, theta(asArg), saturated]. 

/**
  few people: few is a plural determiner (and so is 'fewer')

  a few people: 'a few' is a plural determiner. You can just about use a
  noun modifier on it 'a lucky few were rescued', 'the few who were rescued were
  very lucky'. *It doesn't need an N to specify*
  **/

few(X) :-
    X <> [det2, saturated, aroot2, plural].

few(X) :-
    X <> [nroot(_), sing],
    -target@X,
    D <> [det2, inflected, plural],
    trigger(specified@X, addExternalView(X, D)).

some(X) :-
    language@X -- english,
    X <> [det1, -def],
    trigger(case@target@X, setDetTarget(target@X)).

setDetTarget(T) :-
    T <> [-specified, standardcase].
setDetTarget(T) :-
    T <> [pp, +def, casemarked(of)].
