#!/bin/sh

# jajajasalu2's setup script

# Repository links
VIMRC_GIT="https://github.com/jajajasalu2/.vimrc"
NEOVIM_GIT="https://github.com/neovim/neovim"
TMUXCONF_GIT="https://github.com/gpakosz/.tmux"
VIMPLUG_DLD_LINK="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# Aliases
GIT=git
NVIM=nvim
CURL=curl
MAKE=make

# Other vars
USERHOME=$HOME

install_neovim() {
	echo "Cloning neovim from $NEOVIM_GIT..."
	$GIT clone $NEOVIM_GIT "$USERHOME/repos/neovim"

	echo "Installing neovim..."
	(cd "$USERHOME/repos/neovim" && $MAKE install)
}

install_vimrc() {
	echo "Cloning .vimrc from $VIMRC_GIT..."
	$GIT clone $VIMRC_GIT "$USERHOME/repos/.vimrc"

	echo "Copying .vimrc to $USERHOME..."
	cp "$USERHOME/repos/.vimrc/.vimrc" "$USERHOME/.vimrc"

}

install_vimplug() {
	echo "Curling vim-plug from $VIMPLUG_DLD_LINK..."
	$CURL -fLo ~/.vim/autoload/plug.vim \
		--create-dirs $VIMPLUG_DLD_LINK || {
		echo "Couldn't curl vim-plug. Plugins were not installed.";
		return
	}

	echo "Downloading (Neo)Vim plugins..."
	$NVIM --headless +PlugInstall +q
}

setup_vim() {
	install_neovim
	install_vimrc
	install_vimplug
}

setup_tmux() {
	echo "Cloning .tmux from $TMUXCONF_GIT..."
	$GIT clone $TMUXCONF_GIT "$USERHOME/repos/.tmux"

	echo "Copying tmux confs to $USERHOME..."
	cp "$USERHOME/repos/.tmux/.tmux.conf" "$USERHOME/.tmux.conf"
	cp "$USERHOME/repos/.tmux/.tmux.conf.local" "$USERHOME/.tmux.conf.local"
}

setup_all() {
	setup_vim
	setup_tmux
	setup_zsh
}


# ------------------------------------------------------------------

echo "jajajasalu2's New machine setup."
echo "Run this script with sudo."
echo "Make sure to install git, make and curl before running this script."

# pre-setup
command -v $GIT >/dev/null 2>&1 || {
	echo >&2 "Can't find git. Aborting.";
	exit 1;
}
command -v $CURL >/dev/null 2>&1 || {
	echo >&2 "Can't find curl. Aborting.";
	exit 1;
}
command -v $MAKE >/dev/null 2>&1 || {
	echo >&2 "Can't find make. Aborting.";
	exit 1;
}
mkdir -p "$USERHOME/repos"

# options
case ${1} in
	"all") setup_all
	;;
	"vimall") setup_vim
	;;
	"neovim") install_neovim
	;;
	"vimrc") install_vimrc
	;;
	"vimplug") install_vimplug
	;;
	"tmux") setup_tmux
	;;
esac
