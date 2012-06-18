.PHONY: install

NAME = git-branchdir
GIT_CORE = $(shell git --exec-path)

all:
	@echo "\`make install\` to install."
	@echo "\`make uninstall\` to remove."

install:
	cp $(NAME)* $(GIT_CORE)/
	chmod 0755 $(GIT_CORE)/$(NAME)*
	@echo "(Optional) Source gcd.sh in your .bashrc to install the 'gcd' function to easily change directories between branchdirs."
	@echo "(Optional) Source git-branchdir-completion.sh in your .bashrc to add tab completion for 'git branchdir'."

uninstall:
	rm -f $(GIT_CORE)/$(NAME)*

reinstall:
	$(MAKE) uninstall
	$(MAKE) install
