import re, sys
from useful import *

pattern = re.compile("<(p |q|h).*?>(?P<text>.*?)</", re.DOTALL)
punc = re.compile("(\?|\.)")

def fixpunc(s):
    return punc.sub(r" \g<0>", s)

def fix(s):
    return fixpunc(replaceAll(s, [["&apos;s", " APOS"]]))

def readFracas(ifile="fracas.xml", outsink=sys.stdout):
   return [fix(i.group("text").strip()) for i in pattern.finditer(open(ifile).read())]
        
def parseAll(examples, parser):
    for example in examples:
        print example
        parser.parse(example).showDTree()

def patchdict(parser):
    patches = {"tenors": {"NN":1},
               "tenor": {"NN":1},
               "Italian":{"JJ":0.9, "NN":0.1},
               "Swedish":{"JJ":0.9, "NN":0.1},
               }
    d = parser.tagger.basetagger.dict
    for word in patches:
        d[word] = patches[word]
        
