

lookup(FORM0, W1) :-
    W0 <> [word, inflected],
    atom_codes(FORM0, FORM1),
    findall(C, (member(I, FORM1), atom_codes(C, [I])), FORM2),
    lookup1(FORM2, [], [], [WORDS]),
    tag@W0 -- TAG0,
    root@W0 -- [R0],
    W1\root -- W0,
    member(W0, WORDS),
    root@W1 -- [R0:TAG0].
    %% (nonvar(TAG0) -> root@W1 = [R0:TAG0]; root@W1 = [R0]).

lookup1([], [], L, L) :-
    L = [_].
lookup1(CHARS0, PREFIX, L0, L1) :-
    spellingRule(PREFIX, CHARS0, CHARS1),
    lookup1(CHARS1, PREFIX, L0, L1).
lookup1([C | CHARS0], PREFIX, L0, L1) :-
    \+ C = +,
    lookup1(CHARS0, [C | PREFIX], L0, L1).
lookup1(CHARS0, PREFIX, L0, L1) :-
    (CHARS0 = [+ | CHARS1] -> true; CHARS1 = CHARS0),
    (PREFIX = [] -> CHARS0 = []; true),
    prefix2atom(PREFIX, FORM),
    WORDS1 -- [_ | _],
    findall(W1, (word(FORM, W1), default(inflected(W1)), default(root@W1 = [FORM])), WORDS1),
    /**
      If you've already got something, then the next bit *has*
      to combine with what you've already got
      **/
    WORDS2 -- [_ | _],
    (L0 = [WORDS0] ->
     (mergeWords(WORDS0, WORDS1, WORDS2),
      lookup1(CHARS1, [], [WORDS2], L1));
     lookup1(CHARS1, [], [WORDS1], L1)).

mergeWords(WORDS0, WORDS1, WORDS) :-
    findall(W, (member(W0, WORDS0), member(W1, WORDS1), mergeWord(W0, W1, W)), WORDS).

mergeWord(P, R0, R1) :-
    P <> [prefix],
    affixes@R0 -- [P | affixes@R1],
    R0\affixes\root -- R1,
    root@R0 -- [ROOT0],
    root@P -- [ROOTP],
    root@R1 -- [ROOT0>ROOTP].
mergeWord(R0, P, R1) :-
    P <> [suffix],
    affixes@R0 -- [P | affixes@R1],
    R0\affixes\root -- R1,
    root@R0 -- [ROOT0],
    root@P -- [ROOTP],
    root@R1 -- [ROOT0>ROOTP].

lookup((AFORM, FORM, TAG), WORD, LANGUAGE) :-
    WORDX -- WORD\root\surface\tag,
    [start, end, modified, cat] :: [WORD, hd@WORD],
    language@WORD -- LANGUAGE,
    surface@WORD -- FORM,
    !,
    (\+ \+ word(FORM, DUMMY) ->
     lookup(FORM, WORD, LANGUAGE);
     (\+ FORM = AFORM, word(AFORM, DUMMY)) ->
     lookup(AFORM, WORD, LANGUAGE);
     lookup(TAG, WORDX, LANGUAGE)),
    default(setCost(WORD, 0)),
    default(root@WORD = [(FORM, start@WORD)]).
lookup(FORM, WORD, language@WORD) :-
    lookup(FORM, WORD),
    [start, end, modified, cat] :: [WORD, hd@WORD],
    surface@WORD -- FORM,
    default(saturated(WORD)),
    default(root@WORD = [(FORM, start@WORD)]),
    default(setCost(WORD, 0)).

lookup(N, X, _) :-
    atom_chars(N, [C | _]),
    number_chars(_, [C]),
    !,
    number(X, N),
    root@X -- [N],
    default(saturated(X)),
    default(setCost(X, 0)).

unknown(U, X, english) :-
    ucase(U),
    !,
    properName(X, U).
