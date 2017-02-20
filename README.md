# my dotfiles

## Contents

- `.vimrc`: Vim configuration with some plugins I use, probably a bunch more that I don't use, and some settings I've accumulated. Uses Vundle.
- `burka_Xmodmap`: my idiosyncratic keyboard overlay which uses Caps Lock as a modifier for typing characters useful when programming.

## To install

```sh
# go to home directory
cd ~

# pull down this repo
git init .
git remote add origin git@github.com:durka/dotfiles
git pull origin master

# install Vundle
git clone git@github.com:VundleVim/Vundle.vim .vim/bundle/vundle
vim +PluginInstall +qall

# set up xmodmap
xmodmap burka_Xmodmap
```
