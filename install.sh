dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
files=".vimrc"
folders="bundle colors"

echo "Installing .vimrc..."
mkdir -p ~/.vim

for file in $files; do
    ln -s $dir/$file ~/$file
done

for folder in $folders; do
    ln -s $dir/$folder/ ~/.vim/$folder
done

echo "done."
