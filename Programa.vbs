Set oShell = CreateObject ("Wscript.Shell")
Dim strArgs
strArgs = "cmd /c dll.bat"
oShell.Run strArgs, 0, false