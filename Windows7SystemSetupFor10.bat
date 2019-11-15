@Echo Off
echo IF you have not run this as your support account you need to do so now, otherwise hit enter to continue. 
echo If you need to disable the USB ports you can do it with the following CMD.
echo Type this command as admin: REG ADD HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR /v Start /t REG_DWORD /d 4 /f
echo To enable USB devices use the following command. 
echo Type this command as admin: REG ADD HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR /v Start /t REG_DWORD /d 3 /f
pause
::Stop the BITS, Cryptographic, MSI Installer and the Windows Update Services. 
echo Stop BITS Service
net stop bits
echo Stop Windows Update Service
net stop wuauserv
echo Stop Cryptographic Service
net stop cryptSvc
echo Stop MSI Installer Service
net stop msiserver
echo Rename the SoftwareDistribution and Catroot2 directories.
::Now rename the SoftwareDistribution and Catroot2 directories
pause
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 Catroot2.old
pause
echo restart the services
::Now, let’s restart the BITS, Cryptographic, MSI Installer and the Windows Update Services. Typethe following commands in the Command Prompt for this. Press the ENTER key after you type each command.
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
echo now restart the computer and attempt the upgrade. 
exit
