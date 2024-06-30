#!/bin/bash

# sketchybar --default label.padding_left=6 \
#                      label.padding_right=6 \
#                      icon.padding_left=6 \
#                      icon.padding_right=6 \
#                      icon.font="$FONT:Bold:16.0" \
#                      background.height=30 \
#                      background.padding_right=4 \
#                      background.padding_left=4 \
#                      background.corner_radius=5

# sketchybar --add item spot_logo right \
#            --set spot_logo icon= \
#                            drawing=off \
#                            label.drawing=off \
#                            icon.color=0xff121219 \
#                            background.color=0xffEDC4E5

sketchybar --add item spot right \
           --set spot updates=on \
                      update_freq=1 \
                      icon.drawing=off \
                      updates=on \
                      script="$PLUGIN_DIR/spotify/scripts/spotifyIndicator.sh" \
                      label.color=$TEAL\
                      label.max_chars=35 \
                      background.color=$TRANSPARENT \
                      background.padding_left=-8 \
                      scroll_texts=on

                      # label.max_chars=45 \
                      #
