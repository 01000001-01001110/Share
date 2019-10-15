clear
$Host.UI.RawUI.WindowTitle = "Remote System Inventory Tool"
Write-Host `n
Write-Host This takes a list of computers and outputs a decent excel file of information.  -ForegroundColor yellow
Write-Host `n
Write-Host Requirements to proceed: -ForegroundColor yellow
Write-Host `n
Write-Host "1) You will need to run this as your administrator account." -ForegroundColor yellow
write-host `n
Write-Host "2) You will need to have excel installed to run this script." -ForegroundColor yellow
write-host `n
Write-Host "If 1 or 2 = no then please cancel this script by closing this window and run it when you have all the prerequisites." -ForegroundColor red
write-host `n
Write-Host Created by: Alan Newingham -BackgroundColor black -ForegroundColor white
Write-Host Contact:  netpacket0@gmail.com -BackgroundColor Black -ForegroundColor white
Write-Host `n
Read-Host Press Enter to proceed with this script.
Write-Host "Choose hostnames(computer names list) text file" -ForegroundColor yellow




######################################################################################
#File Prompt
#Keeping this code as this took a while to learn with the folder prompt.
######################################################################################

function Read-OpenFileDialog([string]$WindowTitle, [string]$InitialDirectory, [string]$Filter = "All files (*.*)|*.*", [switch]$AllowMultiSelect)
{  
    Add-Type -AssemblyName System.Windows.Forms
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Title = $WindowTitle
    if ($InitialDirectory -eq $Null) { $openFileDialog.InitialDirectory = $InitialDirectory } 
    $openFileDialog.Filter = $Filter
    if ($AllowMultiSelect) { $openFileDialog.MultiSelect = $true }
    $openFileDialog.ShowHelp = $true    # Without this line the ShowDialog() function may hang depending on system configuration and running from console vs. ISE.
    $openFileDialog.ShowDialog() > $null
    if ($AllowMultiSelect) { return $openFileDialog.Filenames } else { return $openFileDialog.Filename }
}

$var = Read-OpenFileDialog("Select hostnames file:","c:\")

$filepath = Get-Content $var

Start-Sleep -s 3

######################################################################################
#Folder Prompt
#Keeping this code as this took a while to learn with the file prompt.
######################################################################################
Write-Host `n
Write-Host Choose folder to create output files -ForegroundColor yellow

function Read-FolderBrowserDialog([string]$Message, [string]$InitialDirectory)
{
    $app = New-Object -ComObject Shell.Application
    $folder = $app.BrowseForFolder(0, $Message, 0, $InitialDirectory)
    if ($folder) { return $folder.Self.Path } else { return '' }
}
$directory = Read-FolderBrowserDialog ("Select your folder to save output files")

######################################################################################

#get only date and time
$a = Get-Date
$Date = $a.ToShortDateString()
$Time = $a.ToShortTimeString()

#Creating new excel object
# There is still some issues with this, in the fact that it errors out past fourth tab creation. Can't figure it out. 
start-sleep -Seconds 3
Write-Host `n
Write-Host "Please wait.. " -ForegroundColor magenta
$excel = New-Object -ComObject excel.application
$excel.visible = $False
$workbook = $excel.Workbooks.Add()
$workbook.Worksheets.Add() | Out-Null
$workbook.Worksheets.Add() | Out-Null
$workbook.Worksheets.Add() | Out-Null
$workbook.Worksheets.Add() | Out-Null
$workbook.Worksheets.Add() | Out-Null
$excel.DisplayAlerts = $False
$excel.Rows.Item(1).Font.Bold = $true 

$value1= $workbook.Worksheets.Item(1)
$value1.Name = 'Computer Information'
$value1.Cells.Item(1,1) = "Machine Name"
$value1.Cells.Item(1,2) = "OS Running"
$value1.Cells.Item(1,3) = "Total Physical Memory"
$value1.Cells.Item(1,4) = "Last Boot Time"
$value1.Cells.Item(1,5) = "Bios Version"
$value1.Cells.Item(1,6) = "Serial Number"
$value1.Cells.Item(1,7) = "CPU Name"
$value1.Cells.Item(1,8) = "CPU Count"
$value1.Cells.Item(1,9) = "CPU Max Speed"
$value1.Cells.Item(1,10) = "Disk Info"
$value1.Cells.Item(1,11) = "System Model"
$value1.Cells.Item(1,12) = "Manufacturer"
$value1.Cells.Item(1,13) = "Description"
$value1.Cells.Item(1,14) = "PrimaryOwnerName"
$value1.Cells.Item(1,15) = "Systemtype"

#Network details
$sheet2 = $workbook.worksheets.item(2)
$sheet2.Name = 'Network Details'
$sheet2.Rows.Item(1).Font.Bold = $true
$sheet2.Cells.Item(1,1) = "Machine Name"
$sheet2.Cells.Item(1,2) = "Description"
$sheet2.Cells.Item(1,3) = "IPAddress"
$sheet2.Cells.Item(1,4) = "DHCPServer"
$sheet2.Cells.Item(1,5) = "DefaultIPGateway"
$sheet2.Cells.Item(1,6) = "DNSDomain"
$sheet2.Cells.Item(1,7) = "DHCPEnabled"
$sheet2.Cells.Item(1,8) = "MACAddress"

#Pagefile details
$sheet3 = $workbook.worksheets.item(3)
$sheet3.Name = 'Audio Video Details'
$sheet3.Rows.Item(1).Font.Bold = $true
$sheet3.Cells.Item(1,1) = "Machine Name"
$sheet3.Cells.Item(1,2) = "Video Card Type"
$sheet3.Cells.Item(1,3) = "Graphics Memory" 
$sheet3.Cells.Item(1,4) = "Sound Device"
$sheet3.Cells.Item(1,5) = "Monitor Count"
$sheet3.Cells.Item(1,6) = "Screen Size"  

#miscellenious details
$sheet4 = $workbook.worksheets.item(4)
$sheet4.Name = 'Miscellenious Details'
$sheet4.Rows.Item(1).Font.Bold = $true
$sheet4.Cells.Item(1,1) = "Machine Name"
$sheet4.Cells.Item(1,2) = "TimeZone"
$sheet4.Cells.Item(1,3) = "StandardName"
$sheet4.Cells.Item(1,4) = "BootConfiguration"
$sheet4.Cells.Item(1,5) = "Administrators"

#Installed apps
$sheet5 = $workbook.worksheets.item(5)
$sheet5.Name = 'Installed Applications'
$sheet5.Rows.Item(1).Font.Bold = $true

#Paged Pool Details
$sheet6 = $workbook.worksheets.item(6)
$sheet6.Name = 'Paged Pool Memory Details'
$sheet6.Rows.Item(1).Font.Bold = $true
$sheet6.cells.item(1,1) = "Computer Name"
$sheet6.cells.item(1,2) = "PoolUsageMaximum configured(Yes or No)"


$row = 2
$sheet2row = 2
$Page2row = 2
$misc1row = 2
$serverCount123 = 2
$sheet6column = 2
$sheet6row = 2
$appscolumn = 1
$serverCount = 1

write-host `n
Write-Host "Excel application created successfully. Writing data to rows and columns.." -ForegroundColor magenta

foreach ($computer in $filepath) {
write-host `n

if (Test-Connection -ComputerName $computer -Quiet) 
 {
write-host Processing Computer $computer -ForegroundColor yellow
$column = 1

$Opt = New-CimSessionOption -Protocol Dcom
$Session = New-CimSession -ComputerName $computer -SessionOption $Opt

 $OS = Get-CimInstance -Class Win32_OperatingSystem –CimSession $session
 $OS1 = Get-CimInstance -class Win32_PhysicalMemory –CimSession $session |Measure-Object -Property capacity -Sum
 $Bios = Get-CimInstance -Class Win32_BIOS –CimSession $session
 $SerialNumber = $Bios | Select-Object -ExpandProperty serialnumber
 $CS = Get-CimInstance -Class Win32_ComputerSystem –CimSession $session
 $CPU = Get-CimInstance -Class Win32_Processor –CimSession $session
 $drives = Get-CimInstance -Class Win32_LogicalDisk –CimSession $session
 $OSRunning = $OS.caption + " " + $OS.OSArchitecture + " SP " + $OS.ServicePackMajorVersion
 $TotalAvailMemory = ([math]::round(($OS1.Sum / 1GB),2))
  
 $date = Get-Date

 #Posh 3 directly gives date values in dd/mm/yy format. So, no need to use converttodatetime function. If you are using ISE < posh3, then use converttodatetime function.
 #$uptime = $OS.ConvertToDateTime($OS.lastbootuptime)
 $uptime = $OS.LastBootUpTime
 #$BiosVersion = $Bios.Manufacturer + " " + $Bios.SMBIOSBIOSVERSION + " " + $Bios.ConvertToDateTime($Bios.Releasedate)
 $BiosVersion = $Bios.Manufacturer + " " + $Bios.SMBIOSBIOSVERSION + " " + $Bios.Releasedate
 $CPUCount = $cpu | select name | measure | Select -ExpandProperty count
 $CPUInfo = $CPU.Name 
 $CPUMaxSpeed = ($CPU[0].MaxClockSpeed/1000) 
 $Model = $CS.Model
 $Manufacturer = $CS.Manufacturer
 $Description = $CS.Description
 $PrimaryOwnerName = $CS.PrimaryOwnerName
 $Systemtype = $CS.Systemtype
 
 $value1.Cells.Item($row, $column) = $computer
 $column++
 $value1.Cells.Item($row, $column) = $OSRunning
 $column++
 $value1.Cells.Item($row, $column) = "$TotalMem GB"
 $column++
 $value1.Cells.Item($row, $column) = $uptime
 $column++
 $value1.Cells.Item($row, $column) = $BiosVersion
 $column++
 $value1.Cells.Item($row, $column) = "$SerialNumber"
 $column++
 $value1.Cells.Item($row, $column) = $CPUInfo
 $column++
 $value1.Cells.Item($row, $column) = $CPUCount
 $column++
 $value1.Cells.Item($row, $column) = $CPUMaxSpeed
 $column++
 
 $driveStr = ""
 foreach($drive in $drives)
 {
 if ($drive.size -ne $null) {
 $size1 = $drive.size / 1GB
 $size = "{0:N2}" -f $size1
 $free1 = $drive.freespace / 1GB
 $free = "{0:N2}" -f $free1
 $freea = $free1 / $size1 * 100
 $freeb = "{0:N2}" -f $freea
 $ID = $drive.DeviceID
 $driveStr += "$ID = Total Space: $size GB / Free Space: $free GB / Free (Percent): $freeb % ` "
 } else {
  $freea = "NA"
 $freeb = "NA"
 $ID = $drive.DeviceID
 $driveStr += "$ID = Total Space: NA / Free Space: NA / Free (Percent): NA ` "
 }
 }


 $value1.Cells.Item($row, $column) = $driveStr
 $column++
 $value1.Cells.Item($row, $column) = $Model
 $column++
 $value1.Cells.Item($row, $column) = $Manufacturer
 $column++
 $value1.Cells.Item($row, $column) = $Description
 $column++
 $value1.Cells.Item($row, $column) = $PrimaryOwnerName
 $column++
 $value1.Cells.Item($row, $column) = $Systemtype
 $column++
 $row++



#network details

$networkinfo = Get-CimInstance -ClassName win32_networkadapterconfiguration -CimSession $Session | where {$_.ipenabled -eq "true" -and $_.IPAddress -ne "0.0.0.0"}
 
$Description = $networkinfo.description
$IPAddress = $networkinfo.IPAddress
$DHCPServer = $networkinfo.dhcpserver
$DefaultIPGateway = $networkinfo.DefaultIPGateway
$DNSDomain = $networkinfo.DNSDomain
$DHCPEnabled = $networkinfo.DHCPEnabled
$MACAddress = $networkinfo.MACAddress

$sheet2column = 1

$sheet2.Cells.Item($sheet2row, $sheet2column) = $computer
 $sheet2column++
 $sheet2.Cells.Item($sheet2row, $sheet2column) = $Description
 $sheet2column++
 $sheet2.Cells.Item($sheet2row, $sheet2column) = $IPAddress
 $sheet2column++
 $sheet2.Cells.Item($sheet2row, $sheet2column) = $DHCPServer
 $sheet2column++
 $sheet2.Cells.Item($sheet2row, $sheet2column) = $DefaultIPGateway
 $sheet2column++
 $sheet2.Cells.Item($sheet2row, $sheet2column) = $DNSDomain
 $sheet2column++
 $sheet2.Cells.Item($sheet2row, $sheet2column) = $DHCPEnabled
 $sheet2column++
 $sheet2.Cells.Item($sheet2row, $sheet2column) = $MACAddress
 $sheet2row++
 

$usedRange1 = $sheet2.UsedRange
$usedRange1.EntireColumn.AutoFit() | Out-Null

#Pagefile Details

#$page = Get-CimInstance -ClassName win32_pagefilesetting -CimSession $Session
 #if (($page| select Name).count -gt 1) {
 #$captionn = $page[0].Name + "," + $page[1].Name + "," + $page[2].Name + "," + $page[3].Name
 #} else {
# $captionn = $page.Name
# }
# if (($page | select MaximumSize).count -gt 1) {
 #$maxPFconfigured = $page[0].MaximumSize + $page[1].MaximumSize + $page[2].MaximumSize + $page[3].MaximumSize
# } else {
# $maxPFconfigured = $page.MaximumSize
# }
 #if (($page | select InitialSize).count -gt 1) {
# $inipfconfigured = $page[0].InitialSize + $page[1].InitialSize + $page[2].InitialSize + $page[3].InitialSize
# } else {
 #$inipfconfigured = $page.InitialSize
# }

# Video Details
$ScreenSize = (Get-CimInstance -Class Win32_VideoController).VideoModeDescription
$VideoCardInfo = (Get-CimInstance -Class Win32_VideoController).Description
$Monitors = (Get-CimInstance Win32_VideoController).Count
$ComputerGraphics = Get-CimInstance -Class Win32_VideoController | 
        select Name, 
               @{Expression={$_.AdapterRAM / 1GB};Label="GraphicsRAM"}   
 $TotalMem = "{0:N2}" -f $TotalAvailMemory

# Sound Devices
$ComputerSoundDevices = (Get-CimInstance -Class Win32_SoundDevice).Name

 $page2column = 1

 $sheet3.Cells.Item($page2row, $page2column) = $computer
 $page2column++
 $sheet3.Cells.Item($page2row, $page2column) = $VideoCardInfo
 $page2column++
 $sheet3.Cells.Item($page2row, $page2column) = $TotalAvailMemory
 $page2column++
 $sheet3.Cells.Item($page2row, $page2column) = $ComputerSoundDevices
 $page2column++
 $sheet3.Cells.Item($Page2row, $page2column) = "$Monitors"
 $page2column++
 $sheet3.Cells.Item($Page2row, $page2column) = "$ScreenSize"
 $Page2row++
  
 $usedRange2 = $sheet3.UsedRange
$usedRange2.EntireColumn.AutoFit() | Out-Null

#Miscellenious Details

$misc = Get-CimInstance -ClassName win32_TimeZone -CimSession $Session
$timezone = $misc.caption
$standardname = $misc.StandardName
$bootconfig = (Get-CimInstance -ClassName Win32_BootConfiguration -CimSession $Session).ConfigurationPath
###############################################################################
function get-localusers { 
        param( 
    [Parameter(Mandatory=$true,valuefrompipeline=$true)] 
    [string]$strComputer) 
    begin {} 
    Process { 
        $adminlist ="" 
        #$powerlist ="" 
        $computer = [ADSI]("WinNT://" + $strComputer + ",computer") 
        $AdminGroup = $computer.psbase.children.find("Administrators") 
        #$powerGroup = $computer.psbase.children.find("Power Users") 
        $Adminmembers= $AdminGroup.psbase.invoke("Members") | %{$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)} 
        #$Powermembers= $PowerGroup.psbase.invoke("Members") | %{$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)} 
        foreach ($admin in $Adminmembers) { $adminlist = $adminlist + $admin + "," } 
        #foreach ($poweruser in $Powermembers) { $powerlist = $powerlist + $poweruser + "," } 
        #$Computer = New-Object psobject 
        #$computer | Add-Member noteproperty ComputerName $strComputer 
        #$computer | Add-Member noteproperty Administrators $adminlist 
        #$computer | Add-Member noteproperty PowerUsers $powerlist 
        Write-Output $adminlist 
 
 
        } 
end {} 
} 
 
$admins = get-localusers $computer
#######################################################################################

$misc1column = 1
 $sheet4.Cells.Item($misc1row,$misc1column) = $computer
 $misc1column++
$sheet4.Cells.Item($misc1row,$misc1column) = $timezone
 $misc1column++
 $sheet4.Cells.Item($misc1row,$misc1column) = $standardname
 $misc1column++
 $sheet4.Cells.Item($misc1row,$misc1column) = $bootconfig
 $misc1column++
 $sheet4.Cells.Item($misc1row,$misc1column) = $admins
 $misc1row++
 
 
$usedRange3 = $sheet4.UsedRange
$usedRange3.EntireColumn.AutoFit() | Out-Null


#Installed Apps
      $sheet5.Cells.Item(1,$serverCount) = "$computer"
        $serverCount++

$appsrow = 2
$RegBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Computer)
$RegUninstall = $RegBase.OpenSubKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall')
$apps123 = $RegUninstall.GetSubKeyNames() |
ForEach-Object {
($RegBase.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$_")).GetValue('DisplayName')
}
$apps = $apps123 | sort
foreach ($app in $apps) {
if ($app -ne $null)  {
 $sheet5.Cells.Item($appsrow, $appscolumn) = $app
 $appsrow++
 }
 }
$appscolumn++

$usedRange4 = $sheet5.UsedRange
$usedRange4.EntireColumn.AutoFit() | Out-Null

#PagedPool Memory info

$sheet6.Cells.Item($serverCount123,1) = "$computer"
$serverCount123++

$RegBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$computer)
$RegMemMgmt = $RegBase.OpenSubKey('System\CurrentControlSet\Control\Session Manager\Memory Management')
if ($RegMemMgmt.GetValueNames() -contains 'PoolUsageMaximum') {
    $sheet6.cells.item($sheet6row,$sheet6column) = "Yes (Configured Value is $($RegMemMgmt.GetValue('PoolUsageMaximum')))"
    $sheet6row++
} else {
 $sheet6.cells.item($sheet6row,$sheet6column) = "Not Configured"
$sheet6row++
}

$usedrange5 = $sheet6.usedrange
$usedrange5.entirecolumn.autofit() | Out-Null
 } else {
 $outp = "$computer not online"
 write-host $outp.ToUpper() -ForegroundColor Black -BackgroundColor Cyan
 }

 }

#write data to excel file and save it 
$usedRange = $value1.UsedRange
$usedRange.EntireColumn.AutoFit() | Out-Null
$workbook.SaveAs("$directory\ComputerConfiguration.xlsx") 
$excel.Quit()
Write-Host `n 
Write-Host "Configuration Report completed successfully." -ForegroundColor yellow
Write-Host `n 
Write-Host "I hope this has been helpful. - AlanN " -ForegroundColor yellow
Write-Host `n 
Write-Host "Also getting Hotfix info... " -ForegroundColor yellow
#release the excel object created and remove variable
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
Remove-Variable excel



#Compare Hotfixes in all servers mentioned.

# ---------------------------------------------------------------------------------------------------- 
foreach ($object in $filepath) {
if (Test-Connection -ComputerName $object -Quiet) 
 {
 $object | Out-File "$directory\filenames.txt" -Append
 }
 }
$computers = Get-Content "$directory\filenames.txt"

# ---------------------------------------------------------------------------------------------------- 
 
 
$hotfixes = @() 
$result = @() 
 
foreach ($computer in $computers) 
{ 
    foreach ($hotfix in (get-hotfix -computer $computer | select HotfixId)) 
    { 
        $h = New-Object System.Object 
        $h | Add-Member -type NoteProperty -name "Server" -value $computer 
        $h | Add-Member -type NoteProperty -name "Hotfix" -value $hotfix.HotfixId 
        $hotfixes += $h 
    } 
} 
     
$ComputerList = $hotfixes | Select-Object -unique Server | Sort-Object Server 
 
foreach ($hotfix in $hotfixes | Select-Object -unique Hotfix | Sort-Object Hotfix) 
{ 
    $h = New-Object System.Object 
    $h | Add-Member -type NoteProperty -name "Hotfix" -value $hotfix.Hotfix 
         
    foreach ($computer in $ComputerList) 
    { 
        if ($hotfixes | Select-Object |Where-Object {($computer.server -eq $_.server) -and ($hotfix.Hotfix -eq $_.Hotfix)})  
        {$h | Add-Member -type NoteProperty -name $computer.server -value "Installed"} 
        else 
        {$h | Add-Member -type NoteProperty -name $computer.server -value "Not Installed"} 
    } 
    $result += $h 
} 

$result | export-csv "$directory\HotfixDetails.csv" -NoTypeInformation
Write-Host `n
Write-Host Hotfix data file created successfully -ForegroundColor yellow
Write-Host `n
Remove-Item "$directory\filenames.txt"
Write-Host Files saved in Folder $directory -ForegroundColor Cyan
Write-Host `n
Write-Host FileNames: -ForegroundColor yellow
Write-Host ServerConfiguration.xlsx -ForegroundColor yellow
Write-Host HotfixDetails.csv -ForegroundColor yellow
Write-Host `n
Write-Host "Send suggestions and/or feedback to netpacket0@gmail.com" -ForegroundColor white -BackgroundColor blue
Write-Host `n
Read-Host "Press Enter to exit"
