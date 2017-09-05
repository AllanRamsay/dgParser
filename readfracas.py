
import re
from useful import *
import latex
reload(latex)
import sys
        
pattern = re.compile("<(?P<tag>p|q|h)( idx\S*)?>(?P<text>.*?)</(?P=tag)>", re.DOTALL)

def readfracas(src="fracas.xml"):
    return [i.group("text").strip() for i in pattern.finditer(open(src).read())]

def fracas2prolog(src="fracas.xml", dest=sys.stdout):
    punct = re.compile("\.|\?|:|;|,")
    spaces = re.compile(" \s")
    with safeout(dest) as write:
        for s in readfracas(src):
            s = s.replace("n't", " not")
            s = s.replace("&apos;s", " SSS ")
            s = s.replace("&apos;", " APOS ")
            s = punct.sub(" \g<0> ", s)
            s = spaces.sub(" ", s)
            write("fracas('%s').\n"%(s.strip()))
        write("""

testFracas :-
    fracas(X),
    format("~n~nparseOne('~w').~n", [X]),
    parseOne(X),
    fail.
""")

def testfracas(parser, tagger):
    analyses = []
    for s in readfracas():
        if s == "":
            continue
        s = replaceAll(s, [(".", " ."), ("?", " ?"), ("&apos;s", " s"), ("&", "and"), ("#", "NUM")])
        w = s.split(" ")[0]
        if w.lower() in tagger.basetagger.dict:
            s = s[0].lower()+s[1:]
        print s
        analyses.append([s, parser.parse(s, tagger=tagger).dtree])
    return analyses

def latexAll(analyses):
    s = ""
    for x, y in analyses:
        s += r"""
\vbox{\item
%s

%s}"""%(x, latex.latexDTree(y, False, 30, 30, []))
    runlatex(r"""
\begin{landscape}
\begin{examples}
%s
\end{examples}
\end{landscape}"""%(s),
        packages=["examples", "lscape"])
        
