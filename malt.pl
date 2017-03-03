
/**

  beam is a list of states

  state is stack, queue, relations
  
  stack and queue are lists of words

  decision tree is a predicate called classify

**/

getTags(_, 0, []) :-
    !.
getTags([H0 | T0], I, [tag@H0 | T1]) :-
    !,
    J is I-1,
    getTags(T0, J, T1).
getTags([], I, [- | T]) :-
    J is I-1,
    getTags([], J, T).

distanceFromS0toQ0(STATE, D) :-
    queue:state@STATE -- [Q0 | _],
    stack:state@STATE -- [S0 | _],
    D is start@Q0-start@S0.
    
genNewStates(STATE0, ACTIONS) :-
    getTags(queue:state@STATE0, 3, [F0, F1, F2]),
    getTags(stack:state@STATE0, 2, [F3, F4]),
    (distanceFromS0toQ0(STATE0, F5) -> true; true),
    classify([F0, F1, F2, F3, F4, F5], ACTIONS).

maltD(STATE, STATE) :-
    queue:state@STATE -- [],
    stack:state@STATE -- [_].

maltD(STATE0, STATEN) :-
    genNewStates(STATE0, [[_SCORE,ACTION] | _]),
    doIt(ACTION, STATE0, STATE1),
    maltD(STATE1, STATEN).

conll2tree(RELATIONS, [tag@HD+start@HD | TREE]) :-
    member(HD > _DTR, RELATIONS),
    \+ member(_X > HD, RELATIONS),
    !,
    findall(DTR, member(HD > DTR, RELATIONS), DTRS),
    conll2dtrs(DTRS, RELATIONS, TREE).

conll2dtrs([], _RELATIONS, []).
conll2dtrs([H0 | T0], RELATIONS, [[tag@H0+start@H0 | DTRS1] | T1]) :-
    findall(DTR, member(H0 > DTR, RELATIONS), DTRS0),
    conll2dtrs(DTRS0, RELATIONS, DTRS1),
    conll2dtrs(T0, RELATIONS, T1).
    
mergeBounded(L0, [], L0, B1) :-
    !.
mergeBounded([], L0, L0, B1) :-
    !.
mergeBounded(_, _, [], []) :-
    !.
mergeBounded([H0 | T0], [H1 | T1], [H | B0], B1) :-
    (H0 @< H1 ->
     (H = H0, mergeBounded(T0, [H1 | T1], B0, B1));
     (H = H1, mergeBounded(T0, [H1 | T1], B0, B1))).

mergeBounded(L0, L1, L) :-
    mergeBounded(L0, L1, [_, _, _, _, _], L).

initialiseMalt(WORDS0, STATE) :-
    initialiseMalt(WORDS0, 0, queue:state@STATE),
    stack:state@STATE -- [],
    relations:state@STATE -- [].

initialiseMalt([], _I, []).
initialiseMalt([tag@H1 | T0], I, [H1 | T1]) :-
    J is I+1,
    start@H1 -- I,
    end@H1 -- J,
    initialiseMalt(T0, J, T1).

maltB([STATE0 | STATES0]) :-
    genNewStates(STATE0, NEWSTATES),
    mergeSorted(STATES0, NEWSTATES, [ACTION | STATES1]),
    doIt(ACTION, STATE0, STATE1),
    mergeBounded([STATE1], STATES1, STATES2),
    justN(STATES2, [A, B, C, D]),
    maltB([A, B, C, D]).

doIt(shift, STATE0, STATE1) :-
    relations:state :: [STATE0, STATE1],
    queue:state@STATE0 -- [HD | queue:state@STATE1],
    stack:state@STATE1 -- [HD | stack:state@STATE0].

doIt(leftArc, STATE0, STATE1) :-
    queue:state :: [STATE0, STATE1],
    queue:state@STATE0 -- [HDQ | _],
    stack:state@STATE0 -- [HDS | stack:state@STATE1],
    relations:state@STATE1 -- [(HDQ > HDS) | relations:state@STATE0].

doIt(rightArc, STATE0, STATE1) :-
    [HDQ | QUEUE0] -- queue:state@STATE0,
    [HDS | stack:state@STATE1] -- stack:state@STATE0,
    [HDS | QUEUE0] -- queue:state@STATE1,
    relations:state@STATE1 -- [(HDS > HDQ) | relations:state@STATE0].
