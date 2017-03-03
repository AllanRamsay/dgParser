
alltests :-
    example(S, TARGET),
    set(quoteAtoms, RESET),
    %% unset(firstOneOnly, _),
    format("~n~nchartParse('~w', A, english), pretty(index@A+root@A), fail.~n", [S]),
    call(RESET),
    findall(X, chartParse(S, X, english), TREES),
    (TREES = TARGET ->
     (format('OK~n', []),
      member(T, TREES),
      pretty(index@T+root@T),
      fail);
     append(TARGET, _, TREES) ->
     (format('Too many trees~n', []),
      member(T, TREES),
      pretty(index@T+root@T),
      fail);
     (format('Too few trees~n', []),
      member(T, TREES),
      pretty(index@T+root@T),
      fail)),
    fail.

example('he concluded the banquet by eating the owl', [_]).
example('I stole the peach she wanted to eat', [_]).
example('I stole the peach she wanted him to eat', [_]).
example('I saw the man who she loves', [_]).
example('I saw the man who she wants to love her', [_]).
example('I saw the man who she loves', [_]).
example('I stole the peach which she wanted him to eat', [_]).
example('I saw the man who she wanted to love her', [_]).
example('I saw the man who she said she wanted to love her', [_]).
example('the pudding I thought was disgusting', [_]).
example('I went to London to see the queen', [_]).
example('he has been saying he loves her', [_]).
example('he has been saying that he loves her', [_]).
example('he has been saying she is a fool', [_]).
example('she said that the man that loved her is a fool', [_]).
example('she said that that man is a fool', [_]).
example('she said that man is a fool', [_]).
example('she said that', [_]).
example('he is happy', [_]).
example('he is in the park', [_]).
example('John and his friend bought and sold stolen cars for her', [_]).
example('John and his friends bought and sold the cars which Mary had stolen for them', [_]).
example('I believe with all my heart that she loves me', [_]).


    