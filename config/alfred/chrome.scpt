tell application "System Events"
    set frontmostApp to name of first application process whose frontmost is true
end tell

set mouseSpaceId to do shell script "/opt/homebrew/bin/yabai -m query --spaces --space mouse | /opt/homebrew/bin/jq '.index'"
set focusedSpaceId to do shell script "/opt/homebrew/bin/yabai -m query --spaces --space | /opt/homebrew/bin/jq '.index'"


-- If Chrome is frontmost, create a new window
if mouseSpaceId is equal to focusedSpaceId then
    if frontmostApp is "Google Chrome" then
        tell application "Google Chrome"
            make new window
        end tell
    else
        do shell script "open -a 'Google Chrome' --new"
        -- delay so yabai can focus on window
        delay 0.3
        -- running this command twice accounts for it not opening in a manner yabai can understand
        do shell script "/opt/homebrew/bin/yabai -m window --toggle float --grid 4:4:1:1:2:2"
	      do shell script "/opt/homebrew/bin/yabai -m window --toggle float --grid 4:4:1:1:2:2"
        do shell script "/opt/homebrew/bin/yabai -m window --space " & mouseSpaceId
      end if
else
    do shell script "/opt/homebrew/bin/yabai -m space --focus " & mouseSpaceId
    do shell script "open -a 'Google Chrome' --new"
    do shell script "/opt/homebrew/bin/yabai -m window --toggle --grid"
end if
