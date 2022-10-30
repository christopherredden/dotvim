dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing init.lua"
mkdir -p ~/.config/nvim
mkdir -p ~/.local/share/nvim/site/autoload
ln -s $dir/init.lua ~/.config/nvim/init.lua

echo "Installing vim-plug..."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Installing Plugins..."
nvim +PlugInstall +qall

echo "done."
