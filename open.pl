:- include(closed).

word('♥', X) :-
    language@X -- arabic,
     X <> [pronoun].

word('♥', X) :-
    language@X -- arabic,
     X <> [pronoun].

word('نادر', X) :-
    language@X -- arabic,
    noun(X),
    X <> [thirdSing].

word(believes, X) :-
    language@X -- arabic,
    X <> [sverb(S), presTense, thirdSing],
    S <> tensedForm.

word('كتب', X) :-
    language@X -- arabic,
    X <> [uverb, presTense, thirdSing],
    S <> tensedForm.

word('يغلط', X) :-
    language@X -- arabic,
    X <> [uverb, presTense, thirdSing],
    S <> tensedForm.

word('يسوي', X) :-
    language@X -- arabic,
    X <> [uverb, presTense, thirdSing],
    S <> tensedForm.

word('نروح', X) :-
    language@X -- arabic,
    X <> [sverb(S), presTense, not_thirdSing],
    S <> tensedForm.

word('تعمل', X) :-
    language@X -- arabic,
    X <> [uverb, presTense, thirdSing],
    S <> tensedForm.

word('ولد', X) :-
    language@X -- arabic,
    noun(X),
    X <> [thirdSing].

word('درسا', X) :-
    language@X -- arabic,
    noun(X),
    X <> [thirdSing].

word('قطري', X) :-
    language@X -- arabic,
    noun(X),
    X <> [thirdSing].
word('سعيد', X) :-
    language@X -- arabic,
    -def@X,
    noun(X),
    X <> [thirdSing, masculine].

word('سعيدة', X) :-
    language@X -- arabic,
    -def@X,
    noun(X),
    X <> [thirdSing, feminine].

word('السعيد', X) :-
    language@X -- arabic,
    +def@X,
    noun(X),
    X <> [thirdSing, masculine].

word('السعيدة', X) :-
    language@X -- arabic,
    +def@X,
    noun(X),
    X <> [thirdSing, feminine].

word('زوجة', X) :-
    language@X -- arabic,
    -def@X,
    noun(X),
    X <> [thirdSing, feminine].

word('الزوجة', X) :-
    language@X -- arabic,
    +def@X,
    noun(X),
    X <> [thirdSing, feminine].

word('إمرأة', X) :-
    language@X -- arabic,
    -def@X,
    noun(X),
    X <> [thirdSing, feminine].

word('الإمرأة', X) :-
    language@X -- arabic,
    +def@X,
    noun(X),
    X <> [thirdSing, feminine].
