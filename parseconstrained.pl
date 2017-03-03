/**
  Given a set of links, parse the text.

  Then find a link that isn't in the tree. That's someone
  who has the wrong head. Find the tree rooted at their right
  head, check that it's compact. That's a phrase that has
  been mis-analysed. So re-add it to the training data.
  **/

parseConstrained :-
    parseConstrained('reparsed.cnll').

parseConstrained(_) :-
    set(firstOneOnly, _),
    unset(quoteAtoms, _),
    set(forced, UNSETFORCED),
    constrained(I, TXT, CONSTRAINTS),
    \+ (member((_, _, TAG), TXT), member(TAG, ['JJS', 'VBZ', 'VBD', 'VBG', 'PRP$'])),
    set(quoteAtoms, QUOTED),
    pretty(constrained(I, TXT)), write('.'),
    (var(QUOTED) -> unset(quoteAtoms); true),
    parseConstrained(TXT, CONSTRAINTS),
    UNSETFORCED.
parseConstrained(OUT) :-
    standardCONLL(OUT).

makeLink(H0, D0) :-
    H1 is H0-1,
    D1 is D0-1,
    assert(linked(H1, D1)).

parseConstrained(TXT, CONSTRAINTS) :-
    set(quoteAtoms, QUOTED),
    format('~n~n~p.~n', [parseConstrained(TXT, CONSTRAINTS)]),
    (var(QUOTED) -> unset(quoteAtoms); true),
    makeTreeFromLinks(CONSTRAINTS, TXT, CTREE),
    pretty(CTREE),
    retractall(linked(_, _)),
    ((member(linked(_, DTR, HD), CONSTRAINTS), makeLink(HD, DTR), fail); true),
    (parseSegment(TXT, 0, 0) -> fail; fail).

/**
  Could be a list starting with (R, D): each other item
  is {theta, L}
  **/

findDtr([(_R, H) | T], D) :-
    (H = D;
     findDtr(T, D)).
findDtr(T, L) :-
    member({_, K}, T),
    findDtr(K, L).

findDtrs(T, DTRS) :-
    setof(D, findDtr(T, D), DTRS).

findLink([(_R, H) | T], DTRS1:H) :-
    member({_T, [(_RD, D) | _]}, T),
    findDtrs([(_, H) | T], DTRS0),
    length(DTRS0, N),
    N > 2,
    last(DTRS0, Z),
    DTRS0 -- [A | _],
    N is Z-A+1,
    reverse(DTRS0, DTRS1).
findLink([_ | T], L) :-
    member({_, K}, T),
    findLink(K, L).

distinctLists([], []).
distinctLists([H:_ | T0], T1) :-
    H -- [X | _],
    member(H1:_, T0),
    member(X, H1),
    !,
    distinctLists(T0, T1).
distinctLists([H | T0], [H | T1]) :-
    distinctLists(T0, T1).

subtree(X, X) :-
    \+ X = [].
subtree([H | T], X) :-
    subtree(H, X); subtree(T, X).
subtree({_, K}, X) :-
    subtree(K, X).
subtree(_=K, X) :-
    subtree(K, X).
subtree(_=K, X) :-
    subtree(K, X).
  
findErrors(I, MAX) :-
    constrained(I, TXT, CONSTRAINTS),
    \+ (member((_, _, TAG), TXT), member(TAG, ['JJS', 'VBZ', 'VBD', 'VBG', 'PRP$'])),
    \+ I == MAX,
    unset(quoteAtoms, _),
    %% format('~nconstrained(~w, ~p, ~p).~n', [I, TXT, CONSTRAINTS]),
    set(quoteAtoms, _),
    chartParse(TXT, X, arabic),
    root@X -- [_ | DTRS],
    setof(LINK, findLink(DTRS, LINK), ERRORS0),
    distinctLists(ERRORS0, ERRORS1),
    member(_:J, ERRORS1),
    (subtree(root@X, {_, [(R, J) | T]}) ->
     (flattenTree([(R, J) | T], F0),
      sort(F0, F1),
      nl,
      printTree(F1, TXT));
     throw(xxx(I, J, root@X))).

findAllErrors(FILE, MAX) :-
    tell(FILE),
    unset(forced, _),
    findErrors(_I, MAX),
    fail.
findAllErrors(_, _) :-
    (telling(user) -> true; told).

findAllErrors :-
    (telling(user) -> true; told),
    tell(user),
    findAllErrors(user_output, -1).
    
    