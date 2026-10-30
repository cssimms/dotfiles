## Keeping my dotfiles orgnized

Just seems like a good idea as these are the result of months of small realizations and
tweaks and research.

### Setup

For setup, clone the repo into any directory, and create a soft link in the home
directory.
`ln -s ./path/to/dotfiles/bash_profile ~/.bash_profile`

### VsCode
Been trying to play with VSCode recently, on mac you need to softlink these two files:
```
ln -s ./dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s ./dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
```
You will need to restart VSCode after symlinking the files.

#### For Nvim -
Requires a little more setup:

#### Install nvim and setup config files:
  `brew install nvim`
  `mkdir -p ~/.config/nvim/`
  `touch ~/.config/nvim/init.vim`
  `echo 'source ~/.nvimrc' > ~/.config/nvim/init.vim`

#### Install Plug
```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Note that for fzf to work, you also have to
```
brew install fzf
brew install the_silver_searcher
```

#### Setup Colors
  Not even going to detail the steps, must download colorshemes from github,
  possibly creating `~/.config/nvim/colors/`, etc. etc.


### Kitty + herdr
kitty runs as a dedicated herdr host: its `shell` is herdr,
and Cmd shortcuts send herdr's prefix (F12) plus a key. `kitty/herdr.conf` and `herdr/config.toml`
must agree on that prefix.

```
brew install herdr
brew install --cask kitty font-jetbrains-mono-nerd-font
./install-terminal.sh
```

The script symlinks `kitty/` to `~/.config/kitty` and `herdr/config.toml` into `~/.config/herdr/`
(only the toml; that directory also holds herdr's sockets, logs, and session state). Existing files
are moved aside with a `.bak-<timestamp>` suffix. `Cmd+Shift+N` opens a plain zsh window outside herdr.
