
constrainedParseAll :-
    constrained(TEXT, LINKS),
    constrainedParse(TEXT, LINKS).

constrainedParse(TEXT, LINKS) :-
    retractall(linked(_, _, _)),
    (member(