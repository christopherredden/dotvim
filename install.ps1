#if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

echo "Installing nvim config..."
md -Force ~/AppData/Local/nvim
md -Force ~/AppData/Local/nvim-data/site/autoload

Start-Process powershell.exe -Verb runas -ArgumentList "-command &{New-Item -Path '~/AppData/Local/nvim/init.vim' -ItemType SymbolicLink -Value '$PSScriptRoot/.vimrc'}"
Start-Process powershell.exe -Verb runas -ArgumentList "-command &{New-Item -Path '~/AppData/Local/nvim/ginit.vim' -ItemType SymbolicLink -Value '$PSScriptRoot/ginit.vim'}"
 
echo "Installing vim-plug..."
Invoke-WebRequest "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -OutFile "~/AppData/Local/nvim-data/site/autoload/plug.vim"

echo "Installing Plugins..."
nvim +PlugInstall +qall

echo "done."
