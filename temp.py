import re, os, sys
from useful import *

P = re.compile("\\begin{verbatim}.*?\\end{verbatim}", re.DOTALL)

def smalltt(ifile="notes-14-08-2017.tex", out=sys.stdout):
    with safeout(out) as write:
        write(P.sub(r"{\small\g<0>}", open(ifile).read()))
