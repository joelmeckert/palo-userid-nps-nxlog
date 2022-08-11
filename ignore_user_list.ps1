# This code is licensed under MIT license (see LICENSE for details)
# Joel Eckert, joel@joelme.ca, 2022-08-11
#Requires -RunAsAdministrator

# This is useful to exclude computer accounts from showing up on the User-ID log, less pollution is better

# Obtain a list of Domain Computers, merge them to the exclude list in "C:\Program Files\Palo Alto Networks\ignore_user_list.txt"
# It is recommended to run this regularly on the Palo Alto User-ID Agent machine, Active Directory cmdlets are required

# Permanent configuration file for excluded hosts
$ConfigFile = "C:\Program Files\Palo Alto Networks\ignore_user_list_permanent.txt"

# Palo Alto configuration file for ignored users
$LiveConfigFile = "C:\Program Files\Palo Alto Networks\ignore_user_list.txt"

If (!(Test-Path $ConfigFile)) {
  # Get contents of existing ignore file
  $BlackList = Get-Content -Path $LiveConfigFile
}
Else {
  # Get contents of master ignore file
  $BlackList = Get-Content -Path $ConfigFile
}

# Get a list of computers in Active Directory
$Computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name

# Create a combined list of unique entries
$IgnoreList = $BlackList + $Computers | Sort-Object -Unique

# Write the configuration file
$IgnoreList | Set-Content -Path $ConfigFile
