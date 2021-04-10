include Makefile.$(shell </etc/os-release awk -F= '/^ID=/ {print $$2}')
