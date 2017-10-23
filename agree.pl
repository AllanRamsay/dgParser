
/**
  specified=*(N): you have had a specifier added to you (internal). 0 = no, new ones have to score higher than old
  specifier=[_]: you are capable of being used in situation where we need to know what to do with you (external).

  bare noun: has no specifier added, but if it *were* to be used as an NP then the value of specifier would be *mass
  plural noun: has no specifier added, but if it *were* to be used as an NP then the value of specifier would be *count

  det+NP: we record values for both specified (a number) and specifier (a property).
**/

specifier(X, SPEC) :-
    specifier@X -- SPEC.

specified(X) :-
    X <> [specifier(*(_))].

unspecified(X) :-
    -specifier@X.

casemarked(X, case@X).

subjcase(X) :-
    case@X -- *subj.

objcase(X) :-
    case@X -- *obj.

standardcase(X, CASE) :-
    case@X -- *CASE.

standardcase(X) :-
    X <> [standardcase(_)].

sing(X) :-
    number@X -- sing.

plural(X) :-
    number@X -- plural.

first(X) :-
    person@X -- 1.

firstSing(X) :-
    X <> [sing, first].

second(X) :-
    person@X -- 2.

third(X) :-
    person@X -- 3.

thirdSing(X) :-
    X <> [sing, third].

thirdPlural(X) :-
    X <> [plural, third].

notThirdSing(X) :-
    when((nonvar(person@X), nonvar(number@X)),
	 \+ thirdSing(X)).

masculine(X) :-
	gender@X -- masculine.

feminine(X) :-
	gender@X -- feminine.