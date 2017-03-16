%% Parser
:- ensure_loaded([setup]).

%% Fancy bit: if we haven't run setup before, then sign
%% will throw an exception, so we know we do need to run it
:- catch(sign(X), _, setup(allwords)).
%%%%%%%%%%%%%%% Last Week Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Yet To-Do:
   1-fix the rplaced variables [X] to be X
   2-Dealing with morphological differences cat> , cat>s should be considered shared item.
/*
[NOTE]: We no longer turning tress into lists using the =.. operator becasue now we now that a tree is a list of a head and a tail,the head is in the form (Word:Tag). The tail is a list of daughters which are other sub-trees of the form {Role,List}.
*/
%%%%%%%%%%%%%%% Transformation (1)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------------------------
%Step 1: Get open-class words for each tree separatly.
%--------------------------------------------------------------------
getOpenClass(T, OPEN) :-
    getOpenClass(T, [], OPEN).

getOpenClass(X, OPEN, OPEN) :-
    (var(X); atomic(X)),
    !.

getOpenClass([H | T], OPEN0, OPEN2) :-
    !,
    getOpenClass(H, OPEN0, OPEN1),
    getOpenClass(T, OPEN1, OPEN2).

%% I added the TAG (name) to the list of tags as it represents proper noun
%% The TAG could be a veriable because not all words has a certain proper tag (for now), thus, having a variable as a tag is going to be ignored. 
getOpenClass((WORD:TAG), OPEN0, OPEN1) :-
    ((var(TAG); \+ member(TAG, [noun, verb, name])) ->
     OPEN1 = OPEN0;
     member(WORD:TAG, OPEN0) ->
     OPEN1 = OPEN0;
     OPEN1 = [(WORD:TAG) | OPEN0]).

getOpenClass({_ROLE, L}, OPEN0, OPEN1) :-
    !,
    getOpenClass(L, OPEN0, OPEN1).

%-------------------------------------------------------------------------
%Step 2: For two lists of open-class words, find & return the shared ones 
%-------------------------------------------------------------------------

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

%-------------------------------------------------------------------------
%Step 3: Using the shared liset optained from the previous step, each tree will be scaned for these items and got replaced by variables-one tree at a time. 
%-------------------------------------------------------------------------
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

%%%%%Transformation (2)-Part(1): turn a tree into a term and a stack of specifiers.%%%%
%% Run Example: parseOne('every man loved some woman .', X),rep3(X,Y,Z), pretty(Y+Z).

rep3(X,Y,V):-
    rep3(X,Y,[],V).

rep3(X, X, VARS0, VARS0) :-
    var(X),
    !.

rep3([],[], VARS0, VARS0) :-
    !.

/*rep3([W:T|T0],[W:T|T1], VARS0,VARS1) :-
    rep3(T0,T1,VARS0,VARS1),
    !.
  */
rep3(['.':punct|T0],T1, VARS0,VARS1) :-
    rep3(T0,T1,VARS0,VARS1),
    !.
rep3(spec(Tense,L0),[at(V)|L1], VARS0,VARS2) :-
    Tense=tense(_,_),
    rep3(L0, L1, VARS0,VARS1),
    (member([spec(Tense,L0,V)], VARS1)->
    VARS2=VARS1;
    VARS2=[[spec(Tense,L0,V)]|VARS1]),
    !.

rep3(spec([DET:_],[W:TAG]), V, VARS0,VARS1) :-
    (member([DET:V,([W:TAG],V)], VARS0)->
    VARS1=VARS0;
    VARS1=[[DET:V,([W:TAG],V)]|VARS0]),
    !.

rep3(spec([DET:_TAG],L0), [V|L1], VARS0,VARS2) :-
    rep3(L0, L1, VARS0,VARS1),
    (member([DET:V,(L0,V)], VARS1)->
    VARS2=VARS1;
    VARS2=[[DET:V,(L0,V)]|VARS1]),
    !.
rep3(spec(proRef,L), V, VARS0,VARS1) :-
    (member(proRef:V,(L,V), VARS0)->
    VARS1=VARS0;
    VARS1=[proRef:V,(L,V)|VARS0]),
    !.

rep3({R, T0}, {R, T1},VARS0,VARS1) :-
    \+ (R=claim),
    !,
    rep3(T0, T1, VARS0,VARS1).

rep3({claim, T0}, {T1},VARS0,VARS1) :-
    !,
    rep3(T0, T1, VARS0,VARS1).

rep3([H0 | T0], [H1 | T1], VARS0,VARS2) :-
    !,
    rep3(H0, H1, VARS0,VARS1),
    rep3(T0, T1, VARS1,VARS2).

rep3(X, X, _VARS0,_VARS1).




%%%%%%%Transformation (2)-Part(2): Construct the forward-chaining normal form %%%%%%%%%
%% Run example:  parseOne('every man loved some woman .', X),rep3(X,T,Qstack),normalForming(Qstack,T,NF),pretty(NF).
pattern([every:V,(VP,V)],T,[every:V,(VP,V) => T]).
pattern([a:V,(VP,V)],T,[a:V,(VP,V) & T]).
pattern([some:V,(VP,V)],T,[some:V,(VP,V) & T]).
pattern([some:V,(VP,V)],T,[some:V,(VP,V) & T]).
pattern([spec(tense(past,-),_Sentence,V)],T,[exists:V,(tense(past,V),T)]).
%pattern([spec(tense(past,-),_Sentence,V)],T,[exists,(tense(past,-):V,T)]).
normalForming([], T, T).
normalForming([H | L], T, NF) :-
    !,
    normalForming(L,T,NF0),
    pattern(H, NF0, NF).
%% Run example:  parseOne('every man loves a woman', X),rep2(X,T,Qstack),lnf(Qstack,T,LNF),pretty(LNF).
pattern2([every:det:V,{VP}],T,[forall(V, {VP,V}) => T]).
pattern2([a:det:V,{VP}],T,[exists(V, {VP,V}) & T]).
pattern2([some:det:V,{VP}],T,[exists(V, {VP,V}) & T]).

logicalNormalForming([], T, T).
logicalNormalForming([H | L], T, NF) :-
    !,
    logicalNormalForming(L,T,NF0),
    pattern2(H, NF0, [NF|_]).

%%%%%%%%%%%%%% Transformation (4): Skolemisation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Run example:  parseOne('every man loves a woman', X),rep2(X,T,Qstack),lnf(Qstack,T,LNF),qff(LNF,SNF),pretty(SNF).

%it's convenient to have function to find the swapped version of the polarity.
swap(+, -).
swap(-, +).
/* The approach I'm going to take involves working recursively through my
formula. As I go there are two things I need -- a stack of universally
quantifier variables and a polarity marker. These start out as [] and
+ */

qff(A0, A1) :-
    qff(A0, A1, [], +).
/* There are then a surprisingly small set of cases to consider.
 Simple ones: assuming that I've dealt with quantifiers outside a conjunction or disju ction, I will just deal with the conjuncts/disjuncts individually. It doesn't matter what the polarity is. */
qff(A0 & B0, A1 & B1, S, P) :-
    !,
    qff(A0, A1, S, P),
    qff(B0, B1, S, P).
qff(A0 or B0, A1 or B1, S, P) :-
    !,
    qff(A0, A1, S, P),
    qff(B0, B1, S, P).

/* Negation: just replace it by => absurd. Doesn't matter what the polarity
was. not(A) is, by definition, a shorthand for A => absurd. So just do
the replacement. */

qff(not(A0), QFF, S, P) :-
    !,
    qff(A0 => absurd, QFF, S, P).

/*The quantifiers. In positive contexts, we just drop univerals (while
adding them to the stack) and Skolemise existentials.*/

qff(forall(X, A0), A1, S, +) :-
    !,
    qff(A0, A1, [X | S], +).
qff(exists(X, A0), A1, S, +) :-
    !,
    gensym(sk, SK),
    X = [SK | S],
    qff(A0, A1, S, +).

/* But in negative contexts we do it the other way round.*/

qff(exists(X, A0), A1, S, -) :-
    !,
    qff(A0, A1, [X | S], -).
qff(forall(X, A0), A1, S, -) :-
    !,
    gensym(sk, SK),
    X = [SK | S],
    qff(A0, A1, S, -).

/* Implications. This is the interesting one. These swap the polarity on
the antecedent and leave it unchanged on the consequent. And that's
all. We'll see that in action in a minute, because it's not 100% clear
at first sight that this is right. */

qff(A0 => B0, A1 => B1, S, P0) :-
    !,
    swap(P0, P1),
    qff(A0, A1, S, P1),
    qff(B0, B1, S, P0).

/* And otherwise we just leave it unchanged.*/

qff(A, A, _, _).











/**-----------------------Allan's tasks notes----------------------------------
Task 2:
------
every man loves some woman

forall(X :: {man(X)},
       exists(Y :: {woman(Y)},
	           love(X, Y)))

New ones[02-02-17 update]:
[ (love>s):verb,
 {arg(dobj,+),[a:det,{arg(headnoun,-),[(woman>''):noun]}]}, 
 {arg(subject,+),[every:det,{arg(headnoun,-),[(man>''):noun]}]}] 

[(every : det: X), {(arg(arg(headnoun),-) , [(man>):noun])}])},
 (a : det: Y), {(arg(arg(headnoun),-) , [(woman>):noun])}])}],
   [(love>s : verb),
   {arg(dobj, +), Y},
   {arg(subject, +), X}]

  
Recurse through the tree. If the thing you find is a tree whose head is a determiner (that's quite a complicated condition), replace it by a variable and remember the association betwen the variable and this subtree.

Task 3:
------
 
  Y = [(love>s):verb,{arg(dobj,+),_A},{arg(subject,+),_B}],
  Z = [[every:det:_B,{arg(headnoun,-),[(man>''):noun]}],[a:det:_A,{arg(headnoun,-),[(woman>''):noun]}]]

pattern([every:det:B,{BP}]=[T, every:det:B, BP => T]).
pattern([some:det:B,{BP}]=[T, some:det:B, BP & T]).

  To combine a quantifier stack with a term:

  (i) if the qstack is empty, return the term
  (ii) get the top item on the quantifier stack. Find its pattern: that will be something like
  [Q:det:B,{BP}]=[T, Q:det:B, f(B, BP, T)]

  Apply the rest of the qstack to the term. Got a new term, T'.
  Answer is f(B, BP, T').

  
Task 4:
-------
  Skolem normal form
  -------------------
  forall(X, man(X) => exists(Y, woman(Y) & love(X, Y)))
  
  man(X) => woman(sk17([X]))
  man(X) => love(X, sk17([X]))

  woman(sk17(X)) :- man(X).
  ...

  Cases (at all times I've got a qstack, which starts empty and a polarity, which starts 1):

  not(exists(X, P)) ===== forall(X, not(P))
  not(A and B) === not(A) or not(B)
  ...
   
  forall(X, P) ==> snf(P, [X | QSTACK], POL)
  exists(X, P) ==> newskolem(X, QSTACK), snf(P, QSTACK, POL)
  P & Q ==> snf(P, QSTACK, POL) & snf(Q, QSTACK, POL)
  P or Q ==> snf(P, QSTACK, POL) or snf(Q, QSTACK, POL)
  not(P) ==> snf(P => absurd, QSTACK, POL)
  P => Q ==> snf(P, QSTACK, rev(POL)) => snf(Q, QSTACK, POL)

General discussion about other quantifiers:
------------------------------------------
  Ordinary SATCHMO does the right things with all and some. My ordinary
  conception of these two is about right. I'm not going to worry about them.
  That bit is solved.

  "most" is quite like "all". Some oddities, need to keep track of consistency, ...
  "each", "every", "all" are all basically the same. "any" is tricky!

  "a few" is pretty like "some". I'm going to need to keep track of cardinalities,
  but for sure I'm going to have to do that with numbers and "at least six" and ...

  bare NPs are also tricky. "I like cats", "he was eating cakes", "cheetahs are faster than snails".

  *All* quantifiers are either basically conjunctive or basically implicational.
  
Task 4 Cont.:
-------

 nnf,poalrity marking, Skolem normal form-->Prolog rules 
  ------------------------------------------------------

  man(X) => woman(sk17([X]))
  man(X) => love(X, sk17([X]))

  woman(sk17(X)) :- man(X).
  ...
  Cases:-
  ...

From nf:
[(every:det : A),
 ((arg(headnoun,-) , [(man>''):noun])
   => [(a:det : B),
       ((arg(headnoun,-) , [(woman>):noun])
         & [(love>s : verb),
            {(arg(dobj,+) , B)},
            {(arg(subject,+) , A)}])])]

Get the variables to the right place
  
[(every:det : A),
 (((arg(headnoun,-) , [(man>''):noun]), A)
   => [(a:det : B),
       (((arg(headnoun,-) , [(woman>):noun]), B)
         & [(love>s : verb),
            {(arg(dobj,+) , B)},
            {(arg(subject,+) , A)}])])]

nnf(A & B) = nnf(A) & nnf(B)
nnf(A or B) = nnf(A) or nnf(B)
nnf(forall(X, A)) == forall(X, nnf(A))
nnf(exists(X, A)) == exists(X, nnf(A))
nnf(A => B) = nnf(not(A) or B)
nnf(A) = A

  nnf(not(A & B)) = nnf(not(A)) or nnf(not(B))
  nnf(not(A or B)) = nnf(not(A)) & nnf(not(B))
  nnf(not(A => B)) = nnf(A) & nnf(not(B))
  nnf(not(forall(X, A))) = exists(X, not(nnf(A)))
  nnf(not(exists(X, A))) = forall(X, not(nnf(A)))
  nnf(not(A)) = not(A)

pol(A & B, +) = pol(A, +) & pos(B, +)
pol(A or B) = pol(A, +) or pol(B, +)
pol(A => B, +) = pol(A, -) => pol(B, +)
pol(forall(X, A), +) => forall(X, pol(A, +))
pol(A & B, -) => pol(A, -) & pol(B, -) ???
pol(A or B, -) => pol(A, -) or pol(B, -) ???
pol(A => B, -) => pol(A, -) & pol(not(B), +)
pol(not(B), +) => pol(B, -)

p(t0)
r(t1)
(i) forall(X, p(X)) => forall(Y, q(Y))
(ii) forall(X, p(X) => forall(Y, q(Y)))

  nf(i) p(sk) => q(Y)
  nf(ii) p(X) => q(Y)


p => (q & r) --> p => q & p => r
not(p) --> p => absurd
  

  human(X)- => mortal(X)+
  husband(X, Y)- => man(X)+
  husband(A, R)-
  man < human

a, some, many, few, ...
exists(X :: {p(X)}, q(X)) == exists(X, p(X) & q(X))

each, every, all, ...
forall(X :: {p(X)}, q(X)) == forall(X, p(X) => q(X))

the man, he, Mary, had slept ...
the(X :: {p(X)}, q(X)) == the(X :: {p(X)}, q(X)) != exists1(X, p(X) & q(X))
qff(the(X :: {p(X)}, q(X)) = the(X :: {qff(p(X))}, qff(q(X)))


----------------------------------------------------------------------------  **/
