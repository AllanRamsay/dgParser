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
rep(X, X, _VARS) :-
    (atomic(X); var(X)),
    !.
rep([H0 | T0], [H1 | T1], VARS) :-
    !,
    rep(H0, H1, VARS),
    rep(T0, T1, VARS).
rep(W:T, V, VARS) :-
    member((W:T)=V, VARS), 
    !.
rep({R, T0}, {R, T1}, VARS) :-
    !,
    rep(T0, T1, VARS).
rep(X, X, _VARS).



%%%%%%%%%%%%%%% Transformation (2)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Replace DET Subtrees With variables and should remember the Variables subtrees associations and have them in the result tree Y
%% Run Example: parseOne('every man loves a woman', X),rep2(X,Y,Z), pretty(Y+Z).
rep2(X,Y,V):-
    rep2(X,Y,[],V).

rep2(X, X, VARS0, VARS0) :-
    var(X),
    !.
rep2([],[], VARS0, VARS0) :-
    !.
rep2([W:T|T0],[W:T|T1], VARS0,VARS1) :-
    \+ T=det,
    rep2(T0,T1,VARS0,VARS1),
    !.
rep2([W:det|L], V, VARS0,VARS1) :-
    (member([W:det:V|L], VARS0)->
    VARS1=VARS0;
    VARS1=[[W:det:V|L]|VARS0]),
    !.
rep2({R, T0}, {R, T1},VARS0,VARS1) :-
    !,
    rep2(T0, T1, VARS0,VARS1).
rep2([H0 | T0], [H1 | T1], VARS0,VARS2) :-
    !,
    rep2(H0, H1, VARS0,VARS1),
    rep2(T0, T1, VARS1,VARS2).

rep2(X, X, _VARS0,_VARS1).


%%%%%%%%%%%%%% Transformation (3): Forward-chaining normal forming %%%%%%%%%%%%%%%%
%%%% forall(X, man(X) => (exists(Y, woman(Y) & love(X, Y)))) %%%%%%%%%%%%%%%%%%%%%%
%% Run example:  parseOne('every man loves a woman', X),rep2(X,T,Qstack),nf(Qstack,T,NF).
pattern([every:det:V,{VP}],T,[every:det:V, VP => T]).
pattern([a:det:V,{VP}],T,[a:det:V, VP & T]).
pattern([some:det:V,{VP}],T,[some:det:V, VP & T]).

nf([], T, T).
nf([H | L], T, NF) :-
    !,
    nf(L,T,NF0),
    pattern(H, NF0, NF).

%%%%%%%%%%%% [for next week]Transformation (4): Skolem normal form, Prolog rules %%%
/*
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

I think it's simpler than I was saying. If we do polarity marking and
removing negation at the same time, I think it comes out as below. qnf
takes two arguments, a formula and a polarity mark, which is + or
-. The +cases for &, or, forall, exists are obvious. not(A) gets
replaced by A => false, not matter what the polarity, and we do it to
that, so the +case for not reduces to the +case for =>. The +case for
=> involves making the antecedent -.
  
qnf(A & B, +) => qnf(A, +) & qnf(B, +)
qnf(A or B, +) => qnf(A, +) or qnf(B, +)
qnf(forall(X, P), +) => forall(X, qnf(P, +)
qnf(exists(X, P), +) => exists(X, qnf(P, +))
qnf(not(A), POL) => qnf(A => absurd, POL)
qnf(A => P, +) => qnf(A, -) => qnf(P, +)
  
qnf(A & B, -) => qnf(not(A & B), +)
qnf(A or B, -) => qnf(not(A or B) +)
qnf(forall(X, P), -) => qnf(not(exists(X, P)), +)
qnf(exists(X, P), -) => qnf(not(forall(X, P)), +)
  
qnf(A => B, -) => qnf(A, +) & qnf(B, -)
  
The -cases are basically the same as the standard negation normal
form. (A & B) is false if not(A & B) is true, (A or B) is false if
(not(A) and not(B)) is true, exists(X, P) is false, if forall(X,
not(P)) is true, ...

The key is qnf(A => P, +) => qnf(A, -) => qnf(P, +). This does the
polarity switching in the antecedent while preserving the fact that
this is an implication and not just an instance of not(A) or B.

Lots of things get turned into not(...) and then immediately into
... => absurd. That's fine, don't care. It just means that all the
negative cases are going to get looked after by the same process, so
we don't have to worry about handling a whole pile of different
negative cases. not(P) is P => absurd, no matter what P is, so
qnf(not(P), +) is qnf(P => absurd, +), no matter what P is, and the
rule for =>, + will take care of it; and qnf(not(P), -) is qnf(P =>
absurd, -, and the rule for =>,- will take care of it.

It may happen that this leads to things that look like P => (Q => (R
=> T)), and we'd like to tidy them up to be (P & Q & R) => T. That's
not going to be too difficult, but we do need to be a bit careful. P
=> (Q => R) is the same as (P & Q) => R, but (P => Q) => R is not. But
actually you'd have to be pretty careless to get this wrong, because
you'd have to explicitly introduce a step that made this mistake. So
I'm not going to worry about that. We are *not* going to do any normal
forming of (P => Q) => R: rules like that are pretty weird, won't
occur very often, and if they do occur then they should be used for
proving R by proving (P => Q).

  

  
  
*/



























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

[X=(every : det), {(arg(arg(headnoun),-) , [(man>):noun])}])},
 Y=(a : det), {(arg(arg(headnoun),-) , [(woman>):noun])}])}],
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
  
----------------------------------------------------------------------------  **/




