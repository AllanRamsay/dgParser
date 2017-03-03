
/**
  Pick the next item from the stack:

  (i) it's what you want. Q is right, stack is the rest
  (ii) it's not what you want. Shove it back onto the Q,
  move on
  **/
splitStack(H, [H | T]-T, Q-Q).
splitStack(H, [X | T]-S, Q0-Q1) :-
    splitStack(H, T-S, [X | Q0]-Q1).

min(I, J, K) :-
    (I < J -> K = I; K =J).
max(I, J, K) :-
    (I > J -> K = I; K =J).

:- op(401, xfx, ==>).

/**
  Internal/external views:

  Internal view: hd+args+mods
  So what we're growing is the internal view: but if
  a head wants the external view, as either a modifier
  or an argument, they can have it.

  **/

[HQW | QUEUE] // [HSW | STACK] // RELNS0 //_
==>
[R | QUEUE] // STACK // RELNS1 // reduceAsModifier(surface@M, surface@T) :-
    [structure, mod, theta, head, args] :: [M, MW],
    target@M -- T,
    dir@M -- DM,
    M <> saturated,
    R -- result@M,
    moved@M -- MM,
    [MSTART, MEND, TSTART, TEND] -- [start@M, end@M, start@T, end@T],
    ((after(DM), HQW = MW, HSW = T, (MSTART=TEND -> true; MM=after));
     (before(DM), HQW = T, HSW = MW, (MEND=TSTART -> true; MM=before))),
    default(modified@T = 0),
    catch(modified@T =< modified@R,
	  E,
	  (cpretty('modified not specified'),
	   format('~nTARGET', []),
	   cpretty(T),
	   format('~nMODIFIER', []),
	   cpretty(M),
	   throw(E))),
    (combine(T, M, R) -> true; fail),
    insert((index@T):(surface@T) > {theta@M, (index@M):(surface@M):(moved@M)}, RELNS0, RELNS1).

[Q0W | QUEUE0] // [TOP | STACK0] // RELNS0 //_
==>
QUEUE1 // STACK1 // RELNS1 // reduceAsArgument(surface@H0, surface@D) :-
    -zero@D,
    view(H0W, H0),
    view(DW, D),
    H0\args\position -- H1,
    args@H0 -- [D | args@H1],
    dir@D -- DD,
    moved@D -- MD,
    %% If H0 was on the Q, we've removed it, so we have
    %% to put it back. We've removed D from the stack,
    %% which is what we want
    
    %% If H0 was in the stack, we've removed D from the
    %% Q. We want H1 to be on the Q.
    splitStack(S0W, [TOP | STACK0]-STACK1, [H1 | QUEUE0]-QUEUE1),
    ((Q0W = DW, S0W = H0W, ((after(DD), H0W = TOP) -> MD = -; MD = after));
     (Q0W = H0W, S0W = DW, ((before(DD), DW = TOP) -> MD = -; MD = before))),
    combine(H0, D, H1),
    insert((index@H0):(surface@H0) > {theta@D, (index@D):(surface@D):(MD)}, RELNS0, RELNS1).

QUEUE // [H0 | STACK] // RELNS0 // _
==>
[H1 | QUEUE] // STACK // RELNS1 // shift(surface@H0) :-
    +zero@D,
    -moved@D,
    surface@D -- zero,
    H0\args -- H1,
    start@D -- start@H0,
    start@D -- end@D,
    [xstart, xend]@D -- [start, end]@D,
    args@H0 -- [D | args@H1],
    insert((start@H0):(surface@H0) > {theta@D, (start@D):(surface@D):(moved@D)}, RELNS0, RELNS1).
