#!/usr/bin/env bash

#install homebrew
#/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


#brew

#utils
brew list tmux &>/dev/null || brew install tmux
brew list curl &>/dev/null || brew install curl
brew list node &>/dev/null || brew install node

#caskss
brew cask install iterm2
brew cask install google-chrome
brew cask install skype
brew cask install visual-studio-code
brew cask install virtualbox
brew cask install intellij-idea-ce
brew cask install anaconda
brew cask install java
brew cask install pycharm
brew cask install libreoffice
brew cask install itsycal
brew cask install spectacle



