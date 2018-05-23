
:- multifile(signature/1).

/**** SATCHMO.PL

  Basic implementation of Satchmo: there's nothing missing, but it doesn't have any of
  the optimisations.

  I'm storing the facts and rules that make up a description of the world in a list,
  which I'm keeping a:- ensure_loaded(lists).
s a named 'knowledge base', so that I can easily switch between
  problem states without editing and recompiling the program. More flexible that way, but
  a little bit more fiddly.

  Because I'm using the database a lot, I have to do make sure at the START of a proof
  that it's nice and clean. So just before I set a problem, I clear out any facts and
  rules that are lying around from the last problem; and just before I do a proof, I
  clear out any temporary hypotheses that are lying around from the last proof.
  
  I've put in lots of stuff for printing proofs out neatly. If you want to see all the
  gory details of a proof, do

  | ?- set(showProof).

  If you don't, then do

  | ?- unset(showProof).
  ***/
%% Parser
:- ensure_loaded([setup, useful]).
%% Fancy bit: if we haven't run setup before, then sign
%% will throw an exception, so we know we do need to run it
:- catch(sign(X), _, setup(allwords)).

/**
:- ensure_loaded([hypstable]).
if I try doing that to make sure that I have the whole thing a got a problem because the file is too big
  **/

hyp(_,'love','like').
hyp(_,'man','human').
hyp(_,'dog','animal').
hyp(_,'cat','animal').
hyp(_,'fat','obese').

match(X, X).
match(WORD0,WORD1,POL):-
	POL= +1 -> (hyp(_,WORD0,WORD1), showStep('~w is a hyponym of ~w~n', [WORD0,WORD1]));
	POL= -1 -> (hyp(_,WORD1,WORD0); showStep('~w is a hyponym of ~w~n', [WORD1,WORD0]));
	(WORD0 = WORD1, showStep('~w unified with ~w~n', [WORD0,WORD1])).

match({[(WORD0>CARDINALITY):POL0],VAR},{[(WORD1>CARDINALITY):_POL1],VAR}):-
	match(WORD0,WORD1,POL0).

match({(WORD0>CARDINALITY):POL0,VAR},{(WORD1>CARDINALITY):_POL1,VAR}):-
	match(WORD0,WORD1,POL0).

match({[(WORD>CARDINALITY):POL,MODIFIER],VAR},{[(WORD>CARDINALITY):POL],VAR}):-
	showStep('Skipping over modifier ~w~n', [MODIFIER]).

match({[WORD:POL,modifier(amod,MODIFIER0:POL0)],VAR},{[WORD:POL,modifier(amod,MODIFIER1:_POL1)],VAR}):-
	showStep('try matching modifiers ~w and ~w~n', [MODIFIER0,MODIFIER1]),
	match(MODIFIER1,MODIFIER0,POL0).

match([[EVENT0:POL0, R1, R2], VAR],[[EVENT1:_POL1, R1, R2], VAR]):-
	match(EVENT0,EVENT1,POL0).



%% If you're asked for a fact you've never heard of, just fail rather than throwing an exception
:- unknown(_, fail).
:- op(400, xfx, =>).
:- op(399, xfx, &).
:- op(398, xfx, or).

showStep(STRING, ARGS) :-
    (showProof ->
     format(STRING, ARGS);
     true).

/***
  Simple backward chaining proofs: you can prove it if you know it or you
  have a rule that will let you get it and you can prove the antecedent of
  this rule.

  We have two classes of fact--ones that we asserted, as fact(...), when we set the
  problem, and ones that we asserted as temporary hypotheses during proofs. So when we
  are looking to see whether X is a fact we have to look it up under temp(X) and fact(X).
  **/

horn(X, LABEL) :-
    showStep('~n~wTrying Horn proof~w~n', [indent:label@LABEL, X]),
    fail.
horn(X, LABEL) :-
    member(X, stack:label@LABEL),
    !,
    fail.
horn(X, LABEL) :-
     (temp(X1), match(X1,X)),
     showStep('~w~w found as hypothetical fact~n', [indent:label@LABEL, X]).
horn(X, LABEL) :-
    (fact(X1), match(X1,X)), %% X could be human, X1 could be man or fat human
     showStep('~w~w found as actual fact~n', [indent:label@LABEL, X]).
horn(default(X), LABEL) :-
    !,
    showStep('~wAssuming ~w as default -- really should check this later~n', [indent:label@LABEL, X]),
    (extend1(defaults:label@LABEL, X) -> true; fail).
horn(X, LABEL0) :-
    LABEL1\(indent:label) -- LABEL0,
    INDENT0 -- indent:label@LABEL0,
    extend1(stack:label@LABEL0, X),
    ((LHS=>X1), match(X1,X)), %% X could be human, X1 could be man or fat human
    showStep('~w~w found as rule that leads to ~w~n', [INDENT0, LHS => X, X]),
    %% atom_concat(INDENT0, ' ', indent:label@LABEL1),
    horn(LHS, LABEL1).
horn(A & B, LABEL) :-
    showStep('Horn proof of conjunction: ~w', [A &B]),
    horn(A, LABEL),
    horn(B, LABEL). 
horn(A or B, LABEL) :-
    horn(A, LABEL); horn(B, LABEL).
horn(A => B, LABEL) :-
    showStep('~wAbout to try conditional proof of ~w~n', [indent:label@LABEL, A => B]),
    cprove(A => B, LABEL).

/***
  Non-Horn part: find a disjunctive rule (any disjunctive rule, doesn't matter:
  that's the main reason why this can be inefficient--we're liable to explore lots
  of split rules that have nothing to do with the problem at hand
  **/
splitProof(X, LABEL0) :-
    INDENT0 -- indent:label@LABEL0,
    LABEL1\(indent:label) -- LABEL0,
    showStep("~wCan't do it using Horn clauses: think of a split rule~n", [INDENT0]),
    (P => (Q or R)),
    horn(P, LABEL0),
    \+ horn(Q, LABEL0),
    \+ horn(R, LABEL0),
    showStep("~wFound ~w~n", [INDENT0, P => (Q or R)]),
    %%atom_concat(' ', INDENT0, indent:label@LABEL1),
    cprove(Q => X, LABEL1),
    cprove(R => X, LABEL1).

/***
  Conditional proofs: pretend you believe P, see if you can prove Q. If so, then presumably
  P supported the proof of Q. Either way, finish by taking P back, because it was just a
  working hypothesis, it wasn't something you really believed
  **/
cprove(P => Q, LABEL) :-
    indent:label@LABEL -- INDENT,
    LABEL1\(indent:label) -- LABEL0,
    showStep('~wTrying to prove ~w by asserting ~w and trying to prove ~w~n', [INDENT, P=>Q, P, Q]),
   %% atom_concat(INDENT, ' ', indent:label@LABEL1),
    assert(temp(P)),
    (prove(Q, LABEL1) ->
     retract(temp(P));
     (retract(temp(P)), fail)).

/***
  Try to do it just using Horn rules; if not, try a split
  **/
prove(X, LABEL) :-
    INDENT -- indent:label@LABEL,
    showStep('~wTrying Horn proof of ~w~n', [INDENT, X]),
    ((horn(X, LABEL),
      showStep('~wHorn proof of ~w succeeded~n', [INDENT, X]));
     (showStep('~wNo Horn proof of ~w~n', [INDENT, X]),
      fail)).
prove(X, LABEL) :-
    INDENT -- indent:label@LABEL,
    showStep('~wLooking for split rule to help with proof of ~w~n', [INDENT, X]),
    ((splitProof(X, LABEL),
      showStep('~wProof of ~w using split rule succeeded~n', [INDENT, X]));
     (showStep('~wNo proof using split rule of ~w~n', [INDENT, X]),
      fail)).

/***
  Do the necessary book-keeping: clear up anything left in the database from your
  previous proof, add the facts and rules for the current knowledge base
  **/
satchmo(P, KB, defaults:label@L) :-
    setProblem(KB),
    retractall(temp(_)),
    indent:label@L -- '',
    prove(P, L).

satchmo(P, KB) :-
    satchmo(P, KB, _D).

/***
  To set a problem, tidy up the database (so remove old facts and rules), get the list
  of facts and rules for this one, add them one at a time.
  **/
setProblem(P) :-
    retractall(fact(_)),
    retractall(_ => _),
    setProblem1(P).

/***
  Standard recursion down a list: only complication is that the list is a mixture of
  facts and rules, so we have to see which we've got and if it's a rule then we cut to
  make sure we don't also insert it as though it were a fact
  **/
setProblem1([]) :-
    !.
setProblem1(X) :-
    kb(X, Y),
    !,
    setProblem1(Y).
setProblem1(A & B) :-
    !,
    setProblem1(A),
    setProblem1(B).

setProblem1(A => (B & C)) :-
    !,
    setProblem1(A => B),
    setProblem1(A => C).
setProblem1(A => (B => C)) :-
    !,
    setProblem1((A & B) => C).
setProblem1(A => B) :-
    !,
    assert(A => B).
setProblem1(X) :-
    assert(fact(X)).

:- dynamic kb/2.

kb(test1,
   [a,
    a => b,
    b => c,
    c => p or q,
    p => r,
    q => r]).

kb(test2,
   [(rich(X) => happy(X)) => venal(X),
    rich(john) => happy(john)]) :-
    format('Venal: belief that material wealth leads to happiness~n', []).

kb(test3,
   [(farmer, mary),
    ((farmer, A) & default(male, B, A)) => (male, B, A),
    (male, _B, A) => (male, A)]).



