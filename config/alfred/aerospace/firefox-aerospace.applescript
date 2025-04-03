tell application "System Events"
    set frontmostApp to name of first application process whose frontmost is true
end tell

if frontmostApp is "Firefox" then
  tell application "Firefox"
      activate
      tell application "System Events" to keystroke "n" using {command down}
  end tell
else
    do shell script "open -a 'Firefox' --new"
end if
