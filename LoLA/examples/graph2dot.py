#!/usr/bin/env python

import sys
import os
import tempfile

states = []
edges = []
current_state = None
annotations = dict()

for line in sys.stdin:
    line = line.strip()
    if "STATE" in line:
        current_state = line.split()[1]
        states.append(current_state)
        continue

    if "->" in line:
        label = line.split()[0]
        target_state = line.split()[2]
        edges.append((current_state,label,target_state))
        continue

    if " : " in line:
        line = line.replace(",", "")
        place = line.split()[0]
        tokens = int(line.split()[2])

        if not current_state in annotations:
            annotations[current_state] = []
        
        annotations[current_state].append((place, tokens))


dot = "digraph D {\n"

dot += "node [fontname=Helvetica; fontsize=9];\n"
dot += "edge [fontname=Helvetica; fontsize=9];\n"
dot += "init [label=\"\"; fixedsize=true; width=0.1; height=0.1; style=invis]\n"

for state in states:
    annotation = "%s" % state
    if state in annotations:
        annotation_list = []
        for entry in annotations[state]:
            annotation_list.append("%s:%d" % (entry[0], entry[1]))
        annotation = "\\n".join(annotation_list)

    dot += "  state%s [label=\"%s\"];\n" % (state, annotation)
dot += "\n"

dot += "  init -> state0;\n"
for edge in edges:
    (source, label, target) = edge
    dot += "  state%s -> state%s [label=\"%s\"];\n" % (source, target, label)

dot += "}\n"


dotfile = tempfile.NamedTemporaryFile(delete=False)
dotfilename = dotfile.name
dotfile.write(dot)
dotfile.close()

if len(sys.argv) > 1:
    outname = sys.argv[1]
else:
    outname = "out"

os.system("dot %s -Tpng -o %s.png" % (dotfilename, outname))
os.remove(dotfilename)
