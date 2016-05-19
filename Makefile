DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) elisp
EXCLUSIONS := .git .gitignore $(wildcard *~)
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

all: install

help:
	@echo "make list           #=> Show dot files in this repo"
	@echo "make install        #=> Create symlink to home directory"
	@echo "make update         #=> Fetch changes for this repo"
	@echo "make clean          #=> Remove the dot files and this repo"

list:
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

install:
	@echo 'Making symlinks to home directory...'
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@echo 'done.'

update:
	git pull origin master

clean:
	@echo 'Deleting symlinks from home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
	@echo 'done'
