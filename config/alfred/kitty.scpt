tell application "System Events"
    set frontmostApp to name of first application process whose frontmost is true
end tell

set mouseSpaceId to do shell script "/opt/homebrew/bin/yabai -m query --spaces --space mouse | /opt/homebrew/bin/jq '.index'"
set focusedSpaceId to do shell script "/opt/homebrew/bin/yabai -m query --spaces --space | /opt/homebrew/bin/jq '.index'"

if mouseSpaceId is equal to focusedSpaceId then
    if frontmostApp is "Kitty" then
        tell application "Kitty"
            -- Since Kitty does not have native AppleScript support for creating a new window, we use keystrokes
            activate
            tell application "System Events" to keystroke "n" using {command down}
        end tell
    else
        -- Open a new instance of Kitty
        do shell script "open -a 'Kitty' --new"
        -- Delay to give yabai time to recognize the new window
        delay 0.3
        -- Adjust the window's properties with yabai
        do shell script "/opt/homebrew/bin/yabai -m window --toggle float --grid 4:4:1:1:2:2"
        do shell script "/opt/homebrew/bin/yabai -m window --toggle float --grid 4:4:1:1:2:2"
        do shell script "/opt/homebrew/bin/yabai -m window --space " & mouseSpaceId
    end if
else
    -- Focus on the space with the mouse
    do shell script "/opt/homebrew/bin/yabai -m space --focus " & mouseSpaceId
    -- Open a new instance of Kitty in the newly focused space
    do shell script "open -a 'Kitty' --new"
    delay 0.3
    -- Adjust the new window's properties with yabai
    do shell script "/opt/homebrew/bin/yabai -m window --toggle float --grid 4:4:1:1:2:2"
end if
