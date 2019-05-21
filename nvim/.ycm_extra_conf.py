import json
import os
import subprocess

import ycm_core

flags = [
    '-x',
    'c++',
    '-std=c++17',
    '-Wall',
    '-Wextra',
    '-Werror',
]

configfile = os.path.expanduser('~/.ycm_systemflags.txt')
if os.path.exists(configfile):
    with open(configfile) as fp:
        systemflags = [l.strip() for l in fp.readlines()]
else:
    systemflags = []

BUILD_DIRECTORIES = ['build']


def FindNearest(path, target, subdirs=[]):
    candidate = os.path.join(path, target)
    if os.path.exists(candidate):
        return candidate

    for subdir in subdirs:
        candidate = os.path.join(path, subdir, target)
        if os.path.exists(candidate):
            return candidate

    parent = os.path.dirname(os.path.abspath(path))
    if (parent == path):
        return None
    return FindNearest(parent, target, subdirs)


def FindDatabase(filename):
    root = os.path.dirname(os.path.realpath(filename))
    dbname = FindNearest(root, 'compile_commands.json', BUILD_DIRECTORIES)
    if dbname:
        builddir = os.path.dirname(dbname)
        with open(dbname) as fp:
            data = json.load(fp)
        filtered = []
        for target in data:
            if os.path.exists(target['file']):
                filtered.append(target)
        with open(dbname, 'w') as fp:
            json.dump(filtered, fp)

        buf = subprocess.check_output(["compdb", "-p", builddir, "list"])
        dbfile = os.path.join(builddir, 'compile_commands.json')
        with open(dbfile, 'wb') as f:
            f.write(buf)

        return ycm_core.CompilationDatabase(builddir)
    return None


def FlagsForFile(filename, **kwargs):
    database = FindDatabase(filename)
    if not database:
        return {'flags': flags}

    compilation_info = database.GetCompilationInfoForFile(filename)
    final_flags = list(compilation_info.compiler_flags_) or flags
    try:
        final_flags.remove('-isystem/usr/lib/zapcc/7.0.0/include')
    except ValueError:
        pass
    return {
        'flags': final_flags + systemflags,
        'include_paths_relative_to_dir': compilation_info.compiler_working_dir_
    }
