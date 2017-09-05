#!/usr/bin/python

import re, sys
from useful import *

prologPattern = re.compile("\S.*?\.\n", re.DOTALL)
commentPattern = re.compile("/\*.*\*/\s*", re.DOTALL)

def sortprolog(f, out=sys.stdout):
    if out == f:
        raise Exception("Not a good idea to use same filename for input and outsink: %s"%(f))
    clauses = {}
    for i in prologPattern.finditer(open(f).read()):
        c = i.group(0)
        clauses[commentPattern.split(c)[-1]] = c
    with safeout(out) as write:
        for c in sorted(clauses.keys()):
            write("%s\n\n"%(clauses[c].strip()))

if "sortprolog.py" in sys.argv[0]:
    try:
        for x in sys.argv[1:]:
            k, v = x.split("=")
            print k, v
            if "src".startswith(k):
                src = v
            elif "dest".startswith(k):
                dest = v
        sortprolog(src, dest)
    except Exception as e:
        print e
        print "sortprolog src=<...> dest=<...>"
                
