:- use_module(library(sockets)).

talkToSICStus :-
    startClient(60000).
talkToPython :-
    startClient(55000).

startClient(PORTNUMBER) :-
    openPort(PORTNUMBER, PORT),
    talkTo(PORT).

openPort(PORT0, PORTN) :-
    number_chars(PORT0, PORTCHARS),
    atom_chars(PORTATOM, PORTCHARS),
    atom_concat('locked', PORTATOM, LOCK),
    open(LOCK, 'read', LOCKSTREAM),
    (read(LOCKSTREAM, end_of_file) ->
     PORTN = PORT0;
     (PORT1 is PORT0+1, openPort(PORT1, PORTN))).

talkTo(PORT) :-
    read(X),
    (X = end_of_file ->
     true;
     askServer(PORT, X)).

askServer(PORT, X) :-
    format('talkTo(~w, ~w).~n', [PORT, X]),
    socket('AF_INET', S),
    socket_connect(S, 'AF_INET'('localhost',PORT), STREAM),
    socket_buffering(STREAM, read, _RB, unbuf),
    socket_buffering(STREAM, write, _WB, unbuf),
    format('sending(~w)~n', [X]),
    format(STREAM, '~w.~n', [X]),
    format('listening~n', []),
    read(STREAM, ANSWER),
    format('ANSWER RECEIVED ~w~n', [ANSWER]),
    talkTo(PORT).