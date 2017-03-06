
cat(X, cat@X).

/**
  theta@X is the label for X. Packaging it up
  as a function makes it easy to add to lists of properties
  **/

theta(X, theta@X).

/**
  complete is set when all X's arguments have been found
  It's the last thing that happens when we combine a word
  and one of its arguments, so we can safely use it to
  trigger things that happen when something has all its
  arguments, because we know that once this has been set
  then everything else about X's arguments is known
**/

complete(X) :-
    nonvar(complete@X).

/**
  Anything which arises from combining two items, either as
  hd and argument or as modifier and target, will have a
  non-empty set of dtrs. So if the dtrs are empty then it
  must be simple word
  **/

word(X) :-
    dtrs@X -- [].

/**
  We specify the direction in which we expect to find
  something using a dual pair of features, after and before,
  because it gives us a bit of extra flexibility
  **/

after(X) :-
    +after:position@X,
    -before:position@X.

before(X) :-
    -after:position@X,
    +before:position@X.

/**
  Heads know where they expect their arguments to be,
  modifiers know where they expect their targets to be.
  That's what we were doing above.

  But things can turn up in places other than where they
  were expected. Obvious examples include WH-marked items,
  which generally appear at the start of the clause that
  includes them: "he ate it" -> "what he ate _", "she said
  she saw him" -> "who she said she saw _" and things that
  have been moved to the front for emphasis "I enjoyed the
  main course but I thought the dessert was disgusting" -> "I
  enjoyed the main course but the pudding I thought was
  disgusting"

  We have a feature called 'moved' which says where something
  has been moved to/is allowed to moved to. It uses the same
  notion of a position which allows you set before and after
  to + or -. There's also a feature inside a position which
  allows you to see whether the position is actually known. A
  typical use lets us say, for instance, that the subject of
  an English verb cannot be shifted to the right (not
  actually always true, as you can see in examples like
  "At the front of the bus sat an old man", but true enough).

  | ?- subject@X <> [noRightShift], cpretty(X).

  sign(A,
     syntax(B,
            head(C,
                 vform(H,
                       subject(sign(structure(J,
                                              position(K,
                                                       moved(position(after(-)))))
  **/

movedAfter(X, after:position@moved@X).
movedBefore(X, before:position@moved@X).

movedAfter(X) :-
    X <> [movedAfter(+), movedBefore(-)].
movedBefore(X) :-
    X <> [movedAfter(-), movedBefore(+)].

notMoved(X) :-
    X <> [movedAfter(-), movedBefore(-)].

noRightShift(X) :-
    X <> [movedAfter(-)].

noLeftShift(X) :-
    X <> [movedBefore(-)].

/**
  inflected items are words that have all the affixes that
  they need.
  **/

inflected(X) :-
    affixes@X -- [],
    -affix@X.

/**
  X is a prefix of type P
  **/

prefix(X, P) :-
    affix@X -- *P,
    dir@X <> [before],
    affixes@X -- [].

/**
  X is just a prefix, we don't know what type
  **/

prefix(X) :-
    X <> [prefix(_)].

suffix(X, P) :-
    affix@X -- *P,
    dir@X <> after,
    affixes@X -- [].

suffix(X) :-
    X <> suffix(_).

needssuffix(X, S) :-
    affixes@X -- [S],
    S <> [suffix].

needssuffix(X) :-
    X <> [needssuffix(_)].

/**
  It can be handy to describe an entity that needs no arguments,
  and while we're about it we might as well define the notion of
  a dummy object
  **/

saturated(X) :-
    args@X -- [].

dummy(X) :-
    cat@X -- dummy,
    X <> [saturated].

/**
  arguments: postargs follow their heads, fixed arguments
  aren't allow to move and aren't allowed to be zero items,
  strict ones have to appear next to their heads.
  **/

postarg(Y) :-
    dir@Y <> after.

fixed(Y) :-
    Y <> [notMoved, -zero].

fixedpostarg(Y) :-
    Y <> [postarg, fixed].

/**
  Y is a fixed postarg of X
  **/

fixedpostarg(X, Y) :-
    Y <> [fixedpostarg].

strictpostarg(X, Y) :-
    X <> [fixedpostarg(Y)],
    end@X -- start@Y.

prearg(Y) :-
    dir@Y <> before.

fixedprearg(Y) :-
    Y <> [prearg, fixed].

strictprearg(X, Y) :-
    Y <> [fixedprearg],
    start@X -- end@Y.

/**
  modifiers: I'm never very sure about the right way to
  talk about the position of a modifier -- does an adjective
  precede the noun that it modifies, or does a noun follow an
  adjective that modifies it. I have gone for the target
  of a premodifier follows it.

  I deal with movement by saying that the target can or
  cannot move, not that the modifier can. In many ways this
  feels wrong, but if we specify whether the modifier can
  move then we tie our hands for cases where X isn't being
  used as a modifier.

  Targets are *never* zeros. It would be very weird to modify
  something that wasn't there.

  We have fixed and strict versions, just as with arguments.
  **/

premod(X, T) :-
    target@X -- T,
    dir@T <> after,
    -zero@T.

premod(X) :-
    premod(X, _).

fixedpremod(X, T) :-
    X <> premod(T),
    T <> notMoved,
    end@X -- start@T.

fixedpremod(X) :-
    X <> fixedpremod(_T).

strictpremod(X, target@X) :-
    X <> fixedpremod,
    end@X -- start@target@X.

strictpremod(X) :-
    X <> [strictpremod(_)].

postmod(X, T) :-
    target@X -- T,
    dir@T <> before,
    -zero@T.

postmod(X) :-
    postmod(X, _T).

fixedpostmod(X, T) :-
    X <> postmod(T),
    T <> notMoved.

fixedpostmod(X) :-
    X <> fixedpostmod(_T).

strictpostmod(X, target@X) :-
    X <> fixedpostmod,
    end@target@X -- start@X.

strictpostmod(X) :-
    X <> [strictpostmod(_)].

/**
  OK, so that's where modifiers can go. But what do they
  do?

  They take one item and produce another one that shares a lot
  of its properties: "red bus" is a third singular noun, because
  the modifier "red" copied lots of information from the target "bus"
  noun to the resulting combination, "red buses" is third plural
  because "buses" was plural.

  adjuncts copy nearly everything from the target to result.
  fulladjuncts do the same as adjuncts, but they also copy the
  value of spec. This is to allow us to distinguish between
  things like adjectives which copy everything (so "red bus"
  is unspecified because "bus" is) and determiners (if we want to
  treat them as modifiers), which change the value of spec.
  **/

adjunct1(X) :-
    target@X -- T,
    result@X -- R,
    -zero@T,
    language :: [X, T, R],
    T\structure\dir\mod\wh\spec\comp -- R.

adjunct(X) :-
    target@X -- T,
    result@X -- R,
    -zero@T,
    language :: [X, T, R],
    T\structure\dir\modified\wh\spec -- R.

fulladjunct(X) :-
    spec :: [target@X, result@X],
    X <> adjunct.

/**
  Sometimes partial trees have holes in them. Consider "the dessert I
  thought was disgusting". We're going to find "the dessert ... was
  disgusting" as a tree, but its eXtreme start (the position of the
  leftmost word that it contains) is less than its start (the start of
  the island of words that have been built up around its head). If the
  xstart and xend are the same as the start and end, then there are no
  holes. It can be useful to know this.
  **/

compact(X) :-
    [start@X, end@X] -- [xstart@X,xend@X].

/**
  Now for some specific descriptions of various kind of words. We start
  by defining some very basic categories -- basically X-bar definitions
  of noun, verb, adjective, preposition
  **/

x(X) :-
    cat@X <> xbar.

n(X) :-
    cat@X -- C,
    +n:xbar@C,
    -v:xbar@C.

v(X) :-
    cat@X -- C,
    -n:xbar@C,
    +v:xbar@C.

a(X) :-
    cat@X -- C,
    +n:xbar@C,
    +v:xbar@C.

/**
  A sentence is nothing but a saturated verb
  **/

s(X) :-
    X <> [v, saturated].

%%%% NOUNS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
  You'd expect nouns to be simple, and they would be if I were just looking at English ones.
  I'll try to isolate the weird things that Arabic nouns do: the main complication that they offer
  is in what are called 'construct phrases', which are basically possessives.
  
  English: the handle of the door
  Arabic: handle Al-door[+gen] (handle is intrinsically -def but carries the definite form of the case marker if there is one, but distributionally +def)

  English: a door handle
  Arabic: handle door

  English: the door handle
  Arabic: Al-handle Al-door
  **/

baseNoun(X) :-
    X <> [n, saturated, third],
    tag@X -- noun.

/**
  Nouns can functions as modifiers: jam jar, strawberry jam, jan jar lid, ...

  In English only singular nouns can do this, so it's
  set by the empty (singular) affix.
  **/

nmod(X) :-
    language@X -- english,
    X <> [fulladjunct, strictpremod],
    target@X -- T,
    T <> [baseNoun],
    unspecified(T),
    xstart@T -- end@X,
    modified@result@X -- 1.5,
    trigger(index@T, theta(X, nmod)).

/**
  Arabic nouns can also function as possessive determiers
  **/

nmod(X) :-
    language@X -- arabic,
    X <> [+def, theta(poss), adjunct],
    target@X -- T,
    -def@T,
    result@X -- R,
    +def@R.

/**
  Some really complicated stuff for treating Arabic nouns
  as the subjects of verbless sentences. Ignore it
  **/
npred(P, X) :-
    P <> [v, -target],
    altview@P -- equation,
    args@P -- [PRED],
    PRED <> [x, saturated, -zero, +predicative, -def],
    dir@PRED <> after,
    -predicative@P,
    theta@PRED -- pred,
    -comp@P,
    moved@PRED -- MOVED,
    n:xbar@cat@PRED -- N,
    v:xbar@cat@PRED -- V,
    trigger((N, V), (baseNoun(PRED) -> notMoved(PRED); movedBefore(PRED, +))).
    
setnpred(X) :-
    npred(P, X),
    addExternalView(X, P).

arabicNoun(X) :-
    target@X -- T,
    T <> [n, saturated],
    result@X -- R,
    modified@R -- 1,
    modified@T -- MODT,
    X <> strictpostmod,
    trigger(index@T,
	    ((var(MODT) -> true; MODT =< 1),
	     nmod(X),
	     noun(R))).

/**
  English nouns are simpler!
  **/

noun(X) :-
    X <> [baseNoun, -pronominal],
    trigger(language@X,
	    (language@X == arabic ->
	     arabicNoun(X);
	     language@X == english ->
	     true)).

/**
  noun roots -- nouns that need a number/person marker
  **/

nroot(X, mass@X, args@X) :-
    X <> [n, third, standardcase],
    tag@X -- noun,
    language@X -- english,
    affixes@X -- [NUM],
    X\affix\affixes\dir\root -- NUM,
    NUM <> suffix(numPerson).

nroot(X, M) :-
    nroot(X, M, []).

nroot(X) :-
    nroot(X, -).

np(X, specified@X) :-
    X <> [n, saturated].

np(X) :-
    X <> [np(+)].

properName(X, U) :-
    X <> [n, fulladjunct, fixedpremod],
    trigger(tag@target@X, (tag@target@X = name -> true; incCost(X, 0.2))),
    target@X <> [n, saturated],
    tag@X -- name,
    root@X -- [U:(tag@X)],
    default(saturated(X)),
    default(setCost(X, 0)).

pronoun(P) :-
    P <> [np(+), +pronominal, standardcase],
    tag@P -- pronoun,
    trigger(used@P, (objcase(P) -> noRightShift(P); true)).

objpronoun(X) :-
    X <> [pronoun, objcase, +def, -target, noRightShift].

subjpronoun(X) :-
    X <> [pronoun, subjcase, +def, -target, -predicative],
    trigger(language@X, (language@X -- arabic -> setnpred(X); true)).

%% Arabic: ignore
setresumption(R) :-
    cat@X -- resumption,
    X <> [saturated, fulladjunct],
    target@X <> [s, +terminal],
    dir@target@X <> after,
    target@X <> notMoved,
    altview@X -- resumptive,
    theta@X -- resumption,
    -zero@subject@target@X,
    +pronominal@subject@target@X,
    addExternalView(R, X).

%%%% VERBS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
  Subjects can move around, but subject (no pun intended) to quite tight
  constraints. WH-marked subjects can move left, and ordinary ones can for
  non-finite verbs, in order to allow for auxiliaries (where I am treating
  auxiliaries as subcategorising for non-finite clauses. The structure of
  "he is sleeping" is that "he" is a daughter of "sleeping" and "sleeping"
  is a daughter of "is". But in that case "he" has been left-shifted.

  The constraints on subjects come in two parts. There are some things
  that we can just specify when we make the verb, which we specify in
  setSubjConstraints, but there are some fine-detail constraints that
  we can't check until we actually see the subject, done by
  checkSubjConstraints.
  **/

/**
  subjects of nonfinite verbs can be object case. But they can never
  be prepositionally marked
  **/

basicSubjConstraints(V, SUBJ) :-
    [position, head, zero, moved, language, dir, altview, wh] :: [SUBJ, subject@V],
    agree :: [SUBJ, V],
    SUBJ <> [standardcase].
    
setSubjConstraints(V, SUBJ) :-
    language@V -- L,
    /**
      The subject is one of the arguments. I want to have access to lots of
      information about it, but I don't want a complete copy of ALL the
      information about it, because that would be very costly to carry around.
      So there's a feature, subject, where I store the information that I
      actually care about.
      **/
    V <> [basicSubjConstraints(SUBJ)],
    trigger((specified@V, finite@V), (finite@V == tensed -> subjcase(SUBJ); objcase(SUBJ))),
    trigger(L, (L = arabic -> after(dir@SUBJ); before(dir@SUBJ))),
    trigger(set:position@moved@SUBJ, checkSubjConstraints(V, SUBJ)).

checkSubjConstraints(V, SUBJ) :-
    checkSubjConstraints(V, SUBJ, language@V).

checkSubjConstraints(V, SUBJ, english) :-
    (checkNoWH(SUBJ) -> (notMoved(SUBJ) -> true; trigger(finite@V, \+ finite@V = tensed)); true).

/**
  Constraints on objects: what I want to say about objects of Arabic
  and English verbs is sufficiently different that I actually have
  two versions of this, which get invoked once we know what language
  we are speaking.
  **/

setObjConstraints(V, OBJ) :-
    language@V -- L,
    trigger(L, setObjConstraints(V, OBJ, L)).

/**
  WH-marked objects *must* be left-shifted

  Otherwise, they can turn up in the right place, or
  left-shifted (but only if they've been shifted beyond
  the start of the verb) or right-shifted (but only if
  they're quite big: you can right shift large NPs, but
  not ones that are just made of one or two words like
  pronouns)
  **/

setObjConstraints(V, OBJ, english):-
    trigger((index@OBJ, set:position@moved@OBJ, xstart@OBJ, xend@OBJ),
	    ((-zero@OBJ, nonvar(wh@OBJ)) ->
	     movedBefore(OBJ);
	     (notMoved(OBJ);
	      (movedBefore(OBJ), !, xend@OBJ < start@V);
	      true))).

/**
  An English verbal root needs a tense-marking suffix, with
  which it shares nearly everything (inflectional affixes
  generally share nearly everything with their roots: that's
  what makes them inflectional)
  **/

vroot(X) :-
    X <> [v],
    language@X -- english,
    affixes@X -- [TNS],
    X\structure\affixes\affix-- TNS,
    TNS <> suffix(tns).

verb(X) :-
    X <> [v, -predicative].

/**
  The next two are Arabic: ignore them
  (I know you'd like to do some of this stuff for Arabic, but
  for now *ignore them*)
  **/

pretensemarker(X) :-
    cat@X -- tensemarker,
    X <> [fulladjunct, saturated, strictpremod],
    target@X <> [verb, word],
    theta@X -- tns.

posttensemarker(X) :-
    cat@X -- affix,
    X <> [fulladjunct, saturated, strictpostmod],
    target@X <> [verb],
    agree :: [X, target@X],
    args@target@X -- [ARG0 | _],
    subject@target@X -- SUBJ,
    trigger(index@target@X, SUBJ=ARG0),
    theta@X -- person.

/**

  SKIP THIS ON FIRST READING
  
  There's a horrible construction in English, where you can make a
  relative clause just by leaving out an NP. Instead of saying "I saw
  the man who you were talking to" you can just say "I saw the man you
  were talking to".  Horrible horrible horrible.

  How you can possibly spot that? Well it always occurs with the
  'reduced' relative clause adjacent to the noun that it's modifiying,
  so it always looks exactly like a clause with a left-shifted
  NP. "the pudding I thought was disgusting" could be a sentence with
  "the pudding" shifted to the front, but it could also be an NP with
  a reduced relative, e.g. "the pudding I thought was disgusting had
  been made three days before" = "the pudding which I thought was
  disgusting had been made three days before". So we will plant a
  trigger, waiting to see if our verb has a left shifted-argument, and
  if it does we will construct an alternate view of the resulting
  sentence as an NP with a reduced relative.

  | ?- parseAll('the pudding I thought was disgusting had been made three days before').

  (i163
  + [had,
     {(auxcomp,
        [(be > en),
         {(auxcomp,
            [made,
             {(dobj,
                reducedrel=[thought,
                            {(xcomp,
                               [was,
                                {(auxcomp,
                                   [(disgust > ing),
                                    {(subj,
                                       [the, {(headnoun , [pudding>])}])}])}])},
                            {(subj , [I])}])},
             {(ppmod,
                [before,
                 {(comp , [three,{headnoun,[day>s]}])}])}])}])}])
  **/

%%%% specific kinds of verbs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
  auxiliaries: this is one of those topics where different
  linguistic theories say different things.

  (i) An auxiliary is an unsaturated verb which
  needs a complete sentence with specific values for
  tense and aspect, e.g. that "is" requires a present
  participle S.

  That gives me trees like the one below, where "he" is
  the subject of "eating it" rather than of "is".

  | ?- parseAll('he is eating it').

  (i8
  + [is,
     {(auxcomp,
       [(eat > ing), {(dobj , [it])}, {(subject , [he])}])}])

  (ii) And auxiliary needs a VP and the subject of that VP.

  | ?- parseAll('he is eating it').

  (i11
  + [be,
     {(arg(auxcomp, A),
        [(eat>ing : verb), {(arg(dobj,+) , [it:pronoun])}])},
     {(arg(subject,+) , [he:pronoun])}])

  In many ways I prefer (i). I'm currently doing (ii), because I can't
  see any other way of doing elliptical examples like

  -- John loves Mary.
  -- does he?
  -- yes, he does.

  You could do "does he?" and "he does" by letting the VP "loves Mary"
  be elliptical. You'd have to do something to constrain the subject
  if the VP is elliptical, but at least you could do it. I can't see
  how to do these if we do (i).
  
  Whatever you think about that, it's clear that the auxiliary has to
  say something about its complement. "be" takes present participle
  complements, "have" takes past participle complements, ...
  **/

vp(X) :-
    X <> [verb],
    args@X -- [subject@X].

 
%% version (i)
aux(X, COMP) :-
    tag@X -- aux,
    %% currently using version (ii). Going back to this one could
    %% have knock-on effects, particularly with ellipsis
    fail, 
    %% It's useful to mark auxiliaries as being different from other verbs
    X <> [+aux, verb, -target],
    COMP <> [s, fixed, postarg, -zero, theta(auxcomp), noLeftShift],
    args@X -- [COMP],
    [active, subject\case] :: [X, COMP],
    %% plant the stuff we need for handling WH-items: see above
    trigger(language@X, setWHView(X)).

%% version (ii)
aux(X, COMP) :-
    tag@X -- aux,
    %% It's useful to mark auxiliaries as being different from other verbs
    X <> [+aux, verb, -target],
    COMP <> [vp, postarg, theta(auxcomp), noLeftShift],
    /**
    %% constraints on ellipsis to allow for "does he" and "he does".
    trigger(zero@COMP,
	    (+zero@COMP ->
	     (+terminal@X ->
	      true;
	      (+terminal@SUBJECT, np(SUBJECT)));
	     true)),
      **/
    -zero@COMP,
    subject@X -- SUBJECT,
    SUBJECT <> [prearg, standardcase],
    [syntax\case, start, theta] :: [SUBJECT, subject@COMP],
    args@X -- [COMP, SUBJECT],
    [agree] :: [SUBJECT, X],
    %% plant the stuff we need for handling WH-items: see above
    trigger(language@X, setWHView(X)).

aux(X) :-
    X <> aux(_).

/**
  Intransitive verbs: comparatively straightforward. Well, as straightforward as it's
  going to get! They have one argument, which is their subject. They're active, and
  they aren't auxiliaries.
  **/

iverb(X) :-
    X <> [verb, +active, -aux],
    tag@X -- verb,
    args@X -- [SUBJ],
    language :: [X, SUBJ],
    %% plant the stuff we need for handling WH-items: see above
    setWHView(X),
    SUBJ <> [np(_), specified, theta(subject)],
    setSubjConstraints(X, SUBJ).

/**
  Active English transitive verb. We assume that the subject is going to
  be an NP, but we might want to say specific things about the object, so
  that has to be supplied as A2.
  **/

tverb(X, A2) :-
    language@X -- english,
    X <> [verb, +active, basicSubjConstraints(A1)],
    trigger(zero@A2, (+zero@A2 -> zeroObj(X, A2); true)),
    tag@X -- verb,
    trigger(altview@subject@X, \+ altview@subject@X == gerund),
    %% plant the stuff we need for handling WH-items: see above
    setWHView(X),
    %% Two arguments: get the object first, then the subject
    args@X -- [A2, A1],
    language :: [X, A1, A2],
    %% A1 is the subject. Just the usual constraints.
    A1 <> [np(_), specified, theta(subject)],
    %% Say things about what the object is like and where it allowed to move to (see earlier)
    A2 <> [postarg],
    %% Plant machinery for spotting that we have a reduced relative
    %% trigger(complete@X, (\+ \+ tensedForm(X) -> trigger(shifted@X, plantReducedRelative(X)); true)),
    %% Some fiddly stuff to make sure that if the object is left shifted then
    %% it doesn't end up between the subject and the verb
    start@A1 -- STARTSUBJ,
    start@A2 -- STARTOBJ,
    trigger((STARTSUBJ, STARTOBJ, set:position@moved@A2), (movedBefore(A2) -> STARTOBJ < STARTSUBJ; true)).

/**
  Passive English transitive verb. A lot like an intransitive verb, except
  that it's marked as -active and it has to have the form of a past participle
  (this is slightly counter-intuitive, but right: things that look like
  active past participles can also be seen as passive present participle)
  **/

tverb(X, A2) :-
    language@X -- english,
    X <> [verb, -active, basicSubjConstraints(A2)],
    tag@X -- verb,
    setWHView(X),
    pastPartForm(X),
    language :: [X, A2],
    A2 <> [np(_), specified],
    args@X -- [A2],
    start@A2 -- STARTSUBJ,
    trigger((STARTSUBJ, STARTOBJ, MOBJ), (MOBJ = before -> STARTOBJ < STARTSUBJ; true)).

/**
  Most transitive verbs have NPs as their objects, so that's the default
  **/

zeroObj(X, OBJ) :-
    default(setCost(OBJ, 0)),
    incCost(OBJ, 3),
    subject@X <> [-zero, notMoved],
    trigger(wh@subject@X, fail),
    relpronoun(OBJ, 0).

checkObjCase(OBJ, X) :-
    trigger(used@OBJ, \+ \+ (objcase(OBJ); casemarked(OBJ, of))),
    trigger((used@OBJ, specified@X), (specified@X == + -> objcase(OBJ); casemarked(OBJ, of))).

tverb(X) :-
    OBJ <> [np(_), specified],
    theta@OBJ -- dobj,
    tverb(X, OBJ),
    trigger(active@X, (active@X = + -> checkObjCase(OBJ, X); true)),
    trigger(xstart@OBJ, setObjConstraints(X, OBJ)),
    setSubjConstraints(X, subject@X),
    movedAfter(subject@X, -).

/**
  ditransitive verbs. Er, no definition. Exercise for the reader!
  **/

tverb2(X, A2, A3) :-
    language@X -- english,
    X <> [verb, +active, basicSubjConstraints(A1)],
    tag@X -- verb,
    trigger(altview@subject@X, \+ altview@subject@X == gerund),
    %% plant the stuff we need for handling WH-items: see above
    setWHView(X),
    %% Two arguments: get the object first, then the subject
    args@X -- [A2, A3, A1],
    language :: [X, A1, A2, A3],
    %% A1 is the subject. Just the usual constraints.
    A1 <> [np, theta(subject)],
    %% Say things about what the object is like and where it allowed to move to (see earlier)
    A2 <> [postarg],
    A3 <> [postarg],
    %% Plant machinery for spotting that we have a reduced relative
    %% trigger(complete@X, (\+ \+ tensedForm(X) -> trigger(shifted@X, plantReducedRelative(X)); true)),
    %% Some fiddly stuff to make sure that if the object is left shifted then
    %% it doesn't end up between the subject and the verb
    start@A1 -- STARTSUBJ,
    start@A2 -- STARTOBJ,
    trigger((STARTSUBJ, STARTOBJ, set:position@moved@A2), (movedBefore(A2) -> STARTOBJ < STARTSUBJ; true)).
/**
  Verbs with sentential complements. In many ways they're quite like
  transitive verbs, save that their 'object' is a sentence. So we say
  a bit about the complement here, and a bit more in the lexical entry
  for each such verb, since they all have their own idiosyncracies.
  **/

tverb2(X) :-
    A2 <> [np, objcase, theta(iobj)],
    A3 <> [np, objcase, theta(obj)],
    tverb2(X, A2, A3).

sverb(X, COMP) :-
    language@X -- english,
    X <> [verb, +active],
    tag@X -- verb,
    tverb(X, COMP),
    subject@X -- SUBJ,
    trigger(end@SUBJ, \+ (end@SUBJ < start@X, movedBefore(subject@COMP, +))),
    COMP <> [s, specified, postarg, theta(xcomp)],
    trigger(zero@COMP, (-zero@COMP -> true; terminal@X = +)),
    comp@COMP -- *(COMPLEMENTISER),
    trigger(set:position@moved@COMP, (notMoved(COMP) -> true; (movedAfter(COMP, +), COMPLEMENTISER == that))),
    trigger(used@COMP, (compact(COMP) -> true; nonvar(wh@COMP))).

%% Arabic: ignore
sverb(X, COMP) :-
    language@X -- arabic,
    X <> [verb],
    args@X -- [SUBJ, COMP],
    language :: [X, SUBJ, COMP],
    setWHView(X),
    SUBJ <> [np, theta(subj)],
    trigger(end@SUBJ, \+ (end@SUBJ < start@X, movedBefore(subject@COMP, +))),
    agree :: [X, subject@X],
    setSubjConstraints(X, SUBJ),
    COMP <> [s, specified],
    dir@COMP <> after,
    comp@COMP -- *(COMPLEMENTISER),
    trigger(complete@COMP, (notMoved(COMP) -> true; (movedAfter(COMP, +), COMPLEMENTISER == that))),
    -zero@COMP,
    theta@COMP -- xcomp,
    trigger(xstart@COMP, setObjConstraints(X, COMP)).

/**
  definitions for when we don't know what sort of verb it is
  **/

itverb(X) :-
    iverb(X).
itverb(X) :-
    tverb(X).

uverb(X) :-
    itverb(X).
uverb(X) :-
    sverb(X, _COMP).

%%%% DETERMINERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
  Currently being treated as unsaturated NPs (see conversations
  earlier in the week)
  **/

det1(X, args@X) :-
    X <> [inflected, n, -target, standardcase],
    language@X -- language@T,
    agree :: [X, T].

det(X, ARGS) :-
    tag@X -- det,
    X <> [+specified, det1(ARGS)].

det1(X) :-
    det1(X, [NN]),
    [agree] :: [X, NN],
    NN <> [n, -specified, fixedpostarg, theta(headnoun), saturated].

det(X) :-
    det(X, [NN]),
    [agree] :: [X, NN],
    NN <> [n, -specified, fixedpostarg, theta(headnoun), saturated],
    externalviews :: [specifier@NN, X].

%%%% ADJECTIVES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
  Nothing very surprising here. Note that as with various other
  categories, we allow for cases where an adjective can have arguments,
  because some can, but the default is that they don't.
  **/

adj(X) :-
    %% +predicative because they can be the complement of "be"
    %% -- "he is happy"
    X <> [a, +predicative, fixedpremod],
    [cat, mod, args] :: [target@X, result@X],
    target@X <> [n, unspecified, saturated],
    modified@result@X -- 1.5,
    trigger(index@target@X, (theta@X = amod, trigger(theta@result@X, \+ theta@result@X = nmod))),
    tag@X --  adj.

aroot1(X, args@X) :-
    affixes@X -- [NUM],
    [cat] :: [target@X, result@X],
    X\affix\affixes\dir\root -- NUM,
    NUM <> suffix(adjsuffix).

aroot(X, ARGS) :-
    X <> [fulladjunct, aroot1(ARGS)],
    affixes@X -- [NUM],
    X\affix\affixes\dir\root -- NUM,
    NUM <> suffix(adjsuffix).

aroot(X) :-
    X <> [aroot([])].
    
adv1(X, T) :-
    X <> [a, fulladjunct, saturated],
    target@X -- T,
    trigger(cost@T,
	    (modified@result@X is 1+(start@T-start@X)/0.1,
	     theta@X = advmod,
	     (vp(T); (+n:xbar@cat@T, incCost(T, 3))))),
    +v:xbar@cat@T.

adv1(X) :-
    X <> [adv1(T), premod(T)].

adv(X) :-
    X <> [adv1, -predicative],
    tag@X -- adverb.

conj1(X):-
    start@X -- 0,
    X <> [strictpostarg(X2)],
    args@X -- [X2],
    theta@X2 -- conj0,
    -target@X,
    X2 <> [s].

shareCase(X, X1, X2) :-
    [case] :: [X, X1, X2].

checkConjCase(X, X1, X2) :-
    (case@X1 -- *_ -> shareCase(X, X1, X2); true).

conj(X, X1, X2):-
    args@X -- [X2, X1 | args@X2],
    X1 <> [-conjoined, compact, -altview, fixedprearg],
    X2 <> [compact, fixedpostarg],
    xstart@X2 -- end@X,
    xend@X1 -- start@X,
    trigger(complete@X, externalviews@X=externalviews@X1),
    [cat, vform\subject, spec, case, predicative] :: [X, X1, X2],
    [subject] :: [X, X1],
    trigger(used@X2,
	    (vp(X2) ->
	     syntax@subject@X1 = syntax@subject@X2;
	     true)),
    trigger(case@X1, checkConjCase(X, X1, X2)),
    X <> [-target],
    target@X1 -- TX1,
    (target@M)\index -- TM,
    [result] :: [X1, M],
    cat@M -- mod,
    M <> [saturated],
    theta@X1 -- conj1,
    theta@X2 -- conj2,
    trigger(args@X2, conjArgs(args@X2, args@X1)).

conjArgs([], []) :-
    !.
conjArgs([A2 | T2], [H1 | T1]) :-
    [cat, spec] :: [A2, A1],
    conjArgs(T2, T1).

conj(X) :-
    conj(X, _, _).
conj(X) :-
    conj1(X).

comma(X) :-
    commaAsConj(X).
comma(X) :-
    commaAsSep(X).

commaAsConj(X) :-
    conj(X, _, X2),
    [conjoined] :: [X, X2],
    X <> [-target, theta(conj1)],
    trigger(width@X2, nonvar(conjoined@X2)).

commaAsSep(X) :-
    cat@X -- comma,
    X <> [saturated, fulladjunct, strictpostmod, -zero],
    target@X <> [word].

%%%% PREPOSITIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
  XBAR category. I'm following fairly standard practice in treating
  PPs as case-marked NPs, though I'm still taking the prep to be the
  head, as opposed to the UDT decision to treat it as essentially
  a case-marker
  **/

p(X) :-
    X <> [n, +specified, -modifiable],
    [case@X] -- root@hd@X.

/**
  In general, PPs can modify things that are nounlike and things that
  are verblike.  Different people have different views on what kinds
  of nounlike and verblike things they can modify. I very strongly
  believe that they modify -specified nounlike things (i.e.  nouns
  rather than NPs). I ought, therefore, to believe that they modify
  verbs rather than sentences, but actually I'm going to specify below
  that they modify Ss.
  **/

/**
  A PP that is going to modify an N has to have its complement in the
  canonical position (i.e. you can't have things like "What did the
  man with see it?", where "with what" is supposed to modify "man"),
  and it also can't be detached from its target (so you can't say
  "With a big nose the man loves her" as a variation on "The man with
  a big nose loves her").
  **/

prepmodN(X, T, COMP) :-
    COMP <> [notMoved],
    T <> [baseNoun, unspecified, notMoved],
    var(wh@COMP).

/**
  There are fewer constraints on PPs when they are modifying Ss.

  You can say "What did you leave it in", where "in what" is a modifier
  on "you leave it", and you can say "In the park I saw an old man" as
  a variation on "I saw an old man in the park" (note that the first of
  these does *not* involve an attachment ambiguity of the kind that you
  get with the standard order, so it may be that shifting the PP to the
  front is done to reduce ambiguity rather than for emphasis) and even
  "I believe with all my heart that she loves me" where the canonical
  order is "I believe with all my heart that she loves me"
  **/

prepmodS(X, T, _COMP) :-
    T <> [vp, -aux].

/**
  Called once we've decided that the PP is being used as a modifier to
  make sure that the conditions for modifying whatever the target is
  are satisfied
  **/

prepmod(X, T, COMP) :-
    %% Apply a small penalty if the target is in the wrong place
    trigger(set:position@moved@X, (notMoved(X) -> true; movedBefore(T) -> incCost(T, 1))),
    %% trigger(set:position@moved@X, (movedBefore(X) -> true; notMoved(X))),
    theta@X -- ppmod,
    (prepmodN(X, T, COMP); prepmodS(X, T, COMP)).

/**
  PPs are predicative (so you can say "It is on the table")

  Most of prepositions take an argument (usually the argument
  follows the prep, as in "in the park", but in a few cases
  it precedes it -- "a long time ago", "a long way away"). Some
  don't -- in "I fell down the stairs", "down" has "the stairs"
  as an argument, in "I fell down" it has no argument.
  **/

zeroPPCOMP(T, COMP) :-
    T <> [vp],
    incCost(COMP, 1),
    relpronoun(COMP, 0),
    +zero@COMP.

shiftedPPCOMP(X, COMP, T) :-
    ((np(COMP, _), var(wh@COMP)) -> notMoved(COMP); true),
    (start@COMP < start@X ->
     (vp(T), trigger(start@subject@T, start@COMP < start@subject@T));
     true).

prep(X, ARGS) :-
    X <> [p, fulladjunct, postmod(T)],
    root@X -- [case@X],
    tag@X -- prep,
    +predicative@X,
    modified@result@X -- 2,
    target@X -- T,
    T <> [x],
    args@X -- ARGS,
    (ARGS = [COMP] ->
     (COMP <> [noRightShift, compact, objcase],
      [def, agree] :: [X, COMP],
      theta@COMP -- comp,
      trigger((start@T, end@T), nonvar(index@COMP)),
      trigger((end@COMP, set:position@moved@COMP), (notMoved(COMP) -> true; (end@COMP < start@X))));
     true),
  trigger((start@T, end@T), prepmod(X, T, COMP)),
  trigger(zero@COMP, (-zero@COMP -> true; zeroPPCOMP(T, COMP))),
  trigger(used@COMP, shiftedPPCOMP(X, COMP, T)).

/**
  Normal ones, with one following argument
  **/
prep(X) :-
    COMP <> [n, postarg, saturated],
    trigger(specified@COMP, (specified(COMP, -) -> (word(COMP), notMoved(COMP)); true)),
    prep(X, [COMP]).

/**
  ago, away. Don't offhand know of any others
  **/
postp(X) :-
    COMP <> [np, prearg],
    prep(X, [COMP]).

pp(X) :-
    X <> [p, saturated].

tempConj(X) :-
    cat@X -- tempConj,
    X <> [postmod(T), fulladjunct],
    args@X -- [COMP],
    T <> [s, -zero],
    COMP <> [s, fixedpostarg, -zero],
    trigger(index@T, nonvar(index@COMP)).

/**
  WH-marking is a fairly complex phenomenon. The essence is that there
  are a number of words which mark the entire clause that contains them
  as being either a relative clause or a question: "Who do you love?",
  "The man who she loves is an idiot", "Where did you find it?", "I grew
  up in the house where I was born", "Which pocket did you leave it in?",
  ... Somehow you have to propagate the WH-ness of a word (including whether
  marks relative clauses or questions or both) up to the whole of the
  clause that contains it. 

  There are a number of ways of dealing with this. I am doing it by
  letting the feature wh be an open list, onto which we add items as
  we find WH-marked words. That makes maintaining it easy, but it does
  mean that if you want to see whether something is WH-marked or not
  then you have to see whether it's a variable or not, rather than
  just unifying it with [].

  This is confusing stuff. Too difficult to just write it down -- I'll
  try to explain it at our next meeting! Skip to the section on verbs.
  **/

/**
  checkNoWH: can't do this safely until we know what X is. Can't just call it,
  because at the time when you'd want to do that it's unknown, so is bound
  to be a variable.
  **/

checkNoWH(X) :-
    trigger(index@X, var(wh@X)).

setWHMarked(X, WH) :-
    wh@X -- [WH | _].

checkWHMarked(X, WH) :-
    nonvar(wh@X),
    wh@X = [WH | _].

whpron(X, WH) :-
    X <> [pronoun, saturated, setWHMarked(WH), movedBefore(+)],
    -target@X,
    trigger(language@X, (language@X = arabic -> setnpred(X); true)).

whTarget(T) :-
    T <> [baseNoun, -pronominal, saturated, unspecified].
whTarget(T) :-
    T <> [s].
    
setWHItem(X, WH) :-
    [start, end] :: [X, WH],
    wh@X -- [WH | _],
    WH <> [np, adjunct, -modifiable, compact],
    dir@target@WH <> before,
    T -- target@WH,
    T <> [x, saturated, notMoved],
    end@T -- start@X,
    modified@result@WH -- 6,
    spec :: [T, result@WH],
    trigger(index@T,
	    ((tensed(X) -> theta@WH=rcmod; true),
	     whTarget(T))).

whmod(X, WH) :-
    X <> [fulladjunct, saturated, inflected, premod(T)],
    T <> [s],
    trigger(xstart@T, (start@X < xstart@T, theta@X = whmod)),
    setWHItem(X, WH).

whmod(X) :-
    cat@X -- adv,
    whmod(X, _WH).


/**
  The predicates above are for managing WH-markers. But there would be
  no point in doing that if we didn't do anything with them.

  We use two tricks for this:

  (i) we set a trigger to react if the WH-mark on a verb ever becomes
  bound. Remember that we initialise it to an open list, i.e. a variable.
  So we can put a trigger on this variable, and then as soon as something
  is added to it we can respond.

  (ii) So how do we respond? By adding something to the
  "externalviews" of the verb. Remember that the external views are
  descriptions of ways that the entity we are looking at can be used
  that don't match its intrinsic syntactic properties -- we use them,
  for example, for gerunds, where something that looks like a VP can
  be used as an NP or an adjective. Here, we let the WH marker itself
  *be* the external view. So the WH marker on "who" says that it's
  something which can be used as either a question or a relative
  clause, whereas clause where the WH marker comes from "that" (I know
  that the man that you saw is an idiot) can only be used as
  relatives.

  Note that the trigger will only do something if the clause is tensed.
  "the man who is eating it" is OK, "the man who eating it" is not.

  ("I saw the man eating it" is OK, with one reading where "eating it" is
  a modifier on "man", but that comes from somewhere else).
  **/

setWHView(V) :-
    altview@EXTVIEW1 -- whclause,
    last(args@V, L),
    EXTVIEW0\position -- EXTVIEW1,
    EXTVIEW1 <> [compact, notMoved, -modifiable],
    trigger(wh@V,
	    ((wh@V = [EXTVIEW0 | _], tensedForm(V)) ->
	     trigger(index@L, addExternalView(V, EXTVIEW1));
	     true)).

shiftWHOnly(X) :-
    trigger(set:position@moved@X, (checkNoWH(X) -> notMoved(X); true)).

%%%% Weird things in Arabic tweets: ignore %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vocative(X) :-
    cat@X -- vocative,
    altview@X -- vocative,
    X <> [saturated, adjunct],
    theta@X -- addressee,
    target@X <> [s, notMoved],
    dir@target@X <> after.

plantVocative(X) :-
    trigger(start@X,
	    (start@X=0 ->
	     (vocative(V), addExternalView(X, V));
	     true)).

reply(X) :-
    tag@X -- 'REPLY',
    /**
      tense and number can't be set yet because they're not defined yet!
      **/
    trigger(start@X, (start@X = 0, presTense(X), thirdSing(X))),
    cat@X -- tweet,
    args@X -- [USERNAME, S],
    USERNAME <> n,
    strictpostarg(X, USERNAME),
    theta@USERNAME -- user,
    S <> [x, saturated, notMoved, -zero],
    theta@S -- topic,
    dir@S <> after.

reply(X) :-
    trigger(start@X, start@X > 0),
    mention(X).

retweet(X):-
    tag@X -- 'RETWEET',
    start@X -- 0,
    X <> [v],
    args@X -- [S],
    S <> [x, notMoved, -zero],
    theta@S -- rtopic,
    dir@S <> after.

mention(X) :-
    tag@X -- 'MENTION',
    cat@X -- mention,
    -predicative@X,
    args@X -- [NAME],
    NAME <> np,
    X <> [strictpostarg(NAME), fulladjunct],
    theta@NAME -- mentioned,
    target@X -- COMP,
    dir@target@X <> after,
    target@X <> [notMoved, -zero],
    COMP <> [s, saturated, compact],
    theta@X -- mention,
    trigger(index@COMP, nonvar(index@NAME)).

hashtag(X) :-
    tag@X -- 'HASH',
    trigger(start@X, start@X > 0),
    cat@X -- hash,
    X <> [saturated, fulladjunct, notMoved],
    target@X <> x,
    dir@X <> before,
    modified@result@X -- 0,
    theta@X -- hash.    

emoticon(X) :-
    cat@X -- emoj,
    X <> [saturated, fulladjunct],
    xstart@T -- XST,
    target@X -- T,
    result@X -- R,
    [cat, args] :: [T, R],
    T <> [saturated, compact],
    -target@R,
    theta@X -- emoticon,
    dir@T <> before,
    trigger(XST, (XST = 0 -> true; incCost(X, 1))).

setNumber(N0, NP) :-
    catch((atom_chars(N0, NCHARS),
	   number_chars(N1, NCHARS),
	   (N1 == 1 ->
	    sing(NP);
	    N1 > 1 ->
	    plural(NP);
	    true)),
	  _,
	  true).

month(X) :-
    language@X -- english,
    X <> [n, saturated, -target, inflected].
month(X) :-
    language@X -- english,
    X <> [n, -target, inflected],
    args@X -- [Y],
    Y <> [fixedpostarg, number(_)].