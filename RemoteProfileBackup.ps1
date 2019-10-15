
<# Attemping to make this as variablized as possible. #>


<#

Notes on vars used in this script.
Customer Username: $User
Old Computer IP: $Computer
$LogFileInfo
$DateandTime
$NewComputerName
$TicketNumber
$Location
$CustomerName
$OldComputerName
$SourceRoot      = "\\$Computer\c$\Users\$User"
$DestinationRoot = "C:\Backup\$User"  

#>




$DateandTime =Get-Date -Format g
$host.ui.rawui.WindowTitle = "Remote Profile Backup"
$NewComputerName =$env:computername
$LogFileInfo =@("c:\backup\%un%\log.txt")
$TicketNumber = Read-Host -Prompt 'What is the ticket number for this work?'
$Location = Read-Host -Prompt 'What is the location of this work for the customer?'
$CustomerName = Read-Host -Prompt 'What is the customers name?'
$PhoneNumber = Read-Host -Prompt 'What is the customers contact number?'
$OldComputerName = Read-Host -Prompt 'What is the Old Computer Name'

$FoldersToCopy = @(
    'Desktop'
    'Downloads'
    'Favorites'
    'Documents'
    'Pictures'
    'Videos'
    'AppData\Roaming\Adobe\Acrobat\DC\Security'
    'AppData\Roaming\Mozilla\Firefox\Profiles'
    'AppData\Local\Google'
    'ODBA'
    'Application Data\microsoft\signatures'
    )

$ConfirmComp = $null
$ConfirmUser = $null

while( $ConfirmComp -ne 'y' ){
    $Computer = Read-Host -Prompt 'Enter the IP address of the computer to copy from'

    if( -not ( Test-Connection -ComputerName $Computer -Count 2 -Quiet ) ){
        Write-Warning "$Computer is not online. Please enter another computer name."
        continue
        }

    $ConfirmComp = Read-Host -Prompt "The entered computer name was:`t$Computer`r`nIs this correct? (y/n)"
    }

while( $ConfirmUser -ne 'y' ){
    $User = Read-Host -Prompt 'Enter the user profile name with which to copy from'

    if( -not ( Test-Path -Path "\\$Computer\c$\Users\$User" -PathType Container ) ){
        Write-Warning "$User could not be found on $Computer. Please enter another user profile."
        continue
        }

    $ConfirmUser = Read-Host -Prompt "The entered user profile was:`t$User`r`nIs this correct? (y/n)"
    }

"`tThe total size of \\$Computer\c$\Users\$User is {0:N2} MB" -f ((Get-ChildItem \\$Computer\c$\Users\$User -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB) 

$Profilesize ="Write-Host((Get-Item \\$Computer\c$\Users\$User).length/1GB)" 

$SourceRoot      = "\\$Computer\c$\Users\$User"
$DestinationRoot = "C:\Backup\$User" 

New-Item -ItemType Directory -Force -Path $DestinationRoot | Out-Null

foreach( $Folder in $FoldersToCopy ){
    $Source      = Join-Path -Path $SourceRoot -ChildPath $Folder
    $Destination = Join-Path -Path $DestinationRoot -ChildPath $Folder

    if( -not ( Test-Path -Path $Source -PathType Container ) ){
        Write-Warning "Could not find path`t$Source"
        continue
        }   
    Robocopy.exe $source $destination *.* /e /LOG:c:\backup\$User\log.txt
    }   

<# Close Notes #>
$UserEmail ="$User@erau.edu"

Add-Content c:\backup\$User\log.txt "$CustomerName it was a pleasure to work with you today ($DateandTime) for ticket $TicketNumber. 

I look forward to another opportunity to assist you in the future. Should the need arise. While onsite in $Location I was able to migrate your data from the old computer: $OldComputerName to the new computer: $NewComputerName. During this time I completed the install of your printers ############# as well as assisting with your initial login and setup.
This initial setup included printing a test page from each printer with complete success. Prior to my departure we were able to successfully test common applications (Outlook,Skype,Printing, etc...).

The Data transfer was initiated at $DateandTime and was $Profilesize large. The data transfer was successful and completed without a failure. 
I called and / discussed this ticket at $PhoneNumber / left you a voice mail on $PhoneNumber regarding this ticket. 

You may receive a survey via email in reference to this ticket. If you have a spare moment and can fill out the brief survey, we would welcome your honest feedback about this experience.
We will be closing this ticket now that all the work has completed. Please note any and all replies to this email chain will re-open this ticket. Should you have any further questions or concern please contact me by emailing me directly at ######@###.###
Thank you and have a great day!"
