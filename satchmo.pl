
:- multifile(signature/1).

signature(label=[context=_, indent=_]).

incIndent(I0, I1) :-
    (I0 = '' -> true; true),
    atom_concat(I0, '  ', I1).

add((A & B)@@L, REASON) :-
    !,
    add(A@@L, REASON),
    add(B@@L, REASON).
add(X@@(context:label@L), REASON) :-
    assert(temp(X, L, REASON)).

prove(P, L0) :-
    (?showProof -> format('~n~wTrying to prove ~w in ~w', [indent:label@L0, P, context:label@L0]); true),
    temp(P, L0, _),
    (?showProof -> format('~n~wFound ~w in ~w', [indent:label@L0, P, context:label@L0]); true).

prove(P, L0) :-
    L0\(indent:label) -- L1,
    incIndent(indent:label@L0, indent:label@L1),
    temp(Q => P, L1, _),
    (?showProof -> format('~n~wUsing ~w to prove ~w in ~w', [indent:label@L0, Q => P, P, context:label@L0]); true),
    prove(Q, L1).

prove(P & Q, L0) :-
    L0\(indent:label) -- L1,
    incIndent(indent:label@L0, indent:label@L1),
    prove(P, L1),
    prove(Q, L1).

prove(P or Q, LABEL) :-
    prove(P, LABEL);
    prove(Q, LABEL).

prove(not(P), LABEL) :-
    prove(P => absurd, LABEL).

prove(P => Q, L0) :-
    gensym(hyp, TEMP),
    assert(temp(P, L0, TEMP)),
    L0\(indent:label) -- L1,
    incIndent(indent:label@L0, indent:label@L1),
    (prove(Q, L1) -> 
        (%% used(P, LABEL), %% Relevance logic
         retractall(temp(_, TEMP)); 
        (retractall(temp(_, TEMP)), fail))).