My god apple WHY

## Determining MacOS App Properties

- Script Editor -> Open Dictionary
In the dictionary:

Look under the app's top-level entries.

Look for terms like:

window

document

make new window

make new document

Figured it out, the following is key, specifically frontmostApp
```bash
tell application "System Events"
    set frontmostApp to name of first application process whose frontmost is true
end tell

```
