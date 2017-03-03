
%%%% TIMING.PL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time(G, N) :-
    set(noTimers),
    statistics(walltime, _),
    with_output_to_chars(doIt(G, N), _),
    statistics(walltime, [_, E]),
    format('Elapsed time ~w~n', [E]),
    unset(noTimers).

time(G) :-
    time(G, 1).

doIt(_G, 0) :-
    !.
doIt(G, I) :-
    (\+ \+ call(G) -> true; true),
    J is I-1,
    doIt(G, J).

clearTimers :-
    retractall(timer(_, _)),
    retractall(tcounter(_, _)).

showTimers([], N) :-
    format('Total time: ~w~n', [N]),
    bb_put(totalTime, N).
showTimers([timer(A, B, C) | T], I) :-
    J is I+B,
    X is (B*100)/C,
    atom_chars(A, L),
    length(L, N),
    (N > 12 -> 
	format('~w: ~ttime = ~w, \tcalls = ~w, \taverage=~5d~n', [A, B, C, X]);
     N > 5 ->
	format('~w: \t\t~ttime = ~w, \tcalls = ~w, \taverage=~5d~n', [A, B, C, X]);
	format('~w: \t\t\t~ttime = ~w, \tcalls = ~w, \taverage=~5d~n', [A, B, C, X])),
    showTimers(T, J).

showTimers :-
    findall(timer(A, B, C), (timer(A, B), tcounter(A, C)), TIMERS),
    showTimers(TIMERS, 0),
    fail.
showTimers.

startTimer(_) :-
    flag(noTimers),
    !.
startTimer(_T) :-
    statistics(walltime, _).
startTimer(T) :-
    stopTimer(T),
    fail.

stopTimer(_) :-
    flag(noTimers)
,
    !.
stopTimer(T) :-
    statistics(walltime, [_, E]),
    (retract(timer(T, I0)) ->
	true;
	I0 = 0),
    (retract(tcounter(T, J0)) ->
	true;
	J0 = 0),
    I1 is I0+E,
    J1 is J0+1,
    assert(tcounter(T, J1)),
    assert(timer(T, I1)).
stopTimer(_T) :-
    statistics(walltime, _),
    fail.

setTimer(T, G) :-
    startTimer(T),
    call(G),
    stopTimer(T).

withTimers(G) :-
    clearTimers,
    call(G),
    !,
    unset(silent, S),
    showTimers,
    set(silent, S).
