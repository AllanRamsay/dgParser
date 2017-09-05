import re, sys
from useful import *

def unknownwords(ifile="unknownwords.txt", outsink=sys.stdout):
    p = re.compile("No such word\((?P<word>\S*?)\)")
    u = {}
    for i in p.finditer(open(ifile).read()):
        u[i.group("word")] = True
    with safeout(outsink) as write:
        for w in sorted(u.keys()):
            write("""
word('%s', X) :-
    language@X -- english,
    X <> [uverb, past, inflected].
"""%(w))

def addQuotes(ifile, outsink=sys.stdout):
    if ifile == outsink:
        raise Exception("Don't use same file for input and output!")
    p = re.compile("word\((?P<root>[a-zA-Z]*),")
    with safeout(outsink) as write:
        write(p.sub("word('\g<root>',", open(ifile).read()))
        
