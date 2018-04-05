
/**
  A modifier adds a (possibly null) modifier to the tree & possibly sets the
  value of specified.

  Args apply the value of the specifier.
  **/

simpleDet0(X) :-
    start@target@X -- end@X,
    target@X <> [standardcase].

simpleDet1(X, N) :-
    X <> [det2(N), simpleDet0, -modifiable],
    [agree] :: [X, target@X, result@X].

simpleDet2(X, N) :-
    target@X <> [-zero],
    X <> [simpleDet1(N)].

ofDet2(X, N) :-
    target@X <> [+def],
    result@X <> [standardcase],
    X <> [det1(N), -modifiable],
    specifier :: [X, result@X],
    [agree] :: [X, target@X, result@X].

ofDet1(X, N) :-
    fail,
    target@X <> [casemarked([of])],
    X <> [ofDet2(N)].

/**
ofDet(X, N, COMP) :-
    X <> [n, standardcase, -target],
    args@X -- [COMP],
    COMP <> [np, +def, -zero, fixedpostarg, theta(subset)].

ofDet(X, N) :-
    COMP <> [casemarked([of])],
    X <> ofDet(N, COMP).
**/

number(X, I) :-
    X <> [det5(5), simpleDet1(5), -modifiable],
    modifier@X -- numAsMod,
    result@X <> [specifier(*indefinite)].
number(X, I) :-
    ofDet1(X, 5),
    modifier@X -- numAsMod,
    X <> [specifier(*indefinite)].

aa(X) :-
    X <> [saturated, simpleDet1(10)],
    target@X <> [-def, standardcase, -zero],
    result@X <> [specifier(*indefinite)].

all(X) :-
    X <> [saturated, simpleDet1(11)],
    target@X <> [standardcase, -specified],
    result@X <> [specifier(*universal), +specified].
all(X) :-
    X <> [a, saturated, premod, movedBefore(-)],
    target@X <> [np, +def, standardcase, specifier(*the), -zero],
    -zero@hd@target@X,
    result@X <> [np, -target, specifier(*universal)].

any(X) :-
    X <> [simpleDet1(10)],
    result@X <> [np, -target, specifier(*(universal=0.2))].
any(X) :-
    ofDet1(X, 10).

every(X) :-
    X <> [det(10), thirdSing, simpleDet1(10), theta(specifier)],
    result@X <> [np, -target, specifier(*universal)].

few(X) :-
    number(X, few).

many(X) :-
    start@target@X -- end@X,
    X <> [det2(5)],
    target@X <> [standardcase],
    result@X <> [+def].
many(X) :-
    ofDet1(X, 5),
    result@X <> [-modifiable].

most(X) :-
    start@target@X -- end@X,
    X <> [det2(5)],
    target@X <> [standardcase],
    result@X <> [+def, notMoved].
most(X) :-
    ofDet1(X, 5),
    result@X <> [-modifiable].
most(X) :-
    cat@X -- most,
    A <> [a, saturated],
    X <> [adv2(A), saturated, inflected, notMoved, -modifiable].

no(X) :-
    X <> [saturated, simpleDet1(11)],
    target@X <> [standardcase, -specified],
    result@X <> [specifier(*no), +specified].

some(X) :-
    X <> [saturated, simpleDet1(11)],
    target@X <> [standardcase, -specified],
    result@X <> [specifier(*indefinite), +specified].
some(X) :-
    ofDet1(X, 10),
    X <> [specifier(*indefinite)].

the(X) :-
    X <> [+def, simpleDet1(10)],
    result@X <> [specifier(*the), +specified].

possessive(X) :-
    X <> [+def, simpleDet1(10)],
    result@X <> [specifier(*the), +specified],
    modifier@X -- owner.