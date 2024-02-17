Output spawn_shell.gif
Set Shell "bash"
Set FontSize 16
Set Width 800
Set Height 600

Hide
Type "export EDITOR=vi && clear"
Enter
Show

Sleep 500ms
Type "bash spawn_shell.sh https://vimeo.com/71645046"
Sleep 500ms
Enter
Sleep 6s
Type "3"
Sleep 500ms
Enter
Sleep 2s
Type 'echo "$URL" # variables are present in the subshell even if not exported' Enter
Sleep 1s
Type 'yt-dlp --list-formats "$URL"' Enter
Sleep 4s
Ctrl+D
Sleep 1s
Type "2"
Sleep 500ms
Enter
Sleep 1s
Escape
Type "2WcW"
Sleep 500ms
Type "http-480p"
Escape
Sleep 500ms
Type "ZZ"
Sleep 14s
