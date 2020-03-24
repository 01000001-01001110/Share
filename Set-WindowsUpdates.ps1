# Pulled location and registry key information from https://www.windowscentral.com/how-stop-updates-installing-automatically-windows-10#disable_automatic_windows_update_regedit
# By: Alan Newingham
# Date: 3/24/2020

# Purpose of this script is to set the appropriate registry keys to configure windows to auto update in to the mass-remote COVID response.
# Script tests if the key is at the final destination. If they key is there the script writes the correct settings. 
# If the key is not at the final destination it creates the path, and final key and value required.

# Registry setting options: 
# 2 — Notify for download and auto install.
# 3 — Auto download and notify for install.
# 4 — Auto download and schedule the install.
# 5 — Allow local admin to choose settings.

# Set variable data that I need to modify or create.
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
$name = "AUOptions"
$value = "4"

# Does this not exsist? 
if(!(Test-Path $registryPath))
{
   # If not then go ahead and create it all, soup to nuts.
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null

} 
else 
{
    # If so then just change the DWORD (32-bit) Value
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
}

