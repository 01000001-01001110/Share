<#
_____.___.___________ __________.__                 __                 
\__  |   |\__    ___/ \______   \  |   ____   ____ |  | __ ___________ 
 /   |   |  |    |     |    |  _/  |  /  _ \_/ ___\|  |/ // __ \_  __ \
 \____   |  |    |     |    |   \  |_(  <_> )  \___|    <\  ___/|  | \/
 / ______|  |____|     |______  /____/\____/ \___  >__|_ \\___  >__|   
 \/                           \/                 \/     \/    \/       
                                 .__ _______          __               
                                 |__|\      \   _____/  |_             
                          ______ |  |/   |   \_/ __ \   __\            
                         /_____/ |  /    |    \  ___/|  |              
                                 |__\____|__  /\___  >__|              
                                            \/     \/                  
#>

<# Blocks Youtube Between the hours of 8PM and 8AM #>

function Set-HostsFile {
    param (
        [string]$filePath = "$env:windir\System32\drivers\etc\hosts",
        [string]$content = ""
    )
    $content | Out-File -FilePath $filePath -Encoding ASCII -Force
}

while ($true) {
    if (((get-date).TimeOfDay.TotalMinutes) -in 1200..480) {
        Set-HostsFile -content "youtube.com 127.0.0.1"
    } else {
        Set-HostsFile -content ""
    }
    Start-Sleep -Seconds 60
}
