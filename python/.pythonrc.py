from __future__ import print_function


def setup():
    import sys
    import pprint

    try:
        from colorama import init, Fore
        init()
        sys.ps1 = Fore.YELLOW + '>>> ' + Fore.RESET
        sys.ps2 = Fore.YELLOW + '... ' + Fore.RESET
        color = True
    except ImportError:
        color = False

    def displayhook(value):
        if value is not None:
            __builtins__._ = value

            if color:
                print(Fore.LIGHTBLACK_EX, end='')

            pprint.pprint(value)

            if color:
                print(Fore.RESET, end='')

    sys.displayhook = displayhook


setup()
del setup
