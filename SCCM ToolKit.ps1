# #############################################################################
# 3DDad.com - SCRIPT - POWERSHELL
# NAME: SCCMToolKit.ps1
# 
# AUTHOR:  iNet
# DATE:  07/29/2019
# EMAIL: info@3DDad.com
# 
# COMMENT:  This script will load a form to display buttons and output to make SCCM problems easier to fix.
#
# VERSION HISTORY
# 0.1 07.22.2019 Initial Version.
# 1.1 07.29.2019 Upgrade with WMI function
#   Also added richtextbox
#   Resized window to accomodate
#   Output goes to richtextbox
#
# TO ADD
# -licensened powershell studio today, scrapping this and rebuinding in powershell studio
# -Fix the...
# #############################################################################

#----------------------------------------------
#region Application Functions
#----------------------------------------------

#endregion Application Functions

#----------------------------------------------
# Generated Form Function
#----------------------------------------------
function Show-SCCM_ToolKit_psf {

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$formSCCMToolKit = New-Object 'System.Windows.Forms.Form'
	$richtextbox1 = New-Object 'System.Windows.Forms.RichTextBox'
	$groupbox1 = New-Object 'System.Windows.Forms.GroupBox'
	#$richtextbox1 = New-Object 'System.Windows.Forms.Label'
	$buttonDeleteCache = New-Object 'System.Windows.Forms.Button'
	$labelContact = New-Object 'System.Windows.Forms.Label'
	$labelNewinghaerauedu = New-Object 'System.Windows.Forms.Label'
	$labelSCCMToolKit = New-Object 'System.Windows.Forms.Label'
	$buttonRestartConfigMan = New-Object 'System.Windows.Forms.Button'
	$buttonBackupSCCMLogs = New-Object 'System.Windows.Forms.Button'
	$buttonClientHealthEvalulat = New-Object 'System.Windows.Forms.Button'
	$buttonMachinePolicyUpdates = New-Object 'System.Windows.Forms.Button'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	$buttonDeleteSCCM = New-Object 'System.Windows.Forms.Button'
	$buttonCMTrace = New-Object 'System.Windows.Forms.Button'
	$buttonCCMRestart = New-Object 'System.Windows.Forms.Button'
	$buttonCCMRepair = New-Object 'System.Windows.Forms.Button'
	$buttonInstallSCCM = New-Object 'System.Windows.Forms.Button'
	$buttonrebuildWMI = New-Object 'System.Windows.Forms.Button'
	$buttonResetRepo = New-Object 'System.Windows.Forms.Button'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$formSCCMToolKit_Load = {
		
	}

	function rebuildWMI {
		function DisableService([System.ServiceProcess.ServiceController]$svc)
			{ 
				Set-Service -Name $svc.Name -StartupType Disabled 
			}
 
function EnableServiceAuto([System.ServiceProcess.ServiceController]$svc)
			{ 
				Set-Service -Name $svc.Name -StartupType Automatic
			}
 
function StopService([System.ServiceProcess.ServiceController]$svc)
	{
		[string]$dep = ([string]::Empty)
		
		foreach ($depsvc in $svc.DependentServices)
		{ $dep += $depsvc.DisplayName + ", " }
		
		$richtextbox1.Text += "`nStopping $($svc.DisplayName) and its dependent services ($dep)"
		
		$svc.Stop()
		
		$svc.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Stopped)
		
		$richtextbox1.Text += "`nStopped $($svc.DisplayName)"
	}
 
function StartService([System.ServiceProcess.ServiceController]$svc, [bool]$handleDependentServices)
	{
		if ($handleDependentServices)
		{ 
			$richtextbox1.Text += "`nStarting $($svc.DisplayName) and its dependent services" 
		}
		
		else
		{ 
			$richtextbox1.Text += "`nStarting $($svc.DisplayName)" 
		}
		
		if (!$svc.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Running)
		{
			try
			{
				$svc.Start()
		
				$svc.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Running)
			}
		
			catch { }
		}
		
		$richtextbox1.Text += "`nStarted $($svc.DisplayName)"
			
		if ($handleDependentServices)
		{
			[System.ServiceProcess.ServiceController]$depsvc = $null;
		
			foreach ($depsvc in $svc.DependentServices)
			{ 
				if ($depsvc.StartType -eq [System.ServiceProcess.ServiceStartMode]::Automatic)
				{ StartService $depsvc $handleDependentServices }
			}
		}
	} 
 
function RegSvr32([string]$path)
{
   $richtextbox1.Text += "`nRegistering $path"
 
   regsvr32.exe $path /s
}
 
function RegisterMof([System.IO.FileSystemInfo]$item)
{
   [bool]$register = $true
 
   $richtextbox1.Text += "`nInspecting: $($item.FullName)"
 
   if ($item.Name.ToLowerInvariant().Contains('uninstall'))
   {
      $register = $false
      $richtextbox1.Text += "`nSkipping - uninstall file: $($item.FullName)"
   }
 
   elseif ($item.Name.ToLowerInvariant().Contains('remove'))
   {
      $register = $false
      $richtextbox1.Text += "`nSkipping - remove file: $($item.FullName)"
   }
 
   else
   {
      $txt = Get-Content $item.FullName
  
      if ($txt.Contains('#pragma autorecover'))
      {
         $register = $false
         $richtextbox1.Text += "`nSkipping - autorecover: $($item.FullName)"
      }
 
      elseif ($txt.Contains('#pragma deleteinstance'))
      {
         $register = $false
         $richtextbox1.Text += "`nSkipping - deleteinstance: $($item.FullName)"
      }
 
      elseif ($txt.Contains('#pragma deleteclass'))
      {
         $register = $false
         $richtextbox1.Text += "`nSkipping - deleteclass: $($item.FullName)"
      }
   }
 
   if ($register)
   {
      $richtextbox1.Text += "`nRegistering $($item.FullName)"
      mofcomp $item.FullName
   }
}
 
function HandleFSO([System.IO.FileSystemInfo]$item, [string]$targetExt)
{
   if ($item.Extension -ne [string]::Empty)
   {
      if ($targetExt -eq 'dll')
      {
         if ($item.Extension.ToLowerInvariant() -eq '.dll')
         { RegSvr32 $item.FullName }
      }
 
      elseif ($targetExt -eq 'mof')
      {
         if (($item.Extension.ToLowerInvariant() -eq '.mof') -or ($item.Extension.ToLowerInvariant() -eq '.mfl'))
         { RegisterMof $item }
      }
   }
}
 
# get Winmgmt service
[System.ServiceProcess.ServiceController]$wmisvc = Get-Service 'winmgmt'
 
# disable winmgmt service
DisableService $wmisvc
 
# stop winmgmt service
StopService $wmisvc
 
# get wbem folder
[string]$wbempath = [Environment]::ExpandEnvironmentVariables("%windir%\system32\wbem")
 
[System.IO.FileSystemInfo[]]$itemlist = Get-ChildItem $wbempath -Recurse | Where-Object { $_.FullName.Contains('AutoRecover') -ne $true}
 
[System.IO.FileSystemInfo]$item = $null
 
# walk dlls
foreach ($item in $itemlist)
{ HandleFSO $item 'dll' }
 
# call /regserver method on WMI private server executable
wmiprvse /regserver
 
# call /resetrepository method on WinMgmt service executable
winmgmt /resetrepository
 
# enable winmgmt service
EnableServiceAuto $wmisvc
 
# start winmgmt service
StartService $wmisvc $true
 
# walk MOF / MFLs
foreach ($item in $itemlist)
{ HandleFSO $item 'mof' }
	}
	function ReloadSccmClient
	{
		Invoke-WMIMethod -ComputerName $env:COMPUTERNAME -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000021}"
		Invoke-WMIMethod -ComputerName $env:COMPUTERNAME -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000022}"
		$richtextbox1.Text += "`nRan Machine Policy Updates"
	}
	function RestartConfigMan
	{
		cmd /c "%SystemRoot%\ccm\ccmrestart.exe"
		$richtextbox1.Text += "`nConfiguration Manager Is Reloading."
	}
	function ClientHealthEval
	{
		$richtextbox1.Text += "`nRan Client Health Evaluation."
		cmd /c "%SystemRoot%\ccm\ccmeval.exe"
	}
	function BackupSccmLogs
	{
		Robocopy "C:\Windows\CCM\Logs" C:\users\$env:UserName\Desktop\SccmLogs *.* /e
		$richtextbox1.Text += $("`nSCCM Logs backed up." | Out-String)
	}
	function DeleteCache
	{
		Remove-Item -path C:\Windows\ccmcache\* -Force -Recurse
		$richtextbox1.Text += "`nDeleted SCCM Cache."
	}
	function DeleteSCCM
	{
		$richtextbox1.Text += "`nUninstalling SCCM"
		cmd /c "%windir%\ccmsetup\ccmsetup.exe /uninstall"

		# Stop Services
		Stop-Service -Name ccmsetup -Force -ErrorAction SilentlyContinue
		Stop-Service -Name CcmExec -Force
		Stop-Service -Name smstsmgr -Force
		Stop-Service -Name CmRcService -Force

		# Remove WMI Namespaces
		Get-WmiObject -Query “SELECT * FROM __Namespace WHERE Name='ccm'” -Namespace root | Remove-WmiObject
		Get-WmiObject -Query “SELECT * FROM __Namespace WHERE Name='ms'” -Namespace root\cimv2 | Remove-WmiObject

		# Remove Services from Registry
		$MyReg = “HKLM:\SYSTEM\CurrentControlSet\Services”
		Remove-Item -Path $MyReg\CCMSetup -Force -Recurse -ErrorAction SilentlyContinue
		Remove-Item -Path $MyReg\CcmExec -Force -Recurse -ErrorAction SilentlyContinue
		Remove-Item -Path $MyReg\smstsmgr -Force -Recurse -ErrorAction SilentlyContinue
		Remove-Item -Path $MyReg\CmRcService -Force -Recurse -ErrorAction SilentlyContinue

		# Remove SCCM Client from Registry
		$MyPath = “HKLM:\SOFTWARE\Microsoft”
		Remove-Item -Path $MyPath\CCM -Force -Recurse -ErrorAction SilentlyContinue
		Remove-Item -Path $MyPath\CCMSetup -Force -Recurse -ErrorAction SilentlyContinue
		Remove-Item -Path $MyPath\SMS -Force -Recurse -ErrorAction SilentlyContinue

		# Remove Folders and Files
		$MyDir = $env:WinDir
		Remove-Item -Path $MyDir\CCM -Force -Recurse -ErrorAction SilentlyContinue
		Remove-Item -Path $MyDir\ccmsetup -Force -Recurse -ErrorAction SilentlyContinue
		Remove-Item -Path $MyDir\ccmcache -Force -Recurse -ErrorAction SilentlyContinue
		Remove-Item -Path $MyDir\SMSCFG.ini -Force -ErrorAction SilentlyContinue
		Remove-Item -Path $MyDir\SMS*.mif -Force -ErrorAction SilentlyContinue
		$richtextbox1.Text += "`nCompleted Uninstalling SCCM."
	}
	function cmTrace
	{
		{ 
			[system.Diagnostics.Process]::start("C:\WINDOWS\CCM\CMTrace.exe") 
		}
		#cmd /c "C:\WINDOWS\CCM\CMTrace.exe"
		$richtextbox1.Text += "`nStarted CMTrace."
	}
	function CcmRestart
	{
		$salvageRepo = (winmgmt /salvagerepository) | Out-String
		$richtextbox1.Text += $salvageRepo
	}
	function CcmRepair
	{
		$verifyRepo = (winmgmt /verifyrepository) | Out-String
		$richtextbox1.Text += $verifyRepo
	}

	function ResetRepo {
		$ResetRepo1 = (winmgmt /resetRepository) | Out-String
		$richtextbox1.Text += $ResetRepo1
	}
	function InstallSCCM {
		New-Item -Path "%windir%\" -Name "CCM" -ItemType "directory"
		cmd /c 'copy "\\servername\SCCM\Client\ccmsetup\ccmsetup.exe" "%windir%\CCM\ccmsetup.exe" /Z /Y'
		cmd /c "%windir%\CCM\ccmsetup.exe /forceinstall"
		taskmgr
		Invoke-Item c:\windows\ccmsetup\
		$richtextbox1.Text += "`nStarted CCM Setup."
	}
	$buttonMachinePolicyUpdates_Click={
		ReloadSccmClient
	}
	
	$buttonClientHealthEvalulat_Click={
		ClientHealthEval
	}
	
	$buttonBackupSCCMLogs_Click={
		BackupSccmLogs
	}
	
	$buttonRestartConfigMan_Click={
		RestartConfigMan
	}
	
	$buttonDeleteCache_Click={
		DeleteCache
	}

	$buttonDeleteSCCM_Click={
		DeleteSCCM
	}

	$buttonCMTrace_Click={
		CMTrace
	}

	$buttonCcmRestart_Click={
		CcmRestart
	}

	$buttonCcmRepair_Click={
		CcmRepair
	}

	$buttonInstallSCCM_Click={
		InstallSCCM
	}
	
	$buttonResetRepo_Click={
		ResetRepo
	}
	
	$buttonrebuildWMI_Click={
		rebuildWMI
	}

	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formSCCMToolKit.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$buttonDeleteCache.remove_Click($buttonDeleteCache_Click)
			$buttonRestartConfigMan.remove_Click($buttonRestartConfigMan_Click)
			$buttonBackupSCCMLogs.remove_Click($buttonBackupSCCMLogs_Click)
			$buttonClientHealthEvalulat.remove_Click($buttonClientHealthEvalulat_Click)
			$buttonMachinePolicyUpdates.remove_Click($buttonMachinePolicyUpdates_Click)
			$buttonDeleteSCCM.remove_Click($buttonDeleteSCCM_Click)
			$buttonInstallSCCM.remove_Click($buttonInstallSCCM_Click)
			$buttonrebuildWMI.remove_Click($buttonrebuildWMI_Click)
			#$button.ResetRepo.remove_Click($buttonResetRepo_Click)
			$formSCCMToolKit.remove_Load($formSCCMToolKit_Load)
			$formSCCMToolKit.remove_Load($Form_StateCorrection_Load)
			$formSCCMToolKit.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formSCCMToolKit.SuspendLayout()
	$groupbox1.SuspendLayout()
	#
	# formSCCMToolKit
	#
	$formSCCMToolKit.Controls.Add($richtextbox1)
	$formSCCMToolKit.Controls.Add($groupbox1)
	#$formSCCMToolKit.Controls.Add($richtextbox1)
	$formSCCMToolKit.Controls.Add($buttonrebuildWMI)
	$formSCCMToolKit.Controls.Add($buttonDeleteCache)
	$formSCCMToolKit.Controls.Add($labelContact)
	$formSCCMToolKit.Controls.Add($labelNewinghaerauedu)
	$formSCCMToolKit.Controls.Add($labelSCCMToolKit)
	$formSCCMToolKit.Controls.Add($buttonRestartConfigMan)
	$formSCCMToolKit.Controls.Add($buttonBackupSCCMLogs)
	$formSCCMToolKit.Controls.Add($buttonClientHealthEvalulat)
	$formSCCMToolKit.Controls.Add($buttonMachinePolicyUpdates)
	$formSCCMToolKit.Controls.Add($buttonDeleteSCCM)
	$formSCCMToolKit.Controls.Add($buttoncmTrace)
	$formSCCMToolKit.Controls.Add($buttonCcmRestart)
	$formSCCMToolKit.Controls.Add($buttonCcmRepair)
	$formSCCMToolKit.Controls.Add($buttonInstallSCCM)
	$formSCCMToolKit.Controls.Add($buttonResetRepo)
	$formSCCMToolKit.AutoScaleDimensions = '6, 13'
	$formSCCMToolKit.AutoScaleMode = 'Font'
	$formSCCMToolKit.ClientSize = '400, 500'
	$formSCCMToolKit.Name = 'formSCCMToolKit'
	$formSCCMToolKit.Text = 'SCCM ToolKit '
	$formSCCMToolKit.add_Load($formSCCMToolKit_Load)
	# richtextbox1
	#
	$richtextbox1.Font = 'Microsoft Sans Serif, 8pt'
	$richtextbox1.Location = '210, 183'
	$richtextbox1.Name = 'richtextbox1'
	$richtextbox1.Size = '300, 280'
	$richtextbox1.TabIndex = 10
	$richtextbox1.Text = $richtextbox1.Text
	#
	# groupbox1
	#
	$groupbox1.Controls.Add($buttonCCMRestart)
	$groupbox1.Controls.Add($buttonCCMRepair)
	$groupbox1.Controls.Add($buttonResetRepo)
	$groupbox1.Location = '210, 56'
	$groupbox1.Name = 'groupbox1'
	$groupbox1.Size = '140, 120'
	$groupbox1.TabIndex = 9
	$groupbox1.TabStop = $False
	$groupbox1.Text = 'WMI Tools'
	$groupbox1.UseCompatibleTextRendering = $True
	#
	# buttonBackupSCCMLogs
	#
	$buttonBackupSCCMLogs.Location = '32, 143'
	$buttonBackupSCCMLogs.Name = 'buttonBackupSCCMLogs'
	$buttonBackupSCCMLogs.Size = '144, 23'
	$buttonBackupSCCMLogs.TabIndex = 2
	$buttonBackupSCCMLogs.Text = 'Backup SCCM Logs'
	$buttonBackupSCCMLogs.UseCompatibleTextRendering = $True
	$buttonBackupSCCMLogs.UseVisualStyleBackColor = $True
	$buttonBackupSCCMLogs.add_Click($buttonBackupSCCMLogs_Click)
	#
	# $buttonrebuildWMI
	#
	$buttonrebuildWMI.Location = '32, 259'
	$buttonrebuildWMI.Name = 'buttonrebuildWMI'
	$buttonrebuildWMI.Size = '144, 23'
	$buttonrebuildWMI.TabIndex = 2
	$buttonrebuildWMI.Text = 'Rebuild WMI'
	$buttonrebuildWMI.ForeColor = 'Red'
	$buttonrebuildWMI.BackColor = 'Black'
	$buttonrebuildWMI.UseCompatibleTextRendering = $True
	$buttonrebuildWMI.UseVisualStyleBackColor = $True
	$buttonrebuildWMI.add_Click($buttonrebuildWMI_Click)
	#
	# labelOutPutGUI
	#
	#$labelOutPutGUI.AutoSize = $True
	#$labelOutPutGUI.Font = 'Microsoft Sans Serif, 10pt'
	#$labelOutPutGUI.Location = '21, 465'
	#$labelOutPutGUI.Name = 'labelOutPutGUI'
	#$labelOutPutGUI.Size = '80, 20'
	#$labelOutPutGUI.TabIndex = 8
	#$labelOutPutGUI.Text = "$OutPutGUI"
	#$labelOutPutGUI.UseCompatibleTextRendering = $True
	#
	# buttonDeleteCache
	#
	$buttonDeleteCache.Location = '32, 172'
	$buttonDeleteCache.Name = 'buttonDeleteCache'
	$buttonDeleteCache.Size = '144, 23'
	$buttonDeleteCache.TabIndex = 7
	$buttonDeleteCache.Text = 'Delete SCCM Cache'
	$buttonDeleteCache.UseCompatibleTextRendering = $True
	$buttonDeleteCache.UseVisualStyleBackColor = $True
	$buttonDeleteCache.add_Click($buttonDeleteCache_Click)
	#
	# buttonDeleteSCCM
	#
	$buttonDeleteSCCM.Location = '32, 335'
	$buttonDeleteSCCM.Name = 'buttonDeleteSCCM'
	$buttonDeleteSCCM.Size = '144, 23'
	$buttonDeleteSCCM.TabIndex = 9
	$buttonDeleteSCCM.Text = 'Delete SCCM Client'
	$buttonDeleteSCCM.ForeColor = 'Red'
	$buttonDeleteSCCM.BackColor = 'Black'
	$buttonDeleteSCCM.UseCompatibleTextRendering = $True
	$buttonDeleteSCCM.UseVisualStyleBackColor = $True
	$buttonDeleteSCCM.add_Click($buttonDeleteSCCM_Click)
	#
	# buttonInstallSCCM
	#
	$buttonInstallSCCM.Location = '32, 201'
	$buttonInstallSCCM.Name = 'buttonInstallSCCM'
	$buttonInstallSCCM.Size = '144, 23'
	$buttonInstallSCCM.TabIndex = 13
	$buttonInstallSCCM.Text = 'Install SCCM'
	$buttonInstallSCCM.UseCompatibleTextRendering = $True
	$buttonInstallSCCM.UseVisualStyleBackColor = $True
	$buttonInstallSCCM.add_Click($buttonInstallSCCM_Click)
	#
	# buttonCMTrace
	#
	$buttonCMTrace.Location = '32, 230'
	$buttonCMTrace.Name = 'buttonCMTrace'
	$buttonCMTrace.Size = '144, 23'
	$buttonCMTrace.TabIndex = 10
	$buttonCMTrace.Text = 'Run CMTrace'
	$buttonCMTrace.UseCompatibleTextRendering = $True
	$buttonCMTrace.UseVisualStyleBackColor = $True
	$buttonCMTrace.add_Click($buttonCMTrace_Click)
	#
	# buttonCcmRestart - Salvage Repo
	#
	$buttonCcmRestart.Location = '17, 29'
	$buttonCcmRestart.Name = 'buttonCcmRestart'
	$buttonCcmRestart.Size = '101, 23'
	$buttonCcmRestart.TabIndex = 11
	$buttonCcmRestart.Text = 'Salvage Repo'
	$buttonCcmRestart.UseCompatibleTextRendering = $True
	$buttonCcmRestart.UseVisualStyleBackColor = $True
	$buttonCcmRestart.add_Click($buttonCcmRestart_Click)
	#
	# buttonCcmRepair - Verify Repo
	#
	$buttonCcmRepair.Location = '17, 58'
	$buttonCcmRepair.Name = 'buttonCcmRepair'
	$buttonCcmRepair.Size = '101, 23'
	$buttonCcmRepair.TabIndex = 12
	$buttonCcmRepair.Text = 'Verify Repo'
	$buttonCcmRepair.UseCompatibleTextRendering = $True
	$buttonCcmRepair.UseVisualStyleBackColor = $True
	$buttonCcmRepair.add_Click($buttonCcmRepair_Click)
	#
	# buttonResetRepo - Reset Repo
	#
	$buttonResetRepo.Location = '17, 87'
	$buttonResetRepo.Name = 'buttonResetRepo'
	$buttonResetRepo.Size = '101, 23'
	$buttonResetRepo.TabIndex = 15
	$buttonResetRepo.Text = 'Reset Repo'
	$buttonResetRepo.UseCompatibleTextRendering = $True
	$buttonResetRepo.UseVisualStyleBackColor = $True
	$buttonResetRepo.add_Click($buttonResetRepo_Click)
	#
	# labelContact
	#
	$labelContact.AutoSize = $True
	$labelContact.Location = '21, 485'
	$labelContact.Name = 'labelContact'
	$labelContact.Size = '61, 17'
	$labelContact.TabIndex = 6
	$labelContact.Text = 'Contact @:'
	$labelContact.UseCompatibleTextRendering = $True
	#
	# labelNewinghaerauedu
	#
	$labelNewinghaerauedu.AutoSize = $True
	$labelNewinghaerauedu.Location = '79, 485'
	$labelNewinghaerauedu.Name = 'labelNewinghaerauedu'
	$labelNewinghaerauedu.Size = '109, 17'
	$labelNewinghaerauedu.TabIndex = 5
	$labelNewinghaerauedu.Text = 'newingha@erau.edu'
	$labelNewinghaerauedu.UseCompatibleTextRendering = $True
	#
	# labelSCCMToolKit
	#
	$labelSCCMToolKit.AutoSize = $True
	$labelSCCMToolKit.Font = 'Arial Narrow, 14pt, style=Bold'
	$labelSCCMToolKit.Location = '120, 18'
	$labelSCCMToolKit.Name = 'labelSCCMToolKit'
	$labelSCCMToolKit.Size = '112, 27'
	$labelSCCMToolKit.TabIndex = 4
	$labelSCCMToolKit.Text = 'SCCM ToolKit 0.15'
	$labelSCCMToolKit.UseCompatibleTextRendering = $True
	#
	# buttonRestartConfigMan
	#
	$buttonRestartConfigMan.Location = '32, 56'
	$buttonRestartConfigMan.Name = 'buttonRestartConfigMan'
	$buttonRestartConfigMan.Size = '144, 23'
	$buttonRestartConfigMan.TabIndex = 3
	$buttonRestartConfigMan.Text = 'Restart Config Manager'
	$buttonRestartConfigMan.UseCompatibleTextRendering = $True
	$buttonRestartConfigMan.UseVisualStyleBackColor = $True
	$buttonRestartConfigMan.add_Click($buttonRestartConfigMan_Click)
	#
	# buttonBackupSCCMLogs
	#
	$buttonBackupSCCMLogs.Location = '32, 143'
	$buttonBackupSCCMLogs.Name = 'buttonBackupSCCMLogs'
	$buttonBackupSCCMLogs.Size = '144, 23'
	$buttonBackupSCCMLogs.TabIndex = 2
	$buttonBackupSCCMLogs.Text = 'Backup SCCM Logs'
	$buttonBackupSCCMLogs.UseCompatibleTextRendering = $True
	$buttonBackupSCCMLogs.UseVisualStyleBackColor = $True
	$buttonBackupSCCMLogs.add_Click($buttonBackupSCCMLogs_Click)
	#
	# buttonClientHealthEvalulat
	#
	$buttonClientHealthEvalulat.Location = '32, 114'
	$buttonClientHealthEvalulat.Name = 'buttonClientHealthEvalulat'
	$buttonClientHealthEvalulat.Size = '144, 23'
	$buttonClientHealthEvalulat.TabIndex = 1
	$buttonClientHealthEvalulat.Text = 'Client Health Evalulation'
	$buttonClientHealthEvalulat.UseCompatibleTextRendering = $True
	$buttonClientHealthEvalulat.UseVisualStyleBackColor = $True
	$buttonClientHealthEvalulat.add_Click($buttonClientHealthEvalulat_Click)
	#
	# buttonMachinePolicyUpdates
	#
	$buttonMachinePolicyUpdates.Location = '32, 85'
	$buttonMachinePolicyUpdates.Name = 'buttonMachinePolicyUpdates'
	$buttonMachinePolicyUpdates.Size = '144, 23'
	$buttonMachinePolicyUpdates.TabIndex = 0
	$buttonMachinePolicyUpdates.Text = 'Machine Policy Updates'
	$buttonMachinePolicyUpdates.UseCompatibleTextRendering = $True
	$buttonMachinePolicyUpdates.UseVisualStyleBackColor = $True
	$buttonMachinePolicyUpdates.add_Click($buttonMachinePolicyUpdates_Click)
	$groupbox1.ResumeLayout()
	$formSCCMToolKit.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formSCCMToolKit.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formSCCMToolKit.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formSCCMToolKit.add_FormClosed($Form_Cleanup_FormClosed)
	#Show the Form
	return $formSCCMToolKit.ShowDialog()

} #End Function

#Call the form
Show-SCCM_ToolKit_psf | Out-Null
