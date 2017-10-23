readLine(TEXT) :-
    read_line(CHARS),
    (CHARS = end_of_file ->
     TEXT = '';
     atom_chars(TEXT, CHARS)).
    
startDialogue :-
    retractall(temp(_, _, _)),
    dialogue.

accept(CLAIM0) :-
    substitute(hearer, speaker, CLAIM0, CLAIM1),
    add(CLAIM1, claimed).

dialogue :-
    readLine(TEXT),
    format('~w~n', TEXT),
    (TEXT = '' ->
     true;
     (silently(nfParse(TEXT, NF)),
      pretty(NF),
      (NF = claim(CLAIM) ->
       (accept(CLAIM) ->
	format('OK~n', []);
	format("Sorry, I didn't understand that", []));
       NF = query(QUERY@@(context:label@L)) ->
       (indent:label@L = '', prove(QUERY, L));
       (format('I have no idea what you are talking about~n', []),
	fail)),
      dialogue)).
     