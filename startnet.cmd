powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

wpeinit
wpeutil disablefirewall

X:\Windows\system32\WindowsPowerShell\v1.0\powershell -Command "Set-ExecutionPolicy -ExecutionPolicy Unrestricted"

ipconfig /all
X:\Windows\system32\WindowsPowerShell\v1.0\powershell -Command "RunScripts.ps1"
