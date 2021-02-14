# GET MAC ADDRESS
$mac = (Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true -and $_.DHCPEnabled -eq $true }).MACAddress

# Enable setup
try {
	if (!(Test-Path "V:\Windows\Panther")) {
		New-Item -Type Directory -Path V:\Windows\Panther
	}
	
	$result = Invoke-RestMethod -Uri "http://10.0.0.100:3000/api/v1/unattend?mac=$mac" -Method GET -OutFile "V:\Windows\Panther\unattend.xml"
	Write-Host -BackgroundColor Green -ForegroundColor Black $result.message
}
catch {
	
	Write-Host -BackgroundColor Red -ForegroundColor Black "Unattended Datei konnte nicht abgerufen werden!"
}