dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
files=".vimrc"

echo "Installing .vimrc..."
for file in $files; do
    ln -s $dir/$file ~/$file
done

echo "Cloning Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "Installing Plugins..."
vim +PluginInstall +qall

echo "done."
