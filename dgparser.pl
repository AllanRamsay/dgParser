
cleanResidue([], []).
cleanResidue([_-prolog:when(_, WH,G) | T0], [when(WH, G) | T1]) :-
    !,
    cleanResidue(T0, T1).
cleanResidue([_ | R0], R1) :-
    cleanResidue(R0, R1).

l2c([], true).
l2c([H | T], (H, C)) :-
    l2c(T, C).

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
     pretty('No such word'(H0));
     true),
    disjoin(WORDS, H1),
    makeQ(T0, J, T1, LANGUAGE).

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

combine(X, Y, Z) :-
    span@Z is span@X \/ span@Y,
    findStart(start@X, span@Z, start@Z),
    findEnd(end@X, span@Z, end@Z),
    extend(wh@X, wh@Y),
    !,
    catch((min(xstart@X, xstart@Y, xstart@Z),
	   max(xend@X, xend@Y, xend@Z)),
	  E,
	  (cpretty('start or end undefined'),
	   cpretty(X),
	   cpretty(Y),
	   throw(E))).
    
addindexes([]).
addindexes([H | T]) :-
    gensym(i, index@H),
    addindexes(T).

initialise(TEXT, S) :-
    makeQ(TEXT, 0, Q),
    %% addindexes(Q),
    queue:state@S -- Q,
    stack:state@S -- [],
    relations:state@S -- [].

findHead(RELNS, HD:HFORM) :-
    member(HD:HFORM > _, RELNS),
    \+ member(_ > {_LABEL, HD:_:_}, RELNS).

makeTree(RELNS, TREE) :-
    findHead(RELNS, HD),
    !,
    makeTree(HD, RELNS, TREE).

makeTree(HD:HFORM, RELNS, [HD:HFORM:LABEL | DTRS1]) :-
    (member((_: _) > {LABEL, HD:HFORM:_}, RELNS) -> true; LABEL = top),
    findall(D:DFORM, member(HD:_ > {_LABEL, D:DFORM:_DIR}, RELNS), DTRS0),
    makeTrees(DTRS0, RELNS, DTRS1).

makeTrees([], _RELNS, []).
makeTrees([D | DD], RELNS, [T | TT]) :-
    makeTree(D, RELNS, T),
    makeTrees(DD, RELNS, TT).

convertTaggedSequence([], '').
convertTaggedSequence([(FORM, TAG) | T0], T2) :-
    (\+ word(FORM, _) ->
	 H1 = TAG;
         H1 = FORM),
    convertTaggedSequence(T0, T1),
    (T0 = [] ->
	 H2 = H1;
         atom_concat(H1, ' ', H2)),
    atom_concat(H2, T1, T2).

dgParse(TEXT0, X, TREE, SHOWRESULT) :-
    format("~w~n", [TEXT0]),
    gensym(reset),
    STATE <> state,
    retractall(STATE),
    stack:state@TSTATE -- [X],
    (TEXT0 = [_ | _] ->
     TEXT1 = TEXT0;
     makeList(TEXT0, TEXT1)),
    gensym(s, self:state@STATE),
    call_residue((initialise(TEXT1, STATE), process([STATE], TSTATE)), _),
    pretty(***********************************),
    format("~n~w~n", [relations:state@TSTATE]),
    makeTree(relations:state@TSTATE, TREE),
    treepr(TREE).

dgParse(TEXT, TSTATE, TREE) :-
    dgParse(TEXT, TSTATE, TREE, true).

dgParseForPython(TEXT) :-
    (catch(with_output_to_chars(findall(TREE, dgParse(TEXT, _, TREE, _), TREES), _), _, fail) ->   
	 write(TREES);
     write([])).

compareQ(S0, S1) :-
    length(queue:state@S0, LQ0),
    length(stack:state@S0, LS0),
    length(queue:state@S1, LQ1),
    length(stack:state@S1, LS1),
    L0 is LQ0+LS0,
    L1 is LQ1+LS1,
    (L0 < L1; (L0 = L1, LS0 < LS1)).

join(L0, L1, L) :-
    !,
    append(L0, L1, L).
join(L0, L1, L) :-
    append(L0, L1, L2),
    (true ->
     L = L2;
     qsort(L2, L, [], compareQ)).

terminalState(S) :-
    queue:state@S -- [],
    stack:state@S -- [X],
    X <> saturated.

deadend(STATE) :-
    queue:state@STATE = [],
    stack:state@STATE = [X, _ | _].

deadend(STATE) :-
    stack:state@STATE = [X | _],
    args@X -- [Y | _],
    (after:position@dir@Y == +),
    \+ member(Y, queue:state@STATE).

deadend(STATE) :-
    \+ feasible(STATE).

/**
  Count how many things are still needed and how many
  you've got: if N things are needed and you haven't got
  at least N+1 then you're not going to make it.

  This is sort of non-deterministic. Something could have an
  underspecified argument list; but if that happens, I am assuming
  that the shortest such list will turn up first (because disjoin will
  give us a list that is as long as the shortest disjunct), in which
  case we'll get the lowest value for N1, so what we're doing below is
  conservative.

  Probably important to have the args as the first feature in the sign
  for this to work properly.
  **/

feasible(STATE) :-
    countwords(STATE, N0),
    countargs(STATE, N1),
    N0 > N1.

countwords(STATE, N) :-
    length(queue:state@STATE, N0),
    length(stack:state@STATE, N1),
    N is N0+N1.

countargs([], N, N).
countargs([H | T], N0, N3) :-
    length(args@H, N1),
    !,
    N2 is N0+N1,
    countargs(T, N2, N3).

countargs(STATE, N1) :-
    countargs(queue:state@STATE, 0, N0),
    countargs(stack:state@STATE, N0, N1).

process(STATES, T) :-
    T <> terminalState,
    member(T, STATES),
    showState(T).
process([STATE | STATES0], T) :-
    (terminalState(STATE) ->
     process(STATES0, T);
     ((showStates -> showState(STATE); true),
      ((STATE) ->
       (STATES = STATES0,
	(showFullStates -> cpretty(STATE); pretty(************)));
       (\+ STATE,
	assert(STATE),
	(length(stack:state@STATE, 5) ->
	 STATES = STATES0;
	 (newStates(STATE, STATES1),
	  join(STATES1, STATES0, STATES))))),
      process(STATES, T))).

newStates(STATE, NEWSTATES) :-
    findall(NEWSTATE,
	    (newState(STATE, NEWSTATE), \+ deadend(NEWSTATE), gensym(s, self:state@NEWSTATE)),
	    NEWSTATES).

newState(S0, S1) :-
    queue:state@S0//stack:state@S0//relations:state@S0//_
    ==> 
    queue:state@S1//stack:state@S1//relations:state@S1//action:state@S1,
    mother:state@S1 -- self:state@S0.

newState(S0, S1) :-
    queue:state@S0 -- [H | Q],
    stack:state@S0 -- S,
    queue:state@S1 -- Q,
    stack:state@S1 -- [H | S],
    mother:state@S1 -- self:state@S0,
    [relations:state] :: [S0, S1].

showState(STATE) :-
    findall(root@W, member(W, queue:state@STATE), Q),
    findall(root@W, member(W, stack:state@STATE), S),
    R -- relations:state@STATE,
    I -- self:state@STATE,
    M -- mother:state@STATE,
    pretty(I::(Q//S//R<-M::action:state@STATE)).
