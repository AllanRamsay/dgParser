:- multifile(signature/1).

signature(vclass=[pastPart=_, pastTense=_]).

pastTenseSuffix(X, pastTense:vclass@class@X).
pastPartSuffix(X, pastPart:vclass@class@X).

pastForms(X, pastTense:vclass@class@X, pastPart:vclass@class@X).

regularPast(X) :-
    X <> [pastForms(ed, ed)].
	  