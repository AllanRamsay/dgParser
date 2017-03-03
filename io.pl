getStream(_, _) :-
    closeOutputStream,
    fail.
getStream(F, S) :-
    (F = user_output ->
     S = F;
     open(F, write, S, [wcx(unicode)])),
    assert(currentStream(S)).

writeStream(X) :-
    (usingStream(S) -> true; S = user_output),
    write(S, X).

closeStream :-
    retract(currentStream(S)),
    (S = user_output -> true; close(S)),
    fail.
closeStream.