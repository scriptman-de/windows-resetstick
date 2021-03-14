@ECHO OFF
setlocal
set STORE="S:\Efi\Microsoft\Boot\BCD"

rem make common settings for the bootmanager
bcdedit /store %STORE% /set {bootmgr} displaybootmenu TRUE
bcdedit /store %STORE% /set {bootmgr} timeout 5

rem
rem create BCD entry
bcdedit /store %STORE% /create /application osloader > createstore.txt
for /f "tokens=2 delims={}" %%s in (createstore.txt) do set RESETGUID=%%s
echo %RESETGUID% wurde erstellt

rem
rem create new osloader entry
bcdedit /store %STORE% /set {%RESETGUID%} osdevice ramdisk=[\Device\Harddiskvolume3]\Reset\resetos.wim,{%RESETGUID%}
bcdedit /store %STORE% /set {%RESETGUID%} device ramdisk=[\Device\Harddiskvolume3]\Reset\resetos.wim,{%RESETGUID%}
bcdedit /store %STORE% /set {%RESETGUID%} systemroot \windows
bcdedit /store %STORE% /set {%RESETGUID%} path \windows\system32\boot\winload.efi

rem
rem make settings for the entry
bcdedit /store %STORE% /set {%RESETGUID%} detecthal Yes
bcdedit /store %STORE% /set {%RESETGUID%} winpe Yes
bcdedit /store %STORE% /set {%RESETGUID%} description "Betriebssystem zurücksetzen"

rem
rem add bootentry
bcdedit /store %STORE% /displayorder {%RESETGUID%} /addlast
rem bcdedit /store %STORE% /default {%RESETGUID%}

rem
rem show settings
bcdedit /store %STORE% /enum ALL /v


:cleanup
del createstore.txt

endlocal