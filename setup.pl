%%%% SETUP.PL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- use_module(library(charsio)).

coreFiles([useful,
	   features,
	   pretty,
	   io,
	   disjoin]).

compileable([signatures]).

noncompilable([agree,
	       classes,
	       negation,
	       vforms,
	       pronouns,
	       verbs,
	       mclasses,
	       determiners,
	       nouns,
	       lookup,
	       chart,
	       treepr,
	       conll,
	       parseconstrained,
	       preprocess,
	       spelling,
	       transformations]).

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
