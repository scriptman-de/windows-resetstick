# Remove attributes and assign drive letter
Set-Partition -DiskNumber 0 -PartitionNumber 3 -IsHidden $false 
Add-PartitionAccessPath -DiskNumber 0 -PartitionNumber 3 -AssignDriveLetter R

# Remove attributes and assign drive letter
Set-Partition -DiskNumber 0 -PartitionNumber 5 -IsHidden $false 
Add-PartitionAccessPath -DiskNumber 0 -PartitionNumber 5 -AssignDriveLetter W