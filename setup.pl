%%%% SETUP.PL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- use_module(library(charsio)).

coreFiles([useful,
	   features,
	   pretty,
	   io,
	   disjoin,
	   client]).

compileable([signatures]).

noncompilable([agree,
	       classes,
	       vforms,
	       pronouns,
	       verbs,
	       mclasses,
	       determiners,
	       negation,
	       miscellany,
	       nouns,
	       lookup,
	       chart,
	       treepr,
	       conll,
	       parseconstrained,
	       preprocess,
	       nf,
	       %% transformations,
	       spelling,
	       pstree,
	       satchmoplus]).

setup(COMPILING, DICT) :-
    coreFiles(CFILES),
    compile(CFILES),
    compileable(FILES0),
    noncompilable(FILES1),
    (COMPILING ->
     compile(FILES0);
     consult(FILES0)),
    consult(FILES1),
    consult(DICT).

setup(DICT) :-
    setup(fail, DICT).

setup :-
    setup(open).
