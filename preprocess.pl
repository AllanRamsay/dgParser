:- ensure_loaded([useful]).
:- use_module(library(charsio)).

multipunct([(P, B, 'PUNC'), (P, B, 'PUNC') | T0], (MP1, MB1, 'MPUNC'), T1) :-
    !,
    multipunct([(P, B, 'PUNC') | T0], (MP0, MB0, 'MPUNC'), T1),
    atom_concat(P, MP0, MP1),
    atom_concat(B, MB0, MB1).
multipunct([(P, B, 'PUNC') | L], (P, B, 'MPUNC'), L).

retag([], []).
retag([(P, B, 'PUNC'), (P, B, 'PUNC') | T0], [(MP, MB, 'MPUNC') | T2]) :-
    !,
    multipunct([(P, B, 'PUNC'), (P, B, 'PUNC') | T0], (MP, MB, 'MPUNC'), T1),
    retag(T1, T2).
retag([(_, '(', 'PUNC') | L0], Ln) :-
    append(_, [(_, ')', 'PUNC') | L1], L0),
    !,
    retag(L1, Ln).
retag([(AN, '>n', 'IN') | T0], [(AN, '>n', 'CO') | T1]) :-
    !,
    retag(T0, T1).
retag([(AN, 'An', 'IN') | T0], [(AN, 'An', 'CO') | T1]) :-
    !,
    retag(T0, T1).
retag([('لازلت', lAzlt, 'VB') | T0], [('لازلت', lAzlt, 'AUX') | T1]) :-
    !,
    retag(T0, T1).
retag([('معلش', BW, _) | T0], [('معلش', BW, 'APOLOGY') | T1]) :-
    !,
    retag(T0, T1).
retag([(@, @, 'PUNC') | T0], [(@, @, 'REP') | T1]) :-
    !,
    retag(T0, T1).
retag([(HYNMA, 'HynmA', 'NN') | T0], [(HYNMA, 'HynmA', 'WP') | T1]) :-
    !,
    retag(T0, T1).
retag([(NEG, lA, 'RP') | T0], [(NEG, lA, 'NEG') | T1]) :-
    !,
    retag(T0, T1).
retag([(RELPRON, 'AlY', 'IN'), (VBA, VBBW, 'VB') | T0], [(RELPRON, 'AlY', 'WP') | T1]) :-
    !,
    retag([(VBA, VBBW, 'VB') | T0], T1).
retag([(NA, NB, 'NN'), (A, 'w$', 'AGR') | T0], [(NA, NB, 'NN'), (A, 'w$', 'WP') | T1]) :-
    !,
    retag(T0, T1).
retag([H | T0], [H | T1]) :-
    retag(T0, T1).

printText(L) :-
    /*
    nl,
    ((member((W, _, _), L), write(W), write(' '), fail); true),
      */
    nl,
    ((member((W, _, P), L), write(W+P), write(' '), fail); true).

[] $$ [(_, '.', 'PUNC')] $$ [].
[] $$ [(_, ',', 'PUNC')] $$ [].
[] $$ [(_, '?', 'PUNC')] $$ [].
[] $$ [(_, 'Am', _)] $$ [].
[(_, _, 'PRP')] $$ [(_, w, 'CC')] $$ [(_, _, 'NN')].
%% [(_, _, _)] $$ [] $$ [(_, gyr, 'RP'), (_, _, 'DT')].
[(_, _, _)] $$ [] $$ [(_, _, 'AUX')].
[(_, _, _)] $$ [] $$ [(_, _, 'REP')].
[(_, _, _)] $$ [] $$ [(_, _, 'APOLOGY')].
[(_, _, _)] $$ [] $$ [(_, _, 'NEG')].
[(_, _, _)] $$ [] $$ [(_, _, 'WRB')].
[(_, _, _)] $$ [] $$ [(_, 'Allhm', _)].

writePhonemes([(A, B, C) | T]) :-
    format("('~w', '~w', '~w')", [A, B, C]),
    (T = [] ->
     true;
     (format(', ', []),
     writePhonemes(T))).
writeSegment(I, SEGMENT) :-
    format('segment(~w, [', [I]),
    writePhonemes(SEGMENT),
    format(']).~n', []).
/**
  If you call this with SAVE=true, you get the output that we
  need for the web version, if SAVE is fail then you get
  something that you can use to generate what is needed in
  segmented.pl. But note that segmented.pl will contain an
  English tweet that contains 'I'm', which won't compile, so
  you'll have to hand-remove that one (which we don't want
  anyway)
  **/
preprocess(Sn, SAVE) :-
    sentence(S0),
    %% either not a tag for an Arabic word or something wrong in the tagger output
    \+ (member((_, _, TAG), S0), ((atom_chars(TAG, CHARS), number_chars(_, CHARS)); member(TAG, ['', 'Ag', 'FW', 'JJR', 'JJS', 'NNS', 'PRP$', 'PUNC)', 'TO', 'VBD', 'VBG', 'VBN', 'VBP', 'VBZ', 'WRP]', alsumiri, anbae, d, emo, emoj, 'emoj>Hwbگ', emot, link, model, shj]))),
    (retract(sentenceCounter(I)) ->
     true;
     I = 0),
    J is I+1,
    assert(sentenceCounter(J)),
    retractall(segmentCounter(_)),
    assert(sentence(J, S0)),
    (SAVE -> 
     (format('~n**********************************', []),
      printText(S0));
     true),
    retag(S0, S1),
    (SAVE ->
     (format('~nAfter retagging', []),
      printText(S1));
     true),
    Sn = [_ | _],
    findSegment(S1, Sn),
    (retract(segmentCounter(SEG0)) ->
     true;
     SEG0 = 0),
    SEG1 is SEG0+1,
    assert(segmentCounter(SEG1)),
    nl,
    (SAVE -> 
     (format('~nAfter segmentation', []),
      printText(Sn));
     writeSegment(J, Sn)),
    assert(segment(J, SEG1, Sn)).

preprocess(SAVE) :-
    retractall(sentenceCounter(_)),
    retractall(sentence(_, _)),
    retractall(segmentCounter(_)),
    retractall(segment(_, _, _)),
    ((preprocess(_, SAVE), fail); true).

saveSegments(F) :-
    tell(F),
    ((segment(A, B, C), format('~k.~n', [segment(A, B, C)]), fail); told).

saveSegments :-
    saveSegments('segments.pl').

preprocess :-
    abolish(segment/3),
    preprocess(true).

pp(SEGMENTS, SAVE) :-
    tell(SEGMENTS),
    preprocess(SAVE),
    told.

ppandhalt(SEGMENTS) :-
    atom_concat(SEGMENTS, '.txt', SEGMENTSTXT),
    atom_concat(SEGMENTS, '.pl', SEGMENTSPL),
    pp(SEGMENTSTXT, true),
    saveSegments(SEGMENTSPL),
    halt.

startsWith(L, [], L).
startsWith([H | T0], [H | T1], L) :-
    startsWith(T0, T1, L).

findSegment(L, SEGMENT) :-
    set(quoteAtoms),
    format('~nfindSegment(~p, SEGMENT).~n', [L]),
    unset(quoteAtoms),
    findSegment(L, [], SEGMENT).

findSegment(L0, S0, Sn) :-
    L $$ X $$ R,
    startsWith(L0, L, L1),
    startsWith(L1, X, L2),
    startsWith(L2, R, _L3),
    !,
    (append(S0, L, Sn); findSegment(L2, [], Sn)).
findSegment([H | T], SEG0, SEGn) :-
    append(SEG0, [H], SEG1),
    findSegment(T, SEG1, SEGn).
findSegment([], S, S).

    
    
    
