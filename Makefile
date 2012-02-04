all:
	diff diff.vim ~/.vim/ftplugin
	diff tcl.vim ~/.vim/ftplugin
	diff vimrc ~/.vimrc
	diff vim.tcl ~/.vim.tcl
	diff zshrc ~/.zshrc
	@echo "\nSuccess"

