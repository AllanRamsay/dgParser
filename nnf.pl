nnf(A0 & B0, A1 & B1) :-
    !,
    nnf(A0, A1),
    nnf(B0, B1).
nnf(A0 or B0, A1 or B1) :-
    !,
    nnf(A0, A1),
    nnf(B0, B1).
nnf(A0 => B0, A2 => B1) :-
    !,
    nnf(not(A0), A1),
    nnf(not(A1), A2),
    nnf(B0, B1).
nnf(A => B, N) :-
    !,
    nnf(not(A) or B, N).
nnf(forall(X, P0), forall(X, P1)) :-
    !,
    nnf(P0, P1).
nnf(exists(X, P0), exists(X, P1)) :-
    !,
    nnf(P0, P1).

nnf(not(A & B), N) :-
    !,
    nnf(not(A) or not(B), N).
nnf(not(A or B), N) :-
    !,
    nnf(not(A) & not(B), N).
nnf(not(A => B), N) :-
    !,
    nnf(A & not(B), N).
nnf(not(forall(X, P)), N) :-
    !,
    nnf(exists(X, not(P)), N).
nnf(not(exists(X, P)), N) :-
    !,
    nnf(forall(X, not(P)), N).
nnf(not(not(A0)), N) :-
    !,
    nnf(A0, N).
nnf(X, X).

If we do that to the simplified logical translations of "every man loves some woman", "not every man loves some woman" and "every man does not love some woman" we get the output below.

"every man loves some woman"
| ?- nnf(forall(X, man(X) => (exists(Y, woman(Y) & love(X, Y)))), N), pretty(N).

"for every A, either A is not a man or there is a suitable woman"
forall(A, (not(man(A)) or exists(B,woman(B)&love(A,B))))

"it is not the case that every man loves some woman"
| ?- nnf(not(forall(X, man(X) => (exists(Y, woman(Y) & love(X, Y))))), N), pretty(N).

"there is some man who does not love any woman"
exists(A, (man(A) & forall(B,not(woman(B))or not(love(A,B)))))

"every man does not love some woman"
| ?- nnf(forall(X, man(X) => not(exists(Y, woman(Y) & love(X, Y)))), N), pretty(N).

"for every A either A is not a man or A does not love any woman"
forall(A,
       (not(man(A))
         or forall(B, (not(woman(B)) or not(love(A,B))))))

"everything which is not a man loves some woman"
| ?- nnf(forall(X, not(man(X)) => exists(Y, woman(Y) & love(X, Y))), N), pretty(N).

"everything is either a man or it loves some woman
forall(A, (man(A) or exists(B,woman(B)&love(A,B))))

But I don't like

nnf(A => B, N) :-
    !,
    nnf(not(A) or B, N).

because I think that implication is more interesting than that. In particular, I don't think that you can prove A => B just by proving that A is false. So I want to do something else at this point. That's (most of) what we've been looking at.

I've been suggesting that we do it by eliminating negation (by turning it into A => absurd), and then trying to get the rule for => right. It may be that this is not actually the right strategy. It might be better to do get to negation normal form by something very like the rules above, and to turn not(A) into A => absurd later (possibly even after Skolemisation). That would have the advantage that the only thing we would have to deal with is this one rule, because all of the others are acceptable from a constructive point of view.

So let's think about this one. What I'm really trying to do is to get relationship
between quantifiers and negation right, and everything else that I do is to help me do that. I'm perfectly happy with what happens to the consequent. So the thing
that is causing me the most bother is the antecedent of an implication. All the
other standard rules are fine.

OK. Suppose I calculate nnf(not(nnf(not(A)))). That's going move any negations that occur inside A as far as they will go, so I end up with something which is equivalent to A but has all its negations moved in as far as possible. If there were no negations then actually it has no effect, which is fine. So I put the result of this back as the antecdent, and I've got something which has the form A' => B', rather than not(A)' or B', but which has negations pushed in as far as possible.

nnf(A0 => B0, A2 => B1) :-
    !,
    nnf(not(A0), A1),
    nnf(not(A1), A2),
    nnf(B0, B1).

Here's the result of doing this to a reasonably complex example.

Complicated antecedent with a negated universal.

| ?- nnf((exists(X,a(A)) & not(forall(Y, b(Y) & c(Y)))) => d, N).

Result has converted the negated universal into something which is equivalent but which has all the negations as far in as possible, everything else is unchanged.

N = (exists(X,a(A))&exists(Y,not(b(Y))or not(c(Y))))=>d 

Negated conjunct in the antecedent.
| ?- nnf(not(p & q) => r, N).

Disjunction of negated literals in the antecedent.
N = (not(p)or not(q))=>r 

Complicated one:
| ?- nnf(not(forall(X, p(X)) & exists(Y, q(Y))) => r, N).
N = (exists(X,not(p(X)))or forall(Y,not(q(Y))))=>r

Doing this does require me to believe that A and nnf(not(nnf(not(A)))) are equivalent. Not sure how keen I am on that, because I don't believe that A and not(not(A)) are equivalent, but it's not as bad as accepting that A => B and (not(B) or A) are equivalent.

OK, so now I've pushed negations right in without losing the distinction between A => B and (not(B) or A). But I've still got to get rid of the quantifiers.

Here comes standard skolemisation.

%% To do Skolemisation we need a stack of quantifiers
sk(A0, A1) :-
    sk(A0, A1, []).

sk(A0 & B0, A1 & B1, S) :-
    !,
    sk(A0, A1, S),
    sk(B0, B1, S).
sk(A0 or B0, A1 or B1, S) :-
    !,
    sk(A0, A1, S),
    sk(B0, B1, S).
sk(forall(X, A0), A1, S) :-
    !,
    sk(A0, A1, [X | S]).
sk(exists(X, A0), A1, S) :-
    !,
    gensym(sk, SK), %% generate a new skolem constant
    X = [SK | S], %% this makes it into a skolem function
    sk(A0, A1, S).
sk(A, A, _S).

Note that for standard Skolemisation, we don't need cases for not(A) or for (A => B): we don't need a case for not(A) because all the negations have been moved inwards, so there can't be any quantifiers inside them, so Skolemisation won't have any effect. We don't need a case for => because we would have got replaced all
instances by not(A) or B.

Using the original version of nnf we get

| ?- nnf(forall(X, man(X) => exists(Y, woman(Y) & love(X, Y))), N), sk(N, SK).
N = forall(X,not(man(X))or exists([sk2,X],woman([sk2,X])&love(X,[sk2,X]))),
Y = [sk2,X],
SK = not(man(X))or woman([sk2,X])&love(X,[sk2,X])

i.e. the name of the person who is loved is [sk2, X]. If X is John then this will be [sk2, John], if X is Susan then it will be [sk2, Susan], ... So every lovee has a different name (though of course one person could have multiple names: we might find out later that John and Peter love the same person, in the same way that we might find out later that Averroes and Ibn Rushd were the same person. In logic, different people have different names, but one person can have several names. Not like in natural language, where lots of people can have the same name: https://en.wikipedia.org/wiki/Allan_Ramsay (glad to see I'm top of that list!))

But we need a rule for A => B, because we didn't eliminate it during
NNF. Let's take a simple example: forall(X, p(X)) => q (careful: this
is *not* forall(X, p(X) => q)). Under what circumstances would you be
able to use this to prove q? If you knew forall(X, p(X)). And under
what circumstances would you be able to prove forall(X, p(X))? If you
could prove p(sk243), where sk243 was someone you knew nothing
whatsoever about.

So we'd like forall(X, p(X)) => q to be p(sk243) => q, where sk243
appears in this rule and nowhere else.

Similarly, we could use exists(X, p(X)) => q to prove q if we could
find any item that satisfied p. So we'd want the quantifier free form
of this to be p(X) => q: if you can find a value of X for which p(X)
is true then you can conclude q.

So we want to reverse the way that quantifiers are treated in the
antecedents of implications. So we now want to keep track of whether
we are in positive or negative contexts. Initial clause now introduces
an empty quantifier stack and the initial positive polarity mark.

qff(A0, A1) :-
    qff(A0, A1, [], +).

qff(A0 & B0, A1 & B1, S, P) :-
    !,
    qff(A0, A1, S, P),
    qff(B0, B1, S, P).
qff(A0 or B0, A1 or B1, S, P) :-
    !,
    qff(A0, A1, S, P),
    qff(B0, B1, S, P).
qff(A0 => B0, A1 => B1, S, +) :-
    !,
    qff(A0, A1, S, -),
    qff(B0, B1, S, +).
%% split quantifiers into two cases
%% normal
qff(forall(X, A0), A1, S, +) :-
    !,
    qff(A0, A1, [X | S], +).
qff(exists(X, A0), A1, S, +) :-
    !,
    gensym(qff, QFF), %% generate a new skolem constant
    X = [QFF | S], %% this makes it into a skolem function
    qff(A0, A1, S, +).
%% negated
qff(exists(X, A0), A1, S, -) :-
    !,
    qff(A0, A1, [X | S], -).
qff(forall(X, A0), A1, S, -) :-
    !,
    gensym(qff, QFF), %% generate a new skolem constant
    X = [QFF | S], %% this makes it into a skolem function
    qff(A0, A1, S, -).
qff(A, A, _S, _P).

Then with the constructive version of nnf we get

| ?- nnf(forall(X, man(X) => exists(Y, woman(Y) & love(X, Y))), N), qff(N, SK).
N = forall(X,man(X)=>exists([qff0,X],woman([qff0,X])&love(X,[qff0,X]))),
Y = [qff0,X],
SK = man(X)=>(woman([qff0,X])&love(X,[qff0,X])
	     
So we get the correct Skolem function for Y while preserving the =>.

There are some tricky cases to check. The ones that I want to be sure about are (p => q) => r (which is different from p => (q => r), which is supposed to be easy) ones with quantifiers inside the antecedent.

	     
	     


																																																																											  



																							
																																																																											     So
																																																																							

				  
				      