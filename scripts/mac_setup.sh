echo "Start - mac_setup.sh"

echo -e "\nUpdate Brew packages"
brew update

# Node
echo -e "\nUpgrade Node by visiting the Node website"
node -v

echo -e "\nUpgrading NPM Packages"
sudo npm -g outdated
sudo npm -g upgrade --latest

# Rust
echo -e "\nUpgrading Rust"
rustup update
rustup -v

# Nvim 
echo -e "\nUpgrading NVIM"
brew upgrade nvim

# Alacritty

echo -e "\nEnd - mac_setup.sh"

