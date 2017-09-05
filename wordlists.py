import sys, re
from useful import *
from nltk.corpus import wordnet

def readWordList(ifile="Common Verbs _ List of 1000 Most Common Verbs.html", outsink=sys.stdout):
    entrypattern = re.compile('<a href="http://www.poetrysoup.com/dictionary/(?P<word>\w*)" title="Common Noun - \w*">')
    return [i.group("word") for i in entrypattern.finditer(open(ifile).read())]

def readWordLists(d=".", outsink=sys.stdout):
    fpattern = re.compile("Common \w* _ List of \d+ Most Common (?P<tag>\w*).html")
    entries = []
    for f in os.listdir(d):
        m = fpattern.match(f)
        if m:
            l = readWordList(f)
            tag = m.group("tag").lower()
            for word in l:
                if tag == "nouns":
                    entries.append("""
                    
word('%s', X) :-
    language@X -- english,
    X <> [nroot]."""%(word))
                elif tag == "verbs":
                    entries.append("""

word('%s', X) :-
    language@X -- english,
    X <> [tverb, -target, vroot]."""%(word))
                elif tag == "adjectives":
                    entries.append("""

word('%s', X) :-
    language@X -- english,
    X <> [adj]."""%(word))
    entries.sort()
    with safeout(outsink) as write:
        for word in entries:
            write(word)

patterns = [(re.compile("\s*(\([^\)]*\))|(;.*$)"), ""),
            (re.compile("n't"), " not"),
            (re.compile("'s"), " SS "),
            (re.compile("s'"), "s SS2 "),
            (re.compile("'|`"), " SQ "),
            (re.compile('"'), " DQ "),
            (re.compile("(?P<P>,|\.|:|-|/|_|%|\^)"), " \g<P> "),
            (re.compile("\s+"), " ")]

def tidydefn(defn, patterns=patterns):
    for pattern, replacement in patterns:
        defn = pattern.sub(replacement, defn)
    return defn.strip()

def isItAVerb(word, entries):
    for suffix in ["ed", "ing"]:
        if word.endswith(suffix):
            root = word[:-len(suffix)]
            if "%s-v"%(root) in entries or root in entries:
                return True
            if "%se-v"%(root) in entries or "%se"%(root) in entries:
                return True
            if len(root) > 3 and root[-1] == root[-2] and ("%s-v"%(root[:-1]) in entries or root[:-1] in entries):
                return True
    return False

def isItAnAdj(word, entries):
    if "%s-a"%(word) in entries or word in entries:
        return True
    return False

def wdnetList(outsink=sys.stdout):
    seenit = {}
    for w in re.compile("word\('?(?P<form>\w*)'?,").finditer(open('englishopen.pl').read()+open('englishclosed.pl').read()):
        seenit[w.group("form")] = True
    entries = {}
    for ss in sorted(wordnet.all_synsets()): 
        try:
            tag = ss.pos()
        except:
            tag = ss.pos
        if tag == "s":
            tag = "a"
        try:
            defn = tidydefn(ss.definition())
        except:
            defn = tidydefn(ss.definition)
        if not defn == '':
            defn = """
    definition@X -- '%s',"""%(defn)
        try:
            lemmaNames = ss.lemma_names()
        except:
            lemmaNames = ss.lemma_names
        allLemmaNames = []
        for word in lemmaNames:
            word = word.replace("'", "''")
            try:
                int(word[0])
                continue
            except:
                pass
            allLemmaNames.append(word)
        for word in sorted(allLemmaNames):
            if "_" in word or word in seenit or "-" in word or "%s-%s"%(word, tag) in seenit:
                continue
            if tag == "n":
                if word[0].islower():
                    entry = """
                    
word('%s', X) :- 
    language@X -- english,%s
    X <> [nroot]."""%(word, defn)
                else:
                    entry = """
                    
word('%s', X) :- 
    language@X -- english,%s
    X <> [np, inflected, -target]."""%(word, defn)
            elif tag == "v":
                entry = """

word('%s', X) :-
    language@X -- english,%s
    X <> [vroot, regularPast],
    uverb(X)."""%(word, defn)
            elif tag == "a":
                entry = """

word('%s', X) :-
    language@X -- english,%s
    X <> [aroot]."""%(word, defn)
            elif tag == "r":
                if word.endswith("ly") and "%s-a"%(word[:-2]) in seenit:
                    continue
                entry = """

word('%s', X) :-
    language@X -- english,%s
    X <> [adv]."""%(word, defn)
            else:
                raise Exception("No such tag: %s"%(tag))
            if word in entries:
                entries[word].append(entry)
            else:
                entries[word] = [entry]
            seenit["%s-%s"%(word, tag)] = True
    with safeout(outsink) as write:
        for word in sorted(entries.keys()):
            if (word.endswith("ing") or word.endswith("ed")) and isItAVerb(word, seenit):
                continue
            if word.endswith("ly") and isItAnAdj(word[:-2], seenit):
                continue
            for entry in entries[word]:
                if "X <> [nroot]" in entry and isItAnAdj(word, seenit):
                    entry = entry.replace("X <> [nroot]", "X <> [nroot, -target]")
                write(entry)
        write("""

:- include(englishopen).
""")
    return seenit
        
            
        
        
