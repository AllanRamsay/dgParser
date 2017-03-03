:- use_module(library(sockets)).

:- ensure_loaded(setup), setup.

startSicstusServer :-
    startSicstusServer(60000).

startSicstusServer(PORT) :-
    number_chars(PORT, PORTCHARS),
    atom_chars(PORTATOM, PORTCHARS),
    atom_concat('../locked', PORTATOM, LOCKED),
    assert(lockfile(LOCKED)),
    assert(port(PORT)),
    socket('AF_INET', S),
    socket_bind(S, 'AF_INET'('localhost',PORT)),
    listen(S, PORT), 
    halt.

safeListen(S, PORT) :-
    catch(listen(S, PORT), _, safeListen(S, PORT)).

log(MSG0, ARGS) :-
    with_output_to_atom(format(MSG0, ARGS), MSG1),
    format('~w~n', [MSG1]),
    port(PORT),
    open('/tmp/logserver', 'append', LOG),
    format(LOG, '~w: ~w~n', [PORT, MSG1]),
    close(LOG).

listen(S, PORT) :-
    format('listening~n', []),
    socket_listen(S, 1),
    lockfile(LOCKFILE),
    open(LOCKFILE, 'write', UNLOCKED),
    close(UNLOCKED),
    socket_accept(S, SENDER, STREAM),
    format('making lockfile ~w~n', [LOCKFILE]),
    open(LOCKFILE, 'write', LOCKED),
    write(LOCKED, '0.\n'),
    close(LOCKED),
    socket_buffering(STREAM, read, _RB, unbuf),
    socket_buffering(STREAM, write, _WB, unbuf),
    format('About to read message from ~w~n', [STREAM]),
    read(STREAM, X),
    log('Message received from ~w: ~w~n', [SENDER, X]),
    (catch(with_output_to_atom((dgParse(X, Y),pretty(Y)), P), ERRMSG, P = ERRMSG) ->
     true;
     P = 'noAnalysisFound'),
    log('Parse tree for ~w: ~w~n', [X, Y]),
    format(STREAM, '~w~n', [P]),
    close(STREAM),
    safeListen(S, PORT).

