#!/bin/bash

echo "[*] Setting up terminal environment..."

# Install Homebrew (if not installed)
if ! command -v brew &> /dev/null; then
  echo "[*] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install required tools
echo "[*] Installing core packages (zsh, git, tmux, neovim)..."
brew install zsh git tmux neovim

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "[*] Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "[*] Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install Nerd Font (MesloLGS)
echo "[*] Installing Nerd Font (MesloLGS)..."
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font

# Copy dotfiles (only if not already existing)
echo "[*] Copying dotfiles (will skip existing files)..."
for file in .zshrc .p10k.zsh .tmux.conf; do
  if [ ! -f ~/$file ]; then
    echo "  → Copying $file"
    cp "$file" ~/
  else
    echo "  → Skipping $file (already exists)"
  fi
done

# Copy Neovim config
echo "[*] Copying Neovim config..."
mkdir -p ~/.config/nvim
cp -r nvim/* ~/.config/nvim/

# Fix potential permission issues
echo "[*] Fixing permission issues for Neovim cache directories..."
sudo chown -R $(whoami) ~/.cache/nvim ~/.local/share/nvim

echo "[✓] All done! You can now launch Neovim with 'nvim'"
echo "    (and run :Lazy sync if plugins did not install automatically)"
echo "    If this is a new terminal setup, also run: p10k configure"
