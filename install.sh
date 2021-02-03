# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Zsh
chsh -s `which zsh`
touch ~/.zshrc

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# dotfiles
git clone https://github.com/mu29/dotfiles
cp ~/Github/dotfiles/.zshrc ~/.zshrc
cp ~/Github/dotfiles/.vimrc ~/.vimrc
cp ~/Github/dotfiles/mu29.zsh-theme ~/.oh-my-zsh/themes/mu29.zsh-theme
sh ~/Github/dotfiles/fonts/install.sh

# Github
cd ~
mkdir Github

# rbenv
brew install rbenv
rbenv init

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
nvm install v12.20.1
curl -o- -L https://yarnpkg.com/install.sh | bash
