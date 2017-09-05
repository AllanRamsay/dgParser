:- use_module(library(sockets)).

pythonPorts(55000).

askServer(PORT, QUERY, ANSWER) :-
    socket('AF_INET', S),
    socket_connect(S, 'AF_INET'('localhost',PORT), STREAM),
    socket_buffering(STREAM, read, _RB, unbuf),
    socket_buffering(STREAM, write, _WB, fullbuf),
    format(STREAM, '~w~n', [QUERY]),
    flush_output(STREAM),
    read(STREAM, ANSWER).

askServer(QUERY, ANSWER) :-
    pythonPorts(P0),
    askServer(P0, QUERY, ANSWER).