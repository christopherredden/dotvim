dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
files=".vimrc"
folders="bundle colors"

echo "Installing .vimrc..."
for file in $files; do
    ln -s $dir/$file ~/$file
done

echo "Installing .vim files..."
mkdir -p ~/.vim
for folder in $folders; do
    echo ln -d $dir/.vim/$folder ~/.vim/$folder
done

echo "done."
