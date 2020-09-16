#!/bin/sh

set -e
set -x

P10K_CONFIG_URI=$1

if [ -e ~/.oh-my-zsh ]; then
  rm -rf ~/.oh-my-zsh
fi
echo step 1

# Install Oh My Zsh!
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o - | zsh

echo step 2

# Import the powerlevel10k configuration
[ -n "${P10K_CONFIG_URI}" ] && curl -fsSL -o .p10k.zsh ${P10K_CONFIG_URI}

echo step 3

# Install powerlevel10k theme
ZSH_CUSTOM_THEMES=~/.oh-my-zsh/custom/themes

echo step 4

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM_THEMES}/powerlevel10k/

echo step 5

echo "
# Enable powerlevel10k theme
source \"${ZSH_CUSTOM_THEMES}/powerlevel10k/powerlevel10k.zsh-theme\"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc

echo step 6

# Disable zsh theme
sed -i s/^ZSH_THEME=".*"/ZSH_THEME=""/ ~/.zshrc

echo step 7

# Free up drive space
cd ${ZSH_CUSTOM_THEMES}/powerlevel10k/
rm -rf .git .gitignore .gitattributes config

# Remove all gitstatusd that are not for Linux x64
cd gitstatus/bin
find . ! -name 'gitstatusd-linux-x86_64' -type f -exec rm -f {} +
