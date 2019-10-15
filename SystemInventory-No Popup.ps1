<#
	.SYNOPSIS
		Windows Machine Inventory Using PowerShell.

	.DESCRIPTION
		This script is to document the Windows machine. This script will work only for Local Machine.

	.EXAMPLE
		Written by - Alan Newingham

	.OUTPUTS
		HTML File OutPut ReportDate , General Information , BIOS Information etc.

#>
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#Set-ExecutionPolicy RemoteSigned -ErrorAction SilentlyContinue

$UserName = (Get-Item  env:\username).Value 
$ComputerName = (Get-Item env:\Computername).Value
$filepath = "#############Server Location"
$lfilepath = (Get-ChildItem env:\userprofile).value

Add-Content  "$lFilepath\style.CSS"  -Value " <style>
body { background-color:#E5E4E2;
       font-family:Arial;
       font-size:10pt; }
td, th { border:0px solid black; 
         border-collapse:collapse;
         white-space:pre; }
th { color:white;
     background-color:black; }
table, tr, td, th { padding: 2px; margin: 0px ;white-space:pre; }
tr:nth-child(odd) {background-color: lightgray}
table { width:95%;margin-left:5px; margin-bottom:20px;}
h2 {
 font-family:Tahoma;
 color:#6D7B8D;
}
.footer 
{ color:green; 
  margin-left:10px; 
  font-family:Tahoma;
  font-size:8pt;
  font-style:italic;
}
</style>"

Write-Host "CSS File Created Successfully... Executing Inventory Report!!! Please Wait !!!" -ForegroundColor Yellow 

#General Information
$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem | Select -Property Model , Manufacturer , Description , PrimaryOwnerName , SystemType |ConvertTo-Html -Fragment

#Boot Configuration
$BootConfiguration = Get-WmiObject -Class Win32_BootConfiguration | Select -Property Name , ConfigurationPath | ConvertTo-Html -Fragment 

#BIOS Information
$BIOS = Get-WmiObject -Class Win32_BIOS | Select -Property PSComputerName , Manufacturer , Version | ConvertTo-Html -Fragment

#Operating System Information
$OS = Get-WmiObject -Class Win32_OperatingSystem | Select -Property Caption , CSDVersion , OSArchitecture , OSLanguage | ConvertTo-Html -Fragment

#Time Zone Information
$TimeZone = Get-WmiObject -Class Win32_TimeZone | Select Caption , StandardName | ConvertTo-Html -Fragment

#Logical Disk Information
$Disk = Get-WmiObject -Class Win32_LogicalDisk -Filter DriveType=3 | Select DeviceID , @{Expression={$_.Size /1Gb -as [int]};Label="Total Size(GB)"},@{Expression={$_.Freespace / 1Gb -as [int]};Label="Free Size (GB)"} | ConvertTo-Html -Fragment

#Get drive information and display it. Make/Model.
$Drive = Get-WMIObject win32_diskdrive | Where-Object MediaType -eq 'Fixed hard disk media' | Select SystemName,Model,@{Name='Size(GB)';Exp={$_.Size /1gb -as [int]}} | ConvertTo-Html -Fragment

#CPU Information
$SystemProcessor = Get-WmiObject -Class Win32_Processor  | Select Name , MaxClockSpeed , Manufacturer , status | ConvertTo-Html -Fragment

#Memory Information
$PhysicalMemory = Get-WmiObject -Class Win32_PhysicalMemory | Select -Property Tag , SerialNumber , PartNumber , Manufacturer , DeviceLocator , PositionInRow , ConfiguredClockSpeed , ConfiguredVoltage , @{Name="Capacity(GB)";Expression={"{0:N1}" -f ($_.Capacity/1GB)}} | ConvertTo-Html -Fragment

#Network Information
$Network = Get-WmiObject Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE  | 
    Select-Object Description, DHCPServer, 
        @{Name='IpAddress';Expression={$_.IpAddress -join '; '}}, 
        @{Name='IpSubnet';Expression={$_.IpSubnet -join '; '}}, 
        @{Name='DefaultIPgateway';Expression={$_.DefaultIPgateway -join '; '}}, 
        @{Name='DNSDomain';Expression={$_.DNSDomain -join '; '}}, 
        WinsPrimaryServer, WINSSecindaryServer| ConvertTo-Html -Fragment 

#Printer Information
#Get-WMIObject -Class Win32_PrinterConfiguration | ConvertTo-Html -Fragment
$Printer = Get-Printer -ComputerName $ComputerName | Select -Property Name , DriverName | ConvertTo-Html -Fragment

#User Accounts
$Directories = Get-ChildItem -Path "C:\Users\" | Select -Property Name , LastWriteTime | ConvertTo-Html -Fragment

#Installed Windows Updates
$HotFix = Get-WmiObject -Class Win32_QuickFixEngineering | Select -Property HotFixID |ConvertTo-Html -Fragment 

#Installed Products
$InstalledProduct = Get-WmiObject -Class Win32_Product | Select -Property Caption , PackageName | ConvertTo-HTML -Fragment

#Software Inventory
$Software = Get-WmiObject -Class Win32_Product |
Select Name , Vendor , Version , Caption | ConvertTo-Html -Fragment 

#ReportDate
#$ReportDate = Get-Date | Select -Property DateTime |ConvertTo-Html -Fragment



ConvertTo-Html -Body "<p><font color = blue><H1><center>Computer Information Export</center></H1></font>
</p><H1> Computer Name : $ComputerName </H1>
<font color = blue><H4><B>General Information</B></H4></font>$ComputerSystem
<font color = blue><H4><B>Boot Configuration</B></H4></font>$BootConfiguration
<font color = blue><H4><B>BIOS Information</B></H4></font>$BIOS
<font color = blue><H4><B>Operating System Information</B></H4></font>$OS
<font color = blue><H4><B>Hard Disk Information</B></H4></font>$Drive
<font color = blue><H4><B>Disk Information</B></H4></font>$Disk
<font color = blue><H4><B>Processor Information</B></H4></font>$SystemProcessor
<font color = blue><H4><B>Memory Information</B></H4></font>$PhysicalMemory
<font color = blue><H4><B>User Account Information</B></H4></font>$Directories
<font color = blue><H4><B>Hot Fix Installed</B></H4></font>$HotFix
<font color = blue><H4><B>Installed Applications</B></H4></font>$InstalledProduct
<font color = blue><H4><B>Printer Information</B></H4></font>$Printer
<font color = blue><H4><B>Network Information</B></H4></font>$Network
<font color = blue><H4><B>Software Inventory</B></H4></font>$Software
<font color = blue><H4><B>Time Zone Information</B></H4></font>$TimeZone
<BR><BR><BR><BR><BR><BR><BR>
The Report is generated On  $(get-date) by $((Get-Item env:\username).Value) on computer $((Get-Item env:\Computername).Value) <BR><BR>Written By: Alan Newingham<BR><BR>Report Version 0.2.2" -CssUri  "$lfilepath\style.CSS" -Title "$ComputerName" | Out-File "$FilePath\$ComputerName.html"



Write-Host "Script Execution Completed" -ForegroundColor Yellow
# Uncomment the bottom line to popup the html file once created. 
# Invoke-Item -Path "$FilePath\$ComputerName.html"