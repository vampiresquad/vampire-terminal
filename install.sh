#!/bin/bash

# ==========================================
# Ultimate Termux Setup & Hacking Toolkit
# Created for Vampire Squad by Muhammad Shourov
# ==========================================

# --- কালার কোড ---
R='\033[1;31m'   # Red
G='\033[1;32m'   # Green
Y='\033[1;33m'   # Yellow
B='\033[1;34m'   # Blue
C='\033[1;36m'   # Cyan
W='\033[0m'      # White (Reset)

# --- কাস্টম ব্যানার (শুধু ইন্সটলেশনের সময় দেখানোর জন্য) ---
show_banner() {
    clear
    echo -e "${C}================================================================${W}"
    echo -e "${B}  _   _                 _            _____                       _  ${W}"
    echo -e "${B} | | | |               (_)          / ____|                     | | ${W}"
    echo -e "${B} | | | | __ _ _ __ ___  _ _ __ ___ | (___   __ _ _   _  __ _  __| | ${W}"
    echo -e "${B} | | | |/ _\` | '_ \` _ \| | '__/ _ \ \___ \ / _\` | | | |/ _\` |/ _\` | ${W}"
    echo -e "${B} \ \_/ / (_| | | | | | | | | |  __/ ____) | (_| | |_| | (_| | (_| | ${W}"
    echo -e "${B}  \___/ \__,_|_| |_| |_|_|_|  \___||_____/ \__, |\__,_|\__,_|\__,_| ${W}"
    echo -e "${B}                                              | |                   ${W}"
    echo -e "${B}                                              |_|                   ${W}"
    echo -e "${C}================================================================${W}"
    echo -e "${G}         Advanced Termux Environment & Toolkit Setup            ${W}"
    echo -e "${G}                 Created by Muhammad Shourov                    ${W}"
    echo -e "${C}================================================================${W}\n"
}

# --- লাইভ প্রোগ্রেস স্পিনার ---
spin() {
    local pid=$1
    local msg=$2
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${Y}[${spin:$i:1}]${W} ${C}%s...${W}" "$msg"
        sleep 0.1
    done
    wait $pid
    local status=$?
    if [ $status -eq 0 ]; then
        printf "\r${G}[✓]${W} ${C}%-40s${W} ${G}Completed!${W}\n" "$msg"
    else
        printf "\r${R}[✗]${W} ${C}%-40s${W} ${R}Failed!${W}\n" "$msg"
    fi
}

# --- এরর ফিক্সার এবং ইন্টারনেট চেক ---
system_check() {
    echo -en "${Y}[*] Checking internet connection...${W}"
    if ping -q -c 1 -W 1 google.com >/dev/null 2>&1; then
        echo -e "\r${G}[✓] Internet connected!             ${W}"
    else
        echo -e "\r${R}[!] No internet connection! Please check your network.${W}"
        exit 1
    fi

    echo -en "${Y}[*] Fixing broken packages...${W}"
    dpkg --configure -a >/dev/null 2>&1
    apt --fix-broken install -y >/dev/null 2>&1
    echo -e "\r${G}[✓] System errors fixed (if any).   ${W}"
}

show_banner
system_check

# --- স্টোরেজ পারমিশন ---
if [ ! -d "$HOME/storage" ]; then
    echo -e "${Y}[*] Requesting storage access... Please allow on screen.${W}"
    termux-setup-storage
    sleep 3
fi

echo -e "\n${B}--- [ Phase 1: System Update ] ---${W}"
(pkg update -y && pkg upgrade -y) >/dev/null 2>&1 &
spin $! "Updating & Upgrading Repositories"

echo -e "\n${B}--- [ Phase 2: Installing Core Packages ] ---${W}"
CORE_TOOLS=(
    "git" "curl" "wget" "nano" "unzip" "tar" "jq"
    "python" "php" "ruby" "perl" "nodejs" "clang" "make"
    "nmap" "hydra" "openssh" "sqlmap" "neofetch"
    "zsh" "toilet" "figlet" "libffi" "openssl"
)

for tool in "${CORE_TOOLS[@]}"; do
    if ! command -v $tool >/dev/null 2>&1; then
        (pkg install -y $tool) >/dev/null 2>&1 &
        spin $! "Installing $tool"
    else
        printf "${G}[✓]${W} ${C}%-40s${W} ${G}Already Installed${W}\n" "Installing $tool"
    fi
done

if ! command -v lolcat >/dev/null 2>&1; then
    (gem install lolcat) >/dev/null 2>&1 &
    spin $! "Installing Lolcat (Ruby Gem)"
fi

echo -e "\n${B}--- [ Phase 3: Python Dependencies ] ---${W}"
(pip install requests colorama bs4) >/dev/null 2>&1 &
spin $! "Installing basic Python modules"

echo -e "\n${B}--- [ Phase 4: Vampire Squad Toolkit ] ---${W}"
TOOL_DIR="$HOME/Vampire_Tools"
mkdir -p "$TOOL_DIR"

VAMPIRE_REPOS=(
    "https://github.com/vampiresquad/VS-Encrypt-Elite.git"
    "https://github.com/vampiresquad/VortexWordGen.git"
    "https://github.com/vampiresquad/ShadowZip-X.git"
    "https://github.com/vampiresquad/Ip-Tracker.git"
)

for repo in "${VAMPIRE_REPOS[@]}"; do
    repo_name=$(basename "$repo" .git)
    if [ ! -d "$TOOL_DIR/$repo_name" ]; then
        (git clone "$repo" "$TOOL_DIR/$repo_name") >/dev/null 2>&1 &
        spin $! "Cloning $repo_name"
    else
        printf "${G}[✓]${W} ${C}%-40s${W} ${G}Already Exists${W}\n" "Cloning $repo_name"
    fi
done

echo -e "\n${B}--- [ Phase 5: Terminal Beautification & Banner ] ---${W}"

# টার্মাক্সের ডিফল্ট বোরিং মেসেজ (motd) রিমুভ করা
(rm -f /data/data/com.termux/files/usr/etc/motd) >/dev/null 2>&1 &
spin $! "Removing default Termux greeting"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    (RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)") >/dev/null 2>&1 &
    spin $! "Installing Oh My Zsh"
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    (git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k) >/dev/null 2>&1 &
    spin $! "Adding Powerlevel10k Theme"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    (git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions) >/dev/null 2>&1 &
    spin $! "Adding Auto-suggestions Plugin"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    (git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting) >/dev/null 2>&1 &
    spin $! "Adding Syntax Highlighting Plugin"
fi

# --- পারমানেন্ট ব্যানার সহ .zshrc কনফিগারেশন ---
(
cat > ~/.zshrc << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting command-not-found)

source $ZSH/oh-my-zsh.sh

# ==========================================
# PERMANENT VAMPIRE SQUAD BANNER
# ==========================================
clear
toilet -f slant "Vampire Squad" | lolcat
echo -e "\e[1;34m              © Muhammad Shourov\e[0m"
echo -e "\e[1;36m       [ Welcome to the Vampire Zone ]\e[0m\n"

# Alias for tools
alias mytools="cd ~/Vampire_Tools && ls -la"
EOF
) >/dev/null 2>&1 &
spin $! "Setting up permanent Vampire Squad Banner"

# --- ডিফল্ট শেল সেটআপ ---
chsh -s zsh >/dev/null 2>&1
if ! grep -q "exec zsh" ~/.bashrc; then
    echo "exec zsh" >> ~/.bashrc
fi

# --- ফিনিশিং ---
echo -e "\n${C}================================================================${W}"
echo -e "${G}[+] Installation Successfully Completed!${W}"
echo -e "${Y}[*] Your permanent banner has been set.${W}"
echo -e "${Y}[*] Type ${G}mytools${Y} in terminal to access your repos quickly.${W}"
echo -e "${C}================================================================${W}\n"
sleep 2

# নতুন টার্মিনাল চালু করা
exec zsh
