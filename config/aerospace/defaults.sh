#!/bin/bash

# Disable windows opening animations
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# Move iwndows by dragging any part of window by holding ctl + cmd and dragging
defaults write -g NSWindowShouldDragOnGesture -bool true
