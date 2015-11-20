tell application "Xcode"
activate
delay 3
tell active workspace document
    set my_project to (get first project)
    tell my_project

        tell application "System Events"
            keystroke "d" using {command down}
            delay 0.5
            tell application process "Xcode"
                delay 1.0E-3

                click button "Duplicate Only" of window 1


            end tell

        end tell

    end tell
end tell
end tell