.PHONY: install

NAME = git-branchdir
GIT_CORE = $(shell git --exec-path)

all:
	@echo "\`make install\` to install."
	@echo "\`make uninstall\` to remove."

install:
	cp $(NAME)* $(GIT_CORE)/
	chmod 0755 $(GIT_CORE)/$(NAME)*

uninstall:
	rm -f $(GIT_CORE)/$(NAME)*

reinstall:
	$(MAKE) uninstall
	$(MAKE) install
