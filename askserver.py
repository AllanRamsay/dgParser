#!/usr/bin/python
import sys
from servers import askserver

if "askserver.py" in sys.argv[0]:
    print askserver(sys.argv[1])
