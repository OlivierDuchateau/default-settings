#!/usr/bin/env python3

import pathlib
import sys

# Variables from meson.add_install_script() function
xml_file = sys.argv[1]
src_dir = sys.argv[2]
dst_dir = sys.argv[3]

# We work with pathlib.Path object
p = pathlib.Path(dst_dir)
if not p.exists():
    p.mkdir(parents=True)
dst = p.joinpath(xml_file)

# We want a 'string' object
src = '{0}'.format(pathlib.Path(src_dir).joinpath(xml_file))

# Create symlink
# https://docs.python.org/3/library/pathlib.html#pathlib.Path.symlink_to
if isinstance(dst, pathlib.Path):
    dst.symlink_to(src)
