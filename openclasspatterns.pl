%%%%%%%%%%%%%%% Last Week Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Yet To-Do:
   1-fix the rplaced variables [X] to be X
   2-Dealing with morphological differences cat> , cat>s should be considered shared item.
/*
[NOTE]: We no longer turning trees into lists using the
=.. operator because now we now that a tree is a list of a head and a
tail,the head is in the form (Word:Tag). The tail is a list of
daughters which are other sub-trees of the form {Role,List}.
*/
%%%%%%%%%%%%%%% Transformation (1)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------------------------
%Step 1: Get open-class words for each tree separatly.
%--------------------------------------------------------------------
getOpenClass(T, OPEN) :-
    getOpenClass(T, [], OPEN).

getOpenClass(X, OPEN, OPEN) :-
    (var(X); atomic(X)),
    !.

getOpenClass([H | T], OPEN0, OPEN2) :-
    !,
    getOpenClass(H, OPEN0, OPEN1),
    getOpenClass(T, OPEN1, OPEN2).

%% I added the TAG (name) to the list of tags as it represents proper noun
%% The TAG could be a veriable because not all words has a certain proper tag (for now), thus, having a variable as a tag is going to be ignored. 
getOpenClass((WORD:TAG), OPEN0, OPEN1) :-
    ((var(TAG); \+ member(TAG, [noun, verb, name])) ->
     OPEN1 = OPEN0;
     member(WORD:TAG, OPEN0) ->
     OPEN1 = OPEN0;
     OPEN1 = [(WORD:TAG) | OPEN0]).

getOpenClass({_ROLE, L}, OPEN0, OPEN1) :-
    !,
    getOpenClass(L, OPEN0, OPEN1).

%-------------------------------------------------------------------------
%Step 2: For two lists of open-class words, find & return the shared ones 
%-------------------------------------------------------------------------

getSharedOpenClassItems(X, Y, SHARED) :-
    getOpenClass(X, OPENX),
    getOpenClass(Y, OPENY),
    shared2(OPENX, OPENY, SHARED).

shared0([], _L, []).
shared0([H | T], Y, [H | SHARED]) :-
    member(H, Y),
    !,
    shared0(T, Y, SHARED).
shared0([_ | T], Y, SHARED) :-
    shared0(T, Y, SHARED).

shared1(L0, L1, SHARED) :-
    findall(X, (member(X, L0), member(X, L1)), SHARED).

shared2(L0, L1, SHARED) :-
    qsort(L0, LS0),
    qsort(L1, LS1),
    shared2q(LS0, LS1, SHARED).

shared2q([], _, []).
shared2q(_, [], []).
shared2q([H0 | T0], [H1 | T1], SHARED2) :-
    (H0 = H1 ->
     (shared2q(T0, T1, SHARED1),
      SHARED2 = [H0=_ | SHARED1]);
     H0 @< H1 ->
     shared2q(T0, [H1 | T1], SHARED2);
     shared2q([H0 | T0], T1, SHARED2)).

