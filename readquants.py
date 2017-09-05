from useful import *
import re, sys, os

BNC = "/Users/ramsay/BNC"
p1 = re.compile("""(AT0|DT0)!!(?P<Q>\S*)\n((PRF!!of\nAT0!!the)|((DPS|AT0)!!.*))
""", re.DOTALL)
p2 = re.compile("""(AT0|DT0)!!(?P<Q>\S*).*""", re.DOTALL)
def readquants(corpus=BNC, subcorpus="", N=-1):
    tags0 = {}
    tags1 = {}
    l0 = ""
    l1 = ""
    for i, l in enumerate(readlines(os.path.join(corpus, subcorpus))):
        try: 
            incTable(p1.match(l0+l1+l).group("Q").lower(), tags1)
        except:
            try:
                q = p2.match(l0+l1+l).group("Q").lower()
                if q == "an":
                    q ="a"
                incTable(q, tags0)
                if m == "all":
                    print l0+l1+l
            except: 
                pass
        if i == N:
            return tags0, tags1
        l0 = l1
        l1 = l
    return tags0, tags1
