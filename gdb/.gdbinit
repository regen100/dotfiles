set auto-load local-gdbinit

alias exp = catch throw

python
import os
import subprocess
import sys

root = os.path.expanduser('~/.cache/gdb')
if not os.path.exists(root):
    os.makedirs(root)

dashboard = os.path.join(root, 'dashboard')
if not os.path.exists(dashboard):
    subprocess.call(['wget', '-O', dashboard, 'https://github.com/cyrus-and/gdb-dashboard/raw/v0.4.0/.gdbinit'])

bpp = os.path.join(root, 'Boost-Pretty-Printer')
if not os.path.exists(bpp):
    subprocess.call(['git', 'clone', 'https://github.com/ruediger/Boost-Pretty-Printer.git', bpp])
sys.path.insert(1, bpp)
import boost  # isort:skip
boost.register_printers()
end

source ~/.cache/gdb/dashboard
