#Requires -RunAsAdministrator

# This is useful to exclude computer accounts from showing up on the User-ID log, less pollution is better

# Obtain a list of Domain Computers, merge them to the exclude list in "C:\Program Files\Palo Alto Networks\ignore_user_list.txt"
# It is recommended to run this regularly on the Palo Alto User-ID Agent machine, Active Directory cmdlets are required

# Palo Alto configuration file for ignored users
$ConfigFile = "C:\Program Files\Palo Alto Networks\ignore_user_list.txt"

# Get the content of the current blacklist file
$BlackList = Get-Content -Path $ConfigFile

# Get a list of computers in Active Directory
$Computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name

# Create a combined list of unique entries
$NewList = $BlackList + $Computers | Sort-Object -Unique

# Write the configuration file
$NewList | Set-Content -Path $ConfigFile
