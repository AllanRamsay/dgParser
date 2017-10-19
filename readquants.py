from useful import *
import re, sys, os
from nltk.corpus import wordnet as wn

BNC = "/Users/ramsay/BNC"

def findExamples(corpus=BNC, pattern=re.compile("""(\S*!!\S*\n){5}\S*!!some\n\S*!!(two|three|four|five|six|seven)\n(\S*!!\S*\n){5}""", re.DOTALL), subcorpus="", N=sys.maxint, examples=False, windowsize=5):
    if examples == False:
        examples = {}
    if isinstance(pattern, str):
        pattern = re.compile("""(\S*!!\S*\n){%s}%s(\S*!!\S*\n){%s}"""%(windowsize, pattern, windowsize), re.DOTALL)
    if os.path.isdir(corpus):
        for f in os.listdir(corpus):
            examples = findExamples(corpus=os.path.join(corpus, f), pattern=pattern, subcorpus="", N=N, examples=examples, windowsize=windowsize)
            if len(examples) > N:
                break
        return examples
    else:
        for i in pattern.finditer(open(corpus).read()):
            x = i.group(0).replace("\n", " ")
            y = re.compile("\S*!!").sub("", x)
            print y
            try:
                examples[y].append(corpus)
            except:
                examples[y] = [corpus]
            N += 1
            if len(examples) > N:
                break
        return examples

def countExamples(corpus=BNC, pattern=re.compile("""(\S*!!\S*\n){5}\S*!!some\n\S*!!(two|three|four|five|six|seven)\n(\S*!!\S*\n){5}""", re.DOTALL), subcorpus="", N=sys.maxint, examples=False, windowsize=5):
    if examples == False:
        examples = {}
    if isinstance(pattern, str):
        pattern = re.compile("""(\S*!!\S*\n){%s}%s(\S*!!\S*\n){%s}"""%(windowsize, pattern, windowsize), re.DOTALL)
    if os.path.isdir(corpus):
        print corpus
        for f in os.listdir(corpus):
            examples = countExamples(corpus=os.path.join(corpus, f), pattern=pattern, subcorpus="", N=N, examples=examples, windowsize=windowsize)
            if len(examples) > N:
                break
        return examples
    else:
        print corpus
        for i in pattern.finditer(open(corpus).read()):
            x = i.group(0).replace("\n", " ")
            y = re.compile("\S*!!").sub("", x).strip().lower()
            try:
                y1 = wn.morphy(y, "v")
                if y1:
                    y = y1
            except:
                pass
            try:
                examples[y] += 1
            except:
                examples[y] = 1
            N += 1
            if len(examples) > N:
                break
        return examples


