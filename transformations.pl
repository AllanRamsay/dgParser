%% Parser
:- ensure_loaded([setup]).

%% Fancy bit: if we haven't run setup before, then sign
%% will throw an exception, so we know we do need to run it
:- catch(sign(X), _, setup(allwords)).
%%%%%%%%%%%%%%% Last Week Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Yet To-Do:
   1-fix the rplaced variables [X] to be X
   2-Dealing with morphological differences cat> , cat>s should be
   considered shared item.
/*
[NOTE]: We are no longer turning trees into lists using the =..
operator because now we know that a tree is a list of a head and a tail,
the head is in the form (Word:Tag).The tail is a list of daughters which
are other sub-trees of the form {Role,List}.
*/
%%%%%%%%%%%%%%% Transformation (1)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*--------------------------------------------------------------------
Step 1: Get open-class words for each tree separatly.
--------------------------------------------------------------------*/
getOpenClass(T, OPEN) :-
    getOpenClass(T, [], OPEN).

getOpenClass(X, OPEN, OPEN) :-
    (var(X); atomic(X)),
    !.

getOpenClass([H | T], OPEN0, OPEN2) :-
    !,
    getOpenClass(H, OPEN0, OPEN1),
    getOpenClass(T, OPEN1, OPEN2).
/*
I added the TAG (name) to the list of tags as it represents proper noun
The TAG could be a veriable because not all words has a certain proper
tag (for now), thus, having a variable as a tag is going to be ignored.
*/  
getOpenClass((WORD:TAG), OPEN0, OPEN1) :-
    ((var(TAG); \+ member(TAG, [noun, verb, name])) ->
     OPEN1 = OPEN0;
     member(WORD:TAG, OPEN0) ->
     OPEN1 = OPEN0;
     OPEN1 = [(WORD:TAG) | OPEN0]).

getOpenClass({_ROLE, L}, OPEN0, OPEN1) :-
    !,
    getOpenClass(L, OPEN0, OPEN1).

/*-------------------------------------------------------------------------
Step 2: For two lists of open-class words, find & return the shared ones
-------------------------------------------------------------------------*/

getSharedOpenClassItems(X, Y, SHARED) :-
    getOpenClass(X, OPENX),
    getOpenClass(Y, OPENY),
    shared2(OPENX, OPENY, SHARED).

shared0([], _L, []).
shared0([H | T], Y, [H | SHARED]) :-
    member(H, Y),
    !,
    shared0(T, Y, SHARED).
shared0([_ | T], Y, SHARED) :-
    shared0(T, Y, SHARED).

shared1(L0, L1, SHARED) :-
    findall(X, (member(X, L0), member(X, L1)), SHARED).

shared2(L0, L1, SHARED) :-
    qsort(L0, LS0),
    qsort(L1, LS1),
    shared2q(LS0, LS1, SHARED).

shared2q([], _, []).
shared2q(_, [], []).
shared2q([H0 | T0], [H1 | T1], SHARED2) :-
    (H0 = H1 ->
     (shared2q(T0, T1, SHARED1),
      SHARED2 = [H0=_ | SHARED1]);
     H0 @< H1 ->
     shared2q(T0, [H1 | T1], SHARED2);
     shared2q([H0 | T0], T1, SHARED2)).

/*-------------------------------------------------------------------------
  Step 3: Using the shared liset optained from the previous step, each tree
  will be scaned for these items and got replaced by variables-one tree at a
  time.
-------------------------------------------------------------------------*/
repSharedByVar(X, X, _VARS) :-
    (atomic(X); var(X)),
    !.
repSharedByVar([H0 | T0], [H1 | T1], VARS) :-
    !,
    repSharedByVar(H0, H1, VARS),
    repSharedByVar(T0, T1, VARS).
repSharedByVar(W:T, V, VARS) :-
    member((W:T)=V, VARS), 
    !.
repSharedByVar({R, T0}, {R, T1}, VARS) :-
    !,
    repSharedByVar(T0, T1, VARS).
repSharedByVar(X, X, _VARS).

%%%Transformation (2)-Part(1): turn a tree into a term and a stack of specifiers.%%%%
/**-----------------------------------------------------------------------------------
  note that before turning a tree into a term and a stack of specifiers, we call
  fixTree first.
  [To run this part]: parseOne('every man loved some woman .',X),fixTree(X,X1),
  toTermAndStack(X1,Term,Stack),pretty(Term+Stack).
-----------------------------------------------------------------------------------**/

fixTree(V, V) :-
    (var(V); atomic(V)),
    !.
fixTree([('.' : punct), {(claim, T0)}], T1) :-
    !,
    fixTree(T0, T1).
fixTree([('?' : punct), {(query, T0)}], T1) :-
    !,
    fixTree(T0, T1).
fixTree({R, T0}, (R, T1)) :-
    fixTree(T0, T1).
fixTree([{R, T0}], (R, T1)) :-
    nonvar(T0),
    !,
    fixTree(T0, T1).
fixTree([(be : verb), {(subject , S)}, {(predication(xbar(v(+),n(+))) , P)}], (P, S)) :-
    !.
fixTree([(be : verb), {(subject , S)}, {(predication(xbar(v(-),n(+))) , P)}], (P = S)) :-
    !.
fixTree([X0, {R, T} | L0], X1 & F) :-
    nonvar(T),
    !,
    fixTree(X0, X1),
    fixTree([{R, T} | L0], F).
fixTree([H0 | T0], [H1 | T1]) :-
    !,
    fixTree(H0, H1),
    fixTree(T0, T1).
fixTree(X0, X1) :-
    X0 =.. L0,
    fixTree(L0, L1),
    X1 =.. L1.

toTermAndStack(X,Term,Stack):-
    toTermAndStack(X,Term,[],Stack).

toTermAndStack(X, X, VARS, VARS) :-
    (var(X); atomic(X)),
    !.
%%Sometimes we want to apply SUBSTACK on Term directly? explain more? why?
toTermAndStack({(xcomp, X)}, {(xcomp, Z)}, MAINSTACK, MAINSTACK) :-
    fail,
    toTermAndStack(X, Y, SUBSTACK),
    %% We are going to want to take some of what is in
    %% SUBSTACK and add it to MAINSTACK
    normalForming(SUBSTACK, Y, Z).

toTermAndStack(['.':punct|T0],T1, VARS0,VARS1) :-
    !,
    toTermAndStack(T0,T1,VARS0,VARS1).

toTermAndStack(spec(tense(T,-),L0), (at, V, E) & (L1, E), VARS0, [[some:V, (tense(T), V)], [some:E] | VARS1]) :-
    !,
    toTermAndStack(L0, L1, VARS0, VARS1).

toTermAndStack(spec(tense(T, +), L0), (at, V, E) & (L2, E), VARS0,[[the: E, (tense(T), E)], [some: V] | VARS1]) :-
    !,
    collectAuxs(L0,L1),
    toTermAndStack(L1, L2, VARS0,VARS1).

toTermAndStack(spec([his:_],[W:TAG]), V, VARS0, [[the:V, (W:TAG, V) & own(X, V)], [the:X, (male, X)] | VARS0]) :-
    !.

toTermAndStack(spec([DET:_],[W:TAG]), V, VARS0, [[DET:V, (W:TAG, V)] | VARS0]) :-
    !.

toTermAndStack(spec([DET:_],[W:TAG | L0]), [V|L1], VARS0,[[DET:V, (W:TAG,V)]|VARS1]) :-
    \+ (W=of),
    toTermAndStack(L0, L1, VARS0,VARS1),
    !.

toTermAndStack(spec([DET:_],L0), [V|L1], VARS0,[[DET:V]|VARS1]) :-
    toTermAndStack(L0, L1, VARS0,VARS1),
    !.

toTermAndStack(spec(name,[W:_TAG]),V, VARS0,[[the:V,(named(W),V)]|VARS0]) :-
    !.

toTermAndStack(spec(proRef,L), V, VARS0, [[the:V,(salient(L),V)]|VARS0]) :-
    !.

toTermAndStack({claim, T0}, T1, VARS0,VARS1) :-
    !,
    toTermAndStack(T0, T1, VARS0,VARS1).
toTermAndStack({query, T0}, T1, VARS0,VARS1) :-
    !,
    toTermAndStack(T0, T1, VARS0,VARS1).

toTermAndStack([H0 | T0], [H1 | T1], VARS0,VARS2) :-
    !,
    toTermAndStack(H0, H1, VARS0,VARS1),
    toTermAndStack(T0, T1, VARS1,VARS2).

toTermAndStack(X0, X1, VARS0, VARS1) :-
    X0 =.. L0,
    toTermAndStack(L0, L1, VARS0, VARS1),
    X1 =.. L1.

/**----------------------------------------------------------------------------
  collectAux collect auxiliaries into single list for plus tensesd sentences.
  Note:To be fixed so that we collcet auxiliaries as a single list
----------------------------------------------------------------------------**/
collectAuxs([],[]).
collectAuxs(Word:aux,Word:aux):-
	!.

collectAuxs([H0|T0],[H1|T1]):-
	!,
	collectAuxs(H0,H1),
	collectAuxs(T0,T1).

collectAuxs({R, T0}, {R, T0}) :-
    \+ (R=auxcomp),
    !.

collectAuxs({auxcomp, T0}, T1) :-
    !,
    collectAuxs(T0, T1).
collectAuxs(X,X).


%%%%%%%Transformation (2)-Part(2): Construct the forward-chaining normal form %%%%%%%%%%%%
/**----------------------------------------------------------------------------------------
  The normal form is constructed by applying the specifiers stack collected in the first
  part to the term. But first this stack is to be sorted using sortQStack.
  [To run this part]: parseOne('every man loved some woman .',X),fixTree(X,X1),
  toTermAndStack(X1,Term,Stack),sortQStack(Stack,NStack),logicalNormalForming(NStack,Term,NF),
  pretty(NF).
  -----------------------------------------------------------------------------------------**/
/**
  [sortQStack]
  Allan: 28/04/2017
  
  We can't just qsort on the stack for two reasons

  (i) I'd like to be able to backtrack through quantifiers with the
  same scope value, so that we can get the alternative readings of
  "Every man loves some woman. Isn't she lucky" and "Someone is mugged
  every five minutes in New York, and he's getting pretty sick of it"

  (ii) If we just use qsort on the whole quantifier, then ones with
  the same scope value get ordered by the next element of the
  quantifier, e.g.

  [(the : E), ((wife>):noun,E & own(F,E))],
  [(the : F), (male , F)],
  [(the : D), (named(John) , D)]

  gets reordered to

  [(the : A), (named(John) , A)],
  [(the : B), ((wife>):noun,B & own(C,B))],
  [(the : C), (male , C)]

  You could use my qsort with qsort(L0, L1, [], comparequants)
  where comparequants just looked at the score.
  
  **/
scope(the, 0.0).
scope(tense(past,+),0.1).

scope(a, 3.0).
scope(many, 3.0).
scope(few, 3.0).
scope(some, 3.0).
scope(tense(past,-),3.0).

scope(all, 3.1).
scope(each, 3.1).
scope(every, 3.0).

scope(_,5.0).

assignScopeScore([],[]).
assignScopeScore([(Q1 : VAR) | REST],[S1,(Q1 : VAR) | REST]):-
	!,
	scope(Q1,S1).
assignScopeScore([(Q1 : VAR)],[S1,(Q1 : VAR)]):-
	!,
	scope(Q1,S1).
assignScopeScore([H0|T0],[H1|T1]):-
	!,
	assignScopeScore(H0,H1),
	assignScopeScore(T0,T1).

removeScopeScore([],[]).
removeScopeScore([_S1,(Q1 : VAR) | REST],[(Q1 : VAR) | REST]).
removeScopeScore([_S1,(Q1 : VAR)],[(Q1 : VAR)]).
removeScopeScore([H0|T0],[H1|T1]):-
	!,
	removeScopeScore(H0,H1),
	removeScopeScore(T0,T1).

sortQStack(QS0, QS3):-
    assignScopeScore(QS0,QS1),
    qsort(QS1,QS2),
    removeScopeScore(QS2,QS3).


/*
  Allan, 20/04/2017

  I've changed these systematically so that they put the
  variable in the standard place (i.e. directly after the
  quantifier) as we did for every and some this morning.

  */

/* Universals */
pattern([every:V,(VP,V)],T,every(V, (VP, V) => T)).
pattern([each:V,(VP,V)],T,each(V, (VP,V) => T)).
pattern([all:V,(VP,V)],T,forall(V, (VP, V) => T)).
pattern([most:V,(VP,V)],T,forall(V, (VP, V) & default(T) => T)).
pattern([no:V,(VP,V)],T,every(V, (VP, V) => not(T))).

/* Existential */
pattern([a:V,(VP,V)],T,a(V, (VP, V) & T)).
pattern([some:V,(VP,V)],T,exists(V, (VP, V) & T)).
pattern([some:V],T, exists(V, T)).
pattern([many:V,(VP,V)],T,many(V, (VP,V) & T)).
pattern([few:V,(VP,V)],T, few(V, (VP,V) & T)).
pattern([tense(Tense,-):V], T, exists(V, tense(Tense, V) & T)).

/* Referential */
pattern([the:V, R],T,the(V :: {R},T)) :-
    nonvar(R).
pattern([tense(Tense,+):V],T, Q) :-
    pattern([the:V, (tense(Tense), V)], T, Q).

/* others */
pattern([Specifier:V,(VP,V)],T, X) :-
    X =.. [Specifier, (VP,V),T].
pattern(Specifier,T,Q) :-
    Q =.. [Specifier,T].

normalForming([], T, T).
normalForming([H | L], T, NF) :-
    normalForming(L,T,NF0),
    (pattern(H, NF0, NF) -> true; fail).


%%%%%%%%%%%%%% Transformation (3): Skolemisation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Run example:   parseOne('every man loved some woman .', X), doItAll(X,NF), pretty(NF), qff(NF, QFF), pretty(QFF).

%it's convenient to have function to find the swapped version of the polarity.
swap(+, -).
swap(-, +).
/* The approach I'm going to take involves working recursively through my
formula. As I go there are two things I need -- a stack of universally
quantifier variables and a polarity marker. These start out as [] and
+ */

/**
  Allan, 20/04/2017

  qff was already defined about right. The only changes
  I've made are:

  (i) make copies of the rules for some and all
  so that they do the same thing for exists and some

  (ii) add a rule for "the". Not convinced by it, but we can
  change it once we start using the inference engine.

  (ii) add the rule that says ((A & B), X) is the same as (A, X) & (B,
  X). This is easily justified on the grounds that we can think of (P,
  X) as saying that X is in the set denoted by P (standard
  interpretation of predicates) and that (A & B) is the intersection
  of A and B. Then obviously X is in (A & B) iff X is in A and X is in
  B.

 **/

qff(A0, A1) :-
    qff(A0, A1, [], +).

qff(V, V, _S, _P) :-
    (var(V); atomic(V)),
    !.

qff((at, _, _) & P0, P1, S, P) :-
    !,
    qff(P0, P1, S, P).

qff(([P0], V), (P1, V), _S, _P) :-
    qff(P0, P1),
    atomic(P1),
    (var(V); atomic(V)),
    !.

/*
  There are then a surprisingly small set of cases to consider.
  Simple ones: assuming that I've dealt with quantifiers outside a conjunction or disjunction,
  I will just deal with the conjuncts/disjuncts individually. It doesn't matter what the polarity is.
*/
qff(A0 & B0, A1 & B1, S, P) :-
    !,
    qff(A0, A1, S, P),
    qff(B0, B1, S, P).
qff(A0 or B0, A1 or B1, S, P) :-
    !,
    qff(A0, A1, S, P),
    qff(B0, B1, S, P).

/*
  Negation: just replace it by => absurd. Doesn't matter what the polarity
  was. not(A) is, by definition, a shorthand for A => absurd. So just do
  the replacement.
*/

qff(not(A0), QFF, S, P) :-
    !,
    qff(A0 => absurd, QFF, S, P).

/*
  Stupid ones: "every" just means "forall", "a" just means "exists", ...
*/

qff(every(X, A0), A1, S, P) :-
    !,
    qff(forall(X, A0), A1, S, P).

qff(a(X, A0), A1, S, P) :-
    !,
    qff(exists(X, A0), A1, S, P).

qff(some(X, A0), A1, S, P) :-
    !,
    qff(exists(X, A0), A1, S, P).

/*
  The quantifiers. In positive contexts, we just drop univerals (while
  adding them to the stack) and Skolemise existentials.
*/

qff(the(A :: {P0}, Q0), the(A :: {P1}, Q1), S, POL) :-
    !,
    qff(P0, P1, S, POL),
    qff(Q0, Q1, S, POL).
qff(forall(X, A0), A1, S, +) :-
    !,
    qff(A0, A1, [X | S], +).
qff(exists(X, A0), A1, S, +) :-
    !,
    gensym(sk, SK),
    X = [SK | S],
    qff(A0, A1, S, +).

/*
  But in negative contexts we do it the other way round.
*/

qff(exists(X, A0), A1, S, -) :-
    !,
    qff(A0, A1, [X | S], -).
qff(forall(X, A0), A1, S, -) :-
    !,
    gensym(sk, SK),
    X = [SK | S],
    qff(A0, A1, S, -).

/*
  Implications. This is the interesting one. These swap the polarity on
  the antecedent and leave it unchanged on the consequent. And that's
  all. We'll see that in action in a minute, because it's not 100% clear %
  at first sight that this is right.
*/

qff(A0 => B0, A1 => B1, S, P0) :-
    !,
    swap(P0, P1),
    qff(A0, A1, S, P1),
    qff(B0, B1, S, P0).

qff(((A & B), V), Q, S, P) :-
    !,
    qff((A, V) & (B, V), Q, S, P).

qff(default(P0), default(P1), S, P) :-
    !,
    qff(P0, P1, S, P).
qff((A0, B0), (A1, B1), S, P) :-
    !,
    qff(A0, A1, S, P),
    qff(B0, B1, S, P).
qff(X0:_TAG, X1, S, P) :-
    !,
    qff(X0, X1, S, P).
qff(X0>_AFF, X1, S, P) :-
    !,
    qff(X0, X1, S, P).
/*
  And otherwise we just leave it unchanged.
*/
qff([H0 | T0], [H1 | T1], S, P) :-
    !,
    qff(H0, H1, S, P),
    qff(T0, T1, S, P).
qff(X0, X1, S, P) :-
    X0 =.. L0,
    qff(L0, L1, S, P),
    X1 =.. L1.


curry(X, X) :-
    (var(X); atomic(X)),
    !.
curry([H0 | T0], [H1 | T1]) :-
    !,
    curry(H0, H1),
    curry(T0, T1).
curry((A, B), X) :-
    A -- (C, D),
    !,
    curry((C, (B, D)), X).
curry(X0, X1) :-
    X0 =.. L0,
    curry(L0, L1),
    X1 =.. L1.

forwards(X, X) :-
    (var(X); atomic(X)),
    !.
forwards((tense(_), _) & P0, P1) :-
    !,
    forwards(P0, P1).
forwards(default(P0), default(P1)) :-
    !,
    forwards(P0, P1).
forwards(A0 => B0, R) :-
    !,
    forwards(A0, A1),
    forwards(B0, B1),
    (B1 = (X & Y) ->
     (forwards(A1 => X, P),
      forwards(A1 => Y, Q),
      R = (P & Q));
     R = (A1 => B1)).
forwards(A0 & B0, A1 & B1) :-
    !,
    forwards(A0, A1),
    forwards(B0, B1).
forwards([H0 | T0], [H1 | T1]) :-
    !,
    forwards(H0, H1),
    forwards(T0, T1).
forwards(X0, X1) :-
    X0 =.. L0,
    forwards(L0, L1),
    X1 =.. L1.


doItAll(TXT, XN) :-
    parseOne(TXT, X0),
    X0 = [_, {SPEECHACT, X1}],
    (SPEECHACT = claim ->
     P = +;
     SPEECHACT = query ->
     P = -;
     throw('WeirdTree'(X0))),
    %% This is what we do to a parse tree to get its normal form
    %% We would like to do this independently (wrong word) to embedded
    %% sentences ("I know she loves me", "I doubt that anyone likes me", ...)
    %% At the moment we do it with implicit +polarity
    %% We should make the polarity explicit, and in certain contexts it
    %% will be negative
    fixTree(X1, X2),
    toTermAndStack(X2, X3, QS0),
    sortQStack(QS0, QS1),
    normalForming(QS1, X3, X4),
    qff(X4, X5, [], P),
    curry(X5, X6),
    forwards(X6, X7),
    %%
    pretty(X7),
    anchor(X7, XN),
    pretty(XN),
    (SPEECHACT = claim ->
     addToMinutes(XN);
     SPEECHACT = query ->
     tryToAnswer(XN);
     format('Er ??? ~w~~n', [SPEECHACT])).

/*
  Allan 28/4/2017
  anchor has to look at its argument and see if it
  looks like with the((A :: {D}), P)

  Try to prove D. If that succeeds, then it should bind
  A.

  Do it again to P!

  If it works, then P is the answer.

  If it doesn't, then we have to pretend that there is
  something that fits D (you'd never heard of John, but
  you didn't say "Who's John?", you just got on with it).

  How do we do that? By binding A to a new Skolem constant
  and returning D & P. That's pretty close to accommodation.
  */

anchor(the(A :: {D},P),the(A :: {D},P)):-
    !,  
    format('~nTrying to answer ~w~n', [the(A :: {D},P)]),
    (prove(D, '') ->
     format('~nYes ~w~n', [D]);
     format('~nNo~n', [])),
    anchor(P,P).
anchor(X, X).

addToMinutes(A & B):-
    !,
    addToMinutes(A),
    addToMinutes(B).
addToMinutes(A) :-
    assert(kb(minutes, A)).

startConversation :-
    retractall(kb(minutes, _)).

tryToAnswer(X) :-
    format('~nTrying to answer ~w~n', [X]),
    (prove(X, '') ->
     format('~nYes ~w~n', [X]);
     format('~nNo~n', [])).





  /** Allan 27/4/2017

    
the((A :: {(man>):noun,A}),
    the((B :: {tense(past),B}),
        a(C,
          (((woman>):noun , C)
            & exists(D,
                     ((at , B,D)
                       & (((will : aux)
                            & ((auxcomp,
                                ((have> : aux)
                                  & (auxcomp,
                                     ((love>ed):verb & dobj,C))))
                                & (subject , A))),
                          D)))))))
    
the((A :: {(man>):noun,A}),
    exists((B :: {tense(past), will, have}, B}),
        a(C,
          (((woman>):noun , C)
            & exists(D,
                     ((at , B,D)
                       & ((love>ed):verb & dobj,C) & (subject , A), D)))))))

Each man kills the thing he loves
* Every man kills the thing he loves

If you think of a man, then I am telling you that that man loves something and he kills that thing

(((man>):noun , A)
  => (((woman>):noun , [sk1,A])
       & (tense(past, [sk2, A])
           & ((at , [sk2,A],[sk0,A])
               & (((love>ed):verb , [sk0,A])
                   & ((dobj,[sk1,A] , [sk0,A])
                       & (subject,A , [sk0,A])))))))
(((man>):noun , A)
  => (woman>):noun , [sk1,A])
& (man>):noun , A)
  => (tense(past, [sk2, A])
& (man>):noun , A)
  =>((at , [sk2,A],[sk0,A])
& (man>):noun , A)
  => (((love>ed):verb , [sk0,A])
& ...
                   & ((dobj,[sk1,A] , [sk0,A])
                       & (subject,A , [sk0,A])))))))

P => (Q & R) --> (P => Q) & (P => R)

    Let's get the normal forms of

  "every man loved some woman"
  "John is a man"
  "John loved a woman"

  and package up "every man loved some woman" and "John is
  a man" as the knowledge base for a call of satchmo and
  "John loved a woman" as the goal.


the((A :: {named(John),A}),
    (((man>):noun , [sk0])
      & (be:verb & (predication,[sk0])&(subject,A))))

-->
the((A :: {named(John),A}),
    (((man>):noun , [sk0])
       A=[sk0]))

There's someone called John. There's a man. They are the same thing.
|-
John has all the properties that any man has.
-->
the((A :: {named(John),A}), man(A))

NL inference is done in a context. The context consists of general background knowledge plus whatever is in the minutes
of this conversation.

When I say something, it gets added to the minutes.

But it might have contained some referring expressions. We ought to try to deal with those before we add it
to the minutes.

How do we deal with them? For nice simple ones (like "John" in our example) that aren't interacting with any
other quantifiers, we have to prove that there is something that fits this description, and we'd like to show that
there is nothing else which can be proven to fit it. When we do this proof, we will get a Skolem constant.

To handle "John loved a woman", we will assume that the minutes or the background knowledge include named(John, [sk12]).

So given a sentence, look for wide scope referring expressions. Try to prove that there is something like this, using
the minutes+BK. prove(named(John, X)) will bind X to [sk12]. This *will* substitute sk12 for X in the NF for "John loved a woman". We will get man(sk0), sk12=sk0.
    
**/

