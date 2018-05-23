
:- multifile(signature/1).

signature(label=[indent=_, stack=_, defaults=_, abduced=_, degree=_]).

signature(time=[tense=_, aspect=_, aux=_, def=_, finite=_]).

signature(position=[set=_, before=_, after=_]).

signature(sign=[structure=[cost=_,
                           position=[span=_,
				     moved=_,
				     start=_,
				     end=_,
				     xstart=_,
				     xend=_],
			   index=_,
			   dir=_,
			   marked=_,
			   modified=_,
			   form=[root=_, surface=_],
			   dtree=_,
			   zero=_,
			   dtrs=_,
			   language=_,
			   altview=_,
			   terminal=_],
		syntax=[args=_,
			tag=_,
			head=[cat=_,
			      hd=_,
			      agree=[person=_,
				     number=_,
				     gender=_,
				     mass=_],
			      pronominal=_,
			      nform=[case=_],
			      vform=[tense=_,
				     finite=_,
				     subject=_,
				     active=_,
				     mood=_,
				     aspect=_,
				     aux=_,
				     invertsubj=_],
			      aform=[degree=_],
			      predicative=_],
			spec=[specified=_, def=_, specifier=_, numeric=_, counted=_],
			real=_,
			comp=_,
			nonlocal=[wh=_,
				  shifted=_,
				  zerodtr=_],
			conjoined=_,
			mod=[target=_, result=_, modifiable=_]],
		morphology=[affixes=_,
			    affix=_,
			    affixdir=_,
			    class=_],
		semantics=[content=_,
			   theta=_,
			   modifier=_,
			   definition=_,
			   polarity=_],
		externalviews=_,
		complete=_,
		display=[xpos=_,
			 ypos=_,
			 width=_],
		used=_
		]).

signature(xbar=[v=_, n=_]).

signature(state=[queue=_,
		 stack=_,
		 relations=_,
		 self=_,
		 mother=_,
	         action=_]).

signature(relation=[hd=_,
		    dtr=_,
		    label=_]).
