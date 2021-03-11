@ECHO OFF
setlocal
call "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat" 

set DRIVE=%~dp0
set FOLDER=WinPE_amd64_ResetChild
set MediaFolder=%DRIVE%%FOLDER%
cls
echo Ausgabe erfolgt in: %MediaFolder%
pause

rem copy WinPE files
call copype amd64 %MediaFolder%

pause

Dism /Mount-Image /ImageFile:"%MediaFolder%\media\sources\boot.wim" /Index:1 /MountDir:"%MediaFolder%\mount"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\WinPE-WMI.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\en-us\WinPE-WMI_en-us.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\WinPE-NetFX.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\en-us\WinPE-NetFX_en-us.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\WinPE-Scripting.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\en-us\WinPE-Scripting_en-us.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\WinPE-PowerShell.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\en-us\WinPE-PowerShell_en-us.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\WinPE-StorageWMI.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\en-us\WinPE-StorageWMI_en-us.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\WinPE-DismCmdlets.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\en-us\WinPE-DismCmdlets_en-us.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\WinPE-SecureStartup.cab"
Dism /Add-Package /Image:"%MediaFolder%\mount" /PackagePath:"%WinPERoot%\amd64\WinPE_OCs\en-us\WinPE-SecureStartup_en-us.cab"

copy startnet.cmd "%MediaFolder%\mount\Windows\System32"

Dism /Image:%MediaFolder%\mount /Add-Driver /Driver:SurfaceDriver\*.inf /recurse

Dism /Unmount-Image /MountDir:%MediaFolder%\mount /Commit


:end
endlocal
