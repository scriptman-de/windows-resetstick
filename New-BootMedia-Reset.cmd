@ECHO OFF
setlocal
call "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat" 

set DRIVE=%~dp0
set FOLDER=WinPE_amd64_BootMediaReset
set MediaFolder=%DRIVE%%FOLDER%
cls
echo Ausgabe erfolgt in: %MediaFolder%
pause

rem copy WinPE files
if exist %MediaFolder% choice /T 3 /C JN /D N /M "Der Ordner ist schon vorhanden. Neu erstellen? [N]"
if errorlevel 2 goto copyscripts

rmdir /s /q %MediaFolder%
call copype amd64 %MediaFolder%>Nul

pause
:enablepowershell
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
Dism /Unmount-Image /MountDir:%MediaFolder%\mount /Commit

:copyscripts
Dism /Mount-Image /ImageFile:"%MediaFolder%\media\sources\boot.wim" /Index:1 /MountDir:"%MediaFolder%\mount"
@ECHO ON
xcopy /Y "%DRIVE%Stage2-Reset\startnet-reset.cmd" "%MediaFolder%\mount\Windows\System32\startnet.cmd"
xcopy "%DRIVE%Stage2-Reset\Run-Reset.ps1" "%MediaFolder%\mount\Windows\System32\"
xcopy "%DRIVE%Stage2-Reset\Create-ResetBootEntry.cmd" %MediaFolder%\mount\
xcopy "%DRIVE%Stage2-Reset\*.ps1" %MediaFolder%\mount\
xcopy "%DRIVE%Stage2-Reset\*.diskpart" %MediaFolder%\mount\
Dism /Image:"%MediaFolder%\mount" /Add-Driver /Driver:"%DRIVE%Drivers" /recurse
@ECHO OFF
echo %date%%time%>%MediaFolder%\mount\IMAGEDRIVE.MRK
Dism /Unmount-Image /MountDir:%MediaFolder%\mount /Commit

copy "%MediaFolder%\media\sources\boot.wim" %DRIVE%\ResetOS.wim

:end
endlocal
