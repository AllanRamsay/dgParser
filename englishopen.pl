
word('European', X) :-
    language@X -- english,
    X <> [nroot].

word('Irishman', X) :-
    language@X -- english,
    X <> [nroot].

word('Italian', X) :- 
    language@X -- english,
    definition@X -- 'a native or inhabitant of Italy',
    X <> [aroot].

word('Italian', X) :- 
    language@X -- english,
    definition@X -- 'a native or inhabitant of Italy',
    X <> [nroot, -target].

word('Nobel', X) :- 
    language@X -- english,
    definition@X -- 'Swedish chemist remembered for his invention of dynamite and for the bequest that created the Nobel prizes',
    X <> [properName('Nobel')].

word('Ancient', X) :-
    language@X -- english,
    definition@X -- 'belonging to times long past especially of the historical period before the fall of the Western Roman Empire',
    X <> [aroot].

word('accountant', X) :- 
    language@X -- english,
    X <> [nroot].
                   
word('animal', X) :- 
    language@X -- english,
    definition@X -- 'a living organism characterized by voluntary movement',
    X <> [nroot].

word('architect', X) :- 
    language@X -- english,
    X <> [nroot].

word('ate', X) :-
    language@X -- english,
    X <> [pastTense, inflected],
    root@X -- [eat],
    tverb(X).
      
word('award', X) :- 
    language@X -- english,
    definition@X -- 'a grant made by a law court',
    X <> [nroot].

word('award', X) :-
    language@X -- english,
    definition@X -- 'give , especially as an honor or reward',
    X <> [vroot, regularPast],
    tverb2(X).

word('bear', X) :-
    language@X -- english,
    X <> [nroot].

word('bear', X) :-
    language@X -- english,
    X <> [vroot, pastForms(-, -)],
    tverb(X).

word('become', X) :-
    language@X -- english,
    definition@X -- 'enter or assume a certain state or condition',
    X <> [vroot, regularPast],
    tverb(X).

word('beer', X) :-
    language@X -- english,
    X <> [nroot].

word('began', X) :-
    language@X -- english,
    X <> [pastTense, inflected],
    verb(X, begin).

word('begin', X) :-
    language@X -- english,
    X <> [vroot, pastForms(-, -)],
    verb(X, begin).

word('begun', X) :-
    language@X -- english,
    X <> [pastPart, inflected],
    verb(X, begin).

word('belief', X) :- 
    language@X -- english,
    definition@X -- 'any cognitive content held as true',
    X <> [nroot, sing].

word('believe', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    S <> [tensedForm],
    sverb(X, S).

word('believe', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    tverb(X).
          
word('big', X) :-
    language@X -- english,
    definition@X -- 'fully developed',
    X <> [aroot].

/**
word('big', X) :-
    language@X -- english,
    definition@X -- 'extremely well',
    X <> [adv, inflected].
**/

word('blame', X) :- 
    language@X -- english,
    definition@X -- 'a reproach for some lapse or misdeed',
    X <> [nroot].

word('blame', X) :-
    language@X -- english,
    definition@X -- 'put or pin the blame on',
    X <> [vroot, regularPast],
    tverb(X).
               
word('board', X) :- 
    language@X -- english,
    definition@X -- 'a committee having supervisory powers',
    X <> [nroot].

word('board', X) :-
    language@X -- english,
    definition@X -- 'get on board of',
    X <> [vroot, regularPast],
    tverb(X).

word('bookkeeper', X) :- 
    language@X -- english,
    X <> [nroot].

word('bore', X) :-
    language@X -- english,
    X <> [nroot].

word('bore', X) :-
    language@X -- english,
    X <> [pastTense, inflected],
    tverb(X).

word('bore', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    tverb(X).

word('borne', X) :-
    language@X -- english,
    X <> [pastPart, inflected],
    tverb(X).

word('bought', X) :-
    language@X -- english,
    X <> [inflected],
    verb(X, buy),
    (pastTense(X); pastPart(X)).

word('bred', X) :-
    language@X -- english,
    tverb(X),
    X <> [past, inflected].

word('breed', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, pastForms(-, -)].

word('breed', X) :- 
    language@X -- english,
    definition@X -- 'a special variety of domesticated animals within a species',
    X <> [nroot].

word('bring', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, pastForms(-, -)].

word('brought', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastTense, inflected].

word('brought', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastPart, inflected].

word('business', X) :- 
    language@X -- english,
    definition@X -- 'a commercial or industrial enterprise and the people who constitute it',
    X <> [nroot(_)].
                    
word('bunch', X) :- 
    language@X -- english,
    definition@X -- 'a grouping of a number of similar things',
    X <> [nroot].

word('bunch', X) :-
    language@X -- english,
    definition@X -- 'gather or cause to gather into a cluster',
    X <> [vroot, regularPast],
    uverb(X).

word('buy', X) :-
    language@X -- english,
    X <> [vroot, pastForms(-, -)],
    verb(X, buy).
       
word('Canadian', X) :- 
    language@X -- english,
    definition@X -- 'an inhabitant of Canada',
    X <> [nroot(_)].
                  
word('carry', X) :-
    language@X -- english,
    definition@X -- 'behave in a certain manner',
    X <> [vroot, regularPast],
    tverb(X).
                    
word('carry', X) :- 
    language@X -- english,
    definition@X -- 'the act of carrying something',
    X <> [nroot].

word('cat', X) :- 
    language@X -- english,
    definition@X -- 'any of several large cats typically able to roar and living in the wild',
    X <> [nroot].

word('cat', X) :-
    language@X -- english,
    definition@X -- 'beat with a cat - o SQ - nine - tails',
    X <> [vroot, regularPast],
    itverb(X).

word('catalogue', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, regularPast].

word('catalogue', X) :- 
    language@X -- english,
    definition@X -- 'a book or pamphlet containing an enumeration of things',
    X <> [nroot].

word('catch', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, pastForms(-, -)].

word('catch', X) :- 
    language@X -- english,
    definition@X -- 'the act of apprehending',
    X <> [nroot].

word('caught', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastTense, inflected].

word('caught', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastPart, inflected].

word('charity', X) :-
    language@X -- english,
    X <> [nroot(_)].

word('chest', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, regularPast].

word('chest', X) :-
    language@X -- english,
    X <> [nroot(_)].

word('child', X) :-
    language@X -- english,
    X <> [noun, thirdSing, unspecified, inflected].

word('children', X) :-
    language@X -- english,
    X <> [noun, third, plural, inflected].

word('choose', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, pastForms(-, -)].

word('chose', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastTense, inflected].

word('come', X) :-
    language@X -- english,
    X <> [pastPart, inflected],
    verb(X, come).

word('come', X) :-
    language@X -- english,
    X <> [vroot],
    verb(X, come).

word('course', X) :- 
    language@X -- english,
    definition@X -- 'a body of students who are taught together',
    X <> [nroot].
      
word('crook', X) :- 
    language@X -- english,
    X <> [nroot].

word('day', X) :- 
    language@X -- english,
    definition@X -- 'time for Earth to make a complete rotation on its axis',
    X <> [nroot],
    M <> [cat(date), inflected, fulladjunct, saturated, postmod(S), theta(dateAsMod)],
    altview@M -- date,
    S <> [s, -zero],
    trigger(specifier@X, addExternalView(specifier@X, M)).

word('deal', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('deal', X) :- 
    language@X -- english,
    definition@X -- 'an agreement between parties fixing obligations of each',
    X <> [nroot].

word('dealt', X) :-
    language@X -- english,
    itverb(X),
    X <> [past, inflected].

word('deliver', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    tverb(X).

word('deliver', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    tverb2(X).

word('divorce', X) :-
    language@X -- english,
    definition@X -- 'part',
    X <> [vroot, regularPast],
    tverb(X).

word('divorce', X) :- 
    language@X -- english,
    definition@X -- 'the legal dissolution of a marriage',
    X <> [nroot].

word('doe', X) :- 
    language@X -- english,
    definition@X -- 'mature female of mammals of which the male is called SQ buck SQ',
    X <> [nroot, sing].

word('dog', X) :-
    language@X -- english,
    definition@X -- 'go after with the intent to catch',
    X <> [vroot, regularPast],
    verb(X).

word('dog', X) :- 
    language@X -- english,
    X <> [nroot].

word('doubt', X) :- 
    language@X -- english,
    X <> [nroot].

word('doubt', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    S <> [tensedForm],
    sverb(X, S).

word('doubt', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    tverb(X).

word('drank', X) :-
    language@X -- english,
    itverb(X),
    X <> [pastTense, inflected].

word('draw', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, pastForms(-, -)].

word('drew', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastTense, inflected].

word('drink', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('drink', X) :- 
    language@X -- english,
    definition@X -- 'any liquid suitable for drinking',
    X <> [nroot].

word('drunk', X) :-
    language@X -- english,
    itverb(X),
    X <> [pastPart, inflected].

word('dwell', X) :-
    language@X -- english,
    uverb(X),
    X <> [vroot, pastForms(-, -)].

word('dwelt', X) :-
    language@X -- english,
    uverb(X),
    X <> [past, inflected].
        
word('ear', X) :- 
    language@X -- english,
    definition@X -- 'jewelry to ornament the ear',
    X <> [nroot].
                    
word('earring', X) :- 
    language@X -- english,
    definition@X -- 'jewelry to ornament the ear',
    X <> [nroot].

word('eat', X) :-
    language@X -- english,
    X <> [vroot, pastForms(-, -)],
    tverb(X).

word('eaten', X) :-
    language@X -- english,
    X <> [inflected, vspec],
    pastPart(X),
    tverb(X).

word('enjoy', X) :-
    language@X -- english,
    definition@X -- 'take delight in',
    X <> [vroot, regularPast],
    tverb(X).

word('exact', X) :-
    language@X -- english,
    definition@X -- 'characterized by perfect conformity to fact or truth',
    X <> [aroot].

word('exactly', X) :-
    language@X -- english,
    definition@X -- 'characterized by perfect conformity to fact or truth',
    cat@X -- exactly,
    X <> [saturated, fixedpremod, fulladjunct, theta(premod)],
    target@X <> [det1(_), +numeric].

word('exact', X) :-
    language@X -- english,
    definition@X -- 'take as an undesirable consequence of some event or state of affairs',
    X <> [vroot, regularPast],
    tverb(X).

word('expect', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    verb(X, expect).

word('fart', X) :-
    language@X -- english,
    definition@X -- 'expel intestinal gases through the anus',
    X <> [vroot, regularPast],
    iverb(X).

word('fart', X) :- 
    language@X -- english,
    definition@X -- 'a reflex that expels intestinal gas through the anus',
    X <> [nroot].
         
% word('fast', X) :-
%     language@X -- english,
%     definition@X -- 'unrestrained by convention or morality',
%     X <> [aroot].
                    
% word('fast', X) :- 
%     language@X -- english,
%     definition@X -- 'abstaining from food',
%     X <> [nroot, -target].

 word('fast', X) :-
     language@X -- english,
     definition@X -- 'quickly or rapidly',
     X <> [adv].

% word('fast', X) :-
%     language@X -- english,
%     definition@X -- 'abstain from certain foods , as for religious or medical reasons',
%     X <> [vroot, regularPast],
%     iverb(X).

word('fat', X) :- 
    language@X -- english,
    definition@X -- 'a kind of body tissue containing stored fat that serves as a source of energy',
    X <> [nroot, -target].

word('fat', X) :- 
    language@X -- english,
    X <> [aroot].

word('fed', X) :-
    language@X -- english,
    itverb(X),
    X <> [past, inflected].

word('feed', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('feed', X) :- 
    language@X -- english,
    definition@X -- 'food for domestic livestock',
    X <> [nroot].

word('feet', X) :- 
    language@X -- english,
    definition@X -- 'the pedal extremity of vertebrates other than human beings',
    X <> [baseNoun, third, plural, inflected, -target].

word('fight', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('fight', X) :- 
    language@X -- english,
    definition@X -- 'a hostile meeting of opposing military forces in the course of a war',
    X <> [nroot].

word('fled', X) :-
    language@X -- english,
    itverb(X),
    X <> [past, inflected].

word('flee', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].
                    
word('fool', X) :- 
    language@X -- english,
    definition@X -- 'a person who is gullible and easy to take advantage of',
    X <> [nroot].

word('fool', X) :-
    language@X -- english,
    definition@X -- 'make a fool or dupe of',
    X <> [vroot, regularPast],
    tverb(X).

word('foot', X) :-
    language@X -- english,
    definition@X -- 'pay for something',
    X <> [vroot, regularPast],
    tverb(X).

word('foot', X) :- 
    language@X -- english,
    definition@X -- 'the pedal extremity of vertebrates other than human beings',
    X <> [nroot].

word('foretell', X) :-
    language@X -- english,
    uverb(X),
    X <> [vroot, pastForms(-, -)].

word('foretold', X) :-
    language@X -- english,
    uverb(X),
    X <> [past, inflected].

word('forgave', X) :-
    language@X -- english,
    uverb(X),
    X <> [pastTense, inflected].

word('forgive', X) :-
    language@X -- english,
    uverb(X),
    X <> [vroot, pastForms(-, -)].

word('forsake', X) :-
    language@X -- english,
    uverb(X),
    X <> [vroot].

word('forsook', X) :-
    language@X -- english,
    uverb(X),
    X <> [pastTense, inflected].

word('fought', X) :-
    language@X -- english,
    itverb(X),
    X <> [past, inflected].

word('frolick', X) :-
    language@X -- english,
    uverb(X),
    X <> [vroot, regularPast].

word('frolick', X) :- 
    language@X -- english,
    definition@X -- 'gay or light - hearted recreational activity for diversion or amusement',
    X <> [nroot].

word('fungi', X) :- 
    language@X -- english,
    X <> [baseNoun, third, plural, inflected, -target].

word('gave', X) :-
    language@X -- english,
    tverb2(X),
    X <> [pastTense, inflected].

word('get', X) :-
    language@X -- english,
    verb(X, get),
    X <> [vroot, pastForms(-, -)].

word('give', X) :-
    language@X -- english,
    tverb2(X),
    X <> [vroot, pastForms(-, -)].

word('given', X) :-
    language@X -- english,
    X <> [inflected],
    pastPart(X),
    tverb2(X).

word('glycerinate', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, regularPast].

word('got', X) :-
    language@X -- english,
    X <> [inflected, pastTense],
    verb(X, get).

word('got', X) :-
    language@X -- english,
    X <> [inflected, pastPart],
    verb(X, get).

word('gotten', X) :-
    language@X -- english,
    verb(X, get),
    X <> [pastPart, inflected].
                    
word('grape', X) :- 
    language@X -- english,
    definition@X -- 'any of various juicy fruit of the genus Vitis with green or purple skins',
    X <> [nroot].

word('great', X) :-
    language@X -- english,
    definition@X -- 'very good',
    X <> [aroot].

word('great', X) :- 
    language@X -- english,
    definition@X -- 'a person who has achieved distinction and honor in some field',
    X <> [nroot, -target],
    setCost(X, 10).
                    
word('Greek', X) :- 
    language@X -- english,
    definition@X -- 'the Hellenic branch of the Indo - European family of languages',
    X <> [nroot(_)].

word('grew', X) :-
    language@X -- english,
    itverb(X),
    X <> [pastTense, inflected].

word('grow', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('hang', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, regularPast].

word('hat', X) :- 
    language@X -- english,
    definition@X -- 'headdress that protects the head from bad weather',
    X <> [nroot].

word('hate', X) :-
    language@X -- english,
    definition@X -- 'dislike intensely',
    X <> [vroot, regularPast],
    tverb(X).

word('hate', X) :- 
    language@X -- english,
    definition@X -- 'the emotion of intense dislike',
    X <> [nroot].

word('heart', X) :- 
    language@X -- english,
    definition@X -- 'a positive feeling of liking',
    X <> [nroot].

word('hearted', X) :-
    language@X -- english,
    tverb(X),
    X <> [past, inflected].
                    
word('hero', X) :- 
    language@X -- english,
    X <> [nroot].

word('hoe', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, regularPast].

word('hoe', X) :- 
    language@X -- english,
    definition@X -- 'a tool with a flat blade attached at right angles to a long handle',
    X <> [nroot].
              
word('home', X) :- 
    language@X -- english,
    definition@X -- 'the place where you are stationed and from which missions start and end',
    X <> [nroot].

word('home', X) :-
    language@X -- english,
    definition@X -- 'at or to or in the direction of one SS home or family',
    X <> [adv].

word('home', X) :-
    language@X -- english,
    definition@X -- 'provide with , or send to , a home',
    X <> [vroot, regularPast],
    tverb(X).

word('hung', X) :-
    language@X -- english,
    tverb(X),
    X <> [past, inflected].

word('hurt', X) :-
    language@X -- english,
    definition@X -- 'be the source of pain',
    X <> [vroot, pastForms(-, -)],
    itverb(X).

word('hurt', X) :-
    language@X -- english,
    definition@X -- 'be the source of pain',
    X <> [v, pastTense, inflected],
    itverb(X).

word('hurt', X) :-
    language@X -- english,
    definition@X -- 'be the source of pain',
    X <> [v, inflected],
    itverb(X),
    pastPart(X).
                    
word('hurt', X) :- 
    language@X -- english,
    definition@X -- 'the act of damaging something or someone',
    X <> [nroot].

word('i', X) :- 
    language@X -- english,
    definition@X -- 'the 9th letter of the Roman alphabet',
    X <> [nroot, -target, sing].
                     
word('idiot', X) :- 
    language@X -- english,
    definition@X -- 'a person of subnormal intelligence',
    X <> [nroot].

word('island', X) :- 
    language@X -- english,
    definition@X -- 'a land mass that is surrounded by water',
    X <> [nroot].

word('kill', X) :- 
    language@X -- english,
    definition@X -- 'the destruction of an enemy plane or ship or tank or missile',
    X <> [nroot].

word('kill', X) :-
    language@X -- english,
    definition@X -- 'cause to die',
    X <> [vroot, regularPast],
    tverb(X).

word('kiss', X) :-
    language@X -- english,
    X <> [nroot].

word('kiss', X) :-
    language@X -- english,
    X <> [vroot, regularPast, plural],
    iverb(X).

word('kiss', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    tverb(X).

word('knew', X) :-
    language@X -- english,
    uverb(X),
    X <> [pastTense, inflected].

word('know', X) :-
    language@X -- english,
    sverb(X, C),
    X <> [vroot],
    C <> [s].

word('Labour', X) :- 
    language@X -- english,
    X <> [nroot(_), sing].

word('last', X) :-
    language@X -- english,
    definition@X -- 'occurring at or forming an end or termination',
    X <> [aroot].
                    
word('last', X) :- 
    language@X -- english,
    definition@X -- 'the time at which life ends',
    X <> [nroot, -target].

word('last', X) :-
    language@X -- english,
    definition@X -- 'most _ recently',
    X <> [adv].

word('last', X) :-
    language@X -- english,
    definition@X -- 'persist for a specified period of time',
    X <> [vroot, regularPast],
    tverb(X).

word('lead', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('lead', X) :- 
    language@X -- english,
    definition@X -- 'a jumper that consists of a short piece of wire',
    X <> [nroot].

word('led', X) :-
    language@X -- english,
    itverb(X),
    X <> [past, inflected].

word('leave', X) :-
    language@X -- english,
    definition@X -- 'leave or give by will after one SS death',
    X <> [vroot, pastForms(-, -)],
    itverb(X).

word('left', X) :-
    language@X -- english,
    definition@X -- 'leave or give by will after one SS death',
    X <> [v, inflected, pastTense],
    itverb(X).

word('left', X) :-
    language@X -- english,
    definition@X -- 'leave or give by will after one SS death',
    X <> [v, inflected, pastTense],
    itverb(X).
                    
word('leave', X) :- 
    language@X -- english,
    definition@X -- 'the act of departing politely',
    X <> [nroot].

word('legged', X) :-
    language@X -- english,
    X <> aroot([DASH, NUM]),
    DASH <> [fixedprearg, word],
    root@DASH -- ['-'],
    NUM <> [fixedprearg, word, number(_)].

word('like', X) :-
    language@X -- english,
    X <> [sverb(COMP), vroot, regularPast],
    trigger(finite@COMP, (toForm(COMP); presPartForm(COMP))).

word('like', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    tverb(X).

word('likely', X) :-
    language@X -- english,
    definition@X -- 'to a moderately sufficient extent or degree',
    X <> [a, strictpremod, inflected, fulladjunct],
    target@X <> [s, toForm].

word('literature', X) :- 
    language@X -- english,
    definition@X -- 'creative writing of recognized artistic value',
    X <> [nroot(_)].

word('lose', X) :-
    language@X -- english,
    definition@X -- 'retreat',
    X <> [vroot, pastForms(-, -)],
    tverb(X).

word('lost', X) :-
    language@X -- english,
    definition@X -- 'retreat',
    X <> [v, inflected, pastTense],
    tverb(X).

word('lost', X) :-
    language@X -- english,
    definition@X -- 'retreat',
    X <> [v, inflected, pastPart],
    tverb(X).

word('love', X) :-
    language@X -- english,
    X <> [nroot].

word('love', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    trigger(index@COMP, (complete(COMP), (toForm(COMP); presPartForm(COMP)))),
    sverb(X, COMP).

word('love', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    tverb(X).

word('M25', X) :-
    language@X -- english,
    X <> [nroot, sing].

word('made', X) :-
    language@X -- english,
    definition@X -- 'take in marriage',
    X <> [verb, inflected],
    verb(X, make),
    (pastPart(X); pastTense(X)).

word('major', X) :- 
    language@X -- english,
    definition@X -- 'a commissioned military officer in the United States Army or Air Force or Marines',
    X <> [nroot].

word('major', X) :-
    language@X -- english,
    definition@X -- 'have as one SS principal field of study',
    X <> [vroot, regularPast],
    iverb(X).

word('make', X) :-
    language@X -- english,
    definition@X -- 'take in marriage',
    X <> [vroot, pastForms(-, -)],
    verb(X, make).

word('man', X) :-
    language@X -- english,
    X <> [nroot].

word('manage', X) :-
    language@X -- english,
    definition@X -- 'come to terms with',
    X <> [vroot, regularPast],
    sverb(X, S),
    S <> [toForm],
    +zero@subject@S,
    specifier@subject@S -- *lambda.

word('market', X) :-
    language@X -- english,
    definition@X -- 'make commercial',
    X <> [vroot, regularPast],
    tverb(X).
                    
word('market', X) :- 
    language@X -- english,
    definition@X -- 'a marketplace where groceries are sold',
    X <> [nroot].

word('married', X) :- 
    language@X -- english,
    definition@X -- 'a person who is married',
    X <> [nroot].

word('marry', X) :-
    language@X -- english,
    definition@X -- 'take in marriage',
    X <> [vroot, plural, regularPast],
    iverb(X).

word('marry', X) :-
    language@X -- english,
    definition@X -- 'take in marriage',
    X <> [vroot, regularPast],
    tverb(X).

word('mean', X) :-
    language@X -- english,
    uverb(X),
    X <> [vroot, pastForms(-, -)].

word('meant', X) :-
    language@X -- english,
    uverb(X),
    X <> [past, inflected].

word('meet', X) :-
    language@X -- english,
    definition@X -- 'being precisely fitting and right',
    X <> [aroot].

%% Don't need 'meeting' as a noun, because meet+ing is a gerund
word('meet', X) :-
    language@X -- english,
    verb(X, meet),
    X <> [vroot, pastForms(-, -)].

word('meet', X) :- 
    language@X -- english,
    definition@X -- 'a meeting at which a number of athletic contests are held',
    X <> [nroot].

word('met', X) :-
    language@X -- english,
    verb(X, meet),
    X <> [past, inflected, -target].

word('mimick', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, presPart].
                    
word('mortal', X) :-
    language@X -- english,
    definition@X -- 'a human being',
    X <> [nroot, -target].

word('mortal', X) :-
    language@X -- english,
    definition@X -- 'exhibiting courtesy and politeness',
    aroot(X).

word('MP', X) :- 
    language@X -- english,
    X <> [nroot].

word('music', X) :-
    language@X -- english,
    X <> [nroot(_)].
                    
word('need', X) :- 
    language@X -- english,
    definition@X -- 'a state of extreme poverty or destitution',
    X <> [nroot].

word('need', X) :-
    language@X -- english,
    definition@X -- 'require as useful , just , or proper',
    X <> [vroot, regularPast],
    tverb(X).

word('nice', X) :-
    language@X -- english,
    definition@X -- 'exhibiting courtesy and politeness',
    X <> [aroot].

word('nose', X) :-
    language@X -- english,
    definition@X -- 'search or inquire in a meddlesome way',
    X <> [vroot, regularPast],
    iverb(X).
                    
word('nose', X) :- 
    language@X -- english,
    definition@X -- 'the organ of smell and entrance to the respiratory tract',
    X <> [nroot].

word('overran', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastTense, inflected].

word('overrun', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot].

word('oversaw', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastTense, inflected].

word('oversee', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, pastForms(-, -)].

word('overtake', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot].

word('overthrew', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastTense, inflected].

word('overthrow', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot].

word('overtook', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastTense, inflected].

word('overrun', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastPart, inflected].

word('part', X) :- 
    language@X -- english,
    definition@X -- 'an actor SS portrayal of someone in a play',
    X <> [nroot(_)].

word('part', X) :-
    language@X -- english,
    definition@X -- 'leave',
    X <> [vroot, regularPast],
    iverb(X).

word('payrise', X) :-
    language@X -- english,
    X <> [nroot].

word('peach', X) :- 
    language@X -- english,
    definition@X -- 'cultivated in temperate regions',
    X <> [nroot].

/**
word('peach', X) :-
    language@X -- english,
    definition@X -- 'divulge confidential information or secrets',
    X <> [vroot, regularPast],
    iverb(X).
**/

word('people', X) :-
    language@X -- english,
    X <> [noun, thirdSing, specifier(*generic), inflected],
    nmod(X).

word('people', X) :-
    language@X -- english,
    X <> [noun, third, plural, inflected, -target].

word('people', X) :-
    language@X -- english,
    definition@X -- 'fill with people',
    X <> [vroot, regularPast],
    tverb(X).

word('picnick', X) :-
    language@X -- english,
    uverb(X),
    X <> [vroot, presPart].

word('present', X) :-
    language@X -- english,
    definition@X -- 'give , especially as an honor or reward',
    X <> [vroot, regularPast],
    itverb(X).

word('present', X) :-
    language@X -- english,
    definition@X -- 'temporal sense',
    X <> [aroot].
                    
word('present', X) :- 
    language@X -- english,
    definition@X -- 'the period of time that is happening now',
    X <> [nroot, -target].

word('pretty', X) :-
    language@X -- english,
    definition@X -- 'pleasing by delicacy or grace',
    X <> [aroot].

word('pretty', X) :-
    language@X -- english,
    definition@X -- 'to a moderately sufficient extent or degree',
    X <> [adv1(T), strictpremod, -predicative],
    T <> [a].

word('ran', X) :-
    language@X -- english,
    itverb(X),
    X <> [pastTense, inflected].

word('read', X) :-
    language@X -- english,
    uverb(X),
    X <> [pastPart, inflected].

word('read', X) :-
    language@X -- english,
    uverb(X),
    X <> [pastTense, inflected].

word('read', X) :-
    language@X -- english,
    uverb(X),
    X <> [vroot, pastForms(-, -)].

word('read', X) :- 
    language@X -- english,
    definition@X -- 'something that is read',
    X <> [nroot].

word('rebuild', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, pastForms(-, -)].

word('rebuilt', X) :-
    language@X -- english,
    tverb(X),
    X <> [past, inflected].
             
word('resident', X) :-
    language@X -- english,
    definition@X -- 'a physician who lives in a hospital and cares for hospitalized patients under the supervision of the medical staff of the hospital',
    X <> [nroot, -target].

word('resident', X) :-
    language@X -- english,
    X <> [aroot].

word('ride', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('ride', X) :- 
    language@X -- english,
    definition@X -- 'a journey in a vehicle',
    X <> [nroot].

/*
word('right', X) :-
    language@X -- english,
    definition@X -- 'make right or correct',
    X <> [vroot, regularPast],
    tverb(X).

word('right', X) :-
    language@X -- english,
    definition@X -- 'in an accurate manner',
    X <> [adv].
*/

word('right', X) :- 
    language@X -- english,
    definition@X -- 'an abstract idea of that which is due to a person or governmental body by law or tradition or nature',
    X <> [nroot].

word('ripe', X) :- 
    language@X -- english,
    X <> [aroot].

word('rode', X) :-
    language@X -- english,
    itverb(X),
    X <> [pastTense, inflected].

word('run', X) :-
    language@X -- english,
    itverb(X),
    X <> [pastPart, inflected].

word('run', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('run', X) :- 
    language@X -- english,
    definition@X -- 'the pouring forth of a fluid',
    X <> [nroot].

word('sang', X) :-
    language@X -- english,
    itverb(X),
    X <> [pastTense, inflected].

word('sat', X) :-
    language@X -- english,
    X <> [iverb, pastTense, inflected].

word('saw', X) :-
    language@X -- english,
    X <> [sverb(S), pastTense, inflected],
    -zero@subject@S,
    S <> [specified],
    trigger(finite@S, (presPartForm(S); (tensedForm(S), comp@S == *(that)); infinitive(S))).

word('saw', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastTense, inflected].

word('say', X) :-
    language@X -- english,
    X <> [sverb(S), vroot],
    -zero@subject@S,
    S <> [tensedForm, specified].

word('say', X) :-
    language@X -- english,
    X <> [vroot, tverb].

word('see', X) :-
    language@X -- english,
    X <> [sverb(S), vroot, pastForms(-, -)],
    -zero@subject@S,
    S <> [specified],
    trigger(finite@S, (presPartForm(S); (tensedForm(S), comp@S == *(that)); infinitive(S))).

word('see', X) :-
    language@X -- english,
    X <> [tverb, vroot, pastForms(-, -)].
                    
word('Scandinavian', X) :- 
    language@X -- english,
    definition@X -- 'an inhabitant of Scandinavia',
    X <> [nroot(_)].

word('sell', X) :-
    language@X -- english,
    X <> [tverb, pastForms(-, -), vroot].
         
word('send', X) :-
    language@X -- english,
    definition@X -- 'broadcast over the airwaves , as in radio or television',
    X <> [vroot, pastForms(-, -)],
    tverb(X).
     
word('send', X) :-
    language@X -- english,
    definition@X -- 'broadcast over the airwaves , as in radio or television',
    X <> [vroot, pastForms(-, -)],
    tverb2(X).
     
word('sent', X) :-
    language@X -- english,
    definition@X -- 'broadcast over the airwaves , as in radio or television',
    X <> [v, inflected],
    tverb(X),
    edForm(X).
     
word('sent', X) :-
    language@X -- english,
    definition@X -- 'broadcast over the airwaves , as in radio or television',
    X <> [v, inflected],
    tverb2(X),
    edForm(X).

word('sign', X) :- 
    language@X -- english,
    definition@X -- 'an event that is experienced as indicating important things to come',
    X <> [nroot, -target].

word('sign', X) :-
    language@X -- english,
    definition@X -- 'make the sign of the cross over someone in order to call on God for protection',
    X <> [vroot, regularPast],
    tverb(X).

word('shrank', X) :-
    language@X -- english,
    itverb(X),
    X <> [pastTense, inflected].

word('shrink', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('shrink', X) :- 
    language@X -- english,
    definition@X -- 'a physician who specializes in psychiatry',
    X <> [nroot].

word('shrunk', X) :-
    language@X -- english,
    itverb(X),
    X <> [past, inflected].

word('sing', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('sit', X) :-
    language@X -- english,
    iverb(X),
    X <> [vroot, pastForms(-, -)].

word('sleep', X) :-
    language@X -- english,
    X <> [iverb, vroot].

word('slid', X) :-
    language@X -- english,
    itverb(X),
    X <> [past, inflected].

word('slide', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('slide', X) :- 
    language@X -- english,
    definition@X -- 'sloping channel through which things can descend',
    X <> [nroot].

word('small', X) :-
    language@X -- english,
    definition@X -- 'made to seem smaller or less',
    X <> [aroot].

word('small', X) :- 
    language@X -- english,
    definition@X -- 'the slender part of the back',
    X <> [nroot, -target].

word('sold', X) :-
    language@X -- english,
    X <> [pastTense, inflected],
    tverb(X).

word('speak', X) :-
    language@X -- english,
    definition@X -- 'give a speech to',
    X <> [vroot, pastForms(-, -)],
    itverb(X).

word('spend', X) :-
    language@X -- english,
    definition@X -- 'broadcast over the airwaves , as in radio or television',
    X <> [vroot, pastForms(-, -)],
    tverb(X).
     
word('spent', X) :-
    language@X -- english,
    definition@X -- 'broadcast over the airwaves , as in radio or television',
    X <> [v, inflected, pastTense],
    tverb(X).
     
word('spent', X) :-
    language@X -- english,
    definition@X -- 'broadcast over the airwaves , as in radio or television',
    X <> [v, inflected, pastPart],
    tverb(X).

word('spoke', X) :-
    language@X -- english,
    definition@X -- 'give a speech to',
    X <> [v, inflected, pastTense],
    itverb(X).

word('spoken', X) :-
    language@X -- english,
    definition@X -- 'give a speech to',
    X <> [v, inflected],
    itverb(X),
    pastPart(X).

word('spin', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('spin', X) :- 
    language@X -- english,
    definition@X -- 'a swift whirling motion',
    X <> [nroot].

word('sprang', X) :-
    language@X -- english,
    itverb(X),
    X <> [pastTense, inflected].

word('spring', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('spring', X) :- 
    language@X -- english,
    definition@X -- 'the elasticity of something that can be stretched and returns to its original length',
    X <> [nroot].

word('sprung', X) :-
    language@X -- english,
    itverb(X),
    X <> [pastPart, inflected].

word('spun', X) :-
    language@X -- english,
    itverb(X),
    X <> [past, inflected].

word('steal', X) :-
    language@X -- english,
    X <> [tverb, vroot, pastForms(-, -)].

word('stock', X) :- 
    language@X -- english,
    definition@X -- 'a special variety of domesticated animals within a species',
    X <> [nroot(_)].

word('stock', X) :-
    language@X -- english,
    definition@X -- 'put forth and grow sprouts or shoots',
    X <> [vroot, regularPast],
    tverb(X).

word('stole', X) :-
    language@X -- english,
    X <> [pastTense, inflected],
    tverb(X).

word('stolen', X) :-
    language@X -- english,
    X <> [adj, inflected].

word('stolen', X) :-
    language@X -- english,
    X <> [pastPart, inflected, -target],
    tverb(X).

word('summons', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, regularPast].

word('summons', X) :- 
    language@X -- english,
    definition@X -- 'a request to be pastForms(-, -)',
    X <> [nroot].

word('sung', X) :-
    language@X -- english,
    itverb(X),
    X <> [pastPart, inflected].
                    
word('Swede', X) :- 
    language@X -- english,
    definition@X -- 'a native or inhabitant of Sweden',
    X <> [nroot(_)].

word('swam', X) :-
    language@X -- english,
    definition@X -- 'be afloat either on or below a liquid surface and not sink to the bottom',
    X <> [v, inflected, pastTense],
    itverb(X).

word('swim', X) :-
    language@X -- english,
    definition@X -- 'be afloat either on or below a liquid surface and not sink to the bottom',
    X <> [vroot, pastForms(-, -)],
    itverb(X).

word('swum', X) :-
    language@X -- english,
    definition@X -- 'be afloat either on or below a liquid surface and not sink to the bottom',
    X <> [v, inflected, pastPart],
    itverb(X).
                    
word('swim', X) :- 
    language@X -- english,
    definition@X -- 'the act of swimming',
    X <> [nroot].

word('swing', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('swing', X) :- 
    language@X -- english,
    definition@X -- 'in baseball',
    X <> [nroot].

word('swung', X) :-
    language@X -- english,
    itverb(X),
    X <> [past, inflected].

word('take', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, pastForms(-, -)].

word('taught', X) :-
    language@X -- english,
    uverb(X),
    X <> [past, inflected].

word('teach', X) :-
    language@X -- english,
    uverb(X),
    X <> [vroot, pastForms(-, -)].

word('tell', X) :-
    language@X -- english,
    uverb(X),
    X <> [vroot, pastForms(-, -)].
            
word('tenor', X) :- 
    language@X -- english,
    definition@X -- 'the adult male singing voice above baritone',
    X <> [nroot, -target].

word('thing', X) :-
    language@X -- english,
    X <> [nroot(_)].

word('thought', X) :-
    X <> [nroot].

word('thought', X) :-
    language@X -- english,
    X <> [pastTense, inflected],
    sverb(X, S),
    S <> [tensedForm].

word('thought', X) :-
    language@X -- english,
    X <> [pastTense, inflected],
    tverb(X).

word('time', X) :-
    language@X -- english,
    definition@X -- 'measure the time or duration of an event or action or the person who performs an action in a certain period of time',
    X <> [vroot, regularPast],
    tverb(X).

word('time', X) :- 
    language@X -- english,
    definition@X -- 'a reading of a point in time as given by a clock',
    X <> [nroot(_)].

word('today', X) :-
    language@X -- english,
    definition@X -- 'in these times',
    X <> [adv].
                    
word('today', X) :- 
    language@X -- english,
    definition@X -- 'the pastForms(-, -) time or age',
    X <> [nroot(_)].

word('told', X) :-
    language@X -- english,
    tverb(X),
    X <> [v, pastTense, inflected].

word('told', X) :-
    language@X -- english,
    tverb(X),
    X <> [v, pastPart, inflected].

word('took', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastTense, inflected].

word('travel', X) :-
    language@X -- english,
    definition@X -- 'change location',
    X <> [vroot, regularPast],
    iverb(X).

word('travel', X) :- 
    language@X -- english,
    definition@X -- 'a movement through space that changes the location of something',
    X <> [nroot].

word('undergo', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, pastForms(-, -)].

word('undergone', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastPart, inflected].

word('unripe', X) :- 
    language@X -- english,
    X <> [aroot].

word('undertake', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, pastForms(-, -)].

word('undertook', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastTense, inflected].

word('underwent', X) :-
    language@X -- english,
    tverb(X),
    X <> [pastTense, inflected].
                
word('update', X) :- 
    language@X -- english,
    definition@X -- 'news that updates your information',
    X <> [nroot].

word('update', X) :-
    language@X -- english,
    definition@X -- 'modernize or bring up to date',
    X <> [vroot, regularPast],
    itverb(X).

word('used', X) :-
    language@X -- english,
    X <> [pastForms(-, -), inflected, -target],
    finite@X -- VFORM,
    trigger(VFORM, (VFORM=tensed; VFORM=infinitive)),
    -zero@subject@X,
    verb(X, use).

word('use', X) :-
    language@X -- english,
    definition@X -- 'use up , consume fully',
    X <> [vroot, regularPast],
    tverb(X).

word('use', X) :- 
    language@X -- english,
    definition@X -- 'exerting shrewd or devious influence especially for one SS own advantage',
    X <> [nroot].
           
word('valet', X) :- 
    language@X -- english,
    definition@X -- 'a manservant who acts as a personal attendant to his employer',
    X <> [nroot].

word('valet', X) :-
    language@X -- english,
    definition@X -- 'serve as a personal attendant to',
    X <> [vroot, regularPast],
    tverb(X).

word('want', X) :-
    language@X -- english,
    X <> [sverb(S), vroot, regularPast],
    S <> toForm.

word('want', X) :-
    language@X -- english,
    X <> [vroot, regularPast],
    tverb(X).

word('wear', X) :-
    language@X -- english,
    itverb(X),
    X <> [vroot, pastForms(-, -)].

word('wear', X) :- 
    language@X -- english,
    definition@X -- 'a covering designed to be worn on a person SS body',
    X <> [nroot].
                    
word('well', X) :- 
    language@X -- english,
    definition@X -- 'a deep hole or shaft dug or drilled to obtain water or oil or gas or brine',
    X <> [nroot].

word('well', X) :-
    language@X -- english,
    definition@X -- 'in a good or proper or satisfactory manner or to a high standard',
    X <> [adv].

word('well', X) :-
    language@X -- english,
    definition@X -- 'come up , as of a liquid',
    X <> [vroot, regularPast],
    iverb(X),
    setCost(X, 100).

word('went', X) :-
    language@X -- english,
    iverb(X),
    root@X -- [go],
    X <> [pastTense, inflected].

word('win', X) :-
    language@X -- english,
    X <> [vroot, pastForms(-, -)],
    verb(X, win).

word('withstand', X) :-
    language@X -- english,
    tverb(X),
    X <> [vroot, pastForms(-, -)].

word('withstood', X) :-
    language@X -- english,
    tverb(X),
    X <> [past, inflected].

word('woman', X) :-
    language@X -- english,
    X <> [nroot].

word('won', X) :-
    language@X -- english,
    verb(X, win),
    root@X -- [win],
    X <> [pastTense, inflected].

word('wore', X) :-
    language@X -- english,
    uverb(X),
    X <> [pastPart, inflected].

word('wore', X) :-
    language@X -- english,
    uverb(X),
    X <> [pastTense, inflected].

word('write', X) :-
    language@X -- english,
    X <> [vroot, pastForms(-, -)],
    verb(X, write).

word('written', X) :-
    language@X -- english,
    X <> [pastPart, inflected],
    verb(X, write).

word('wrote', X) :-
    language@X -- english,
    X <> [v, inflected, pastTense],
    verb(X, write).
         
word('yesterday', X) :- 
    language@X -- english,
    definition@X -- 'the day immediately before today',
    X <> [np, adjunct, postmod, inflected],
    target@X <> [vp].

:- include('englishclosed').

