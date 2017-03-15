
makeQ(L0, I, L1) :-
    makeQ(L0, I, L1, _LANGUAGE).

makeQ([], _I, [], _LANGUAGE).
makeQ([H0 | T0], I, [H1 | T1], LANGUAGE) :-
    J is I+1,
    start@WORD -- I,
    end@WORD -- J,
    xstart@WORD -- I,
    xend@WORD -- J,
    span@WORD is 1 << I,
    dtrs@WORD -- [],
    (T0 = [] ->
     +terminal@WORD;
     -terminal@WORD),
    gensym(i, index@WORD),
    findall(WORD, lookup(H0, WORD, LANGUAGE), WORDS),
    (WORDS = [] ->
     (unknown(H0, WORD, LANGUAGE) ->
      H1 = WORD;
      throw('No such word'(H0)));
      disjoin(WORDS, H1)), 
    makeQ(T0, J, T1, LANGUAGE).

initialiseAgenda(TEXT0, TEXT2, LANGUAGE) :-
    makeList(TEXT0, TEXT1),
    makeQ(TEXT1, 0, TEXT2, LANGUAGE).

chartParse(TEXT0, X, LANGUAGE, MAX) :-
    gensym(reset),
    D <> sign,
    retractall(D),
    retractall(packed(_, _)),
    initialiseAgenda(TEXT0, TEXT2, LANGUAGE),
    length(TEXT2, L),
    addZero,
    processAgenda(TEXT2, X, L, MAX).

chartParse(TEXT, X, LANGUAGE) :-
    chartParse(TEXT, X, LANGUAGE, i5000).

chartParse(TEXT, LANGUAGE) :-
    call_residue((chartParse(TEXT, _, LANGUAGE) -> true; fail), _).

parseOne(TEXT, root@X) :-
    call_residue((chartParse(TEXT, X, english),
		  pretty(index@X+root@X)),
		 _),
    !.

parseOne(TEXT) :-
    parseOne(TEXT, _).

parseAll(TEXT) :-
    call_residue((chartParse(TEXT, X, english),
		  pretty(index@X+root@X),
		  fail),
		 _).

testFracas(START, END, THROWFAIL) :-
    retractall(fracasCounter(_)),
    fracas(X),
    (retract(fracasCounter(I)) -> J is I+1; J = 1),
    assert(fracasCounter(J)),
    trigger(START, J >= START),
    trigger(END, \+ J > END),
    format("~n~ntestFracas(~w). %%  '~w').~n parseOne('~w').~n", [J, X, X]),
    (catch(parseOne(X), CAUGHT, \+ format('caught ~w~n', [CAUGHT])) ->
     true;
     THROWFAIL ->
     throw('no analysis');
     format('** no analysis *****************************************~n', [])),
    fail.

testFracas(I, J) :-
    testFracas(I, J, fail).

testFracas(I) :-
    testFracas(I, I).

testFracas :-
    testFracas(_, _, fail).

addZero :-
    start@X -- end@X,
    xstart@X -- xend@X,
    start@X -- xstart@X,
    [start, end, modified] :: [X, hd@X],
    span@X -- 0,
    index@X -- z0,
    root@X -- [('zero', start@X)],
    X <> [x, -target, notMoved, +zero],
    trigger(n:xbar@cat@X, (n(X) -> saturated(X); v(X))),
    setCost(X, 0),
    assert(X).

/**
  if I == 0:
      START is I
  elif 1 >> I & SPAN == 0:
      START is I+1
  else:
      findStart(I-1, SPAN)
  **/

findStart(0, _SPAN, 0) :-
    !.
findStart(I0, SPAN, J) :-
    I1 is I0-1,
    (0 is (1 << I1) /\ SPAN ->
     J = I0;
     findStart(I1, SPAN, J)).

/**
  Suppose our phrase is made of words 0-1, 1-2, 2-3.

  Then its span will be 1 \/ 2 \/ 4, i.e. 7.

  If we take 2 as the end of the hd, then we want the
  end of this one to be 3, i.e. the last number such that
  1 << N is 1, or the first such that 1 << (N+1) is 0.
  **/

findEnd(I0, SPAN, J) :-
    I1 is I0+1,
    (0 is (1 << I1) /\ SPAN ->
     J = I1;
     findEnd(I1, SPAN, J)).

setPosition(X, Y, Z) :-
    span@Z is span@X \/ span@Y,
    findStart(start@X, span@Z, start@Z),
    findEnd(start@X, span@Z, end@Z),
    (nonvar(xend@Y) ->
     max(xend@X, xend@Y, xend@Z);
     xend@X -- xend@Z),
    (nonvar(xstart@Y) ->
     min(xstart@X, xstart@Y, xstart@Z);
     xstart@X -- xstart@Z),
    ((+terminal@X; +terminal@Y) -> +terminal@Z; -terminal@Z).

view(WORD, WORD).
view(WORD, VIEW) :-
    [position\moved, language, hd, cost] :: [WORD, VIEW],
    disjunct(externalviews@WORD, VIEW).

find(X) :-
    [theta, structure\root] :: [X, Y],
    call(Y),
    view(Y, X),
    (root@X == root@Y -> true; root@X = (altview@X=root@Y)).

checkWHPosition(H, D) :-
    H <> [v],
    -zero@D,
    -zero@WH,
    checkNoWH(H),
    checkWHMarked(D, WH),
    !,
    catch(start@WH < xstart@H, E, throw(checkWHPosition1(E, index@H, index@D))).

checkWHPosition(H, D) :-
    H <> [v],
    -zero@D,
    -zero@WH,
    checkWHMarked(H, WH),
    checkNoWH(D),
    !,
    catch(xstart@D > start@WH, E, (pretty(D), throw(checkWHPosition2(E, index@H, index@D)))).

checkWHPosition(_, _).

/**
  linked(HD, DTR)
  **/

checkLinked(IDTR, HD, DTR) :-
    (IDTR == z0; linked(start@hd@HD, start@hd@DTR)).

plantCheckLinked(HD, DTR) :-
    index@DTR -- IDTR,
    start@hd@HD -- SHDHD,
    start@hd@DTR -- SHDDTR,
    !,
    trigger((IDTR, SHDHD, SHDDTR), checkLinked(IDTR, HD, DTR)).

breakOn(X, I) :-
    (index@X == I -> trace; true).

modPosition(M, T, R) :-
    [ST, ET, SM, EM, SR, ER, DT]
    -- [start@T, end@T, start@M, end@M, start@R, end@R, dir@T],
    (after(DT) ->
      (EM = ST ->
       notMoved(M);
       (SM < ET ->
	movedBefore(M);
	movedAfter(M)));
     (before(DT),
      (SM = ET ->
       notMoved(M);
       (SM < ET ->
	movedAfter(M);
	movedBefore(M))))),
    (set:position@moved@M = +).

checkFixedMod(M, T) :-
    T <> [notMoved],
    !,
    ((after(dir@M), start@M -- end@T);
     (before(dir@M), end@M -- start@T)).
checkFixedMod(_M, _T).

/**
  If X could have multiple views, then instead of doing assert(X)
  you could do assert((T :- T=X; vmember(T, externalviews@X))).

  Is that any different from
  
  
  **/

addExternalView(X, Y) :-
    (addDisjunct(externalviews@X, Y) -> true; true).

extendWH(X, Y) :-
    extend(wh@X, wh@Y),
    \+ (nonvar(wh@X),
	wh@Y = [WH1, WH2 | _],
	nonvar(zero@WH2),
	zero@WH1 == +,
	zero@WH2 == +).
    
combineModAndTarget(M, T, R) :-
    [complete, shifted, wh] :: [T, R],
    extend(shifted@R, shifted@M),
    target@M -- T,
    T <> [+modifiable],
    result@M -- R,
    \+ ((length(wh@T, L) -> true; true), L = 2),
    [surface, language, externalviews, hd] :: [T, R],
    dtrs@R -- [index@T, mod(index@M)],
    (?forced ->
     plantCheckLinked(T, M);
     true),
    trigger((span@M, span@T), 0 is span@T /\ span@M),
    modified@T -- MODT,
    modified@R -- MODR,
    (var(span@M) -> find(M); find(T)),
    \+ (nonvar(MODT), nonvar(MODR), (MODT > MODR; (MODT == MODR, \+ compact(R)))),
    (theta@M == specifier ->
     root@R = spec(root@M, root@T);
     append(root@T, [{modifier(theta@M, specified@T), root@M}], root@R)),
    (zero@T == + ->
     (after(dir@T) -> start@T = end@M; end@T = start@M);
     true),
    setPosition(M, T, R),
    modPosition(M, T, R),
    checkWHPosition(T, M),
    extendWH(T, M),
    mergeCosts(T, M, R),
    incCost(R, 0.5),
    (nonvar(shifted@R) -> var(wh@R); true),
    (used@T = +).

argPosition(H0, A, H1) :-
    shifted :: [H0, H1],
    extend(shifted@H1, shifted@A),
    [EA, SA, SH0, EH0, DA] -- [end@A, start@A, start@H0, end@H0, dir@A],
    (before(DA) ->
      (EA -- SH0 ->
       notMoved(A);
       (-zero@A,
	compact(A),
	(EA < SH0 ->
	 movedBefore(A);
	 movedAfter(A))));
     (after(DA),
      (SA -- EH0 ->
       notMoved(A);
       (-zero@A,
	compact(A),
	(SA > EH0 ->
	 movedAfter(A);
	 movedBefore(A)))))),
    A\shifted -- X,
    ((movedBefore(A), var(wh@A)) -> add1(shifted@H1, X); true),
    (set:position@moved@A = + -> true),
    (notMoved(A) -> true; incCost(H0, 0.3)).

combineHdAndArg(H0, A, H1) :-
    [syntax\args, theta, externalviews, complete, moved, hd] :: [H0, H1],
    \+ ((length(wh@H0, L) -> true; true), L = 2),
    %% \+ \+ wh@H0 -- [_],
    args@H0 -- [A | args@H1],
    dtrs@H1 -- [arg(index@A), index@H0],
    [surface, language] :: [H0, H1],
    -zero@H0,
    (?forced ->
     plantCheckLinked(H0, A);
     true),
    trigger((span@A, span@H0), 0 is span@A /\ span@H0),
    (var(span@A) ->
     find(A);
     find(H0)),
    default(zero@A = -),
    ((specified@A == +, nonvar(specifier@A)) ->
     ROOTA = spec(specifier@A, root@A);
     ROOTA = root@A),
    append(root@H0, [{theta@A, ROOTA}], root@H1),
    checkWHPosition(H0, A),
    extendWH(H0, A),
    setPosition(H0, A, H1),
    argPosition(H0, A, H1),
    mergeCosts(H0, A, H1),
    (args@H1 = [] -> complete@H1 = +; true),
    (nonvar(shifted@H1) -> var(wh@H1); true),
    (used@A = +).

findCombination(X, _Z) :-
    breakOn(X, i3),
    fail.
findCombination(X, Z) :-
    combineHdAndArg(X, _Y, Z).
findCombination(X, Z) :-
    combineHdAndArg(_Y, X, Z).
findCombination(M, R) :-
    target@M <> sign,
    +modifiable@T,
    combineModAndTarget(M, T, R).
findCombination(T, R) :-
    +modifiable@T,
    combineModAndTarget(_M, T, R).
findCombination(X, Z) :-
    index@Y -- ext(index@X),
    [position\moved, language, hd, cost] :: [X, Y],
    disjunct(externalviews@X, Y),
    root@Y -- (altview@Y=root@X),
    (used@X = +),
    findCombination(Y, Z).

spanningEdge(X, end@X) :-
    start@X -- 0,
    X <> [saturated, compact],
    var(wh@X).

spanningEdge(Y) :-
    start@Y -- 0,
    Y <> [compact, saturated],
    end@Y -- EY,
    end@Z -- EZ,
    retrieve(_I, Y),
    nonvar(EY),
    var(wh@X),
    \+ (retrieve(_, Z), nonvar(EZ), EZ > EY).

showThisEdge(X) :-
    (?showEdges ->
     pretty(index@X+root@X+dtrs@X);
     true).

checkNewEdge(X, AGENDA0, AGENDA2) :-
    %% This is a hack to have a feature that is known to be the last thing
    %% that will be unified, so that we can set triggers that can look to see
    %% whether things have been bound
    ((?packing, call_residue(D, true)) ->
     (assert(packed(index@D, X)),
      AGENDA2 = AGENDA0);
      assert(X)).

processAgenda(AGENDA, K, END) :-
    processAgenda(AGENDA, K, END, i1000).

processAgenda([X | AGENDA0], K, END, MAX) :-
    [span, syntax] :: [X, D],
    index@X -- IX,
    (var(IX) -> gensym(i, IX); true),
    (IX == MAX -> (!, fail); true),
    checkNewEdge(X, AGENDA0, AGENDA2),
    showThisEdge(X),
    ((spanningEdge(X, END),
      K = X,
      (?firstOneOnly -> !; true));
     ((AGENDA2 == AGENDA0 ->
       true;
       (findall(C, findCombination(X, C), AGENDA1),
	(true ->
	 (qsort(AGENDA1, SORTED1, [], cheaperQ), mergeSorted(SORTED1, AGENDA0, AGENDA2, cheaperM));
	 append(AGENDA1, AGENDA0, AGENDA2)))),
     processAgenda(AGENDA2, K, END, MAX))).

retrieve(index@X, X) :-
    call(X).

rpretty(I) :-
    retrieve(I, X),
    pretty(X).

fpretty(I) :-
    retrieve(I, X),
    cpretty(X).

fpretty(I, F) :-
    retrieve(I, X),
    extractFeature(F, X, K, fail),
    cpretty(K).

whyNot(I, J) :-
    retrieve(I, IX),
    args@IX -- [A | _],
    retrieve(J, JX),
    compare(JX, A).

whyNot(I, J) :-
    retrieve(I, IX),
    args@IX -- [A | _],
    retrieve(J, JX),
    disjunct(externalviews@JX, KX),
    compare(KX, A).

whyNotModify(I, J) :-
    retrieve(I, IX),
    target@IX -- T,
    retrieve(J, JX),
    compare(T, JX).

whyNotModifyAltView(I, J) :-
    retrieve(I, IX),
    position :: [IX, IZ],
    disjunct(externalviews@IX, IZ),
    target@IZ -- T,
    retrieve(J, JX),
    compare(T, JX).

arglength(V, ???) :-
    var(V),
    !.
arglength([], 0).
arglength([_ | T], L) :-
    arglength(T, L0),
    (L0 = ??? ->
     L = ???;
     L is L0+1).

showAllEdges :-
    call(X),
    arglength(args@X, L),
    pretty(index@X+root@X+L+dtrs@X),
    fail.

parseSegment(STREAM, X, S, N) :-
    !,
    call_residue(((chartParse(X, arabic) -> true; true),
		  (spanningEdge(K) ->
		   (unset(quoteAtoms, QUOTED1),
		    pretty(STREAM, complete),
		    pretty(STREAM, index@K+root@K),
		    QUOTED1);
		   biggest2(K, L) ->
		   (unset(quoteAtoms, QUOTED2),
		    pretty(STREAM, incomplete),
		    ((compact(K)->
		       (pretty(STREAM, index@K+root@K), assert(saved(S, N, X, root@K)));
		       true),
		      (nonvar(index@L), compact(L)) ->
		      (pretty(STREAM, index@L+root@L), assert(saved(S, N, X, root@L)))),
		    QUOTED2);
		   fail)), _).

parseSegment(STREAM, X) :-
    parseSegment(STREAM, X, _, _),
    !.

parseSegment(X) :-
    parseSegment(user_output, X).

writeNumbered(_STREAM, [], _N).
writeNumbered(STREAM, [(A, E, P) | T], I) :-
    format(STREAM, '~w:~w:~w:~w, ', [I, E, A, P]),
    J is I+1,
    writeNumbered(STREAM, T, J).

parseSegments(OUT) :-
    getStream(OUT, STREAM),
    retractall(saved(_, _, _, _)),
    set(firstOneOnly, _),
    set(packing, _),
    segment(S, N, X),
    \+ member((_, _, 'VBD'), X),
    \+ member((_, _, 'NNS'), X),
    \+ member(('atin', _, _), X),
    unset(quoteAtoms, _QUOTED),
    nl(STREAM), print(STREAM, **************************),
    set(quoteAtoms, _),
    nl(STREAM), write(STREAM, segment(S, N)),
    %% reverse(X, Y), nl(STREAM), ((member((A, _, _), Y), write(STREAM, A), write(STREAM, ' '), fail); true),
    nl(STREAM), writeNumbered(STREAM, X, 0),
    nl(STREAM), nl(STREAM), print(STREAM, parseSegment(X)), write(STREAM, '.'),
    nl(STREAM),
    parseSegment(STREAM, X, S, N),
    nl(STREAM),
    fail.
parseSegments(_OUT) :-
    closeStream,
    unset(quoteAtoms, _).

parseSegments :-
    parseSegments(user_output).

getCost(X, I) :-
    get_mutable(I, cost@X),
    default(I=0).

setCost(X, I) :-
    create_mutable(I, cost@X).

incCost(X, I) :-
    catch(get_mutable(J, cost@X), _, (setCost(X, 0), J=0)),
    K is I+J,
    update_mutable(K, cost@X).

mergeCosts(X, Y, Z) :-
    getCost(X, CX),
    getCost(Y, CY),
    CZ is CX + CY,
    setCost(Z, CZ).

cheaperM(X, Y) :-
    getCost(X, CX),
    getCost(Y, CY),
    catch(CX =< CY, E, throw(cheaperM(E, index@X, index@Y))).

cheaperQ(X, Y) :-
    getCost(X, CX),
    getCost(Y, CY),
    catch(CX < CY, E, throw(cheaperQ(E, index@X, index@Y))).

parseDefns :-
    definition@Y -- D,
    word(X, Y),
    nonvar(D),
    format("~n~w: ~nchartParse('~w', X, english), pretty(index@X+root@X), fail.~n", [X, D]),
    chartParse(D, T, english, i200),
    pretty(root@T),
    nl,
    fail.

getUnknownWords :-
    definition@Y -- D,
    word(X, Y),
    nonvar(D),
    catch(initialiseAgenda(D, T, english), 'No such word'(ROOT), pretty('No such word'(ROOT))),
    fail.

    