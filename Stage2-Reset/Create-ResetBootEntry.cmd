@ECHO OFF
setlocal
set STORE="S:\Efi\Microsoft\Boot\BCD"

rem make common settings for the bootmanager
bcdedit /store %STORE% /set {bootmgr} displaybootmenu TRUE
bcdedit /store %STORE% /set {bootmgr} description "Surface Reset Environment Boot Loader"
bcdedit /store %STORE% /set {bootmgr} timeout 5

rem create ramdisk options for loading winpe
for /f "tokens=2 delims={}" %%g in ('bcdedit /store %STORE% /create /device') do set RAMDISK={%%g}
bcdedit /store %STORE% /set %RAMDISK% ramdisksdidevice [R:]\Reset\ResetOS.wim
bcdedit /store %STORE% /set %RAMDISK% ramdisksdipath \Boot\boot.sdi

rem
rem create BCD entry
for /f "tokens=2 delims={}" %%g in ('bcdedit /store %STORE% /create /application osloader') do set RESETGUID={%%g}
rem bcdedit /store %STORE% /create /application osloader > createstore.txt
rem for /f "tokens=2 delims={}" %%s in (createstore.txt) do set RESETGUID=%%s
echo %RESETGUID% wurde erstellt

rem
rem create new osloader entry
bcdedit /store %STORE% /set %RESETGUID% osdevice ramdisk=[R:]\Reset\ResetOS.wim,%RAMDISK%
bcdedit /store %STORE% /set %RESETGUID% device ramdisk=[R:]\Reset\ResetOS.wim,%RAMDISK%
bcdedit /store %STORE% /set %RESETGUID% systemroot \windows
bcdedit /store %STORE% /set %RESETGUID% path \windows\system32\boot\winload.efi
bcdedit /store %STORE% /set %RESETGUID% detecthal Yes
bcdedit /store %STORE% /set %RESETGUID% winpe Yes
bcdedit /store %STORE% /set %RESETGUID% isolatedcontext Yes
bcdedit /store %STORE% /set %RESETGUID% description "Betriebssystem zurucksetzen"

rem
rem add bootentry
bcdedit /store %STORE% /displayorder %RESETGUID% /addlast
rem bcdedit /store %STORE% /default %RESETGUID%

rem
rem show settings
bcdedit /store %STORE% /enum ALL /v


:cleanup
del createstore.txt

endlocal