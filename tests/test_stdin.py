#!/usr/bin/env python3
"""
run Meson tests with programs that takes inputs from a file into stdin
"""
import argparse
import subprocess
import sys
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument("exe", help="name of executable to run")
p.add_argument("filein", help="filename to put into program stdin")
p.add_argument("--args", help="optional arguments")
P = p.parse_args()

exe = Path(P.exe).expanduser().resolve()
if not exe.is_file():
    print("executable", exe, "not found", file=sys.stderr)
    raise SystemExit(77)

filein = Path(P.filein).expanduser().resolve()
if not filein.is_file():
    print("input file", filein, "not found", file=sys.stderr)
    raise SystemExit(77)

args = P.args.strip("\"'").split() if P.args else []

subprocess.check_call([str(exe)] + args, stdin=filein.open(), universal_newlines=True)
