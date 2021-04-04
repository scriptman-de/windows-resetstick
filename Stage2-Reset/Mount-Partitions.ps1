# Boot
Set-Partition -DiskNumber 0 -PartitionNumber 1 -NewDriveLetter S

# ResetOS
Set-Partition -DiskNumber 0 -PartitionNumber 3 -NewDriveLetter R

# PageFile
Set-Partition -DiskNumber 0 -PartitionNumber 4 -NewDriveLetter P

# Images
Set-Partition -DiskNumber 0 -PartitionNumber 5 -NewDriveLetter W 

Get-Partition -DiskNumber 0