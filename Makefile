.PHONY: all

SRCS := diff.vim tcl.vim tclshrc vimrc zshrc vim.tcl

all: $(SRCS)
	@echo "\nSuccess"

# make each repo file dependent on its effective location
diff.vim: ~/.vim/ftplugin
tcl.vim: ~/.vim/ftplugin
tclshrc: ~/.tclshrc
vimrc: ~/.vimrc
zshrc: ~/.zshrc
vim.tcl: ~/.vim.tcl

%:
	diff $@ $^

