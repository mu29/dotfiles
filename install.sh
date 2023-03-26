# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Github
cd ~
mkdir Github

# Clone dotfiles
cd ~/Github
git clone https://github.com/mu29/dotfiles
sh dotfiles/fonts/install.sh
cp dotfiles/mu29.zsh-theme ~/.oh-my-zsh/themes/mu29.zsh-theme
cp dotfiles/.zshrc ~/.zshrc
source ~/.zshrc
cd ~

# rbenv
brew install rbenv
echo '' >> ~/.zshrc
echo '# rbenv' >> ~/.zshrc
echo 'eval "$(~/.rbenv/bin/rbenv init - zsh)"' >> ~/.zshrc
source ~/.zshrc

rbenv install 2.7.6
rbenv global 2.7.6
rbenv rehash

# Cocoapods
gem install cocoapods

# nvm
brew install nvm
mkdir ~/.nvm
echo '' >> ~/.zshrc
echo '# nvm' >> ~/.zshrc
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm' >> ~/.zshrc
echo '  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion' >> ~/.zshrc
source ~/.zshrc

nvm install 16.19.1
