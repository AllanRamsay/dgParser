
:- op(32, xfy, '\IN').
:- op(32, xfy, '\sub').

revpolarity(P0, P1) :-
    (P0 = + -> P1 = -; P0 = - -> P1 = +;P1 = -). 

/**
  It may be useful to order the dtrs of tree so that modifiers
  come at the end. It's hard to see it doing any damage, unless
  we start getting into situations in which the surface order is
  important for dealing with pronouns.
  **/
orderDtrs(_, modifier(_, _)).

/**
  The tree that comes out of the parser reflects the order of
  combination. That means that for "he loves her" we get

  baseTree([[love>s, arg(dobj, *(indefinite), [woman>, modifier(A, a)])],
            arg(subject, *(universal), [man>, modifier(B, every)])])

  where we have a two-element list made of ["loves a woman", "a man"]

  That's just an accident of the way the parser works. denest turns
  this into

  justRoots([love,
             arg(dobj, *(indefinite), [woman, modifier(A, a)]),
             arg(subject, *(universal), [man, modifier(B, every)])])

  It includes sorting dtrs so that modifiers come at the end. That
  will help when trying to deal with upward/downward matching and
  possibly with simplification.
  **/

denest([[H | T0] | T1], D) :-
    !,
    append(T0, T1, T),
    denest([H | T], D).
denest([H0 | T0], L) :-
    !,
    denest(H0, H1),
    denest(T0, T1),
    qsort([H1 | T1], L, orderDtrs).
denest(_A=B, C) :-
    !,
    denest(B, C).
denest(arg(A, B, D0), arg(A, B, D1)) :-
    !,
    denest(D0, D1).
denest(modifier(A, B0), modifier(A, B1)) :-
    !,
    denest(B0, B1).
denest(A0?P, A1?P) :-
    !,
    denest(A0, A1).
denest(X, X).

justRoots(X, X) :-
    (var(X); atomic(X)),
    !.
justRoots(A > X, A > X) :-
    X='singular';
    X='plural',
    !.
justRoots(A > _, A) :-
    !.
justRoots([H0 | T0], [H1 | T1]) :-
    !,
    justRoots(H0, H1),
    justRoots(T0, T1).
justRoots(X0, X1) :-
    X0 =.. L0,
    justRoots(L0, L1),
    X1 =.. L1.

timeSequence(['.',arg(claim,*(time(Arg0,Arg1,Arg2,Arg3,Arg4)),List)],['.',arg(claim,TimeSeq,Rest1)]):-
    nonvar(Arg0),
    !,
    collectTime(List,[(time(Arg0,Arg1,Arg2,Arg3,Arg4))],TimeSeq,Rest0),
    timeSequence(Rest0,Rest1).

timeSequence(['?',arg(query,*(time(Arg0,Arg1,Arg2,Arg3,Arg4)),List)],['?',arg(query,TimeSeq,Rest1)]):-
    nonvar(Arg0),
    !,
    collectTime(List,[(time(Arg0,Arg1,Arg2,Arg3,Arg4))],TimeSeq,Rest0),
    timeSequence(Rest0,Rest1).

timeSequence(['?',arg(query,*(time(Arg0,Arg1,Arg2,Arg3,Arg4)),List)],['?',arg(query,TimeSeq,Rest1)]):-
    fail,
    !,
    collectTime(List,[(time(Arg0,Arg1,Arg2,Arg3,Arg4))],TimeSeq,Rest0),
    timeSequence(Rest0,Rest1).

timeSequence(['.',arg(frag,Specifier,List0)],['.',arg(frag,Specifier,List1)]):-
    !,
    timeSequence(List0,List1).

timeSequence([WORD, modifier(Type,List0) |OtherMods0],[WORD, modifier(Type,List1) |OtherMods1]):-
    !,
    timeSequence(List0,List1),
    timeSequence(OtherMods0,OtherMods1).

timeSequence([WORD,arg(xcomp,*(time(Arg0,Arg1,Arg2,Arg3,Arg4)),List)|OthrArgs0],[WORD,arg(xcomp,TimeSeq,Rest1)|OthrArgs1]):-
    !,
    collectTime(List,[(time(Arg0,Arg1,Arg2,Arg3,Arg4))],TimeSeq,Rest0),
    timeSequence(Rest0,Rest1),
    timeSequence(OthrArgs0,OthrArgs1).

timeSequence([WORD,arg(negComp,*(time(Arg0,Arg1,Arg2,Arg3,Arg4)),List)],[WORD,arg(negComp,TimeSeq,Rest1)]):-
    !,
    collectTime(List,[(time(Arg0,Arg1,Arg2,Arg3,Arg4))],TimeSeq,Rest0),
    timeSequence(Rest0,Rest1).

timeSequence(arg(Type,Specifier,List0),arg(Type,Specifier,List1)):-
	!,
	timeSequence(List0,List1).

timeSequence([_AUX,arg(auxComp,*(time(Arg0,Arg1,Arg2,Arg3,Arg4)),List) | MODS],[TimeSeq|Rest1]):-
	!,
	collectTime([List | MODS],[(time(Arg0,Arg1,Arg2,Arg3,Arg4))],TimeSeq,Rest0),
	timeSequence(Rest0,Rest1).

timeSequence([WORD,arg(Type,Specifier,List0) |OthrArgs0],[WORD,arg(Type,Specifier,List1) |OthrArgs1]):-
	!,
	timeSequence(List0,List1),
	timeSequence(OthrArgs0,OthrArgs1).

timeSequence(X,X).
 
/** version(2) **/
refine(List,*List).

collectTime([_AUX,arg(_Type,*(time(Arg0,_Arg1,_Arg2,_Arg3,_Arg4)),List)],TimeSeq0,TimeSeq2,Rest):-
    var(Arg0),
    !,
    collectTime(List,TimeSeq0,TimeSeq2,Rest).

collectTime([_AUX,arg(_Type,*(time(Arg0,Arg1,Arg2,Arg3,Arg4)),List)],TimeSeq0,TimeSeq2,Rest):-
    !,
    append(TimeSeq0,[(time(Arg0,Arg1,Arg2,Arg3,Arg4))],TimeSeq1),
    collectTime(List,TimeSeq1,TimeSeq2,Rest).

collectTime([WORD,arg(Type,Specifier,List)|OthrArgs],TimeSeq,RefinedTimeSeq,
	    [WORD,arg(Type,Specifier,List)|OthrArgs]):-
    !,
    refine(TimeSeq,RefinedTimeSeq).

collectTime(X0?P, TimeSeq, RefinedTimeSeq, X1?P) :-
    collectTime(X0, TimeSeq, RefinedTimeSeq, X1).

convSteps(X0,XN):-
	denest(X0,X1),
	pretty(denested(X1)),
	justRoots(X1,X2),
	pretty(jr(X2)),
	timeSequence(X2,X3),
	pretty(ts(X3)),
	nfTree(X3,X4),
	pretty(nf(X4)),
	qlf(X4, XN),
	pretty(qlf(XN)).

/**
  Because I have this theory of modifiers and specifiers that says
  that any modifier *might* be a specifier and any specifier *might*
  be a modifier, I have to do some tidying up to get rid of cases
  where a modifier isn't actually a specifier and vice versa.
  **/

nfTree(X, X) :-
    (var(X); atomic(X)),
    !.
nfTree(arg(Type,Specifier,List0), arg(Type,Specifier,List1)):-
    !,
    nfTree(List0,List1).
nfTree(X0?P, X1?P) :-
    !,
    nfTree(X0, X1).
nfTree([modifier(identity, _D0) | T0], T1) :-
    !,
    nfTree(T0, T1).
nfTree([modifier(A, D0) | T0], [modifier(A, D1) |T1]) :-
    !,
    nfTree(D0, D1),
    nfTree(T0, T1).
nfTree([X0 | T0], [X1 | T1]) :-
    !,
    nfTree(X0, X1),
    nfTree(T0, T1).
nfTree(X, X).

nfDtrs([], []).
nfDtrs([H0 | T0], [H1 | T1]) :-
    nfTree(H0, H1),
    nfDtrs(T0, T1).

/** Polarity table for quantifiers:assuming quantifiers have effects on their restricted items, commonly one item **/
polTable(*(universal),-1).
polTable(*(no),-1).
polTable(*(proRef),0).
polTable(*(name),0).
polTable(*(the),0).
polTable(_DEFAULT,+1).

/** Polarity table fornegations, verbs, adverbs..etc: assuming each affect 2 argument maximum **/
polTable2('not',1,-1,_).
polTable2('without',1,-1,_).
polTable2('lack',2,-1,+1).
polTable2('doubt',2,-1,+1).
polTable2(_DEFAULT,2,+1,+1).

polTable3('doubt',[-1]).
polTable3('without',[-1]).
polTable3('lack',[-1,+1]).
polTable3('doubt',[-1,+1]).
polTable3(_DEFAULT,[+1,+1]).

/** Polarity Compositional operator **/
polarityComposition(POL0,POL1,COMP):-
	COMP is POL0 * POL1.


polMark(X0,X1):-
	polMark(X0,+1,X1).

polMark(['.',arg(claim,SPEC,List0)],Pol,['.',arg(claim,SPEC,List1)]):-
    !,
    polMark(List0,Pol,List1).


polMark(['?',arg(query,SPEC,List0)],Pol,['?',arg(query,SPEC,List1)]):-
    !,	
    polMark(List0,Pol,List1).

/**assuming that negation words takes one argument which is a sentence **/
polMark([NEGWORD,arg(negComp,SPEC,List0)],Pol0,[NEGWORD:Pol0,arg(negComp,SPEC,List1)]):-
    !,
    polTable2(NEGWORD,_ARGS,Pol1,_),
    polarityComposition(Pol0,Pol1,Pol2),
    pretty(Pol2),
    polMark(List0,Pol2,List1).

polMark([WORD,arg(xcomp,TIMESPEC,List0)|OthrArgs0],Pol0,[WORD:Pol0,arg(xcomp,TIMESPEC,List1)|OthrArgs1]):-
    !,
    polTable2(WORD,ARGS,Pol01,Pol11),
    (ARGS=2 ->(polarityComposition(Pol0,Pol01,Pol02),
	       polMark(List0,Pol02,List1),
	       polarityComposition(Pol0,Pol11,Pol12),
	       polMark(OthrArgs0,Pol12,OthrArgs1)));
    (ARGS=1 ->(polarityComposition(Pol0,Pol01,Pol02),
	       polMark(List0,Pol02,List1),
	       polMark(OthrArgs0,Pol0,OthrArgs1))).

polMark([WORD,arg(Type,Specifier,List0)|OthrArgs0],Pol0,[WORD:Pol0,arg(Type,Specifier,List1)|OthrArgs1]):-
    !,
    polTable2(WORD,ARGS,Pol01,Pol11),
    polTable(Specifier,SPol),
    (ARGS=2 ->(polarityComposition(Pol0,Pol01,Pol02),
	       polarityComposition(Pol02,SPol,SPol02),
	       polMark(List0,SPol02,List1),
	       polarityComposition(Pol0,Pol11,Pol12),
	       polMark(OthrArgs0,Pol12,OthrArgs1)));
    (ARGS=1 ->(polarityComposition(Pol0,Pol01,Pol02),
	       polarityComposition(Pol02,SPol,SPol02),
	       polMark(List0,SPol02,List1),
	       polMark(OthrArgs0,Pol0,OthrArgs1))).



polMark([arg(Type,Specifier,List0)|OthrArgs0],Pol0,[arg(Type,Specifier,List1)|OthrArgs1]):-
    !,
    polTable(Specifier,SPol),
    polarityComposition(Pol0,SPol,SPol0),
    polMark(List0,SPol0,List1),
    polMark(OthrArgs0,Pol0,OthrArgs1).


polMark([WORD,modifier(Type,List0)|OtherMods0],Pol0,[WORD:Pol0,modifier(Type,List1)|OtherMods1]):-
    !,
    polTable2(WORD,ARGS,Pol01,Pol11),
    (ARGS=2 ->(polarityComposition(Pol0,Pol01,Pol02),
	       polMark(List0,Pol02,List1),
	       polarityComposition(Pol0,Pol11,Pol12),
	       polMark(OtherMods0,Pol12,OtherMods1)));
    (ARGS=1 ->(polarityComposition(Pol0,Pol01,Pol02),
	       polMark(List0,Pol02,List1),
	       polMark(OtherMods0,Pol0,OtherMods1))).	
   
polMark([modifier(ppmod,List0)],Pol0,[modifier(ppmod,List1)]):-
	!,
	polMark(List0,Pol0,List1).
   

polMark([],_Pol,[]):-
      !.
polMark([WORD],Pol0,[WORD:Pol0]):-
      !.
polMark(WORD,Pol0,(WORD:Pol0)):-
      !.
polMark(X,_Pol,X).

convSteps2(X0,XN):-
	denest(X0,X1),
	pretty(denested(X1)),
	justRoots(X1,X2),
	pretty(jr(X2)),
	timeSequence(X2,X3),
	pretty(ts(X3)),
	nfTree(X3,X4),
	pretty(nf(X4)),
	%% polMark(X4,X5), pretty(pm(X5)),
	X5 = X4,
	qlf(X5,XN),
	pretty(qlf(XN)).

qlf(X, X) :-
    (var(X); atomic(X)),
    !.
qlf(time(A, B, C, D, E), time(A, B, C, D, E)) :-
    !.
qlf(['.', X0], X1) :-
    !,
    qlf(X0, X1).
qlf(['?', X0], X1) :-
    !,
    qlf(X0, X1).
qlf(arg(claim, *SPEC, X0), qq(claim, X1)) :-
    !,
    qlf(qq(SPEC, X0), X1).
qlf(arg(query, *SPEC, X0), qq(query, X1)) :-
    !,
    qlf(qq(SPEC, X0), X1).
/**
qlf(arg(query, *SPEC, X0), query(opaque(X1))) :-
    !,
    qlf(qq(SPEC, X0), X1).
  **/
qlf(arg(negComp, *SPEC, X0), X1) :-
    !,
    qlf(qq(SPEC, X0), X1).
qlf(arg(xcomp, *SPEC, X0), xcomp(opaque(X1))) :-
    !,
    qlf(qq(SPEC, X0), X1).
%% The template case
qlf(arg(THETA, *SPEC, X0), qq(SPEC::{X1, V}, {THETA, V})) :-
    !,
    qlf(X0, X1).
qlf([H0 | T0], [H1 | T1]) :-
    !,
    qlf(H0, H1),
    qlf(T0, T1).
qlf(X0, X1) :-
    X0 =.. L0,
    qlf(L0, L1),
    X1 =.. L1.

/** Steps for extracting certain informations; Tenses list (path), aspect and quantifier, from the time specifier**/
same([_]).
same([X,X|T]) :- same([X|T]).
getTenseList([time(Arg1,_Arg2,_Arg3,_Arg4,_Arg5)|OtherTimes],[Arg1]):-
	length(OtherTimes,0),
	!.
getTenseList(TimeList,Path):-
	tenseList(TimeList,[PathHead|PathTail]),
	(same([PathHead|PathTail])->Path=PathHead;
	 Path=[PathHead|PathTail]),
	!.
tenseList([],[]):-
	!.
tenseList([time(tense(present),_Arg2,_Arg3,_Arg4,_Arg5)|OtherTimes],TesneList):-
	tenseList(OtherTimes,TesneList),
	!.
tenseList([time(Arg1,_Arg2,_Arg3,_Arg4,_Arg5)|OtherTimes],[Arg1|TesneList]):-
	tenseList(OtherTimes,TesneList).

timeToQuantifier([time(_Arg1,_Arg2,_Arg3,def(Sign),_Arg5)|_OtherTimes],Quantifier):-
	((atomic(Sign),Sign='-')->Quantifier='existential');
	((atomic(Sign),Sign='+')->Quantifier='referential');
	(var(Sign)->Quantifier='existential'); %%why both and I swap them, originally 'unidentified' then existential'
	(var(Sign)->Quantifier='unidentified').

getAspect([time(_Arg1,aspect(Aspect),_Arg3,_Arg4,_Arg5)|OtherTimes],Aspect):-
	last([time(Arg1,aspect(Aspect),_Arg3,_Arg4,_Arg5)|OtherTimes],time(Arg1,aspect(Aspect),_Arg3,_Arg4,_Arg5)),
	!.
getAspect([time(_Arg1,_Arg2,_Arg3,_Arg4,_Arg5)|OtherTimes],Aspect):-
	getAspect(OtherTimes,Aspect).

extractQQ(X, X, Q, Q) :-
    (atomic(X); var(X)),
    !.
extractQQ(opaque(X0), X1, Q, Q) :-
    !,
    fixQuants(X0, X1).

extractQQ(qq([time(Arg1,Arg2,Arg3,Arg4,Arg5)|OtherTimes], X0), XN, Q0, Q1) :-
    fail,
    !,
    getTenseList([time(Arg1,Arg2,Arg3,Arg4,Arg5)|OtherTimes],Path),
    timeToQuantifier([time(Arg1,Arg2,Arg3,Arg4,Arg5)|OtherTimes],Quantifier),
    getAspect([time(Arg1,Arg2,Arg3,Arg4,Arg5)|OtherTimes],Aspect),
    extractQQ(qq(Quantifier :: {Path,V},
		 qq(existential :: {(Aspect, V), X},
		    [X0, X])),
	      XN, Q0, Q1).
extractQQ(qq([time(Arg1,Arg2,Arg3,Arg4,Arg5)|OtherTimes], X0), XN, Q0, Q1) :-
    getTenseList([time(Arg1,Arg2,Arg3,Arg4,Arg5)|OtherTimes],Path),
    timeToQuantifier([time(Arg1,Arg2,Arg3,Arg4,Arg5)|OtherTimes],Quantifier),
    getAspect([time(Arg1,Arg2,Arg3,Arg4,Arg5)|OtherTimes],Aspect),
    extractQQ(qq(Quantifier :: {Path,V},
		 qq(existential :: {(Aspect, V), W},
		    qq((universal=10) :: {(member, W), X},
		       [X0, X]))),
	      XN, Q0, Q1).

extractQQ(qq(Q0, T0), T1, QS0, [Q1 | QS2]) :-
    !,
    extractQQ(Q0, Q1, QS0, QS1),
    extractQQ(T0, T1, QS1, QS2).
extractQQ([H0 | T0], [H1 | T1], Q0, Q2) :-
    !,
    extractQQ(H0, H1, Q0, Q1),
    extractQQ(T0, T1, Q1, Q2).
extractQQ(X0, X1, Q0, Q1) :-
    X0 =.. L0,
    extractQQ(L0, L1, Q0, Q1),
    X1 =.. L1.

extractQQ(X0, X1, QSTACK) :-
    extractQQ(X0, X1, [], QSTACK).

occursIn(X, Y) :-
    X == Y,
    !.
occursIn(X, _) :-
    (var(X); atomic(X)),
    !,
    fail.
occursIn([H | T], V) :-
    !,
    (occursIn(H, V); occursIn(T, V)).
occursIn(X, V) :-
    X =.. [_ | A],
    occursIn(A, V).

checkScopes([], []).
checkScopes([H | T0], S) :-
    xdelete(Q, T0, T1),
    Q = _ :: R,
    (var(R) -> V = R; R = {_, V}),
    occursIn(H, V),
    !,
    checkScopes([Q, H | T1], S).
checkScopes([H | T0], [H | T1]) :-
    checkScopes(T0, T1).


/** Test ======================================================**/



scope(existential,2.0).
scope(indefinite,2.0).
scope(universal, 1.0).
scope(no, 0.3).
scope(generic, 3.0).
scope(name, 0.1).
scope(the, 0.1).
scope(proRef,0.1).
scope(referential, 0.1).
scope(not, 0.3).
scope(claim, 0.2).
scope(query, 0.2).

assignScopeScore([],[]).
assignScopeScore((Q=S)::T, (S, Q::T)) :-
    !.
assignScopeScore((Q::T),(Score,Q::T)):-
    scope(Q,Score).
assignScopeScore(Q,(Score,Q)):-
    scope(Q,Score).

assignScopeScore(Q:POL,(Score,Q:POL)):-
    scope(Q,Score).
assignScopeScore([H0|T0],[H1|T1]):-
    !,
    assignScopeScore(H0,H1),
    assignScopeScore(T0,T1).

compOperator((Score0,_),(Score1,_)):-
    Score0<Score1.

removeScopeScore([],[]).
removeScopeScore((_Score,Q),(Q)).
removeScopeScore([H0|T0],[H1|T1]):-
    !,
    removeScopeScore(H0,H1),
    removeScopeScore(T0,T1).

sortQStack(QS0, QS3):-
    assignScopeScore(QS0,QS1),
    qsort(QS1,QS2,[],compOperator),
    removeScopeScore(QS2,QS3).
    
 /**============================================================== **/
fixQuants(X0, X2) :-
     extractQQ(X0, X1, QSTACK0),
     /*
      If a quantifier *contains* another quantifier in its restrictor
      then we will get problems later on. So we have to check for this
      and re-order them as required
      */
     checkScopes(QSTACK0, QSTACK1),
     sortQStack(QSTACK1,QSTACK2),
     pretty(QSTACK2),
     applyQuants(QSTACK2, X1, X2),
     pretty(X2).
    

applyQuants([], X, X).
applyQuants([Q0::{R, V} | QQ], X0, XN) :-
    !,
    (member(Q0, [indefinite, existential]) ->
     Q1 = exists;
     member(Q0, [universal]) ->
     Q1 = forall;
     member(Q0, [referential]) ->
     Q1 = the;
     Q1 = Q0),
    applyQuants(QQ, X0, X1),
    XN =.. [Q1, V::{R, V}, X1].

applyQuants([Q:_POL | QQ], X0, XN) :-
    !,
    applyQuants(QQ, X0, X1),
    XN =.. [Q, X1].
applyQuants([Q | QQ], X0, XN) :-
    applyQuants(QQ, X0, X1),
    XN =.. [Q, X1].


/**
  Pretty standard quantifier free form: the only real oddity is that
  we convert (P => Q, -) to (P, -_) =>(Q, -), and that we give queries
  negative polarity.
**/

skolem(X, L) :-
    gensym('#', S),
    X =.. [S | L].

qff(X, X, _QSTACK, _POLARITY) :-
    (var(X); atomic(X)),
    !.
qff(A0 => B0, A1 => B1, QSTACK, POL0) :-
    !,
    revpolarity(POL0, POL1),
    qff(A0, A1, QSTACK, POL1),
    qff(B0, B1, QSTACK, POL0).
qff(forall(X, P0), P2, QSTACK, +) :-
    var(X),
    !,
    substitute(Y, X, P0, P1), 
    qff(P1, P2, [Y | QSTACK], +).

qff(forall(X, P0), P2, QSTACK, -) :-
    fail,
    var(X),
    !,
    qff(exists(X, P0), P2, QSTACK, +).
qff(forall(X, P0), P2, QSTACK, -) :- %% my attempt to solve the problem
    var(X),
    !,
    skolem(X, QSTACK),
    qff(P0, P2, QSTACK, -).
qff(forall(X :: {P0}, Q0), QFF, QSTACK, POLARITY) :-
    !,
    qff(forall(X, {P0} => Q0), QFF, QSTACK, POLARITY).
qff(generic(X :: {P0}, Q0), QFF, QSTACK, POLARITY) :-
    !,
    qff(exists(X :: {Q0}, P0), QFF, QSTACK, POLARITY).
qff(no(X :: {P0}, Q0), QFF, QSTACK, POLARITY) :-
    !,
    qff(forall(X :: {P0}, not(Q0)), QFF, QSTACK, POLARITY).
qff(exists(X, P0), P2, QSTACK, +) :-
    var(X),
    !,
    skolem(X, QSTACK),
    qff(P0, P2, QSTACK, +).
qff(exists(X, P0), P2, QSTACK, -) :-
    var(X),
    !,
    qff(P0, P2, [X | QSTACK], -).
qff(exists(X :: {P0}, Q0), QFF, QSTACK, POLARITY) :-
    !,
    qff(exists(X, {P0} & Q0), QFF, QSTACK, POLARITY).
qff(claim(X0), claim(X1), QSTACK, POLARITY0) :-
    !,
    qff(X0, X1, QSTACK, POLARITY0).
qff(query(X0), query(X1), QSTACK, POLARITY0) :-
    !,
    revpolarity(POLARITY0, POLARITY1),
    qff(X0, X1, QSTACK, POLARITY1).
qff([H0 | T0], [H1 | T1], QSTACK, POLARITY) :-
    !,
    qff(H0, H1, QSTACK, POLARITY),
    qff(T0, T1, QSTACK, POLARITY).
qff((A0, B0), (A1, B1), QSTACK, POLARITY) :-
    !,
    qff(A0, A1, QSTACK, POLARITY),
    qff(B0, B1, QSTACK, POLARITY).
qff(not(A0), X, QSTACK, POLARITY) :-
    !,
    qff(A0 => absurd, X, QSTACK, POLARITY).
qff(X0, X1, QSTACK, POLARITY) :-
    X0 =.. L0,
    qffArgs(L0, L1, QSTACK, POLARITY),
    X1 =.. L1.

qffArgs([], [], _QSTACK, _POLARITY).
qffArgs([H0 | T0], [H1 | T1], QSTACK, POLARITY) :-
    qff(H0, H1, QSTACK, POLARITY),
    qffArgs(T0, T1, QSTACK, POLARITY).

qff(X0, X1) :-
    qff(X0, X1, [], +).

doItAll(TXT,XN):-
     parseOne(TXT, X0),
     verbatim(pretty(X0)),
     convSteps2(X0,X1),
     fixQuants(X1,X2),
     format('~nAfter fixQuants~n', []),
     verbatim(pretty(X2)),
     qff(X2,X3),
     pretty(X3),
     anchor(X3,X4),
     pretty(X4),
     X4=..[SPEECHACT,XN],
     pretty(XN),
    (SPEECHACT = claim ->
     addMinutesToKb(XN);
     SPEECHACT = query ->
     tryToAnswer(XN);
     format('Er ??? ~w~~n', [SPEECHACT])).

background([{[name,'John'], X} => {he, X},
	    fact({salient, X})]).

addBackground :-
    background(L),
    addBackground(L).

addBackground([]).
addBackground([H | T]) :-
    assert(H),
    addBackground(T).

startConversation :-
	format('~nstarting a new conversation ~n', []),
	retractall(kb(minutes, _)),
	retractall(fact(_)),
	retractall(_=>_),
	gensym(reset(#)),
	addBackground.

addMinutesToKb(MINUTES):-
	format('~n~w added to knowledge base ~n', [MINUTES]),
	setProblem1(MINUTES).

addToMinutes(Tree):-
	pretty(Tree),
	format('~nAdd the tree to Minutes ~w~n', [Tree]),
	(retract(kb(minutes, MINUTES)) ->
	 assert(kb(minutes, MINUTES & Tree));
	 assert(kb(minutes, Tree))).

tryToAnswer(Tree):-
	format('~nTrying to answer ~w~n', [Tree]),
	INDENT = '',
	indent:label@LABEL -- INDENT,
	(prove(Tree,LABEL) ->
	 (format('~nYes ~w~n', [Tree]),pretty(Tree));
	 format('~nNo~n', [])).

assimilate(A & B) :-
    !,
    assimilate(A),
    assimilate(B).
assimilate({PROP, X}):-
    (gensym('#', X) -> true; true),
    addMinutesToKb({PROP,X}),
    format('~nanchored ~w~w~n', [PROP,X]).
  
anchor(name(X::{[Name:_],X},P0),P1):-
    format('~nTrying to anchor ~w~n', [Name]),
    !,
    INDENT = '',
    indent:label@LABEL -- INDENT,
    (prove({[name, Name], X},LABEL) ->
    true;
    assimilate({[name, Name], X})),
    anchor(P0,P1).

anchor(the(X::{Name,X},P0),P1):-
	format('~nTrying to anchor ~w~n', [Name]),
	!,
	INDENT = '',
	indent:label@LABEL -- INDENT,
	(prove({Name,X},LABEL) ->
	true;
	assimilate({Name,X})),
	anchor(P0,P1).

anchor(proRef(X::{Name,X},P0),P1):-
	format('~nTrying to anchor ~w~n', [Name]),
	!,
	INDENT = '',
	indent:label@LABEL -- INDENT,
	PROP = ({Name, X} & {salient, X}),
	(prove(PROP,LABEL) ->
	true;
	assimilate(PROP)),
	anchor(P0,P1). 
anchor(X, X):-
	format('~n Skip anchor ~w~n', [X]).


/**
  We use X \IN C to mean that X is true in the context C. We sometimes
  end up with things like (X \IN C0) \IN C1, which would be better as
  X \IN C0+C2.
  **/

flattenLabels(X, X) :-
    (var(X); atomic(X)),
    !.
flattenLabels((X0 '\IN' L1) '\IN' L0, X1 '\IN' [L0 | L2]) :-
    !,
    flattenLabels(X0 '\IN' L1, X1 '\IN' L2).
flattenLabels(X0 '\IN' L, X1 '\IN' [L]) :-
    !,
    flattenLabels(X0, X1).
flattenLabels([H0 | T0], [H1 | T1]) :-
    !,
    flattenLabels(H0, H1),
    flattenLabels(T0, T1).
flattenLabels(X0, X1) :-
    X0 =.. L0,
    flattenLabels(L0, L1),
    X1 =.. L1.

/**
  Do it all, print stuff out as you go. If you didn't do some step
  because the flags weren't set to make you do it, don't print out the
  intermediate result:

  Flags are [qlf, fixQuants, qff, addContexts, curry, generics,
  list2conj, simplify, elimEQ]. Some don't do much unless others have
  already been applied, but I'm not doing anything here to ensure that
  only a coherent set are asserted.

  member(F, [qlf, fixQuants, qff, addContexts, curry, generics,
  list2conj, simplify, elimEQ]), set(F), fail.
  **/

nf(X, FLATTENLABELS) :-
    (?printing -> (nl, pretty(baseTree(dtree@X))); true),
    denest(dtree@X, DN),
    justRoots(DN, JR),
    (?printing -> (nl, pretty(justRoots(JR))); true),
    nfTree(JR, NF),
    (?printing -> (pretty(nf(NF))); true),
    (?qlf -> qlf(NF, QLF); QLF = NF),
    ((?printing, ?qlf) -> (nl, pretty(qlf(QLF))); true),
    (?fixQuants -> fixQuants(QLF, FQ); FQ = QLF),
    ((?printing, ?fixQuants) -> (nl, pretty(fixQuants(FQ))); true),
    (?qff -> qff(FQ, QFF); QFF = FQ),
    ((?printing, ?qff) -> (nl, pretty(qff(QFF))); true),
    (?addContexts -> addContexts(QFF, CONTEXTUALISED); QFF = CONTEXTUALISED),
    ((?printing, ?addContexts) -> (nl, pretty(addContexts(CONTEXTUALISED))); true),
    (?curry -> curry(CONTEXTUALISED, CURRIED); CURRIED = QFF),
    ((?printing, ?curry) -> (nl, pretty(curried(CURRIED))); true),
    (?generics -> generics(CURRIED, GENERICS); GENERICS = CURRIED),
    ((?printing, ?generics) -> (nl, pretty(generics(GENERICS))); true),
    (?list2conj -> list2conj(GENERICS, LIST2CONJ); LIST2CONJ = GENERICS),
    ((?printing, ?list2conj) -> (nl, pretty(list2conj(LIST2CONJ))); true),
    (?simplify -> simplify(LIST2CONJ, SIMP); SIMP = LIST2CONJ),
    ((?printing, ?simplify) -> (nl, pretty(simplify(SIMP))); true),
    (?elimEQ -> elimEQ(SIMP, ELIMEQ); ELIMEQ = SIMP),
    ((?printing, ?elimEQ) -> (nl, pretty(elimEQ(SIMP, ELIMEQ))); true),
    flattenLabels(ELIMEQ, FLATTENLABELS).

