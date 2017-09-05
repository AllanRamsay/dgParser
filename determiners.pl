/**

  There are phrases headed by Ns which can be used as arguments to
  verbs and prepositions. Call these "external NPs". Something is an
  external NP if it has instructions about what to do with the
  description that it contains. Simple examples include "a man", "the
  man", "every man", "men".

  You can add certain kinds of instructions to certain kinds of
  N. These include bare Ns (which can have just about any kind of
  instruction added), counted Ns, sometimes definite NPs.

  So what we want is for a determiner to be something that looks at an
  N and does two things: it adds an instruction, and it leaves a trace
  of itself. It would be nice if the instruction *was* the trace. You
  could do that by writing horrible sets of special cases. The key is
  to do better than that.

  a man, the man, every man, all men: simple external NPs

  A fair number can take "of NP(+def)": "some of the men", "all of the
  men", "each of these people", "six of my friends". "all" doesn't need the
  "of", but then "all" is pretty weird.

  six men, many men, most men, few men: these can be used as external
  NPs, but they can also be the descriptor for "the" and for personal
  pronouns. "six men" can also be the descriptor for "some", "every",
  "all". I think that "every six men" and "any six men" may do
  different things with "six". But then I am pretty confused about
  what "any" means.

  "six", "many", "few" all say something about the size of the
  set. So you can refer to the members of a set of that size, though
  with the ones that are quantifiers you would normally require the
  description to contain more than just a noun -- "the many men who
  rushed to aid the king", but less obviously "the many men". But that
  might just be because "many men" won't normally be a unique
  description.

  "six men" can have a wider variety of other dets added to it than
  "many", "few" and "most". It's not just an adj, because if there is
  no other det then it's existential, but it's not much more than an
  adj. "every six men", "the six men", "all six men", "some six men",
  "each six men", "any six men", "at the most/least six men", "at
  most/least six men", "his three books", *"many six men", *"few six
  men", ?"most six men". Worth noting that "at most/least N Xs"
  is *extremely* rare in the BNC: just one occurrence of "at least
  one". 

     - add a specifier
     - mark it as counted
  
all: simple (not common, often inside a PP)
  per ( not all employers offer their
  in 250 of all adults worldwide .
  one third of all adults in towns
  with responsibility for all ACET operations .

  DET+NP(+def)
  This can make all the difference to
  , and releases all these viruses into
  You could covenant all your taxable income
  that he satisfies all the conditions relating
  gross amount of all these payment ,
  unconditional care of all those who are
  does not cover all our costs and
  that people get all the care they

  DET+NP(+def), but the DET has shifted somewhere (not necessarily on
  subject). I seem to have a constraint somewhere else that means if
  "all" is before the main verb then it attaches to the subject and if it
  follows it then it attaches to the object. Don't know where that
  comes from!
  
  , it is all very much needed
  and made us all realise just how
  time they will all be ill .
  
| ?- parseAll('they eat them all').

(i11
  + [(eat > ),
     {(dobj , spec([all],[them,{modifier(A,10),[all]}]))},
     {(subject , spec([proRef],[they]))}])
no
| ?- parseAll('they are all eating them').

(i7
  + [(eat > ),
     {(dobj , spec([proRef],[them]))},
     {(subject , spec([all],[they,{modifier(A,10),[all]}]))}])
no
| ?- parseAll('they eat all them').

(i7
  + [(eat > ),
     {(dobj , spec([all],[them,{modifier(A,10),[all]}]))},
     {(subject , spec([proRef],[they]))}])
no
| ?- parseAll('they are all eating them').

(i17
  + [be,
     {(auxcomp,
        spec(-, [(eat > ing), {(dobj , spec([proRef],[them]))}]))},
     {(subject , spec([all],[they,{modifier(A,10),[all]}]))}])
no
| ?- parseAll('they are eating them all').

(i20
  + [be,
     {(auxcomp,
        spec(-,
             [(eat > ing),
              {(dobj,
                 spec([all], [them, {(modifier(A,10) , [all])}]))}]))},
     {(subject , spec([proRef],[they]))}])

  
  DET+NP(of,+def)
  was expressed in all of the organisational
  can not give all of the support
  this year &mdash all of them long-term
  not to be all of an equally ***
  sculpture have problems all of their own
  print , to all of the participants
  that constitutes almost all of the book
  
any: simple or DET+NP(of,+def)
  weight loss or any combination of these
  clients covered at any one time by
  transmitted , in any form or by
  loss , or any combination of these
  , sexuality or any other factor .
  
  by a critic in any of these cases to describe works as
  with it , choose any of the four points of the compass
  withers will never win any of the races Ronnie had been telling
  I have not included any of the well known speeches from such
  choose a piece from any of those just mentioned is thoroughly viable
  
every: just simple
  now take place every September and February
  difficulties is that every person 's situation
  gift to ACET every time the amount
  be saved for every &pound;1,000 that you
  ever clear that every section of society
  
his: just simple
  Tony Chapman at his home , together
  June , in his appearance on BBC
  with Patrick giving his assessment of the
  Department , on his new appointment as
  , has given his backing to ACET
  
most: simple, DET+NP(of, +def) and "at most"/"at the most"/"at the very most"

| ?- parseAll('most NNs VV').

(i8
  + [(VV > ),
     {(subject,
        spec([most], [(NN > s), {(modifier(A,0) , [most])}]))}])
no
| ?- parseAll('most of the NNs VV').

(i17
  + [(VV > ),
     {(subject,
        spec([most],
             [of,
              {(comp,
                 spec([the], [(NN > s), {(modifier(A,0) , [the])}]))},
              {(modifier(B,C) , [most])}]))}])
no
  
These are ALL the occurrences of this pattern in the BNC:
  
  every Parishioner shall communicate at the least three times in the year ,
  They were thirteen or at the most fourteen years old , but to
  perhaps two , or at the most three , separate occasions simply for
  fact that they are at the most 6 in ( 15 cm )
  presented on one or at the most two dials in his office which
  the RHA to axe at the very least one-third of this provision , even
  in a week , at the most three week 's , but you
  a backroad and sees at the most two or three cars a day
  but that was only at the most twenty yards from the house .
  received only one or at the most two services , and then only
  round every three or at the most four years , and er we
  was you 'd pay at the most ten shillings down about two and
  were only been about at the most ten who were suffering from burns
  divergent spellings suggest that at the very least three written English versions
  or four , or at the very most five , of these categories were
  of been about , at the most eighteen I think , messing about
  
So it's not common, and ones with "the" are much commoner than ones without

It does also occur without a target, but these can very easily be
confused with cases where it's an adverb (either as an intensifier on
an adjective or (worse) a participle masquerading as an adjective or
just as an ordinary adverb):

| ?- parseAll('most VV'). %% zero target

(i4
  + [(VV > ),
     {(subject,
        spec([most], [(zero , 1), {(modifier(A,10) , [most])}]))}])
no
  
| ?- parseAll('she owns the thing which he most wants'). %% simple adverb

(i33
  + [(own > s),
     {(object,
        spec([the],
             [(thing > ),
              {(modifier(rcmod, 0),
                 whclause=[(want > s),
                           {(dobj , spec([whSpec],[which]))},
                           {(modifier(advmod,A) , [most])},
                           {(subject , spec([proRef],[he]))}])},
              {(modifier(B,0) , [the])}]))},
     {(subject , spec([proRef],[she]))}])
     
  people say that sex is most fulfilling when it expresses the commitment
  this is the novel which most resembles Guerrillas</hi> , and it undoubtedly
  In fact , those who most seem to be themselves appear to
  the persons who helped me most were the professional actors who were
  then I lose what I most want from it , that it
  is this alarming development which most concerns the National Amenity Societies
  The thing that I found most striking about Harwich was that there
  what I 'd really like most is my independence back . &equo **********************
  the side of the garden most exposed to prevailing winds , with
  very easy to fly but most are lighter on the controls . *************************
  &bquo thick description &equo which most alarmed them ; for as almost
  be 5&ft 10&ins at and most were 6&ft 0&ins or over . ****************************
  knotted at the back , most were bearded : the uplanders had *********************
  west and east , but most hung on with a sense that ******************************
  was the driest coldest and most shrivelled of cunts , if indeed
  favourite as the one they most want to win ) are due
  the anterior deltoid is the most developed and the posterior the least
  to those steps which they most enjoyed and thus performed best ,
  that this experience &bquo was most agonising in that it was a
  existence , more important to most is the question of security , ****************
  not say the things he most wanted to say but who ,
  is the amateur who is most admired ; and Auden 's charming
  that even by those readers most alert to and informed about Eliot
  poem of his that he most needed reassurance about was Homage to
  the 50 Europeans who have most influenced the consciousness of Europe in
  the one which Conservatives would most like to abolish : the Department
  powerful lawyer born into the most distinguished of the half-dozen Hong Kong
  Reuter ) &mdash Austria 's most wanted man , Udo Proksch ,
  This is the latest and most daring in a sequence of dramatic

my
  one:CRD of:PRF                 my:DPS three:CRD violins:NN2 ':POS ):PUR is:VBZ
  I:PNP place:VVB                my:DPS three:CRD long-stemmed:AJ0 ,:PUN red:AJ0 roses:NN2
  discovered:VVD that:CJT        my:DPS three:CRD days:NN2 ':POS neglect:NN1 of:PRF
  
some
  was:VBD only:AV0               some:DT0 three:CRD miles:NN2 north:NN1 of:PRF our:DPS
  it:PNP supports:VVZ            some:DT0 three:CRD hundred:CRD brand:AJ0 or:CJC very:AV0
  point:NN1 is:VBZ               some:DT0 three:CRD feet:NN2 shallower:AJC than:CJS when:AVQ
the
  more:DT0 of:PRF                the:AT0 three:CRD helpful:AJ0 elements:NN2 ,:PUN perhaps:AV0
  wide-ranging:AJ0 of:PRF        the:AT0 three:CRD elements:NN2 ,:PUN including:PRP questions:NN2
  contrasts:NN2 with:PRP         the:AT0 three:CRD later:AJC busts:NN2 on:PRP a:AT0

  "many" can occur inside "the". From the BNC, "few" can occur inside "a", "some",
  "every" (usually with a time), "the" and possessives (see
  below). Allow things to constrain their specifiers?
  
a
  where:AVQ only:AV0             a:AT0 few:DT0 items:NN2 or:CJC rooms:NN2 will:VM0
  are:VBB only:AV0               a:AT0 few:DT0 of:PRF the:AT0 varied:AJ0 topics:NN2
  give:VVI only:AV0              a:AT0 few:DT0 useful:AJ0 results:NN2 ,:PUN for:AV0
his
  ***************:*************** With:PRP his:DPS few:DT0 belongings:NN2 it:PNP was:VBD home:AV0
  use:NN1 of:PRF                 his:DPS few:DT0 square:AJ0 feet:NN2 of:PRF soil:NN1
  Noriega:NP0 and:CJC            his:DPS few:DT0 remaining:AJ0 allies:NN2 would:VM0 be:VBI
some
  ,:PUN in:PRP                   some:DT0 few:DT0 cases:NN2 ,:PUN made:VVD you:PNP
  ,:PUN with:PRP                 some:DT0 few:DT0 exceptions:NN2 ,:PUN the:AT0 main:AJ0
  ,:PUN and:CJC                  some:DT0 few:DT0 others:NN2 &equo:PUQ .:PUN ***************:
every
  it:PNP regularly:AV0           every:AT0 few:DT0 circles:NN2 .:PUN ***************:***
  the:AT0 airspeed:NN1           every:AT0 few:DT0 seconds:NN2 .:PUN ***************:***
  the:AT0 speed:NN1              every:AT0 few:DT0 seconds:NN2 .:PUN ***************:***
each
  coin:NN1 after:CJS             each:DT0 few:DT0 rubs:NN2 on:PRP the:AT0 elbow:NN1
the
  one:CRD of:PRF                 the:AT0 few:DT0 in:PRP which:DTQ a:AT0 generous:AJ0
  to:TO0 climb:VVI               the:AT0 few:DT0 steps:NN2 to:PRP the:AT0 communal:AJ0
  Representatives:NN2 of:PRF     the:AT0 few:DT0 people:NN0 they:PNP had:VHD come:VVN

  Some of them don't need a noun: "many are called but few are
  chosen", "I bought two peaches and Mary bought three". But not
  "his": it does appear in contexts where it seems to have no noun,
  but it's actually a pronoun (like "hers" or "mine", rather than
  "her" or "my") there -- "I sold my children, but Dave looked after
  his".

  "many" and "most" occur with "how" and "so" and "as". I don't think
  any others do.
  
  "all" is pretty weird: it does take part in "all of my
  cats", but it also does things like "they all had a good
  time" and "my friends all drive Porsches". Do "my friends all
  drive Porsches" and "all my friends drive Porsches" mean
  the same?

  "all my friends drive Porsches": I have a set of friends. Everything
  in that set drives a Porsche.

  "my friends all drive Porsches": I have a set of friends. "my
  friends all drive Porsches" would be false if one of them didn't
  drive a Porsche. I can't actually see any difference.

  **/

simpleDet1(X, N) :-
    start@target@X -- end@X,
    X <> [det(N)],
    target@X <> [standardcase].

simpleDet(X, N) :-
    X <> [simpleDet1(N), -modifiable],
    [agree] :: [X, target@X, result@X].

ofDet1(X, N) :-
    target@X <> [+def, casemarked([of]), specifier([_])],
    result@X <> [standardcase],
    X <> [det1(N)].

ofDet(X, N) :-
    X <> [ofDet1(N), -modifiable],
    [agree] :: [X, target@X, result@X].

number(X, I) :-
    X <> [simpleDet(5)].
number(X, I) :-
    X <> [ofDet(5)].

all(X) :-
    X <> [saturated, det4(11), movedBefore(-), movedAfter(M)],
    target@X <> [-zero, +def, standardcase].
all(X) :-
    ofDet(X, 10).

any(X) :-
    X <> [simpleDet(10)].
any(X) :-
    X <> [ofDet(10)].

few(X) :-
    start@target@X -- end@X,
    X <> [det2(5)],
    target@X <> [standardcase].
few(X) :-
    X <> [ofDet1(5)].

many(X) :-
    start@target@X -- end@X,
    X <> [det2(5)],
    target@X <> [standardcase],
    result@X <> [+def].
many(X) :-
    X <> [ofDet1(5)],
    result@X <> [-modifiable].

most(X) :-
    start@target@X -- end@X,
    X <> [det2(5)],
    target@X <> [standardcase],
    result@X <> [+def, notMoved].
most(X) :-
    X <> [ofDet1(5)],
    result@X <> [-modifiable].
most(X) :-
    cat@X -- most,
    X <> [adv2, saturated, inflected, notMoved, -modifiable].