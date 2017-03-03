
/**
  These are constraints on what is allowed.
  To say that something *is* specified or unspecified, use +specified/-specified
  **/

unspecified(X) :-
    trigger(used@X, \+ specified@X == +).
specified(X) :-
    trigger(used@X, \+ specified@X == -).

specified(X, specified@X).

casemarked(X, case@X).

subjcase(X) :-
    case@X -- *subj.

objcase(X) :-
    case@X -- *obj.

standardcase(X) :-
    case@X -- *_.

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