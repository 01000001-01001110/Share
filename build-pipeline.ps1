<# 

This is what it should look like: 
pipeline {
    agent any

    stages {
        stage("Build") {
            steps {
                echo "Building"
            }
        }
        
        stage("Test") {
            steps {
                echo "Testing"
            }
        }
    }
    post {
        cleanup {
            deleteDir()
        }
    }
}

As per building as it should look this is how I want to use my new function
Build-Pipeline -Name $filename -Agent $agentName -Stages[$Build, $Test]  -Cleanup $True

Why: Because I do not want to write my own pipelines each time and have to remember the format. Unfortunately as many times as I "tweaked" this script I do know the format pretty well.
By: Alan Newingham
Date: 11/1/2022
#>

function Build-Pipeline {

    param(
    [string]$Name,
    [string]$agentName,
    [string[]]$Stages, 
    [string]$Cleanup
    )

    begin {
        [String]$Path = "C:\Temp\AlansWork\Automations"
        [string]$File = "$Name.txt"
        [string]$FullPath = $Path+$File
        [string]$Post = 'post {
            cleanup {
                deleteDir()
            }
        }'
        #Debugging
        #Write-Host $agentName
        #Write-Host $Stages
        #Write-Host $Cleanup
    }

    process {
        Add-Content $FullPath "pipeline {
    agent any
    
    stages {"
    $data = "stage("
        foreach($Stage in $Stages) {
            $Tabs = "       "
            $Quotes = '"'
            $ing = $stage+"ing"
            
            $data2 = ") {
            steps {
                echo $ing
            }
        }"
        Add-Content $FullPath $Tabs -NoNewline
        Add-Content $FullPath $data -NoNewline
        Add-Content $FullPath $Quotes -NoNewline
        Add-Content $FullPath $Stage -NoNewline
        Add-Content $FullPath $Quotes -NoNewline
        Add-Content $FullPath $data2 

        }
        Add-Content $FullPath "    }"

        if ($Cleanup -eq "True") {
            Add-Content $FullPath $Tabs -NoNewline
            Add-Content $FullPath $Post
        }
        Add-Content $FullPath "}"
    }

    end {
        code $FullPath
    }

}

