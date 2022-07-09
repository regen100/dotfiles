include Makefile.$(shell awk -F= '/^ID=/ {print $$2}' /etc/os-release)

.PHONY: all
all:

.PHONY: config
config:
	@git config user.name "$$(git log -1 --pretty=format:'%an')"
	@git config user.email "$$(git log -1 --pretty=format:'%ae')"
