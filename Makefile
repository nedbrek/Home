.PHONY: all dummy

SRCS := diff.vim gdbinit tcl.vim tclshrc vimrc zshrc vim.tcl

all: $(SRCS)
	@echo "\nSuccess"

# make each repo file dependent on its effective location
# add a dummy dependency, so the rule always runs
diff.vim: ~/.vim/ftplugin/diff.vim dummy
gdbinit: ~/.gdbinit dummy
tcl.vim: ~/.vim/ftplugin/tcl.vim dummy
tclshrc: ~/.tclshrc dummy
vimrc: ~/.vimrc dummy
zshrc: ~/.zshrc dummy
vim.tcl: ~/.vim.tcl dummy

%:
	diff $@ $(word 1, $^)

