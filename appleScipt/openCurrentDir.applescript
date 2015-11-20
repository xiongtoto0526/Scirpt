tell application "Finder"
    set myWin to window 1
    set thePath to (quoted form of POSIX path of (target of myWin as alias))
    tell application "Terminal"
        activate
        tell window 1
            do script "cd " & thePath
        end tell
    end tell
end tell