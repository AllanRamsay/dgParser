/**
  Simple determiners combine with descriptors, where a
  descriptor could be just an NN or "of NP[+def]".

  Some can combine with NNs with +zero heads: "all who sail
  in her", "the richest of my friends".

  "all" is pretty weird: it does take part in "all of my
  cats", but it also does things like "they all had a good
  time" and "my friends all drive Porsches". Do "my friends all
  drive Porsches" and "all my friends drive Porsches" mean
  the same? I think probably not:

  forall(X :: {member(X, ref(lambda Y: friend(me, Y)))},
         drive(X, Porsche))

  

  **/


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

all(X) :-
    language@X -- english,
    X <> [det4, -def, plural],
    trigger(case@target@X, (member(I, [1]), setDetTarget(X, I))).

all(X) :-
    fail,
    cat@X -- all,
    X <> [saturated, fulladjunct, premod, theta(allAsMod)],
    target@X <> [np, +def],
    trigger(set:position@moved@X, (notMoved(X) -> true; (movedAfter(X)))).

standardDet(X) :-
    language@X -- english,
    X <> [det1, -def],
    trigger(case@target@X, (member(I, [1,2]), setDetTarget(X, I))).

none(X) :-
    language@X -- english,
    X <> [det1, -def],
    trigger(case@target@X, (member(I, [2]), setDetTarget(X, I))).

setDetTarget(X, 1) :-
    T -- target@X,
    [def] :: [X, target@X, result@X],
    T <> [-specified, standardcase].
setDetTarget(X, 2) :-
    T -- target@X,
    T <> [pp, +def, casemarked(of), -zero].
setDetTarget(X, 3) :-
    T -- target@X,
    T <> [np, +def, standardcase, -zero].

number(X, N) :-
    fail,
    trigger(N, catch((N > 1, plural(X)), _, true)),
    /**
      It could just be an NP. "I saw him in 1989".
      It could be just a noun: "He bought a red one", "I wanted two of them"
      
      **/
    X <> [n, -target, +numeric, unspecified, saturated, inflected, plural].
number(X, N) :-
    language@X -- english,
    X <> [-def, det3, saturated],
    trigger(case@target@X, (member(I, [1,2]), setDetTarget(target@X, I))).

number(X, N0) :-
    fail,
    tag@X -- num,
    catch((atom_chars(N0, NCHARS),
	   number_chars(N1, NCHARS),
	   N1 > 1000,
	   N1 < 3000,
	   specified@X = +),
	  _,
	  true),
    X <> [n, saturated, inflected, -target].

less(X) :-
    language@X -- english,
    X <> [det, inflected].

less(X) :-
    language@X -- english,
    cat@X -- predet,
    X <> [premod, fulladjunct],
    args@X -- [THAN],
    THAN <> [cat(than), fixedpostarg, word, theta(than)],
    target@X <> [det3, saturated].
