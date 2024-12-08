#!/bin/sh

/opt/homebrew/bin/aerospace workspace "$(opt/homebrew/bin/aerospace list-workspaces --monitor mouse --visible)" && opt/homebrew/bin/aerospace workspace next
