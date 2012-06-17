.PHONY: install

NAME = git-branchdir
GIT_CORE = $(shell git --exec-path)
BIN = $(GIT_CORE)/$(NAME)

install:
	@cp $(NAME) $(BIN)
	@chmod 0755 $(BIN)
