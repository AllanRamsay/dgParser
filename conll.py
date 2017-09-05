import re, sys, os
from classes import *
from useful import *
import tb
import a2bw

if usingMac():
    BNC = './BNC'
    programs = "."
else:
    BNC = '/opt/info/courses/COMP34411/PROGRAMS/BNC'
    programs = "/opt/info/courses/COMP34411/PROGRAMS"
    
numPattern = re.compile("\d+\t(?P<num>\d+(\.\d+)?)\t")
                
def readconll(udt="ud-treebanks-v1.3", language="English", f="wholething.txt"):
    if language:
        conllfile = "%s/%s/UD_%s/%s"%(programs, udt, language, f)
    else:
        conllfile = "%s/%s/%s"%(programs, udt, f)
    specials = {"any":"DT",
                "most":"DX",
                "few":"DX",
                "least":"DX",
                "that":"THAT",
                "there":"TX",
                "to":"TO",
                "if":"IF",
                "his":"PX",
                "my":"PX",
                "our":"PX",
                "your":"PX",
                "their":"PX",
                "sure":"JJ",
                "ago":"NI",
                "of":"OF",
                # "has":"VH", "had":"VH", "have":"VH", "having":"VH",
                # "be":"VX", "am":"VX", "is":"VX", "are":"VX", "was":"VX", "were":"VX", "being":"VX", "been":"VX",
                }
    for p in ".:,?-":
        specials[p] = p
    preps = ['@', 'about', 'across', 'after', 'although', 'as', 'at', 'because', 'before', 'behind', 'besides', 'between', 'beyond', 'by', 'due', 'during', 'for', 'in', 'into', 'near', 'on', 'over', 'out', 'per', 'since', 'than', 'through', 'till', 'under', 'up', 'vs', 'vs.', 'whereas', 'while', 'with']
    for p in preps:
        specials[p] = "IN"
    sentences = []
    words = [WORD(form="AAAA", tag="AAAA", position=-1)]
    sentence = []
    allrelations = {}
    n = 0
    for line in codecs.open(conllfile, encoding="UTF-8").readlines():
        line = a2bw.convert(line.strip())
        if line.startswith("#"):
            continue
        m = numPattern.match(line)
        line = line.replace("``", '"').replace("''", '"')
        if line == "":
            if len(sentence) > 1:
                roots = 0
                relations = [RELATION(word.hd, word.position, rel=word.label) for word in sentence]
                for word in sentence:
                    allrelations[word.label] = True
                    if word.label == "root":
                        roots += 1
                if roots == 1:
                    preswap(sentence, relations)
                    tree = buildtree(relations, sentence)
                    leaves = sentence
                    sentence = SENTENCE(leaves, conllfile, n, n)
                    sentence.dtree = tree
                    sentence.leaves = leaves
                    relations = {r.dtr:r for r in relations}
                    sentence.goldstandard = relations
                    sentence.parsed = relations
                    sentences.append(sentence)
                    words += [WORD(form="ZZZZ", tag="ZZZZ", position=words[-1].position+1),
                              WORD(form="AAAA", tag="AAAA", position=-1)]
                else:
                    print "Skipping %s"%(relations)
            sentence = []
        else:
            word = line.split("\t")
            POSITION = 0
            FORM = 1
            TAG0 = 3
            TAG1 = 4
            HD = 6
            LABEL = 7
            form = word[FORM].replace('"', '\\"')
            if form == "":
                word[FORM] = "SP"
                form = word[FORM]
            if form[0] in "?.!*+-=":
                word[FORM] = form[0]
                form = word[FORM]
            if re.compile("\d+(\.\d+)").match(form):
                word[FORM] = "9999"
                form = word[FORM]
            tag = word[TAG1]
            if tag == "_":
                tag = word[TAG0]
            if tag == "NNP" or tag == "NNPS" or tag == "NP":
                tag = "PN"
            else:
                if language == "English":
                    word[FORM] = form.lower()
                else:
                    word[FORM] = form
                form = word[FORM]
            try:
                tag = specials[form]
            except:
                pass
            try:
                tag = specials[tag]
            except:
                pass
            try:
                word = WORD(form=word[FORM], tag=tag, label=word[LABEL], hd=int(word[HD])-1, position=int(word[POSITION])-1)
                sentence.append(word)
                words.append(word)
            except ValueError:
                pass
    if len(sentence) > 1:
        preswap(sentence, [RELATION(word.hd, word.position, rel=word.label) for word in sentence])
        tree = buildtree([RELATION(word.hd, word.position, rel=word.label) for word in sentence], sentence)
        sentence = SENTENCE(words, conllfile, n, n)
        sentence.dtree = tree
        sentence.leaves = words
        sentences.append(sentence)
    return sentences, words, allrelations

def swap(w, words, relations, swapdtrs=False):
    i = w.position
    h = words[w.hd]
    rx = False
    ry = False
    for r in relations:
        if r.dtr == h.position:
            rx = r
        if r.dtr == i:
            ry = r
    if rx and ry:
        if swapdtrs:
            for r in relations:
                if r.hd == h.position and not r.dtr == i:
                    r.hd = w.position
        rx.dtr = i
        ry.dtr = ry.hd
        ry.hd = i
    
def preswap(words, relations):
    for x in words:
        if False and x.tag == "TO" and x.hd >= 0:
            swap(x, words, relations)
        if False and x.tag == "IN" and x.label == "case" and x.hd >= 0:
            hd = words[x.hd]
            x.label = hd.label
            x.hd = hd.hd
            hd.hd = x.position
            hd.label = "dobj"
            relations[x.position] = RELATION(x.hd, x.position, rel=x.label)
            relations[hd.position] = RELATION(hd.hd, hd.position, rel=hd.label)
        if x.label == "cop" and x.hd >= 0:
            """
            the head of the cop is what would normally be
            the object, and the subj of that would normally
            be the subject of the cop
            """
            pred = x.hd
            for r in relations:
                if r.hd == pred and r.rel == "nsubj":
                    subj = words[r.dtr]
                    pred = words[pred]
                    cop = x
                    cop.hd = pred.hd
                    cop.label = pred.label
                    subj.hd = cop.position
                    subj.label = "nsubj"
                    pred.hd = cop.position
                    pred.label = "dobj"
                    for w in [cop, subj, pred]:
                        relations[w.position] = RELATION(w.hd, w.position, rel=w.label)
                    break

def swaprel(r, relations):
    print "swaprel(%s, %s)"%(r, relations)
    hd = r.hd
    dtr = r.dtr
    hdhd = relations[hd].hd
    print r, hd, dtr, hdhd
            
def postswap(relations, words):
    for x in relations:
        x = relations[x]
        if words[x.dtr].tag == "IN" and x.hd >= 0:
            swaprel(x, relations)
        if words[x.dtr].tag == "TO" and x.hd >= 0:
            swaprel(x, relations)
        if words[x.dtr].tag == "." and not x.hd == -1:
            swaprel(x, relations)

def allpostswaps(sentences):
    for s in sentences:
        print s.parsed
        print s.leaves
        postswap(s.parsed, s.leaves)
        postswap(s.goldstandard, s.leaves)
        
def red(s):
    return """<span style="fontsize: 0.5em; color:red;">%s</span>"""%(s)

def getmistagged(tagger, words, out=sys.stdout):
    with safeout(out) as out:
        out("<html><body>\n  <table>\n")
        tagged = tagger.tag(map(lambda x: x.form, words))
        for x, t0, t1 in map(lambda x: x[0]+[x[1]], zip(map(lambda x: [x.form, x.tag], words), map(lambda x: x[1], tagged))):
            if t0[:len(t1)] == t1:
                out("    <tr><td>%s</td><td>%s</td><td>%s</td></tr>\n"%(x, t0, t1))
            else:
                out("""    <tr><td>%s</td><td>%s</td><td>%s</td></tr>\n"""%(red(x), red(t0), red(t1)))
        out("  </table></body>\n</html>")

def getpreps(tagger):
    d = tagger.mxl.dict
    preps = {}
    for x in d:
        v = d[x]
        if not "-" in x and not "!" in x and 'IN' in v and len(v) > 1 and v['IN'] > 0.6:
            preps[x] = v
    return preps

def simplifytree(tree):
    if type(tree) == "WORD":
        return r"{\Rnode{N%s}{\footnotesize \textcolor{%s}{%s$_{%s}^{%s:%s}$}}}"%(tree.position, tree.colour, tree.form.replace("$", r"\$"), tree.label, tree.position, tree.tag.replace("$", r"\$"))
    else:
        return map(simplifytree, tree)

def plantlinks(tree):
    goldstandard = tree.goldstandard
    parsed = tree.parsed
    s = ""
    for x in parsed:
        if x in goldstandard:
            h0 = parsed[x]
            h1 = goldstandard[x]
            if not h0.hd == h1.hd:
                s += "\\ncline[linecolor=blue,linestyle=dashed]{->}{N%s}{N%s}\n"%(x, h1.hd)
    return s
            
def showtrees(trees, outfile=sys.stdout):
    with safeout(outfile) as out:
        out(r"""
\documentclass[10pt]{article}
\usepackage[a4paper,landscape]{geometry}
\usepackage{headerfooter}
\usepackage{defns}
\usepackage{lscape}
\usepackage{ifthen}
\usepackage{natbib}
\usepackage{lscape}
\usepackage{examples}
\usepackage{multicol}
\usepackage[usenames,dvipsnames,svgnames,table]{xcolor}
\usepackage{pstricks, pst-node, pst-tree}
\usepackage{graphicx}
\oddsidemargin=0in
\evensidemargin=0in
\begin{document}
\begin{examples}
""")

        for tree in trees:
            for leaf in tree.leaves:
                leaf.colour = "black"
            t = simplifytree(tree.dtree)
            d = depth(t)
            out(r"""

\newpage
\item %s

\noindent
DTREE (= Gold Standard)

\noindent
%s
"""%(" ".join(map(lambda x: x.form, tree.leaves)).replace("$", r"\$"),
     pstree(t, lsep=min(70, int(350.0/d)), tsep=20)))
            goldstandard = tree.goldstandard
            parsed = tree.parsed
            out(showTreeAsArcs(tree.leaves, goldstandard))
            for leaf in tree.leaves:
                i = leaf.position
                if i in goldstandard and i in parsed:
                    if not goldstandard[i].hd == parsed[i].hd:
                        leaf.colour = "red"
                elif i in goldstandard or i in parsed:
                    leaf.colour = "red"
            t = simplifytree(buildtree(tree.parsed, tree.leaves))
            d = depth(t)
            out(r"""         
\newpage
\noindent
PARSED

\noindent
%s
"""%(pstree(t, lsep=min(70, int(350/d)), tsep=20)))
            out(plantlinks(tree))
            out(showTreeAsArcs(tree.leaves, parsed))
        out(r"""
\end{examples}
\end{document}
""")
    if not outfile == sys.stdout:
        subprocess.Popen(["latex", outfile]).wait()
        subprocess.Popen(["dvipdf", outfile[:-4]]).wait()
        print "dvipdf complete"

from math import log
def showTreeAsArcs(leaves, relations):
    if len(leaves) > 10:
        return ""
    txt = "\n"
    for leaf in leaves:
        txt += r"""\Rnode{c%sleft}{}\Rnode{c%scentre}{%s}\Rnode{c%sright}{}\hspace{0.5in}
"""%(leaf.position, leaf.position, leaf.form, leaf.position)
    for r in relations.values():
        if r.hd > r.dtr:
            A = "left"
            B = "right"
        else:
            A = "right"
            B = "left"
        if abs(r.hd-r.dtr) == 1:
            txt += r"""\ncline[nodesepA=8pt,nodesepB=3pt,arrowscale=2]{->}{c%s%s}{c%s%s}
"""%(r.hd, A, r.dtr, B)
        else:
            txt += r"""\nccurve[angleA=%s,angleB=%s,nodesepA=8pt,nodesepB=3pt,ncurv=%.2f,arrowscale=2]{->}{c%s%s}{c%scentre}
"""%(90, 90, log(abs(r.hd-r.dtr))/2, r.hd, A, r.dtr)
    return txt

NPPN = {"NP":True, "PN":True}

def relabel(words):
    for word in words:
        if word.tag == "NP":
            word.tag = "PN"
            
def alltags(tagsets, tags=False):
    if tags == False:
        tags = {}
    if isinstance(tagsets, list):
        for t in tagsets:
            alltags(t, tags)
    else:
        for form in tagsets:
            if not form in tags:
                tags[form] = {}
            for tag in tagsets[form]:
                try:
                    tags[form][tag] += tagsets[form][tag]
                except:
                    tags[form][tag] = tagsets[form][tag]
    return tags

nametags = {"PN", "GW"}
def checknamelike(tags):
    for tag in tags:
        if not tag in nametags:
            return False
    return True

"""
If it's only ever been seen as either a name or GW, in either upper or lower case, then it's a name.
"""
def reallynames(tags):
    names = {}
    for form in tags:
        if checknamelike(tags[form]) and (not form.lower() in tags or checknamelike(tags[form.lower()])):
            names[form] = True
    return names

def fixnames(words, names):
    for w in words:
        if w.form in names and w.form.islower():
            w.form = w.form.title()
        if w.tag == "GW" and w.form.istitle():
            w.tag = "PN"

def fixdates(words, tags):
    dates = {}
    for x in words:
        if x.tag == "PN" and x.label == "TMP":
            dates[x.form] = True
    for x in words:
        if x.form in dates:
            x.tag = "DA"
        if x.form.lower() in dates and x.tag == "PN":
            x.form = x.form.title()
            x.tag = "DA"

def fixlower(words):
    for word in words:
        if word.form.istitle() and not word.tag == "PN" and not word.tag == "DA":
            word.form = word.form.lower()

def readandfixRound1(taglength=2):
    sentences1, pretagged1 = readconll()
    sentences2, pretagged2 = tb.readtb()
    tagset1, contexts1 = tagsandstuff(pretagged1)
    tagset2, contexts2 = tagsandstuff(pretagged2)
    tags = alltags([tagset1, tagset2])
    pretagged = pretagged1+pretagged2
    names = reallynames(tags)
    fixnames(pretagged, names)
    fixdates(pretagged, tags)
    fixlower(pretagged)
    return pretagged, [contexts1, contexts2], tags, [tagset1, tagset2], names
    
"""
If it's part of a sequence, all of which are currently tagged as names or GW, then it's a name.
"""
def couldbenames(words0, realnames, tags):
    i = 0
    words1 = []
    while i < len(words0):
        print i, "%.2f"%(float(i)/len(words0))
        word = words0[i]
        i += 1
        if word.form.istitle() and word.tag in nametags:
            seq = []
            for j in range(i, len(words0)):
                next = words0[j]
                if next.form.istitle() and next.tag in nametags:
                    seq.append(next)
                else:
                    break
            if seq == []:
                words1.append(word)
            else:
                i = j
                for w in [word]+seq:
                    words1.append(WORD(w.form, tag="PN", position=w.position))
        else:
            words1.append(word)
    return words1
                    
def tagsandstuff(words):
    tagset = {}
    contexts = {}
    mapctxt = lambda x: [x.form, x.tag]
    for i in range(len(words)):
        word = words[i]
        form = word.form
        if word.position==0 and form.istitle() and not word.tag in NPPN:
            form = form.lower()
        context = [map(mapctxt,words[i-5:i]), map(mapctxt, words[i:i+6])]
        try:
            contexts[form].append(context)
        except:
            contexts[form] = [context]
        if not form in tagset:
            tagset[form] = {}
        try:
            tagset[form][word.tag[:2]] += 1
        except:
            tagset[form][word.tag[:2]] = 1
    return tagset, contexts

def getmismatches(tagset1, tagset2, i=0, mismatches=False):
    if mismatches == False:
        mismatches = {}
    for form in tagset1:
        if form in tagset2:
            mm = []
            for tag in tagset1[form]:
                if not tag in tagset2[form]:
                    mm.append(tag)
            if not mm == []:
                if not form in mismatches:
                    mismatches[form] = [[],[]]
                mismatches[form][i] = mm
    return mismatches

def mergetagsets(words1, words2):
    uppercase = {}
    lowercase = {}
    mixedcase = {}
    for word in words1+words2:
        form = word.form
        if word.position==0 and form.istitle() and not word.tag in NPPN:
            uppercase[form.lower()] = True
        elif form.islower():
            lowercase[form] = True
    for form in uppercase:
        if form in lowercase:
            mixedcase[form] = True
    tagset1, contexts1 = tagsandstuff(words1, mixedcase)
    tagset2, contexts2 = tagsandstuff(words2, mixedcase)
    mismatches = getmismatches(tagset2, tagset1, i=0)
    mismatches=getmismatches(tagset1, tagset2, i=1, mismatches=mismatches)
    return mismatches, tagset1, tagset2, contexts1, contexts2

def gettagpairs(t1, t2, mismatches):
    tagpairs = []
    for form in mismatches:
        if mismatches[form] == [t1, t2]:
            tagpairs.append(form)
    return sorted(tagpairs)

def select(tagset, form=False, tag=False):
    if form == False and tag == False:
        raise Exception("one of form and tag must be specifie")
    if form:
        l = tagset[form]
        if tag:
            return [x for x in l if x.tag==tag]
        else:
            return l
    else:
        return [(x, tagset[x]) for x in tagset if tag in tagset[x]]

def both(tagsets):
    pairs = {}
    for tagset in tagsets:
        for form in tagset:
            if not form in pairs:
                pairs[form] = {}
            for tag in tagset[form]:
                pairs[form][tag] = True
    for form in pairs:
        if form.istitle() and form.lower() in pairs:
            print form, pairs[form]
            print form.lower(), pairs[form.lower()]

def showcontexts(x, contexts, tag=False):
    if isinstance(contexts, list):
        for c in contexts:
            showcontexts(x, c, tag=tag)
        return
    if not x in contexts:
        return
    if tag:
        contexts = [ctxt for ctxt in contexts[x] if [x, tag] == ctxt[1][0]]
    else:
        contexts = contexts[x]
    for ctxt in contexts:
        left = " ".join([c[0] for c in ctxt[0]])
        while len(left) < 50:
            left = " "+left
        right = " ".join([c[0] for c in ctxt[1][1:]])
        print left[-50:]+" %s "%(ctxt[1][0])+right
        
"""
Anything that occurs only as a capitalised NP or PN really is a name.

Anything that is capitalised and is preceded by something that is a name is a name.

Anything that is capitalised and is tagged as a name but doesn't meet either of the
above criteria should be decapitalised and retagged as its most common non-name tag.

Anything that is capitalised and is tagged as something other than a name should be
decapitalised.
"""

"""
Mistagging JJ as NN shouldn't have major consequences, because there are plenty of
examples of NNs as NN modifiers. So the parser is going to have to learn that one
anyway, and then when it sees "a fat man" as "a/DT, fat/NN, man/NN" it will treat
"fat" as a modifier of "man" (we hope).
"""

def getMistags(testing, tagger, tag0, tag1, n=3):
    tagged = tagger.tag(map(lambda x: x.form, testing))
    originaltags = map(lambda x: x.tag, testing)
    i = 0
    for a, b in zip(tagged, originaltags):
        if a[1] == tag0 and b == tag1:
            print "****"
            for x, y in zip(tagged[i-n:i+n+1], originaltags[i-n:i+n+1]):
                print x, y
        i += 1

def getExamples(tagged, tagseq):
    if isinstance(tagged[0], malt.WORD):
        tagged = map(lambda x: [x.form,x.tag], tagged)
    tags = [x[1] for x in tagged]
    for i in range(len(tagged)-len(tagseq)):
        if tags[i:i+len(tagseq)] == tagseq:
            print tagged[i:i+len(tagseq)]
