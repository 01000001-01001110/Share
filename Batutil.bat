@ECHO off
:: \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
:: Original written by Alan Newingham 10/7/2018
:: ------------------------------------------------------------------------------------------------------------------------------------
::  Technician DOS Utilities.  
:: Completely Re-Written from scratch by Alan Newingham 12/5/2018
:: Last Updated 4/23/2019
:: ------------------------------------------------------------------------------------------------------------------------------------ 
:: Menu Option One(1) SubMenu One(1) backs up: 
:: Printer List
:: Outlook Signature
:: Desktop
:: Downloads
:: Documents
:: Pictures
:: Favorites
:: FireFox Bookmarks
:: Chrome Bookmarks
:: Adobe Signature/Security File
:: Windows Custom Dictionary
:: Outlook files including templates
:: PST/OST.
:: OS Version
:: System Name
:: Serial Number
:: Installed Programs list
:: Services list
:: Event Viewer Logs
:: Microsoft QuickParts
:: Python Environment
:: Virtual Box Configuration 
:: Visual Studio Code 
:: OneDrive for Business - Unsynced Changes
:: Firewall Settings Backed Up
:: Battery Report
:: System Power Report
:: Opens Devices and Printers
:: ipconfig /all
:: Export list of local admins
:: Export List Mapped Drives
:: ------------------------------------------------------------------------------------------------------------------------------------
:: Menu Option One(1) SubMenu Option Two(2) Restores from backup created :
:: Outlook Signature
:: Desktop
:: Downloads
:: Documents
:: Pictures
:: Favorites
:: FireFox Bookmarks
:: Chrome Bookmarks
:: Adobe Signature/Security File
:: Python Environment
:: Virtual Box Configuration 
:: Visual Studio Code 
:: Microsoft QuickParts
:: OneDrive for Business - Unsynced Changes
:: ------------------------------------------------------------------------------------------------------------------------------------
:: Menu Option One(1) SubMenu Option Three(3) Restores:
:: Outlook Signature
:: Desktop
:: Downloads
:: Documents
:: Pictures
:: Favorites
:: FireFox Bookmarks
:: Chrome Bookmarks
:: Adobe Signature/Security File
:: Python Environment
:: Virtual Box Configuration 
:: Visual Studio Code 
:: Microsoft QuickParts
:: OneDrive for Business - Unsynced Changes
:: ------------------------------------------------------------------------------------------------------------------------------------
:: Menu Option One(1) SubMenu Option Four(4) Restores:
:: From Specific location to a specific location
:: You provide both full UNC path's 
:: Example: C:\Users\%Username%\Desktop
:: ------------------------------------------------------------------------------------------------------------------------------------
:: Menu Option One(1) SubMenu Option Five(5) Backs up profile data to OneDrive.
:: Log file saved to the desktop backed up directory.
:: Desktop
:: Downloads
:: Documents
:: Pictures
:: Favorites
:: FireFox Bookmarks
:: Chrome Bookmarks
:: Adobe Signature/Security File
:: Microsoft QuickParts
:: Firewall Settings Backed Up
:: ------------------------------------------------------------------------------------------------------------------------------------
:: Menu Option Two(2) Main Menu
:: OS Version
:: System Name
:: Serial Number
:: Firewall Settings Backed Up
:: Installed Programs list
:: Services list
:: Event Viewer Logs
:: Battery Report
:: System Power Report
:: Opens Devices and Printers
:: ipconfig /all
:: Export list of local admins
:: Export List Mapped Drives
:: ------------------------------------------------------------------------------------------------------------------------------------
:: Option Three(3) Main Menu
:: 
:: Option One (1) now offers the option to restart the computer in one of three safe mode options. 
:: Safe Mode
:: Safe Mode with Networking
:: Safe Mode with Command Prompt
:: ------------------------------------------------------------------------------------------------------------------------------------
:: Option 2 WMI Repair Tool
:: Repairs WMI on a Win7/10 computer. It will prompt you based off your input. 
::
::
:: Option 3 Free Space Cleaner
:: Delete everything in %TEMP%
:: Delete any and all shadow copies. (THIS HAS BEEN REMOVED)
:: Get rid of any downloaded software updates.
:: Delete any hidden Windows install files. Chances are there are none, but it cannot hurt to check.
:: Delete the Windows prefetch files. There also probably none of those either.
:: Run disk cleanup.
:: Defragment the C:\ drive (It shouldn’t be that fragmented).
:: Clear the Event Logs. Execute one command on each line. (THIS HAS BEEN REMOVED)
:: Flush the DNS cache, because 8kb-15kb is still free space...
:: ------------------------------------------------------------------------------------------------------------------------------------
:: Option 4 Delete Profile Tool. 
:: Prompts you for input and makes sure you are aware this will delete data and there is no recovery. 
:: Deletes all profiles older than input date excluding default accounts like admin public or default
:: ------------------------------------------------------------------------------------------------------------------------------------
:: Option 5 Printer Install Tool
:: Prompts for the server, and printer name, then does the rest. For those systems that printer configuration doesn't load correctly. 
:: ------------------------------------------------------------------------------------------------------------------------------------
:: Option Four(4) Main Menu
:: ------------------------------------------------------------------------------------------------------------------------------------
:: Invokes the repair Configuration Manager client function
:: runs both Configuration Manager commands to update machine policy.
:: Does what it says
:: Forces a Client Health Evaluation on Configuration Manager which in turn might force it to communicate with SCCM sooner than later. 
:: Backs up the log folder to the profile desktop location.
:: Completely removes SCCM and rebuilds it by pulling a copy from \\fileserveraddress\directory\Software\SCCM\Client\ccmsetup\ccmsetup.exe 
::        Then takes the exe and completely rebuilds local configuration manager. 
:: 	      After running this please restart and wait up to two hours for SCCM to Propagate changes.
:: ------------------------------------------------------------------------------------------------------------------------------------
:: 
:: On 1/2/2019 was told we will move forward with sharing this script with Prescott. Welcome team! 
:: Using this command extracts locations within the command prompt once. 
:: ------------------------------------------------------------------------------------------------------------------------------------

:: Variable-ize the Reference site so I don't have to find it each time. 
setlocal enableDelayedExpansion
:: Purpose of this is to log the use of this tool going forward. 
:: Primarily to see if I need to change the orders of the menus based on usage. 
:: Got a bit more fancy with this. 
:: Changing this to log more and to searchable CSV. 
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j

set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2% %ldt:~8,2%:%ldt:~10,2%:%ldt:~12,6%

for /F "usebackq" %%i IN (`hostname`) DO SET HOST=%%i
:: ------------------------------------------------------------------------------------------------------------------------------------
:: My version of randomization
set /a r1=%random% %%12345 +71
set /a r2=%random% %%67891 +651
set /a r3=%random% %%23450 +11
set /a r4=%random% %%67890 +21
set /a r5=%random% %%12345 +3
set /a val=%r1%+%r2%/%r3%+%r4%*%r5%
:: Randomize done. 
:: ------------------------------------------------------------------------------------------------------------------------------------
:: More Variables
:: Attempting to variablize the host and server locations.
set rl = "\\0.0.0.0\c$\record\%HOST%.csv"
set fs = "\\fileserveraddress\directory\"
:: Will add this functionality later after testing.
:: ------------------------------------------------------------------------------------------------------------------------------------

ECHO.
:: If this fails the "cls" command below will clean the screen before the technician can read it. 
:: Uses the %val% which is a unique number identifying the instance, the time and date, menu option selected, username that ran the file, and the computer name saved to the computer name .csv file.
:: Variable-ize the Reference site so I don't have to find it each time. 

ECHO %val%, %ldt%, Batch Utility Ran, %username%, %HOST%, v. 0.5.12 >> \\0.0.0.0\c$\record\%HOST%.csv
:: hostname >> \\0.0.0.0\c$\record\bat.txt
:: If this fails the "cls" command below will clean the screen before the technician can read it. 

:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: -/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\- IT SERVICES DOS UTILITIES MENU-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:BEGIN
CLS
ECHO.                 
ECHO			  IT SERVICES DOS UTILITIES MENU		     
ECHO			Please choose from the following options
ECHO.
ECHO.
ECHO				1 = Profile / Data Backup
ECHO				2 = System Logs 
ECHO				3 = System Tools
ECHO				4 = SCCM Tool Box
ECHO				5 = Inventory / Setup New Computer
ECHO				6 = Quit 
ECHO                                            v. 0.5.12
ECHO.
ECHO         "Fight till the last gasp." -William Shakespeare
ECHO.                      
CHOICE /N /C:123456
IF ERRORLEVEL ==6 GOTO :END
If ERRORLEVEL ==5 GOTO :ZEROZ
If ERRORLEVEL ==4 GOTO :FOURZ
IF ERRORLEVEL ==3 GOTO :THREEZ
IF ERRORLEVEL ==2 GOTO :TWOZ
IF ERRORLEVEL ==1 GOTO :ONEZ

GOTO END

:ZEROZ
ECHO %val%, %ldt%, Inventory / Setup New Computer, %username%, %HOST% >> \\0.0.0.0\c$\record\%HOST%.csv
:: Inventory / Setup New Computer
:: Start by clearing the screen, then we will add each function independently and let the user go through the options at their own pace. 
CLS
:: Start Inventory
ECHO Starting the system inventory please wait. This will require support.account access to run.
start \\fileserveraddress\directory\SINPU.exe
ECHO Finished the system inventory. Thank you for waiting.
ECHO Next up is opening applications.
:: Finished Inventory
pause
:: Enabling the F8 key for advanced boot menu. 
ECHO Setting system to use F8 to boot into advanced boot options (safe mode)
bcdedit /set {default} bootmenupolicy legacy
ECHO Completed setting system to legacy F8 safe mode option.
:: Completed setting F8 key like legacy.
pause
:: Opening Browsers and Outlook etc...
ECHO Opening applications for customer. 
ECHO Applications include Outlook, Chrome, and Firefox
start "" "%ProgramFiles(x86)%\Microsoft Office\Office16\Outlook.exe"
start "" "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
start "" "%ProgramFiles%\Mozilla Firefox\firefox.exe"
start "" "%AppData%\Local\Microsoft\OneDrive\OneDrive.exe"
start control
start control /name Microsoft.DevicesAndPrinters
ECHO Completed opening applications for customer.
:: Completed opening Browsers and Outlook
pause
:: Deleting the task bar icons
ECHO Deleting taskbar icons.
DEL /F /S /Q /A "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar*"
REG DELETE HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /F
:: Stop and start explorer.exe for the changes to reflect.
taskkill /f /im explorer.exe
start explorer.exe
ECHO Completed deleting taskbar icons.
:: Done with task bar icon removal
pause

:: Begin Power Settings Changes. 
:: =============================================================================================================================================================
:: PC
set /p "q1=Are you running a [P]C or a [L]aptop? [P/L] "
ECHO.
if /I "%q1%" EQU "P" goto :PC
if /I "%q1%" EQU "L" goto :LT

:PC
:: PC Settings, Turn everything off.
powercfg /x -standby-timeout-ac 0 :: set sleep off on AC
powercfg /x -hibernate-timeout-ac 0 :: set hibernate off on AC
powercfg /x -hibernate-timeout-dc 0 :: set hibernate off on DC
powercfg /x -disk-timeout-ac 0 :: set disk timeout off on AC
powercfg /x -disk-timeout-dc 0:: set disk timeout off on DC
powercfg /x -monitor-timeout-ac 0 :: set monitor timeout off on AC
powercfg /x -monitor-timeout-dc 0 :: set monitor timeout off on DC
powercfg /x -standby-timeout-dc 0 :: set sleep off on DC
powercfg /setactive scheme_current :: Reactivates the current scheme as this needs done after the changes have been made. 



:LT
:: Laptop Settings, turn off disk timeout and set other settings to not off, but not inconvienient. Plus you do not want to shut off sleep on a laptop as that is the only way it regulates and shuts down properly. 
powercfg /x -disk-timeout-ac 0 :: set disk timeout off on AC
powercfg /x -disk-timeout-dc 0 :: set disk timeout off on DC
powercfg /x -monitor-timeout-ac 60 :: set monitor timeout off on AC
powercfg /x -monitor-timeout-dc 60 :: set monitor timeout off on DC
Powercfg /x -standby-timeout-ac 240 :: set sleep 4hours on AC
powercfg /x -standby-timeout-dc 240 :: set sleep 4hours on DC
powercfg /setdcvalueindex scheme_current sub_buttons lidaction 0 :: Setting lid close action to null

powercfg /setactive scheme_current :: Reactivates the current scheme as this needs done after the changes have been made. 


:: =============================================================================================================================================================
:: End Power Settings Changes.

:: Getting the IP address of the technicians computer to open an RDP session.
:: I travel light, and by light I mean no laptop/surface, so I use the device I am working on, while transferring files to update tickets/scripts.
set /p "rdpip=Hello %username%, We will now open an RDP session. What is the IP address of your desk computer? : "
ECHO.
:: Tried to make it clear you can exit out of this question if you do not care. 
set /p "q=Thank you, %username%. You said the IP address is %rdpip% is this correct? [Y/N/Q]"
ECHO.
if /I "%q%" EQU "Y" goto :YES9975
if /I "%q%" EQU "N" goto :ZEROZ
if /I "%q%" EQU "Q" goto :BEGIN

:YES9975
mstsc /v: %rdpip%
:: End RDP section.


:: Created to copy the Software Center link to the desktop globally. 
:: If it's already there it will skip doing this so as to not create more than one icon.
IF EXIST "C:\users\Public\Desktop\Software Center.lnk" GOTO :BEGIN
copy  "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft System Center\Configuration Manager\Software Center.lnk" "C:\users\Public\Desktop\Software Center.lnk"
:: fin' 
pause
GOTO :BEGIN


:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: -/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\- IT SERVICES DOS UTILITIES MENU-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\-/=+\
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:FOURZ
cls
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Begin SCCM Tool Box Configuration--
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:FOUR
:: SCCM TOOL BOX 
cls

ECHO.                 
ECHO           -TECHNICIAN DOS SCCM TOOL BOX		     
ECHO        Please choose from the following options
ECHO.
ECHO		1 = SCCM Repair Utility
ECHO		2 = Machine Policy Updates 
ECHO		3 = Restart Configuration Manager
ECHO		4 = Client Health Evaluation
ECHO		5 = Backing up SCCM log files
ECHO		6 = SCCM Removal / Reinstall
ECHO		7 = Only Install SCCM Client
ECHO        8 = Exit To Main Menu
ECHO.
ECHO            It did get bigger...
ECHO.
CHOICE /N /C:12345678 
ECHO.
If ERRORLEVEL ==8 GOTO :BEGIN
If ERRORLEVEL ==7 GOTO :INSTALLSCCM
If ERRORLEVEL ==6 GOTO :FOUR6
If ERRORLEVEL ==5 GOTO :FOUR5
If ERRORLEVEL ==4 GOTO :FOUR4
IF ERRORLEVEL ==3 GOTO :FOUR3
IF ERRORLEVEL ==2 GOTO :FOUR2
IF ERRORLEVEL ==1 GOTO :FOUR1

pause
:FOUR1

ECHO %val%, %ldt%, SCCM Repair Utility, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv

:: Running the command to repair SCCM client
ECHO Running SCCM Repair Utility 
WMIC /namespace:\\root\ccm path sms_client CALL RepairClient
ECHO Completed backing up GP information. 
pause 
GOTO :FOUR

:FOUR2

ECHO %val%, %ldt%, SCCM Info, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv

:: Running the command to run Machine Policy Updates.
ECHO Refreshing SCCM Information, Running Machine Policy Updates... 
ECHO.
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000021}" /NOINTERACTIVE
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000022}" /NOINTERACTIVE
ECHO Started the Machine Policy Update Process. 
pause
GOTO :FOUR

:FOUR3

ECHO %val%, %ldt%, Restarting Configuration Manager, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv

:: Restarting SCCM on Local Device.
ECHO Restarting Configuration Manager on Local Device. 
ECHO.
"%SystemRoot%\ccm\ccmrestart.exe"
pause
GOTO :FOUR

:FOUR4

ECHO %val%, %ldt%, Run Client Health Evaluation, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv

:: Run Client Health Evaluation
ECHO Running Client Health Evaluation
ECHO.
"%SystemRoot%\ccm\ccmeval.exe"
ECHO Completed
GOTO :FOUR

:FOUR5

ECHO %val%, %ldt%, SCCM log, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv

:: Backing up SCCM log files

ECHO Backing up SCCM log files
ECHO.
set /p "lg=Hello %username% you selected to backup the SCCM Logs. Please enter the entire path to the directory you are saving the logs to, including drive letter : "
ECHO.
set /p "q=Thank you, %username%. You will now backup the system info to %lg% are you sure? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :YES3
if /I "%q%" EQU "N" goto :TOO
if /I "%q%" EQU "Q" goto :BEGIN
:YES3

:: Ran into an issue where the backup directory needed built first. So adding the directory creation before backup starts to not have this issue. 
md %lg%

Robocopy "C:\Windows\CCM\Logs" %lg% *.* /e 
GOTO :FOUR

:FOUR6

ECHO %val%, %ldt%, SCCM Removal, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv

ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO ####################################################################################################################################################################
ECHO Welcome, this is the Last Option, SCCM Removal tool. ONLY USE THIS IF EVERY OTHER OPTION FAILED!!!
ECHO.
ECHO.
ECHO This script will check for SCCM 2007, 2012, SMSCFG, and promptly remove all traces of it. 
ECHO.
ECHO The process goes like this; Once the "Last Option" portion runs it will finish with reinstalling, and pulling a fresh copy from J:\ and running a new install. 
ECHO After the install is completed please delete the old record from the SCCM console as there will now be two copies. 
ECHO.
ECHO Lastly before this begins understand that all changes in SCCM take time to propagate. Be Patient.
ECHO.
ECHO.
ECHO When you are ready... GO! 
ECHO ####################################################################################################################################################################
pause
ECHO.
:: Some systems have SCCM 2007... highly unlikely but why not add it just in case? 
ECHO Checking for SCCM 2007 client...
IF EXIST %windir%\System32\ccmsetup\ccmsetup.exe GOTO DELETE07
ECHO No SCCM 2007 client found.
ECHO.
:: Check to see if SCCM 2012 client is installed, if it is go 
ECHO Checking for SCCM 2012 client...
IF EXIST %windir%\ccmsetup\ccmsetup.exe GOTO DELETE12
ECHO No SCCM 2012 client found.
ECHO.
:: Check to see if SMSCFG file is present, if so delete. 
ECHO Checking for SMSCFG file...
IF EXIST %windir%\SMSCFG.INI GOTO DELETEINI
ECHO No SMSCFG file found.
ECHO All software already removed or no client installed.
ECHO.
GOTO INSTALLSCCM

:DELETE07
ECHO Found SCCM Client v2007. Removing...
%windir%\System32\ccmsetup\ccmsetup.exe /uninstall
RD /S /Q %windir%\System32\ccmsetup
RD /S /Q %windir%\System32\ccm
RD /S /Q %windir%\System32\ccmcache
ECHO SCCM Client 2007 removed.
IF EXIST %windir%\ccmsetup\ccmsetup.exe GOTO DELETE12
IF EXIST %windir%\SMSCFG.INI GOTO DELETEINI
GOTO INSTALLSCCM

:DELETE12
ECHO Found SCCM client v2012. Removing.
%windir%\ccmsetup\ccmsetup.exe /uninstall
RD /S /Q %windir%\ccmsetup
RD /S /Q %windir%\ccm
RD /S /Q %windir%\ccmcache
ECHO SCCM Client 2012 removed.
IF EXIST %windir%\SMSCFG.INI GOTO DELETEINI
GOTO INSTALLSCCM

:DELETEINI
ECHO SMSCFG file found. Removing...
del /F %windir%\SMSCFG.INI
ECHO SMSCFG file removed.
GOTO INSTALLSCCM

:INSTALLSCCM

ECHO %val%, %ldt%, SCCM Install, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv

:: Now to install SCCM fresh from the J:\ Drive. 
:: Declair yo' vars
:: Copy the SCCM install file to the PC in the correct location.
ECHO Copying the SCCM install file
copy "\\fileserveraddress\directory\Software\SCCM\Client\ccmsetup\ccmsetup.exe" "%windir%\CCM\ccmsetup.exe" /Z /Y
ECHO Completed copying files
:: Run SCCM with /forceinstall to get things moving. 
ECHO Installing SCCM client on PC. 
%windir%\CCM\ccmsetup.exe /forceinstall
GOTO END9


ECHO Completed, it is strongly advised that you do not restart for at least 15 minutes.
ECHO. 
ECHO Thank you and have a great day! 
ECHO. 
pause
:END9
cls
ECHO Batmat is not a real superhero. Just sayin'.
timeout 3
cls
GOTO FOUR




:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: End SCCM Tool Box Configuration-
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:THREEZ
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+Begin Menu Three Configuration+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Option 3 Free Space Cleaner
:: Delete everything in %TEMP%
:: Delete any and all shadow copies.
:: Get rid of any downloaded software updates.
:: Delete any hidden Windows install files. Chances are there are none, but it cannot hurt to check.
:: Delete the Windows prefetch files. There also probably none of those either.
:: Run disk cleanup.
:: De-fragment the C:\ drive (It shouldn’t be that fragmented).
:: Clear the Event Logs. Execute one command on each line.
:: Flush the DNS cache, because 8kb-15kb is still free space...

:: Option 2 WMI Repair Tool
:: Repairs WMI on a Win7/10 computer. It will prompt you based off your input.  

:: Option 4 Delete Profile Tool
:: This option deletes all profiles on the local computers past the date that you specify.

:: Option 5 Printer Install Tool
:: Installs a printer after asking what the server name and printer name is. 

:: Option 6 Symbolic Links Setup
:: Symbolic Links Setup
:: This creates links from the local PC to onedrive but does not create more space on the local system. 
:: Convenient way to backup data automatically. 
:: Only set to backup Desktop/Documents/Downloads because --
:: syncing other directories creates massive sync issues as the files are in use the moment you login.

:THREE
ECHO %val%, %ldt%, System Tools, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
:: Menu Option #3 Profile & Data Backup
CLS
ECHO.                 
ECHO        IT SERVICES SYSTEM TOOLS MENU		     
ECHO          Please choose from the following options
ECHO.
ECHO        1 = Safe Mode Tools
ECHO        2 = WMI Repair Tool
ECHO        3 = Free Space Cleaner 
ECHO        4 = Delete Profile Tool
ECHO        5 = Printer Install Tool
ECHO        6 = Symbolic Links Setup
ECHO        7 = Main Menu
ECHO.
ECHO   "Yes, of course! The Holy Hand Grenade of Antioch!"
CHOICE /N /C:1234567
ECHO.
IF ERRORLEVEL ==7 GOTO :BEGIN
IF ERRORLEVEL ==6 GOTO :FIVE35
IF ERRORLEVEL ==5 GOTO :FOUR34
IF ERRORLEVEL ==4 GOTO :THREE33
IF ERRORLEVEL ==3 GOTO :ONE3
IF ERRORLEVEL ==2 GOTO :TWO3
IF ERRORLEVEL ==1 GOTO :SMBEGIN
GOTO END

:ONE3

:: Purpose of this is to log the use of this tool going forward. 
:: Append PC name to txt file on my PC, if using support.account should not have any issues getting access to the directory. 
:: If this fails the "cls" command will clean the screen before the technician can read it. 
ECHO %val%, %ldt%, Free Space Cleaner, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv

CLS

:: Delete everything in %TEMP%
del %TEMP%\*.* /f /s /q

:: Delete any and all shadow copies.
:: vssadmin delete shadows /All /Quiet (This was asked to be removed by security. 

:: Get rid of any downloaded software updates.
del c:\Windows\SoftwareDistribution\Download\*.* /f /s /q

:: Delete any hidden Windows install files. Chances are there are none, but it cannot hurt to check.
del %windir%\$NT* /f /s /q /a:h

:: Delete the Windows prefetch files. There also probably none of those either.
del c:\Windows\Prefetch\*.* /f /s /q

:: Run disk cleanup.
c:\windows\system32\cleanmgr /sagerun:1

:: Defragment the C:\ drive (It shouldn’t be that fragmented).
:: defrag c: /U /V

:: Clear the Event Logs. Execute one command on each line.
:: wevtutil el 1>cleaneventlog.txt
:: for /f %%x in (cleaneventlog.txt) do wevtutil cl %%x
:: del cleaneventlog.txt

:: Flush the DNS cache, because 8kb-15kb is still free space...
:: ipconfig /flushdns

pause
ECHO Okay, bye bye!

GOTO BEGIN

:SMBEGIN

ECHO %val%, %ldt%, Safe Mode Menu, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
CLS
ECHO.                 
ECHO		     IT SERVICES DOS SAFE MODE TOOLS MENU	     
ECHO			 Please choose from the following options
ECHO.
ECHO			1 = Reboot in Safe Mode
ECHO			2 = Reboot in Safe Mode With Neworking
ECHO			3 = Reboot in Safe Mode with Command Prompt
ECHO			4 = Set computer to use "F8" for safe mode
ECHO			5 = Revert back to default from the "F8" change
ECHO			6 = Exit To Main Menu 
ECHO.
ECHO												v. 0.0.1 
ECHO			           "I like pie!" - Alan Newingham
ECHO.
CHOICE /N /C:123456
If ERRORLEVEL ==6 GOTO :BEGIN
If ERRORLEVEL ==5 GOTO :SMFIV
If ERRORLEVEL ==4 GOTO :SMFOU
IF ERRORLEVEL ==3 GOTO :SMTHR
IF ERRORLEVEL ==2 GOTO :SMTWO
IF ERRORLEVEL ==1 GOTO :SMONE
GOTO :SMEND


:SMONE
:: Safe Mode
ECHO %val%, %ldt%, Basic Safe Mode Option, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
bcdedit /set {default} safeboot minimal
pause 
GOTO :BEGIN

:SMTWO
:: Safe Mode with Networking
ECHO %val%, %ldt%, Safe Mode W/Networking, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
bcdedit /set {default} safeboot network
pause
GOTO :BEGIN

:SMTHR
:: Safe Mode with Command Prompt
ECHO %val%, %ldt%, Safe Mode W/Networking, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
bcdedit /set {default} safeboot minimal 
bcdedit /set {default} safebootalternateshell yes
pause
GOTO :BEGIN

:SMFOU
:: Enabling the F8 key for advanced boot menu. 
ECHO %val%, %ldt%, Enable F8, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
ECHO Setting system to use F8 to boot into advanced boot options (safe mode)
bcdedit /set {default} bootmenupolicy legacy
ECHO Completed setting system to legacy F8 safe mode option.
:: Completed setting F8 key like legacy.
pause
GOTO :BEGIN

:SMFIV
:: Disabling the F8 key for advanced boot menu.
ECHO %val%, %ldt%, Disable F8, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv 
ECHO Setting system to default safe mode option.
bcdedit /set {default} bootmenupolicy standard
ECHO Completed setting system to default safe mode option.
:: Completed setting F8 key like legacy.
pause
GOTO :BEGIN

:SMEND
GOTO :BEGIN

:TWO3



:: Purpose of this is to log the use of this tool going forward. 
:: Append PC name to txt file on my PC, if using support.account should not have any issues getting access to the directory. 
ECHO %val%, %ldt%, WMI Repair, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
:: If this fails the "cls" command will clean the screen before the technician can read it. 

cls 

ECHO.
ECHO.
ECHO.
ECHO          Welcome to the WMI Repair Tool
ECHO.
ECHO.
ECHO            1.) Win7 Repair 
ECHO            2.) Win10 Repair
ECHO            3.) Email Santa
ECHO.
ECHO.
ECHO      Please try not to leave any fingerprints... 
ECHO
choice /N /C:123
IF ERRORLEVEL ==3 GOTO :BEGIN
IF ERRORLEVEL ==2 GOTO :WMI2
IF ERRORLEVEL ==1 GOTO :WMI1
GOTO :BEGIN

:WMI1
:: Windows7 
ECHO %val%, %ldt%, WMI Windows 7, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
ECHO Starting Verifying the repository for Windows 7...
ECHO. 

cd /d % windir% \System32\Wbem
net stop winmgmt
ECHO. 
winmgmt /clearadap
winmgmt /kill
winmgmt /unregserver
winmgmt /regserver
winmgmt /resyncperf
ECHO. 
del % windir% \System32\Wbem\Repository /Q
del % windir% \System32\Wbem\AutoRecover /Q
ECHO. 
for % % i in (* .dll) do Regsvr32 -s % % i
for % % i in (* .mof, * .mfl) do Mofcomp % % i
wmiadap.exe /Regsvr32
wmiapsrv.exe /Regsvr32
wmiprvse.exe /Regsvr32
ECHO. 
net start winmgmt
ECHO. 
ECHO Completed unless errors above. 
pause
GOTO :END


:WMI2
:: Windows10
ECHO %val%, %ldt%, WMI Windows 10, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
ECHO Starting Verifying the repository for Windows 10...
ECHO.
winmgmt /verifyrepository
ECHO.
ECHO If the repository is not corrupted, a “WMI Repository is consistent” message will be returned. If you get something else, go to step 3. If the repository is consistent, you need to troubleshoot more granularly. The repository is not the problem.
ECHO.
ECHO.
set /p "q1=With the above information do we need to continue the repair process? [Y/N] "
ECHO.
if /I "%q1%" EQU "Y" goto :THREE2
if /I "%q1%" EQU "N" goto :WMI2
if /I "%q1%" EQU "Q" goto :BEGIN

:THREE2
ECHO Running repository salvage...
ECHO.
winmgmt /salvagerepository
ECHO.
ECHO  If the repository salvage fails to work, then continue, otherwise do not. 
ECHO.
set /p "q2=With the above information do we need to continue the repair process? [Y/N] "
ECHO.
if /I "%q2%" EQU "Y" goto :THREE3
if /I "%q2%" EQU "N" goto :WMI2
if /I "%q2%" EQU "Q" goto :BEGIN

:THREE3
ECHO.
ECHO.
winmgmt /resetrepository
ECHO.
ECHO There should be a “WMI Repository has been reset” message returned that verifies the command was successful.
ECHO.
ECHO If there was then you have successfully repaired the WMI, if not... 
pause
cls
ECHO I don't know... sorry. 
pause
GOTO :BEGIN

:THREE33
:PRN1
ECHO %val%, %ldt%, Profile Deletion Tool, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
cls
ECHO.
ECHO.
ECHO.
ECHO.
set /p "un=Please provide the count of days you would like to delete past[Example: 365 days for one(1) year]: " 
ECHO.
set /p "q=We have commited to deleting everything older than %un% days from today are you sure? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :PRY1
if /I "%q%" EQU "N" goto :PRN1
if /I "%q%" EQU "Q" goto :BEGIN
:PRY1
ECHO. 
cls
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO.
ECHO ============================================================================
ECHO NOTE: This is the last prompt you will be given before completely wiping
ECHO       any and all data that is older than %un% days old from C:\Users\
ECHO  Continuing past this prompt will be regretable if you need to recover data
ECHO  that is older than %un% days old and did not complete a backup of their data.
ECHO ============================================================================

pause

set EX="Public" "Administrator" "Default"
:: Mix and match of batch and power-shell I pipe the ECHO and robocopy commands and then use find to grab the data we need
:: Then once this is completed I pull the files from the directory in a fake robocopy command that moves them to null. 
for /d %%D in (C:\users\*) do (
ECHO %EX% | find /i """%%~nD""" >nul
if errorlevel 1 (
set too_new=0
robocopy "%%D" "%%D" /L /v /s /xjd /minage:%un% | findstr /r /c:"^. *too new" >nul
if errorlevel 1 (
ECHO Deleting %un% days old %%D
rd /s /q "%%D"
)
)
)
pause
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=Begin Printer Install Scriptn+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:FOUR34
:: Starting the process...
ECHO Welcome to the  network printer install script. 
ECHO.


:YSRV
set /p "srv=Which print server will we be connecting to in order to install printers? "
ECHO.
set /p "q=You stated the print server is %srv% are you sure? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :SRV
if /I "%q%" EQU "N" goto :YSRV
if /I "%q%" EQU "Q" goto :CLOSE

:SRV
ECHO.
set /p "prn=Hello %username% what is the name of the printer on the print server? "
ECHO.
set /p "q=You stated we are installing the printer \\%srv%\%prn% are you sure? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :YESRV
if /I "%q%" EQU "N" goto :YSRV
if /I "%q%" EQU "Q" goto :CLOSE




:YESRV
ECHO %val%, %ldt%, Printer Install, %username%, %HOST%, \\%srv%\%prn%, >> \\0.0.0.0\c$\record\%HOST%.csv
rundll32 printui.dll,PrintUIEntry /ga /n\\%srv%\%prn%
GOTO :AGAINSRV




:AGAINSRV
set /p "q=Completed. Do you need to install another printer? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :YSRV
if /I "%q%" EQU "N" goto :BEGIN
if /I "%q%" EQU "Q" goto :CLOSE

:CLOSE
ECHO.
set /p "q=You stated you wanted to close this window is that correct? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :END
if /I "%q%" EQU "N" goto :BEGIN
if /I "%q%" EQU "Q" goto :BEGIN

GOTO BEGIN

:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=End Printer Install Scriptn+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=Start Symbolic link Creation Scriptn+=++=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:FIVE35
@cls
@echo off
setlocal
set un=%username%


set SymbolicLinkLocation=%UserProfile%\OneDrive - Embry-Riddle Aeronautical University\%un%

:: call used to be fancy. It's not really needed in this regard. 

call :CreateSymbolicLinkLocation
call :CreateSymbolicLink Desktop
call :CreateSymbolicLink Documents
call :CreateSymbolicLink Downloads
call :CreateSymbolicLink Music
call :CreateSymbolicLink Pictures
call :CreateSymbolicLink Videos
goto :EndScript

:: Here's some function sexiness...

:CreateSymbolicLinkLocation
echo Checking if "%SymbolicLinkLocation%" is available...
if exist "%SymbolicLinkLocation%" (
	echo "%SymbolicLinkLocation%" was found.
	echo.
	goto :eof
) else (
	echo "%SymbolicLinkLocation%" was not found.
	md "%SymbolicLinkLocation%"
	echo.
	goto :eof
)

:CreateSymbolicLink
echo Checking if "%SymbolicLinkLocation%\%1" is available...
if exist "%SymbolicLinkLocation%\%1" (
	echo "%1" was found.
	echo.
	goto :eof
) else (
	echo "%1" was not found.
	mklink /J "%SymbolicLinkLocation%\%1" "%UserProfile%\%1"
	echo.
	goto :eof
)

:EndScript
echo End
endlocal
pause
goto :BEGIN

:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=End Symbolic link Creation Scriptn+=++=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:TWOZ
ECHO %val%, %ldt%, System Log Backup, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ====================================================== IT SERVICES DOS BACKUP SYSTEM LOGS ==============================================================================
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:TWO

:TOO
ECHO Below is asking for the full path, Full path defined in this for E:\Users\Newingha\Desktop, will be input as "E:\Users\Newingha\Desktop", without quotes.
ECHO.
set /p "cn=Hello %username% you selected to back up the system info. Please enter the full path to the destination directory you are saving the data to : "
ECHO.
set /p "q=Thank you, %username%. You will now backup the system info to %cn% are you sure? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :YES3
if /I "%q%" EQU "N" goto :TOO
if /I "%q%" EQU "Q" goto :BEGIN
:YES3
:: Drive Letter
:: ECHO Below is asking for the Drive letter. Being defined in this for E:\Users\Newingha\Desktop, will be input by you as "E:"
:: ECHO.
:: set /p "dl=Fantastic. We are almost done %username% please enter the backup location drive letter: "
:: ECHO.
:: set /p "q1=You will now backup the system logs to the location: %dl%. Do you want to proceed %username%? [Y/N] "
:: ECHO.
:: if /I "%q1%" EQU "Y" goto :YES4
:: if /I "%q1%" EQU "N" goto :TOO
:: if /I "%q1%" EQU "Q" goto :BEGIN
:: :YES4 
:: Ran into an issue where the backup directory needed built first. So adding the directory creation before backup starts to not have this issue. 
md %cn%

:: I used this following ECHO to flag the beginning.
ECHO "Hold on %username%, this process will take some time"
ECHO "Getting Retrieval Of Printer list..."
start control /name Microsoft.DevicesAndPrinters
:: Using the following thanks to AricG for this line...
cscript C:\Windows\System32\Printing_Admin_Scripts\en-US\prnmngr.vbs -l >> %cn%\PrinterList.txt
:: wmic printer list brief >> %dl%:\backup\%un%\PrinterList.txt
ECHO "Printer List completed and in %cn%\PrinterList.txt."
ECHO.
:: OS Build and version, PC name, printers info added to text documents getting backed up to backup location.
ECHO Getting OS information 
ECHO.
ECHO Net Use Log
net use >> %cn%\NetUseLog.txt
ECHO.
WMIC OS LIST BRIEF >> %cn%\ComputerLog.txt
ECHO.
ECHO Getting serial number 
ECHO.
WMIC BIOS get serialnumber >> %cn%\ComputerLog.txt
ECHO.
ECHO Getting IP Information 
ECHO.
ipconfig /all >> %cn%\IPINFO.txt
ECHO.
ECHO Gathering the list of Local Administrators
ECHO.
net localgroup "Administrators" >> %cn%\LocalAdmins.txt
ECHO.
ECHO Getting computer name
ECHO.
WMIC OS GET csname >> %cn%\ComputerLog.txt
ECHO.
ECHO Getting Battery Information (If on a laptop)
ECHO.
powercfg /batteryreport /output %cn%\BatteryReport.html
ECHO.
ECHO Collecting services that are running. 
ECHO.
WMIC SERVICE where (state="running") GET caption, name, state >> %cn%\Services.txt
ECHO.
ECHO Gathering Firewall Information
ECHO.
netsh advfirewall export "%cn%\firwallpolicy.wfw"
ECHO.
ECHO Gathering GP data. 
ECHO.
gpresult /SCOPE COMPUTER /Z >> %cn%\Group_Policy.txt
ECHO.
ECHO Gathering last 500 Event Viewer records.
ECHO.
WEVTUtil query-events System /count:500 /rd:true /format:text >> %cn%\Eventlog.txt
ECHO.
ECHO Completed with Getting OS Information.
ECHO.
:: Adding the backup of installed programs log. 
ECHO Making a list and saving the installed programs to backup location.
ECHO.
wmic /output:%cn%\Programs.txt product get name,version 
ECHO.
ECHO All Done, going to main menu. 
pause. 
GOTO :BEGIN

:ONEZ

:: \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
::
:: Option One Backs Up
:: Printer List
:: Outlook Signature
:: Desktop
:: Downloads
:: Documents
:: Pictures
:: Favorites
:: FireFox Bookmarks
:: Chrome Bookmarks
:: Adobe Signature/Security File
:: Windows Custom Dictionary
:: Outlook files including templates
:: PST/OST.
:: OS Version
:: System Name
:: Serial Number
:: Installed Programs list
:: Services list
:: Event Viewer Logs
:: 
:: \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

:ONE
:: #####################################################################################################################
:: #######           ###  #  ### #  # #  # ####                                                                    ####
:: #######           ### ### #   ###  #  # #####                                                                   ####
:: #######           ### ### #   ###  #  # #                                                                       ####
:: #######           ### # # ### #  # #### #                                                                       ####
:: #####################################################################################################################

:: If this fails the "cls" command below will clean the screen before the technician can read it. 
:: Uses the %val% which is a unique number identifying the instance, the time and date, menu option selected, username that ran the file, and the computer name saved to the computer name .csv file.
:: Variable-ize the Reference site so I don't have to find it each time. 

ECHO %val%, %ldt%, Profile Backup Utility, %username%, %HOST%, v. 2.2.6 >> \\0.0.0.0\c$\record\PB-%HOST%.csv
:: Menu Option #1 Profile & Data Backup
CLS
ECHO.                 
ECHO		 IT SERVICES DOS PROFILE-DATA BACKUP / RECOVERY MENU		     
ECHO			Please choose from the following options
ECHO.
ECHO			1 = Backup / Prep Data For Option #2
ECHO			2 = Restore Data Gathered From Option #1 
ECHO			3 = Restore From USB To New Computer (Drive Docked USB)
ECHO			4 = Backup To/From Specific Directory (From Manual Location to new client computer)
ECHO			5 = Backup to OneDrive
ECHO			6 = Setup Symbolic Links
ECHO			7 = Exit To Windows 
ECHO.
ECHO            Too big for it's own good. -- 
ECHO												v. 2.2.6 
ECHO.
CHOICE /N /C:1234567
If ERRORLEVEL ==7 GOTO :BEGIN
If ERRORLEVEL ==6 GOTO :BUO6
If ERRORLEVEL ==5 GOTO :BUO5
If ERRORLEVEL ==4 GOTO :BUO4
IF ERRORLEVEL ==3 GOTO :BUO3
IF ERRORLEVEL ==2 GOTO :BUO2
IF ERRORLEVEL ==1 GOTO :BUO1
GOTO END

:BUO1
:: Backup & Prep Data For Option #2
:: verifying the profile name
:: the use of %% in this was to identify to the person running the application who they are. 
:: I wanted the questions to also show the user where they were without having to look at the menu. 
:: The "one liner" statements are different in each option.
:: Needed to specify not just yourself but any user on the computer. So I came up with this. 

:: Added this user list to display the list of user accounts on the computer in case you need. 
:: This was a request from TonyS that works pretty well. 
:: I pull the list of users from the system directly in the C:\Users directory while not showing Administrators and Public. 

ECHO Here is a list of the current user account directories on the computer. 
ECHO.

SET "Value="
setlocal enableDelayedExpansion
SET Users="dir C:\Users\ /B"
FOR /F "tokens=1*" %%A IN ('%Users%') DO (
    SET "Name=%%A"
:: If administrator do not display
    IF /I "!NAME!" NEQ "Administrator" (
:: If Public account do not display
        IF /I "!NAME!" NEQ "Public" (
                SET "Value=!Value! "
                SET "Value=!Value!%%A"

            )
        )
    )
)
ECHO %Value%
ECHO.
:: Paused to make sure the technician is paying attention to the screen and takes note.
pause
::


set /p "un=Welcome %username%, you chose option -Backup & Prep Data For Option #2- To continue please enter the profile name you wish to backup: "
ECHO.
set /p "q=Thank you for your input %username%. We will now backup the profile %un% are you sure? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :ONEY1
if /I "%q%" EQU "N" goto :BUO1
if /I "%q%" EQU "Q" goto :BEGIN
:ONEY1
:: Afterwards I also felt that you needed to specify the drive letter you would backup to as it's truly dynamic from device to device. 
set /p "dl=Thank you %username%. Now please enter the backup location drive letter: "
ECHO.
set /p "q1=You will now backup the profile to the location: %dl%. Do you want to proceed %username%? [Y/N] "
ECHO.
if /I "%q1%" EQU "Y" goto :ONEY2
if /I "%q1%" EQU "N" goto :ONEY1
if /I "%q1%" EQU "Q" goto :BEGIN
:ONEY2 
:: Ran into an issue where the backup directory needed built first. So adding the directory creation before backup starts to not have this issue. 
:: Ran into an issue just creating a folder blindly, so added function to check if it is already there, if not then create the directory. 
IF NOT EXIST "%dl%:\backup\%un%" MD "%dl%:\backup\%un%"

:: I used this following ECHO to flag the beginning, even though you don't see it right away. 
ECHO "Hold on %username%, this process will take some time"
ECHO.
:: PrinterList.txt saves to where you run this batch file.
ECHO "Getting Retrieval Of Printer list..."
start control /name Microsoft.DevicesAndPrinters
:: Using the following thanks to AricG for this line...
cscript C:\Windows\System32\Printing_Admin_Scripts\en-US\prnmngr.vbs -l >> %dl%:\backup\%un%\PrinterList.txt
:: wmic printer list brief >> %dl%:\backup\%un%\PrinterList.txt
ECHO "Printer List completed and in %dl%:\backup\%un%."
ECHO.

:: OS Build and version, PC name, printers info added to text documents getting backed up to backup location.
ECHO Getting OS information 
ECHO.
WMIC OS LIST BRIEF >> %dl%:\backup\%un%\ComputerLog.txt
ECHO.
ECHO Getting serial number 
ECHO.
WMIC BIOS get serialnumber >> %dl%:\backup\%un%\ComputerLog.txt
ECHO.
ECHO Getting computer name 
ECHO.
ECHO Net Use Log
ECHO.
net use >> %dl%:\backup\%un%\NetUseLog.txt
ECHO.
ECHO Getting Battery Information (If on a laptop)
ECHO.
powercfg /batteryreport /output %dl%:\backup\%un%\BatteryReport.html
ECHO.
ECHO Gathering the list of Local Administrators
ECHO.
net localgroup "Administrators" >> %dl%:\backup\%un%\LocalAdmins.txt
ECHO.
ECHO Getting System Power Report (If on a laptop)
ECHO.
powercfg /systempowerreport /output %dl%:\backup\%un%\PowerReport.html
ECHO.
WMIC OS GET csname >> %dl%:\backup\%un%\ComputerLog.txt
ECHO.
ECHO Collecting services that are running.
ECHO.
WMIC SERVICE where (state="running") GET caption, name, state >> %dl%:\backup\%un%\Services.txt
ECHO.
ECHO Getting IP information.
ECHO.
ipconfig /all >> %dl%:\backup\%un%\IP-info.txt
ECHO.
ECHO Gathering Firewall Information
ECHO.
netsh advfirewall export "%dl%:\backup\%un%\firwallpolicy.wfw"
ECHO.
ECHO Gathering last 500 Event Viewer records.
ECHO.
WEVTUtil query-events System /count:500 /rd:true /format:text >> %dl%:\backup\%un%\Eventlog.txt
ECHO.
ECHO Gathering GP data. 
ECHO.
gpresult /SCOPE COMPUTER /Z >> %dl%:\backup\%un%\Group_Policy.txt
ECHO.
ECHO Completed with Getting OS Information.
ECHO.
ECHO Initiating profile backup.
:: outlook signature file 
ECHO "Backing up Outlook Signature..."
ECHO.
Robocopy "C:\users\%un%\application data\microsoft\signatures" %dl%:\backup\%un%\signatures *.* /e >> %dl%:\backup\%un%\BackupLog.txt
ECHO "Completed Backing up Outlook Signature..."
ECHO.
::  Desktop, Downloads, Documents, and Pictures. 
ECHO Profile consists of the following: Desktop, Downloads, Documents, Pictures, Python, VirtualBox, Microsoft Code, and OneDrive for Business - Unsynced Changes
ECHO.
ECHO This is going to take a while maybe you could talk to the customer about the weather...?
ECHO.
:: The reason for the /XA:SH /MIR for documents was to not have issues with the "My Videos, My Music, etc..." broken links. Ultimately the issue was resolved with using your support.account to run the script.
ECHO "Backing up Profile..."
Robocopy "C:\users\%un%\Desktop" %dl%:\backup\%un%\Desktop *.* /e >> %dl%:\backup\%un%\BackupLog.txt
ECHO Desktop directory
Robocopy "C:\users\%un%\Downloads" %dl%:\backup\%un%\Downloads *.* /e >> %dl%:\backup\%un%\BackupLog.txt
ECHO Downloads directory
Robocopy "C:\users\%un%\Documents" %dl%:\backup\%un%\Documents *.* /e /XA:SH /MIR >> %dl%:\backup\%un%\BackupLog.txt
ECHO The next few lines are backing up data in case the system has any of these environments setup.
ECHO.
ECHO Quick Parts Backup
Robocopy "C:\users\%un%\AppData\Roaming\Microsoft\Templates" %dl%:\backup\%un%\AppData\Roaming\Microsoft\Templates *.* /e >> %dl%:\backup\%un%\BackupLog.txt 
ECHO.  
ECHO Virtual Box Environment
Robocopy "C:\users\%un%\.VirtualBox" %dl%:\backup\%un%\.VirtualBox *.* /e >> %dl%:\backup\%un%\BackupLog.txt
ECHO Visual Studio Code Environment
Robocopy "C:\users\%un%\.vscode" %dl%:\backup\%un%\.vscode *.* /e >> %dl%:\backup\%un%\BackupLog.txt
ECHO Onedrive unsync'd changes. 
Robocopy "C:\users\%un%\ODBA" %dl%:\backup\%un%\ODBA *.* /e >> %dl%:\backup\%un%\BackupLog.txt
ECHO Gimp Environment 
Robocopy "C:\users\%un%\.gimp-2.8" %dl%:\backup\%un%\.gimp-2.8 *.* /e >> %dl%:\backup\%un%\BackupLog.txt
ECHO Java Programming Environment
Robocopy "C:\users\%un%\.oracle_jre_usage" %dl%:\backup\%un%\.oracle_jre_usage *.* /e >> %dl%:\backup\%un%\BackupLog.txt
ECHO Eclipse Environment
Robocopy "C:\users\%un%\.eclipse" %dl%:\backup\%un%\.eclipse *.* /e >> %dl%:\backup\%un%\BackupLog.txt
ECHO.
ECHO "Completed Backing up Profile..."
ECHO.
:: Browser data
ECHO "Backing up Browser Profile Data..."
Robocopy "C:\users\%un%\Favorites" %dl%:\backup\%un%\Favorites *.* /e >> %dl%:\backup\%un%\BackupLog.txt
Robocopy "C:\Users\%un%\AppData\Roaming\Mozilla\Firefox\Profiles" %dl%:\backup\%un%\AppData\Roaming\Mozilla\Firefox\Profiles *.* /e >> %dl%:\backup\%un%\BackupLog.txt
Robocopy "C:\Users\%un%\AppData\Local\Google\Chrome\User Data\Default" %dl%:\backup\%un%\AppData\AppData\Local\Google\Chrome\User Data\Default *.* /e >> %dl%:\backup\%un%\BackupLog.txt
ECHO "Completed Backing up Browser Profile Data..."
ECHO.
:: Adobe Acrobat signature file
ECHO "Backing up Adobe Signature Data..."
Robocopy "C:\users\%un%\AppData\Roaming\Adobe\Acrobat\DC\Security" %dl%:\backup\%un%\AppData\Roaming\Adobe\Acrobat\DC\Security *.* /e >> %dl%:\backup\%un%\BackupLog.txt
ECHO "Completed Backing up Adobe Signature Data..."
ECHO.
:: Microsoft profile data backup.
ECHO "Backing up Microsoft Data..."
Robocopy "c:\users\%un%\application data\microsoft\templates" %dl%:\backup\%un%\templates normal.dot >> %dl%:\backup\%un%\BackupLog.txt
Robocopy "c:\users\%un%\appData\Local\Microsoft\Office" %dl%:\backup\%un%\Local *.Officeui >> %dl%:\backup\%un%\BackupLog.txt
Robocopy "c:\users\%un%\appData\Roaming\Microsoft\Office" %dl%:\backup\%un%\Roaming *.Officeui >> %dl%:\backup\%un%\BackupLog.txt
regedit /e %dl%:\backup\%un%\CustomDictionaries.reg "HKEY_CURRENT_USER\Software\Microsoft\Shared Tools\Proofing tools\Custom Dictionaries" >> %dl%:\backup\%un%\BackupLog.txt
ECHO.
:: Adding the backup of installed programs log. 
ECHO Making a list and saving the installed programs to backup location.
ECHO.
wmic /output:%dl%:\backup\%un%\Programs.txt product get name,version >> %dl%:\backup\%un%\BackupLog.txt
ECHO.
:: All done, bye bye. 
ECHO "All done backing up data %username%. ..."
pause 
GOTO :BEGIN
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ====================================================Restore Data Gathered From Option #1==========================================================================================
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:BUO2
:: Restore Data Gathered From Option #1
:: Verifying the profile name
:: Copied from my original test below. 
ECHO Here is a list of the current user account directories on the computer. 
ECHO.

SET "Value="
SET Users="dir C:\Users\ /B"
FOR /F "tokens=1*" %%A IN ('%Users%') DO (
    SET "Name=%%A"
:: If administrator do not display
    IF /I "!NAME!" NEQ "Administrator" (
:: If Public account do not display
        IF /I "!NAME!" NEQ "Public" (
                SET "Value=!Value! "
                SET "Value=!Value!%%A"

            )
        )
    )
)
ECHO %Value%
ECHO.
:: Paused to make sure the technician is paying attention.
pause
::
ECHO.
set /p "un=Welcome %username%, you chose option -Restore Data Gathered From Option #1- To continue please enter the profile name you wish to backup: "
ECHO.
set /p "q=You will now restore the profile %un% are you sure this is what you want to do? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :TWOY1
if /I "%q%" EQU "N" goto :BUO2
if /I "%q%" EQU "Q" goto :BEGIN
:TWOY1
:: Afterwards I also felt that you needed to specify the drive letter you would backup to as it's truly dynamic from device to device.
set /p "dl=Please enter the backup location drive letter: "
ECHO.
set /p "q1=You will now pull the data from the location: %dl%\backup\%un% and place it at the location C:\Users\%un%. Do you want to proceed %username%? [Y/N] "
ECHO.
if /I "%q1%" EQU "Y" goto :TWOY2
if /I "%q1%" EQU "N" goto :BUO2
if /I "%q1%" EQU "Q" goto :BEGIN
:TWOY2

ECHO.
:: I used this following ECHO to flag the beginning, even though you didn't originally see it. 

ECHO Opening applications to build the users profile in these applications.
:: Opening Browsers and Outlook etc...
start control
start control /name Microsoft.DevicesAndPrinters

ECHO Next Step is the recovery process.
pause
ECHO "Hold on %username%, this process will take some time..."
ECHO.
:: outlook signature file 
ECHO "Retrieving Outlook Signature..."
Robocopy %dl%:\backup\%un%\signatures "C:\users\%un%\application data\microsoft\signatures" *.* /e  >> %dl%:\backup\%un%\RecLog.txt
ECHO "Completed Retrieving Outlook Signature..."
ECHO.
::  Desktop, Downloads, Documents, and Pictures. 
:: The reason not needing the /XA:SH /MIR for documents is because the files didn't move with it, and two, there's no backup of permissions done during the backup process. 
ECHO "Retrieving Profile..."
Robocopy %dl%:\backup\%un%\Desktop "C:\users\%un%\Desktop" *.* /e >> C:\users\%un%\RecLog.txt
ECHO Desktop directory
Robocopy %dl%:\backup\%un%\Downloads "C:\users\%un%\Downloads" *.* /e >> C:\users\%un%\RecLog.txt
ECHO Downloads directory
Robocopy %dl%:\backup\%un%\Documents "C:\users\%un%\Documents" *.* /e >> C:\users\%un%\RecLog.txt
ECHO Pictures directory
Robocopy %dl%:\backup\%un%\Pictures "C:\users\%un%\Pictures" *.* /e  >> C:\users\%un%\RecLog.txt
:: 2/7/2019 Recently I stumbled across the need to backup a few more directories. 
ECHO The next few lines are backing up data in case the system has any of these environments setup. 
ECHO.
ECHO Restoring Quick Parts if they exsist. 
Robocopy %dl%:\backup\%un%\AppData\Roaming\Microsoft\Templates "C:\users\%un%\AppData\Roaming\Microsoft\Templates"  *.* /e  >> C:\users\%un%\RecLog.txt
ECHO.
Robocopy %dl%:\backup\%un%\.pylint.d "C:\users\%un%\.pylint.d" *.* /e >> C:\users\%un%\RecLog.txt
ECHO Virtual Box Environment
Robocopy %dl%:\backup\%un%\.VirtualBox "C:\users\%un%\.VirtualBox" *.* /e >> C:\users\%un%\RecLog.txt
ECHO Visual Studio Code Environment
Robocopy %dl%:\backup\%un%\.vscode "C:\users\%un%\.vscode" *.* /e >> C:\users\%un%\RecLog.txt
ECHO Onedrive unsync'd changes. 
Robocopy %dl%:\backup\%un%\ODBA "C:\users\%un%\ODBA" *.* /e >> C:\users\%un%\RecLog.txt
ECHO Gimp Environment 
Robocopy %dl%:\backup\%un%\.gimp-2.8 "C:\users\%un%\.gimp-2.8" *.* /e >> C:\users\%un%\RecLog.txt
ECHO Java Programming Environment
Robocopy %dl%:\backup\%un%\.oracle_jre_usage "C:\users\%un%\.oracle_jre_usage" *.* /e >> C:\users\%un%\RecLog.txt
ECHO Eclipse Environment
Robocopy %dl%:\backup\%un%\.eclipse "C:\users\%un%\.eclipse" *.* /e >> C:\users\%un%\RecLog.txt
:: fin, Added Python environment configuration backup, Virtual Box configuration backup, Visual Studio Code configuration backup, OneDrive for Business - Unsynced Changes.
ECHO "Completed Retrieving Profile..."
ECHO.
:: Browser data
ECHO "Retrieving Browser Profile Data..."
Robocopy %dl%:\backup\%un%\Favorites "C:\users\%un%\Favorites" *.* /e >> C:\users\%un%\RecLog.txt
Robocopy %dl%:\backup\%un%\AppData\Roaming\Mozilla\Firefox\Profiles "C:\Users\%un%\AppData\Roaming\Mozilla\Firefox\Profiles" *.* /e >> C:\users\%un%\RecLog.txt
Robocopy %dl%:\backup\%un%\AppData\AppData\Local\Google\Chrome\User Data\Default "C:\Users\%un%\AppData\Local\Google\Chrome\User Data\Default" *.* /e >> C:\users\%un%\RecLog.txt
ECHO "Completed Retrieving Browser Profile Data..."
ECHO.
:: Adobe Acrobat signature file
ECHO "Retrieving Adobe Signature Data..."
Robocopy %dl%:\backup\%un%\AppData\Roaming\Adobe\Acrobat\DC\Security "C:\users\%un%\AppData\Roaming\Adobe\Acrobat\DC\Security" *.* /e >> C:\users\%un%\RecLog.txt
ECHO "Completed Retrieving Adobe Signature Data..."
ECHO.
:: I didn't add this in as you need to do this manually. 
ECHO "Microsoft Data including Registry Setting for custom dictionaries, or Chrome\Firefox bookmarks need added manually."
ECHO.
:: All done, should go back to the main menu.
ECHO "All done Retrieving data %username%. ..."
pause 
GOTO :BEGIN

:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ===============================================================Restore From Failed System (Drive Docked USB)======================================================================
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:BUO3
:: Restore From Failed System (Drive Docked USB)
ECHO %val%, %ldt%, Restore From Failed System, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
CLS
ECHO Hello %username%, welcome to the USB backup tool. 
ECHO.
ECHO #########################################################################################
ECHO #########################################################################################
ECHO ##    There are three things this script assumes                                       ##
ECHO ##    1.) This assumes that you have already swapped the computer.                     ##
ECHO ##    2.) The old computer hard drive is attached via USB storage.                     ##
ECHO ##    3.) The customer has logged into the new computer and the profile has been built.##
ECHO ##                                                                                     ##  
ECHO ##    There will be a log file of this process saved to the backup location desktop.   ##
ECHO #########################################################################################
ECHO #########################################################################################
ECHO.
ECHO To continue we are going to ask you a few questions to get started. 
ECHO.
:NO
ECHO.

set /p "un=Welcome %username%, you chose option -Restore From Failed System (Drive Docked USB)- To continue please enter the profile name you wish to recover from USB:"
ECHO.
set /p "q=Thank you %username%! To clarify you said you are backing up data from %un%, is that correct? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :YES
if /I "%q%" EQU "N" goto :NO
if /I "%q%" EQU "Q" goto :BEGIN
:YES
ECHO.
set /p "un2=In case we are not copying to the same directory. Please enter the profile name you need to backup to: "
ECHO.
set /p "q=Thank you %username%! To clarify you said you are backing up data to %un2%, is that correct? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :YES1
if /I "%q%" EQU "N" goto :NO
if /I "%q%" EQU "Q" goto :BEGIN
:YES1
ECHO Thank you %username%, let us continue.
ECHO. 
set /p "dl=Enter backup location drive letter: "
ECHO.
set /p "q1=You will now copy the data from location: %dl%:\Users\%un% ===and moving it to===> C:\users\%un2%. Do you want to proceed %username%? [Y/N] "
ECHO.
if /I "%q1%" EQU "Y" goto :YES2
if /I "%q1%" EQU "N" goto :NO
if /I "%q1%" EQU "Q" goto :BEGIN
:YES2
:: Adding this to verify if you are the tech, or the customer, then if you are the tech, using take down to get ownership of the directory before transferring.
set /p "q=To continue, can you tell me if you are [T]echnician or a [C]ustomer? [T/C] "
ECHO.
if /I "%q%" EQU "T" goto :TECH
if /I "%q%" EQU "C" goto :CUSTOMER
if /I "%q%" EQU "Q" goto :BEGIN

:TECH
:: Take ownership of the object (Directory) Very much a "just in case" approach.
takeown /F "%dl%:\users\%un%" /A /R /D /Y
:: Take ownership of a directory and set permissions recursively. 
icalcs "%dl%:\users\%un%" /setowner "Administrators" /T /C

start "%dl%:\users\%un%"
ECHO Completed the takedown of the customers profile directory. Please open the documents directory in the customers source location.
ECHO This ensures that windows has provided all of the correct access across the entire profile directory.
pause
GOTO :TECHCONT
:CUSTOMER
CLS
ECHO.
ECHO Opening applications to build the users profile in these applications.
:: Opening Browsers and Outlook etc...
ECHO Opening applications for customer. 
ECHO Applications include Outlook, Chrome, Firefox, Control Panel, and Devices & Printers
start "" "%ProgramFiles(x86)%\Microsoft Office\Office16\Outlook.exe"
start "" "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
start "" "%ProgramFiles%\Mozilla Firefox\firefox.exe"
start control
start control /name Microsoft.DevicesAndPrinters
ECHO Completed opening applications for customer.
ECHO Next Step is the recovery process.
pause 
:TECHCONT
start control
start control /name Microsoft.DevicesAndPrinters
ECHO Starting the recovery process. 
ECHO.
ECHO.
:: outlook signature file 
ECHO "Backing up Outlook Signature..."
ECHO Running Command: Robocopy %dl%:\users\%un%\signatures "C:\users\%un2%\application data\microsoft\signatures" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
Robocopy %dl%:\users\%un%\signatures "C:\users\%un2%\application data\microsoft\signatures" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
ECHO "Completed Backing up Outlook Signature..."
ECHO.
::  Desktop, Downloads, Documents, and Pictures. 
ECHO Maybe you could talk to the customer about the weather...?
:: The reason for the /XA:SH /MIR for documents was to not have issues with the "My Videos, My Music, etc..." broken links.
ECHO "Backing up Profile... Starting with Desktop --> Downloads --> Documents --> Pictures"
ECHO.
ECHO Running Command: Robocopy %dl%:\Users\%un%\Desktop "C:\users\%un2%\Desktop" *.* /e 2>> C:\users\%un2%\Desktop\RecLog.txt
Robocopy %dl%:\Users\%un%\Desktop "C:\users\%un2%\Desktop" *.* /e 2>> C:\users\%un2%\Desktop\RecLog.txt
ECHO Desktop directory
ECHO.
ECHO Running Command: Robocopy %dl%:\Users\%un%\Downloads "C:\users\%un2%\Downloads" *.* /e 2>> C:\users\%un2%\Desktop\RecLog.txt
Robocopy %dl%:\Users\%un%\Downloads "C:\users\%un2%\Downloads" *.* /e 2>> C:\users\%un2%\Desktop\RecLog.txt
ECHO Downloads directory
ECHO.
ECHO Running Command: Robocopy %dl%:\Users\%un%\Documents "C:\users\%un2%\Documents" *.* /e 2>> C:\users\%un2%\Desktop\RecLog.txt
Robocopy %dl%:\Users\%un%\Documents "C:\users\%un2%\Documents" *.* /e 2>> C:\users\%un2%\Desktop\RecLog.txt
ECHO Pictures directory
ECHO.
ECHO Running Command: Robocopy %dl%:\Users\%un%\Pictures "C:\users\%un2%\Pictures" *.* /e 2>> C:\users\%un2%\Desktop\RecLog.txt
Robocopy %dl%:\Users\%un%\Pictures "C:\users\%un2%\Pictures" *.* /e 2>> C:\users\%un2%\Desktop\RecLog.txt
:: 2/7/2019 Recently I stumbled across the need to backup a few more directories. 
ECHO The next few lines are backing up data in case the system has any of these environments setup. 
ECHO Restoring Quick Parts
ECHO.
ECHO Running Command: Robocopy %dl%:\Users\%un%\AppData\Roaming\Microsoft\Templates "C:\users\%un2%\AppData\Roaming\Microsoft\Templates" *.* /e 2>> C:\users\%un2%\Desktop\RecLog.txt
Robocopy %dl%:\Users\%un%\AppData\Roaming\Microsoft\Templates "C:\users\%un2%\AppData\Roaming\Microsoft\Templates" *.* /e 2>> C:\users\%un2%\Desktop\RecLog.txt
ECHO Restoring Python Environment
ECHO.
ECHO Running Command: Robocopy %dl%:\Users\%un%\.pylint.d "C:\users\%un2%\.pylint.d" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
Robocopy %dl%:\Users\%un%\.pylint.d "C:\users\%un2%\.pylint.d" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
ECHO Virtual Box Environment
ECHO.
ECHO Running Command: Robocopy %dl%:\Users\%un%\.VirtualBox "C:\users\%un2%\.VirtualBox" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
Robocopy %dl%:\Users\%un%\.VirtualBox "C:\users\%un2%\.VirtualBox" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
ECHO Visual Studio Code Environment
ECHO.
ECHO Running Command: Robocopy %dl%:\Users\%un%\.vscode "C:\users\%un2%\.vscode" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
Robocopy %dl%:\Users\%un%\.vscode "C:\users\%un2%\.vscode" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
ECHO Onedrive unsync'd changes 
ECHO.
ECHO Running Command: Robocopy %dl%:\Users\%un%\ODBA "C:\users\%un2%\ODBA" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
Robocopy %dl%:\Users\%un%\ODBA "C:\users\%un2%\ODBA" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
ECHO Gimp Environment 
ECHO.
ECHO Running Command: Robocopy %dl%:\Users\%un%\.gimp-2.8 "C:\users\%un2%\.gimp-2.8" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
Robocopy %dl%:\Users\%un%\.gimp-2.8 "C:\users\%un2%\.gimp-2.8" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
ECHO Java Programming Environment
ECHO.
ECHO Running Command: Robocopy %dl%:\Users\%un%\.oracle_jre_usage "C:\users\%un2%\.oracle_jre_usage" *.* /e 2>> C:\users\%un22%\Desktop\BackupLog.txt
Robocopy %dl%:\Users\%un%\.oracle_jre_usage "C:\users\%un2%\.oracle_jre_usage" *.* /e 2>> C:\users\%un22%\Desktop\BackupLog.txt
ECHO Eclipse Environment
ECHO.
ECHO Running Command: Robocopy %dl%:\Users\%un%\.eclipse "C:\users\%un2%\.eclipse" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
Robocopy %dl%:\Users\%un%\.eclipse "C:\users\%un2%\.eclipse" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt

:: fin Added Python Environment backup, Virtual Box configuration backup, Visual Studio Code configuration backup, OneDrive for Business - Unsynced Changes, Gimp configuration, eclipse configuration, and java environment. 

ECHO "Completed Backing up Profile ..."
ECHO.
:: Browser data
ECHO "Backing up Browser Profile Data..."
ECHO.
ECHO Running Command: Robocopy %dl%:\users\%un%\Favorites "C:\users\%un2%\Favorites" *.* /e 2>> C:\users%un2%\Desktop\BackupLog.txt
Robocopy %dl%:\users\%un%\Favorites "C:\users\%un2%\Favorites" *.* /e 2>> C:\users%un2%\Desktop\BackupLog.txt
ECHO.
ECHO Running Command: Robocopy %dl%:\users\%un%\AppData\Roaming\Mozilla\Firefox\Profiles "C:\Users\%un2%\AppData\Roaming\Mozilla\Firefox\Profiles" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
Robocopy %dl%:\users\%un%\AppData\Roaming\Mozilla\Firefox\Profiles "C:\Users\%un2%\AppData\Roaming\Mozilla\Firefox\Profiles" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
ECHO.
ECHO Running Command: Robocopy %dl%:\users\%un%\AppData\Roaming\Mozilla\Firefox\Profiles "C:\Users\%un2%\AppData\Roaming\Mozilla\Firefox\Profiles" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
Robocopy %dl%:\users\%un%\AppData\Roaming\Mozilla\Firefox\Profiles "C:\Users\%un2%\AppData\Roaming\Mozilla\Firefox\Profiles" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
ECHO.
ECHO Running Command: Robocopy %dl%:\users\%un%\AppData\AppData\Local\Google\Chrome\User Data\Default "C:\Users\%un2%\AppData\Local\Google\Chrome\User Data\Default" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
Robocopy %dl%:\users\%un%\AppData\AppData\Local\Google\Chrome\User Data\Default "C:\Users\%un2%\AppData\Local\Google\Chrome\User Data\Default" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
ECHO "Completed Backing up Browser Profile Data..."
ECHO.
:: Adobe Acrobat signature/security file
ECHO "Backing up Adobe Signature Data..."
ECHO.
ECHO Running Command: Robocopy %dl%:\users\%un%\AppData\Roaming\Adobe\Acrobat\DC\Security "C:\users\%un2%\AppData\Roaming\Adobe\Acrobat\DC\Security" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
Robocopy %dl%:\users\%un%\AppData\Roaming\Adobe\Acrobat\DC\Security "C:\users\%un2%\AppData\Roaming\Adobe\Acrobat\DC\Security" *.* /e 2>> C:\users\%un2%\Desktop\BackupLog.txt
ECHO "Completed Backing up Adobe Signature Data..."
ECHO.
:: All done, bye bye. 
ECHO "All done backing up data %username%. ..."
pause 
GOTO :BEGIN


:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ===================================================================Backup To/From Specific Folder (Manual Location)===============================================================
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:BUO4
ECHO %val%, %ldt%, Backup To/From Specific Folder, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
:: Backup To Specific Folder (Manual Location)
:: verifying the profile name
:: the use of %% in this was to identify to the person running the application who they are. 
:: I wanted the questions to also show the user where they were without having to look at the menu. 
set /p "backup=Welcome %username%, you chose option -Backup To/From Specific Folder (Manual Location)- To continue please enter the entire directory path to the data you want to backup: "
ECHO.
set /p "q=Thank you for your input %username%. We will now backup the location %backup% are you sure? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :FOURY
if /I "%q%" EQU "N" goto :BUO4
if /I "%q%" EQU "Q" goto :BEGIN
:FOURY

set /p "destination=Thank you %username%. Now please enter the entire directory path to the backup location: "
ECHO.
set /p "q1=You will now backup to the location: %destination%. Do you want to proceed %username%? [Y/N] "
ECHO.
if /I "%q1%" EQU "Y" goto :FOURYY1
if /I "%q1%" EQU "N" goto :BUO4
if /I "%q1%" EQU "Q" goto :BEGIN

:FOURYY1
ECHO To clarify and make sure you read the intent of this script will now backup from the location: %backup% to the location: %destination%.
set /p "q1=Are you sure you want to proceed %username%? [Y/N] "
ECHO.
if /I "%q1%" EQU "Y" goto :FOURY1
if /I "%q1%" EQU "N" goto :BUO4
if /I "%q1%" EQU "Q" goto :BEGIN



:FOURY1 

:: I used this following ECHO to flag the beginning
ECHO "Hold on %username%, this process will take some time"
ECHO.
:: PrinterList.txt saves to where you run this batch file.
ECHO "Getting Retrieval Of Printer list..."
start control /name Microsoft.DevicesAndPrinters
:: Using the following thanks to AricG for this line...
cscript C:\Windows\System32\Printing_Admin_Scripts\en-US\prnmngr.vbs -l >> %destination%\PrinterList.txt
:: wmic printer list brief >> %dl%:\backup\%un%\PrinterList.txt
:: ECHO "Printer List completed and in %dl%:\backup\%un%."
:: wmic printer list brief >> %destination%\PrinterList.txt
ECHO "PrinterList completed and in %destination%."
ECHO.

:: OS Build and version, PC name, printers info added to text documents getting backed up to backup location.
ECHO Getting OS information
ECHO.
WMIC OS LIST BRIEF >> %destination%\pcinfo.txt
ECHO.
ECHO Getting serial number
ECHO.
WMIC BIOS get serialnumber >> %destination%\pcinfo.txt
ECHO.
ECHO Net Use Log
ECHO.
net use >> %destination%\NetUseLog.txt
ECHO.
ECHO Getting computer name
ECHO.
ECHO Getting Battery Information (If on a laptop)
ECHO.
powercfg /batteryreport /output %destination%\BatteryReport.html
ECHO.
ECHO Gathering the list of Local Administrators
ECHO.
net localgroup "Administrators" >> %destination%\LocalAdmins.txt
ECHO.
ECHO Getting IP Information
ECHO.
ipconfig /all >> %destination%\ipconfig.txt
ECHO.
WMIC OS GET csname >> %destination%\pcinfo.txt 
ECHO.
ECHO Collecting services that are running.
ECHO.
WMIC SERVICE where (state="running") GET caption, name, state >> %destination%\services.txt
ECHO.
ECHO Gathering Firewall Information
ECHO.
netsh advfirewall export "%destination%\firwallpolicy.wfw"
ECHO.
ECHO The firewall settings can be restored on the new computer with the command netsh advfirewall --import "%destination%\firwallpolicy.wfw"--
ECHO.
ECHO Collecting another form of printer information. 
ECHO.
:: WMIC Printer >> %destination%\pcinfo.txt
ECHO.
ECHO Gathering GP data. 
ECHO.
gpresult /SCOPE COMPUTER /Z >> %destination%\Group_Policy.txt
ECHO.
ECHO Gathering last 500 Event Viewer records.
ECHO.
WEVTUtil query-events System /count:500 /rd:true /format:text >> %destination%\Eventlog.txt
ECHO.
ECHO Completed with this step.
ECHO.

Robocopy %backup% %destination% *.* /e >> %destination%\BackupLog.txt

:: Adding the backup of installed programs log. 
ECHO Making a list and saving the installed programs to backup location.
ECHO.
wmic /output:%destination%\Programs.txt product get name,version
ECHO.
:: All done, bye bye. 
ECHO "All done backing up data %username%. ..."
pause 
GOTO :BEGIN



:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ===============================================================================Backup to OneDrive=================================================================================
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:BUO5
ECHO %val%, %ldt%, ONEDRIVE BACKUP, %username%, %HOST%, >> \\0.0.0.0\c$\record\%HOST%.csv
:: Backup to OneDrive
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ============================================================-TECHNICIAN DOS ONEDRIVE BACKUP===================================================================================
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
SETLOCAL
ECHO.
ECHO.
ECHO.
ECHO.
ECHO Before you continue please make sure the customer account you are backing up is correctly syncing to OneDrive and they have enough data to duplicate their profile size. 
ECHO Both on their PC and their OneDrive account. This tool will backup the profile to OneDrive, however it has to make a local copy of the files to sync them as a backup to OneDrive. 
ECHO.
ECHO.
ECHO. 
set /p "un=Hello %username% you selected to backup the customers profile to OneDrive. Please enter the profile name you want to backup: " 
ECHO.
set /p "q=Thank you, %username%. You will now backup the system info to %un% are you sure? [Y/N] "
ECHO.
if /I "%q%" EQU "Y" goto :YES6
if /I "%q%" EQU "N" goto :BUO5
if /I "%q%" EQU "Q" goto :BEGIN
:YES6
:: I was being lazy with this will clean this up with better code later. 
:: The var parade...
SET SDesktopP=C:\Users\%un%\Desktop
SET SDocumentsP=C:\Users\%un%\Documents
SET SDownloadsP=C:\Users\%un%\Downloads
SET SPicturesP=C:\Users\%un%\Pictures
SET SFavoritesP=C:\users\%un%\Favorites
SET SFirefoxP=C:\Users\%un%\AppData\Roaming\Mozilla\Firefox\Profiles
SET SChromeP=C:\Users\%un%\AppData\Local\Google\Chrome\User Data\Default
SET SAdobeP=C:\users\%un%\AppData\Roaming\Adobe\Acrobat\DC\Security
SET DestinationPath=C:\Users\%un%\OneDrive - Embry-Riddle Aeronautical University\Profile Backup %date:~-4,4%%date:~-10,2%%date:~-7,2%
SET LogFile="%DestinationPath%\Logfile.txt"
:: Now let's put that into motion. 

:: If you do not find the DestinationPath then create it so there is no conflicts. 
IF NOT EXIST "%DestinationPath%" MD "%DestinationPath%"

:: Starting the backup process. 
ECHO Backing up your Desktop to %DestinationPath%
ROBOCOPY "%SDesktopP%" "%DestinationPath%" *.* /PURGE /S /NP /ZB /R:5 /LOG+:%LogFile% /TS /FP
ECHO Backing up your Documents to %DestinationPath%
ROBOCOPY "%SDocumentsP%" "%DestinationPath%" *.* /PURGE /S /NP /ZB /R:5 /LOG+:%LogFile% /TS /FP
ECHO Backing up your Downloads to %DestinationPath%
ROBOCOPY "%SDownloadsP%" "%DestinationPath%" *.* /PURGE /S /NP /ZB /R:5 /LOG+:%LogFile% /TS /FP
ECHO Backing up your Pictures to %DestinationPath%
ROBOCOPY "%SPicturesP%" "%DestinationPath%" *.* /PURGE /S /NP /ZB /R:5 /LOG+:%LogFile% /TS /FP
ECHO Backing up your Internet Explorer Favorites to %DestinationPath%
ROBOCOPY "%SFavoritesP%" "%DestinationPath%" *.* /PURGE /S /NP /ZB /R:5 /LOG+:%LogFile% /TS /FP
ECHO Backing up your Firefox Bookmarks to %DestinationPath%
ROBOCOPY "%SFirefoxP%" "%DestinationPath%" *.* /PURGE /S /NP /ZB /R:5 /LOG+:%LogFile% /TS /FP
ECHO Backing up your Chrome Bookmarks to %DestinationPath%
ROBOCOPY "%SChromeP%" "%DestinationPath%" *.* /PURGE /S /NP /ZB /R:5 /LOG+:%LogFile% /TS /FP
ECHO Backing up your Adobe signature file to %DestinationPath%
ROBOCOPY "%SAdobeP%" "%DestinationPath%" *.* /PURGE /S /NP /ZB /R:5 /LOG+:%LogFile% /TS /FP
GOTO :BEGIN

:BUO6
@cls
@echo off
setlocal

:: Starting the Symbolic Link creation.

set un=%username%
set SymbolicLinkLocation=%UserProfile%\OneDrive - Embry-Riddle Aeronautical University\%un%

:: call used to be fancy. It's not really needed in this regard. 

call :CreateSymbolicLinkLocation
call :CreateSymbolicLink Desktop
call :CreateSymbolicLink Documents
call :CreateSymbolicLink Downloads
call :CreateSymbolicLink Music
call :CreateSymbolicLink Pictures
call :CreateSymbolicLink Videos
goto :EndScript

:: Here's some function sexiness...

:CreateSymbolicLinkLocation
echo Checking if "%SymbolicLinkLocation%" is available...
if exist "%SymbolicLinkLocation%" (
	echo "%SymbolicLinkLocation%" was found.
	echo.
	goto :eof
) else (
	echo "%SymbolicLinkLocation%" was not found.
	md "%SymbolicLinkLocation%"
	echo.
	goto :eof
)

:CreateSymbolicLink
echo Checking if "%SymbolicLinkLocation%\%1" is available...
if exist "%SymbolicLinkLocation%\%1" (
	echo "%1" was found.
	echo.
	goto :eof
) else (
	echo "%1" was not found.
	mklink /J "%SymbolicLinkLocation%\%1" "%UserProfile%\%1"
	echo.
	goto :eof
)

:EndScript
endlocal
pause
goto :BEGIN

:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ===================================================================End Menu One Configuration=====================================================================================
:: ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:END
exit