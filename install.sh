dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing .vimrc..."
ln -s $dir/.vimrc ~/.vimrc
echo "Installing init.vim"
ln -s $dir/.vimrc ~/.config/nvim/init.vim

echo "Cloning Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim

echo "Installing Plugins..."
vim +PluginInstall +qall
nvim +PluginInstall +qall

echo "done."
