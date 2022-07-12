dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#echo "Installing .vimrc..."
#ln -s $dir/.vimrc ~/.vimrc
echo "Installing init.vim"
mkdir -p ~/.config/nvim
mkdir -p ~/.local/share/nvim/site/autoload
ln -s $dir/.vimrc ~/.config/nvim/init.vim

echo "Installing vim-plug..."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Installing Plugins..."
nvim +PlugInstall +qall

echo "done."
