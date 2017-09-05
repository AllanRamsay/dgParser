import sys, re
from useful import *

def nocopies(ifile="testfracas.pl", out="testfracasNoCopies.pl"):
    seenIt = {}
    with safeout(out) as write:
        for line in open(ifile):
            if not line in seenIt:
                seenIt[line] = True
                write(line)
