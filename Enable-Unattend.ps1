# GET MAC ADDRESS
$mac = (Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true -and $_.DHCPEnabled -eq $true }).MACAddress

# Prepare JSON
$params = @{ "name" = "$(hostname)"; "mac" = "$mac"; "comment" = "Automatically added from Prepare-Environment"; }

# Enable setup
$result = Invoke-RestMethod -Uri "http://10.0.0.100:3000/api/v1/enable" -Method POST -Body ($params | ConvertTo-Json) -ContentType "application/json"
Write-Host -BackgroundColor Green -ForegroundColor Black $result.message
