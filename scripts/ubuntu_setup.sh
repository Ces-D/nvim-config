echo "Start - ubuntu_setup.sh"
echo "Edit this file to specify what you want to install"
## updates the list of available packages and their versions, but it does not install or upgrade any packages.
echo -e "\nUpdating package lists"
sudo apt-get update
sudo snap refresh

## actually installs newer versions of the packages you have. After updating the lists, the package manager knows about available updates for the software you have installed. 
echo -e "\nUpgrading packages"
sudo apt-get upgrade

# Node
echo -e "\nUpgrading Node"
echo -e "\nUpdating NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install node # upgrade to latest version of node and npm

sudo npm -g outdated
sudo npm -g upgrade --latest

# Python
echo -e "\nUpgrading Python"
echo -e "\nUpdating UV"
uv self update

## Rust
echo -e "\nUpgrading Rust"
rustup update
rustup -v

# Nvim 
echo -e "\nUpgrading Neovim"
echo -e "\nDownload tarbell then extract it"
echo -e "\nRun sudo mv nvim-linux63 /usr/local/bin"
echo -e "\nRun sudo ln -s /usr/local/bin/nvim-linux64/bin/nvim /usr/local/bin/nvim"
echo -e "\n This is a manual process to get the latest version of nvim using tarbell"

# Alacritty
echo -e "\nUpgrading Alacritty"
cargo install alacritty
sudo cp /home/$(whoami)/.cargo/bin/alacritty /usr/local/bin

# Like clean, autoclean clears out the local repository of retrieved package files. The difference is that it only removes package files that can no longer be downloaded, and are largely useless.
echo -e "\nCleaning up"
sudo apt-get  autoclean

# is used to remove packages that were automatically installed to satisfy dependencies for some package and that are no longer needed.
echo -e "\nRemoving unused packages"
sudo apt autoremove

echo "End - ubuntu_setup.sh"

