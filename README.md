# dotfiles
## only neovim config files written in lua for now.
Did not get the splash screen working yet.

My main areas of focus for this neovim setup are:
* Lua for neovim
* Swift for Vapor, also worth a look: https://github.com/kkharji/xbase
* XML / XSLT for CoreData aka xcdatamodel, Storyboard / XIB / NIB, EHF, and UBL
* Rust for Yew and RataTUI
* JSON for UI

### Install Packer
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
nvim ~/.config/nvim/lua/user/packer.lua
:so
:PackerSync
```

### Install tree-sitter-cli
```
cargo install tree-sitter-cli
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
brew install btop git neovim tmux lazygit lsd alacritty font-cousine-nerd-font rust
```

## arch GNU/Linux as pr example
```
yay -S btop git neovim tmux lazygit lsd alacritty font-cousine-nerd-font rust
```
