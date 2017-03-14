
conll([H | T]) :-
    member({_THETA, X}, T),
    (X = [XH | _XT] ->
     (format('"~w":"~w",', [XH, H]),
      conll(X));
     format('"~w":"~w",', [X, H])),
    fail.
conll(_).

roles([_H | T]) :-
    member({THETA, X}, T),
    (X = [XH | _XT] ->
     (format('"~w":"~w",', [XH, THETA]),
      roles(X));
     format('"~w":"~w",', [X, THETA])),
    fail.
roles(_).
    
arabic([], []).
arabic([(H0, _, _) | T0], [H1 | T1]) :-
    (unicode(H0, H1) -> true; H1 = H0),
    arabic(T0, T1).

english([], []).
english([(_, H, TAG) | T0], [H1 | T1]) :-
    (TAG = 'EMOJ' ->
     H1 = H;
     with_output_to_atom(format('~w-~w', [H, TAG]), H1)),
    english(T0, T1).

writeArabic([]).
writeArabic([H | T]) :-
    (T = [] ->
     format('~p', [H]);
     format('~p ', [H])),
    writeArabic(T).

conllSaved(F) :-
    set(quoteAtoms),
    tell(F),
    format("[~n", []),
    ((sentence(S, TXT),
      ((format("~n(", []),
	arabic(TXT, ARABICTXT0),
	reverse(ARABICTXT0, ARABICTXT1),
	unset(quoteAtoms),
	with_output_to_atom(writeArabic(ARABICTXT1), ARABICTXT2),
	set(quoteAtoms),
	english(TXT, ENGLISHTXT0),
	with_output_to_atom(print(ENGLISHTXT0), ENGLISHTXT1),
	format("~w, u'~w', ~w, [", [S, ARABICTXT2, ENGLISHTXT1]),
	saved(S, N, TEXT, TREE),
	TREE = [_ | _],
	with_output_to_atom(conll(TREE), CONLL),
	with_output_to_atom(roles(TREE), ROLES),
	arabic(TEXT, ARABIC0),
	reverse(ARABIC0, ARABIC1),
	unset(quoteAtoms),
	with_output_to_atom(writeArabic(ARABIC1), ARABIC2),
	set(quoteAtoms),
	english(TEXT, ENGLISH),
	with_output_to_atom(print(ENGLISH), ENGLISHATOM),
	format("(~w, u'~w', ~w, {~w}, [{~w}]),", [N, ARABIC2, ENGLISHATOM, ROLES, CONLL]),
       fail);
       format("]),", [])),
      fail);
     (format("]~n", []),
      told)).

conllSaved :-
    conllSaved(user).

flattenTree(T, F) :-
    T -- [(FORM, I) | _],
    flattenTree(T, [(I, FORM, -1, root)], F).

flattenTree([(zero, _)], F, F) :-
    !.
flattenTree([(FORM, I) | DTRS], F0, Fn) :-
    flattenTree((FORM, I), DTRS, F0, Fn).

flattenTree((zero, _), _, F, F) :-
    !.
flattenTree((_FORM, _I), [], F, F).
flattenTree((_FORM, I), [D | DTRS], F0, Fn) :-
    D = {THETA, [(DR, DI) | DDTRS]},
    flattenTree([(DR, DI) | DDTRS], F0, F1),
    flattenTree((_FORM, I), DTRS, [(DI, DR, I, THETA) | F1], Fn).
flattenTree((_FORM, I), [D | DTRS], F0, Fn) :-
    D = {THETA, _ALTVIEW=[(DR, DI) | DDTRS]},
    flattenTree([(DR, DI) | DDTRS], F0, F1),
    flattenTree((_FORM, I), DTRS, [(DI, DR, I, THETA) | F1], Fn).

printTree([], _).
printTree([(DI, DR, I, THETA) | F1], TXT) :-
    (DR == zero ->
     true;
     (nth(DI, TXT, (_, _, TAG)),
      format('~w	~w	~w	~w	~w	~w	~w	~w~n', [DI, DR, DR, TAG, TAG, -, I, THETA]))),
    printTree(F1, TXT).

standardCONLL(TAGS, TREE0) :-
    flattenTree(TREE0, TREE1),
    sort(TREE1, TREE2),
    printTree(TREE2, TAGS).
    
standardCONLL(FILE) :-
    tell(FILE),
    saved(_, _, TAGS, TREE),
    standardCONLL(TAGS, TREE),
    nl,
    fail.
standardCONLL(_) :-
    told.

standardCONLL :-
    standardCONLL(user).

parse2conll(_FILE) :-
    parseSegments,
    fail.
parse2conll(FILE) :-
    standardCONLL(FILE).