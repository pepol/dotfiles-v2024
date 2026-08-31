# dotfiles
Configuration files v2.0

## Installation

To install the files, ensure GNU stow is available and then run

```bash
git clone git@github.com:pepol/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow -R --no-folding --dotfiles --adopt -t "$HOME" .
```

Then load the launchd agent that numbers workspaces and agents in the herdr
sidebar:

```bash
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/dev.herdr.sidebar-numbers.plist
```
