# dotfiles
## only neovim config files written in lua for now.
Did not get the splash screen working yet.

### Inspired by

* https://youtu.be/w7i4amO_zaE
* https://youtu.be/KYDG3AHgYEs

My main areas of focus for this neovim setup are:
* Lua for neovim
* Swift for Vapor, also worth a look: https://github.com/kkharji/xbase; this is how I installed SourceKit-LSP under Ubuntu 22.04 LTS https://gist.github.com/TyrfingMjolnir/ad7bbc1940f1dcf218204b3149d488ed
* XML / XSLT for CoreData aka xcdatamodel, Storyboard / XIB / NIB, EHF, and UBL
* Rust for Yew and RataTUI
* JSON for UI

### Prerequisite Ubuntu 22.04
```Shell
apt-get install cargo ripgrep fd-find
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
nvm i --lts
npm i -g json
```

### Install lazygit

```sh
export LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | json tag_name | tr -d v)
curl -Lo /tmp/lazygit.tar.gz ""https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz""
sudo tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit
```

Verify the correct installation of lazygit:

```sh
lazygit --version
```

### Install Packer
```Shell
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
nvim ~/.config/nvim/lua/user/packer.lua
```
```vim
:so
:PackerSync
```

### Install tree-sitter-cli
```Shell
cargo install tree-sitter-cli
```
or the npm way
```Shell
npm i -g tree-sitter-cli
```

you also want to install

* https://github.com/BurntSushi/ripgrep
* https://github.com/sharkdp/fd

Eventually this repo will contain more stuff; in this case you may or may not desire to pull one or more folders specifically. https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository

#### Excerpt below: The steps to do a sparse clone are as follows:

```
mkdir <repo>
cd <repo>
git init
git remote add -f origin <url>
```

This creates an empty repository with your remote, and fetches all objects but doesn't check them out. Then do:

`git config core.sparseCheckout true`

Now you need to define which files/folders you want to actually check out. This is done by listing them in .git/info/sparse-checkout, eg:

```
echo "some/dir/" >> .git/info/sparse-checkout
echo "another/sub/tree" >> .git/info/sparse-checkout
```

If I interpret this correcly; the checkout for nvim should be as follows: `echo ".config/nvim/" >> .git/info/sparse-checkout`

Last but not least, update your empty repo with the state from the remote:

`git pull origin master`

# Platform specific

## macOS Sonoma as pr example
```
brew install ripgrep mtr btop git neovim tmux lazygit lsd kitty font-cousine-nerd-font rust vapor
```

## arch GNU/Linux as pr example
```
yay -S mtr btop git neovim tmux lazygit lsd kitty font-cousine-nerd-font rust
```

## debian GNU/Linux as pr example
```
apt-get install ripgrep fd-find mtr btop git neovim tmux lazygit lsd kitty fonts-croscore rust
```
