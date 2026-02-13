`git clone https://github.com/calm-atom/nvim-light.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim`

<details><summary>Debian Install Steps</summary>

```
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl

# Neovim Stable
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage

# Neovim Nightly
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage

# Global Install
sudo mv ./nvim-linux-x86_64.appimage /usr/local/bin/nvim
sudo chmod +x /usr/local/bin/nvim
nvim --version

# User Only Install
chmod u+x nvim-linux-x86_64.appimage
mv nvim-linux-x86_64.appimage ~/.local/bin/nvim

## Make sure PATH is correct
export PATH="$HOME/.local/bin:$PATH"
nvim --version
```
</details>
