import os
import json
import subprocess
import ycm_core

flags = [
    '-x',
    'c++',
    '-std=c++14',
    '-Wall',
    '-Wextra',
    '-Werror',
]

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

        subprocess.call([
            "compdb", "-c", "compdb.complementers=headerdb", "-p", builddir,
            "update"
        ])
        buf = os.path.join(builddir, 'compile_commands.tmp.json')
        with open(buf, 'w') as f:
            subprocess.call(
                [
                    "compdb", "-c", "compdb.complementers=headerdb", "-p",
                    builddir, "list"
                ],
                stdout=f)
        os.rename(buf, dbname)

        return ycm_core.CompilationDatabase(builddir)
    return None


def FlagsForFile(filename, **kwargs):
    database = FindDatabase(filename)
    if not database:
        return {
            'flags': flags,
        }

    compilation_info = database.GetCompilationInfoForFile(filename)
    if not compilation_info:
        return None

    final_flags = list(compilation_info.compiler_flags_)
    return {
        'flags': final_flags,
        'include_paths_relative_to_dir': compilation_info.compiler_working_dir_
    }
