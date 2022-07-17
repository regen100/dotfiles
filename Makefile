include Makefile.$(shell [[ "$$(uname -s)" == Linux ]] && awk -F= '/^ID=/ {print $$2}' /etc/os-release || uname -s)

.PHONY: all
all:

.PHONY: config
config:
	@git config user.name "$$(git log -1 --pretty=format:'%an')"
	@git config user.email "$$(git log -1 --pretty=format:'%ae')"
