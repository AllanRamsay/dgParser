
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

%%Matching algortihm 
:- op(397, xfx, match).
/**
:- ensure_loaded([matchAlgo]).
  **/

match(X, X).

%%:- ensure_loaded([hypstable]). is called within the matching algorithm


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

horn(X, INDENT) :-
     (temp(X1), match(X1,X)),
     showStep('~w~w found as hypothetical fact~n', [INDENT, X]).
horn(X, INDENT) :-
    (fact(X1), match(X1,X)),
     showStep('~w~w found as actual fact~n', [INDENT, X]).
horn(X, INDENT) :-
    ((LHS=>X1),match(X1,X)),
    showStep('~w~w found as rule that leads to ~w~n', [INDENT, LHS => X, X]),
    atom_concat(INDENT, ' ', INDENT1),
    horn(LHS, INDENT1).
horn(A & B, INDENT) :-
    horn(A, INDENT),
    horn(B, INDENT). 
horn(A or B, INDENT) :-
    horn(A, INDENT); horn(B, INDENT).
horn(A => B, INDENT) :-
    showStep('~wAbout to try conditional proof of ~w~n', [INDENT, A => B]),
    cprove(A => B, INDENT).

/***
  Non-Horn part: find a disjunctive rule (any disjunctive rule, doesn't matter:
  that's the main reason why this can be inefficient--we're liable to explore lots
  of split rules that have nothing to do with the problem at hand
  **/
splitProof(X, INDENT) :-
    showStep("~wCan't do it using Horn clauses: think of a split rule~n", [INDENT]),
    (P => (Q or R)),
    horn(P, INDENT),
    \+ horn(Q, INDENT),
    \+ horn(R, INDENT),
    showStep("~wFound ~w~n", [INDENT, P => (Q or R)]),
    atom_concat(' ', INDENT, INDENT1),
    cprove(Q => X, INDENT1),
    cprove(R => X, INDENT1).

/***
  Conditional proofs: pretend you believe P, see if you can prove Q. If so, then presumably
  P supported the proof of Q. Either way, finish by taking P back, because it was just a
  working hypothesis, it wasn't something you really believed
  **/
cprove(P => Q, INDENT) :-
    showStep('~wTrying to prove ~w by asserting ~w and trying to prove ~w~n', [INDENT, P=>Q, P, Q]),
    atom_concat(INDENT, ' ', INDENT1),
    assert(temp(P)),
    (prove(Q, INDENT1) ->
     retract(temp(P));
     (retract(temp(P)), fail)).

/***
  Try to do it just using Horn rules; if not, try a split
  **/
prove(X, INDENT) :-
    showStep('~wTrying Horn proof of ~w~n', [INDENT, X]),
    ((horn(X, INDENT),
      showStep('~wHorn proof of ~w succeeded~n', [INDENT, X]));
     (showStep('~wNo Horn proof of ~w~n', [INDENT, X]),
      fail)).
prove(X, INDENT) :-
    showStep('~wLooking for split rule to help with proof of ~w~n', [INDENT, X]),
    ((splitProof(X, INDENT),
      showStep('~wProof of ~w using split rule succeeded~n', [INDENT, X]));
     (showStep('~wNo proof using split rule of ~w~n', [INDENT, X]),
      fail)).

/***
  Do the necessary book-keeping: clear up anything left in the database from your
  previous proof, add the facts and rules for the current knowledge base
  **/
satchmo(P, KB) :-
    setProblem(KB),
    retractall(temp(_)),
    prove(P, '').

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
setProblem1([H | T]) :-
    !,
    setProblem1(H),
    setProblem1(T).
setProblem1(A => B) :-
    !,
    assert(A => B).
setProblem1(X) :-
    assert(fact(X)).

/**
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
  **/



