# dotfiles
Configuration files v2.0

## Installation

To install the files, ensure GNU stow is available and then run

```bash
git clone git@github.com:pepol/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow -R --no-folding --dotfiles --adopt -t "$HOME" .
```
