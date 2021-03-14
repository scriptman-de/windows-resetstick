# Remove access path from drive R
Get-Volume -DriveLetter R | Get-Partition | Remove-PartitionAccessPath -AccessPath R:\ -ErrorAction SilentlyContinue
Set-Partition -DiskNumber 0 -PartitionNumber 3 -IsHidden $true 

# Remove access path form drive W
Get-Volume -DriveLetter W | Get-Partition | Remove-PartitionAccessPath -AccessPath W:\ -ErrorAction SilentlyContinue
Set-Partition -DiskNumber 0 -PartitionNumber 5 -IsHidden $true -NoDefaultDriveLetter $true