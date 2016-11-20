#!/usr/bin/python

from __future__ import print_function
from sys import argv
import re

input_file=argv[1]
min_funcs = argv[2:]

visited = set()
result = set()

functions = {}

name_re = re.compile("^function ([a-zA-Z0-9_]+)\(")
invocation_re = re.compile("(^|.* )([a-zA-Z0-9_]+)\(")

current_name = ""
current_function = []

for line in open(input_file, "r"):
    line = line.strip()
    name_match = name_re.match(line)
    if name_match is not None:
        functions[current_name] = current_function
        current_name = name_match.group(1)
        current_function = []
    else:
        current_function.append(line)
del functions[""]

print("Found", len(functions), "functions")

total_lines = {}
base_name_re = re.compile("^([a-zA-Z0-9_]+)__async[a-zA-Z0-9_]*")
for func, lines in functions.items():
    base_name_match = base_name_re.match(func)
    if base_name_match is None:
        base_name = func
    else:
        base_name = base_name_match.group(1)
    total_lines[base_name] = len(lines) + total_lines.get(base_name, 0)
largest_functions = list(total_lines.items())
largest_functions.sort(lambda x, y: y[1] - x[1])
print("Largest functions (may be inaccurate):")
for i in range(5):
    print(largest_functions[i])

while len(min_funcs) > 0:
    func = min_funcs.pop()
    if func in visited:
        continue
    print("Processing", func)
    visited.add(func)
    prev_async = False
    for line in functions[func]:
        if prev_async:
            if "FUNCTION_TABLE" in line:
                result.add(func)
            else:
                invocation_match = invocation_re.match(line)
                if invocation_match is None:
                    print("Strange invocation in", func)
                    result.add(func)
                    continue
                else:
                    min_funcs.append(invocation_match.group(2))
        prev_async = "alloc_async" in line

print("'" + "','".join(f[1:] for f in result) + "'")