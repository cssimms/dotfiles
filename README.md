## Keeping my dotfiles orgnized

Just seems like a good idea as these are the result of months of small realizations and
tweaks and research.

### Setup

For setup, simply clone the repo into any directory, and create a soft link in the home
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
Notes that for fzf to work, you also have to
=======
## Keeping my dotfiles orgnized

Just seems like a good idea as these are the result of months of small realizations and
tweaks and research.

### Setup

For setup, simply clone the repo into any directory, and create a soft link in the home
directory.
`ln -s ./path/to/dotfiles/bash_profile ~/.bash_profile`

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

Notes that for fzf to work, you also have to
```
brew install fzf
brew install the_silver_searcher
```

#### Setup Colors
  Not even going to detail the steps, must download colorshemes from github,
  possibly creating `~/.config/nvim/colors/`, etc. etc.

