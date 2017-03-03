
word('began', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('begin', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('begun', X) :-
    language@X -- english,
    X <> [uverb, pastPart, inflected].

word('borne', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('bred', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('breed', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('breed', X) :- 
    language@X -- english,
    definition@X -- 'a special variety of domesticated animals within a species',
    X <> [nroot].

word('bring', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('brought', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('catalogue', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('catalogue', X) :- 
    language@X -- english,
    definition@X -- 'a book or pamphlet containing an enumeration of things',
    X <> [nroot].

word('catch', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('catch', X) :- 
    language@X -- english,
    definition@X -- 'the act of apprehending',
    X <> [nroot].

word('caught', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('chest', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('choose', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('chose', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('deal', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('deal', X) :- 
    language@X -- english,
    definition@X -- 'an agreement between parties fixing obligations of each',
    X <> [nroot].

word('dealt', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('drank', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('draw', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('drew', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('drink', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('drink', X) :- 
    language@X -- english,
    definition@X -- 'any liquid suitable for drinking',
    X <> [nroot].

word('drunk', X) :-
    language@X -- english,
    X <> [uverb, pastPart, inflected].

word('dwell', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('dwelt', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('fed', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('feed', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('feed', X) :- 
    language@X -- english,
    definition@X -- 'food for domestic livestock',
    X <> [nroot].

word('fight', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('fight', X) :- 
    language@X -- english,
    definition@X -- 'a hostile meeting of opposing military forces in the course of a war',
    X <> [nroot].

word('fled', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('flee', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('foretell', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('foretold', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('forgave', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('forgive', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('forsake', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('forsook', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('fought', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('frolick', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('frolick', X) :- 
    language@X -- english,
    definition@X -- 'gay or light - hearted recreational activity for diversion or amusement',
    X <> [nroot].

word('gave', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('get', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('give', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('glycerinate', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('got', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('gotten', X) :-
    language@X -- english,
    X <> [uverb, pastPart, inflected].

word('grew', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('grow', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('hang', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('hearted', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('hoe', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('hoe', X) :- 
    language@X -- english,
    definition@X -- 'a tool with a flat blade attached at right angles to a long handle',
    X <> [nroot].

word('hung', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('knew', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('know', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('lead', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('lead', X) :- 
    language@X -- english,
    definition@X -- 'a jumper that consists of a short piece of wire',
    X <> [nroot].

word('led', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('mean', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('meant', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('meet', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('meet', X) :-
    language@X -- english,
    definition@X -- 'being precisely fitting and right',
    X <> [aroot].

word('meet', X) :- 
    language@X -- english,
    definition@X -- 'a meeting at which a number of athletic contests are held',
    X <> [nroot].

word('met', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('mimick', X) :-
    language@X -- english,
    X <> [uverb, vroot, presPart].

word('overran', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('overrun', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('oversaw', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('oversee', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('overtake', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('overthrew', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('overthrow', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('overtook', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('overun', X) :-
    language@X -- english,
    X <> [uverb, pastPart, inflected].

word('picnick', X) :-
    language@X -- english,
    X <> [uverb, vroot, presPart].

word('ran', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('rebuild', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('rebuilt', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('ride', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('ride', X) :- 
    language@X -- english,
    definition@X -- 'a journey in a vehicle',
    X <> [nroot].

word('rode', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('run', X) :-
    language@X -- english,
    X <> [uverb, pastPart, inflected].

word('run', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('run', X) :- 
    language@X -- english,
    definition@X -- 'the pouring forth of a fluid',
    X <> [nroot].

word('sang', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('saw', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('shrank', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('shrink', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('shrink', X) :- 
    language@X -- english,
    definition@X -- 'a physician who specializes in psychiatry',
    X <> [nroot].

word('shrunk', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('sing', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('slid', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('slide', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('slide', X) :- 
    language@X -- english,
    definition@X -- 'sloping channel through which things can descend',
    X <> [nroot].

word('spin', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('spin', X) :- 
    language@X -- english,
    definition@X -- 'a swift whirling motion',
    X <> [nroot].

word('sprang', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('spring', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('spring', X) :- 
    language@X -- english,
    definition@X -- 'the elasticity of something that can be stretched and returns to its original length',
    X <> [nroot].

word('sprung', X) :-
    language@X -- english,
    X <> [uverb, pastPart, inflected].

word('spun', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('summons', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('summons', X) :- 
    language@X -- english,
    definition@X -- 'a request to be present',
    X <> [nroot].

word('sung', X) :-
    language@X -- english,
    X <> [uverb, pastPart, inflected].

word('swing', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('swing', X) :- 
    language@X -- english,
    definition@X -- 'in baseball',
    X <> [nroot].

word('swung', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('take', X) :-
    language@X -- english,
    X <> [uverb, vroot].

word('taught', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('teach', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('tell', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('told', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('took', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('undergo', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('undergone', X) :-
    language@X -- english,
    X <> [uverb, pastPart, inflected].

word('undertake', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('undertook', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('underwent', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('wear', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('wear', X) :- 
    language@X -- english,
    definition@X -- 'a covering designed to be worn on a person SS body',
    X <> [nroot].

word('went', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('withstand', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('withstood', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].

word('wore', X) :-
    language@X -- english,
    X <> [uverb, pastPart, inflected].

word('wore', X) :-
    language@X -- english,
    X <> [uverb, pastTense, inflected].

word('write', X) :-
    language@X -- english,
    X <> [uverb, vroot, present].

word('written', X) :-
    language@X -- english,
    X <> [uverb, pastPart, inflected].
