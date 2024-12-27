#!/bin/bash

output=$(swaymsg -t get_outputs | jq -r '.[] | select(.active) | .name')

