#!/bin/bash

# Colors
GREEN="\033[1;32m"
NC="\033[0m"

# Update & install dependencies
echo -e "${GREEN}[*] Updating packages...${NC}"
pkg update -y && pkg upgrade -y

# Install required packages
echo -e "${GREEN}[*] Installing dependencies...${NC}"
pkg install -y zsh git toilet figlet ruby
gem install lolcat

# Install Oh My Zsh
echo -e "${GREEN}[*] Installing Oh My Zsh...${NC}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set theme to powerlevel10k
echo -e "${GREEN}[*] Setting Powerlevel10k theme...${NC}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k

# Setup Vampire-Tools directories
echo -e "${GREEN}[*] Creating Vampire-Tools directories...${NC}"
mkdir -p ~/Vampire-Tools/recon
mkdir -p ~/Vampire-Tools/ddos
mkdir -p ~/Vampire-Tools/exploits
mkdir -p ~/Vampire-Tools/scripts

# Update .zshrc with custom config
echo -e "${GREEN}[*] Configuring .zshrc...${NC}"
cat > ~/.zshrc << 'EOF'
# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Custom Banner
clear
toilet -f slant "Vampire Squad" | lolcat
echo -e "\e[1;34m        by Muhammad Shourov\e[0m" | lolcat

# Aliases for tools navigation
alias tools='cd ~/Vampire-Tools'
alias recon='cd ~/Vampire-Tools/recon'
alias ddos='cd ~/Vampire-Tools/ddos'
alias exploits='cd ~/Vampire-Tools/exploits'
alias scripts='cd ~/Vampire-Tools/scripts'
alias cls='clear'
EOF

# Set zsh as default shell for Termux
echo "zsh" >> ~/.bashrc

# Done
echo -e "\n${GREEN}[+] Vampire Terminal installed! Restart Termux to see the magic.${NC}"
exec zsh
