dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing init.lua"
mkdir -p ~/.config/nvim
ln -s $dir/init.lua ~/.config/nvim/init.lua

echo "done."
