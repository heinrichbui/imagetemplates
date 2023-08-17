<#Author       : Heinrich Wewers
# Usage        : Install McAfee Trellix Agent
#>

#######################################
#     Install McAfee Trellix          #
#######################################

Param (

    [Parameter(Mandatory=$true)]
        [string]$TrellixInstaller
)

######################
#    AVD Variables   #
######################
$LocalAVDpath            = "c:\temp\avd\"
$TrellixInstaller             = 'Agent.5.7.9.zip'
$templateFilePathFolder = "C:\AVDImage"

####################################
#    Test/Create Temp Directory    #
####################################
if((Test-Path c:\temp) -eq $false) {
    Write-Host "AVD AIB Customization - Install McAfee Trellix : Creating temp directory"
    New-Item -Path c:\temp -ItemType Directory
}
else {
    Write-Host "AVD AIB Customization - Install McAfee Trellix : C:\temp already exists"
}
if((Test-Path $LocalAVDpath) -eq $false) {
    Write-Host "AVD AIB Customization - Install McAfee Trellix : Creating directory: $LocalAVDpath"
    New-Item -Path $LocalAVDpath -ItemType Directory
}
else {
    Write-Host "AVD AIB Customization - Install McAfee Trellix : $LocalAVDpath already exists"
}

#################################
#    Download AVD Components    #
#################################
Write-Host "AVD AIB Customization - Install McAfee Trellix : Downloading FSLogix from URI: $TrellixInstaller"
Invoke-WebRequest -Uri $TrellixInstaller -OutFile "$LocalAVDpath$TrellixInstaller"


##############################
#    Prep for AVD Install    #
##############################
Write-Host "AVD AIB Customization - Install McAfee Trellix : Unzipping Trellix installer"
Expand-Archive `
    -LiteralPath "C:\temp\avd\$TrellixInstaller" `
    -DestinationPath "$LocalAVDpath\Trellix" `
    -Force `
    -Verbose
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-Location $LocalAVDpath 
Write-Host "AVD AIB Customization - Install McAfee Trellix : UnZip of Trellix complete"


#########################
#    Trellix Install    #
#########################
Write-Host "AVD AIB Customization - Install McAfee Trellix : Starting to install Trellix"
$trellix_deploy_status = Start-Process `
    -FilePath "$LocalAVDpath\Trellix\Agent.5.7.9.Windows.exe" `
    -ArgumentList "/install=agent /silent /norestart" `
    -Wait `
    -Passthru

Write-Host "AVD AIB Customization - Install McAfee Trellix : Finished installing McAfee Trellix agent"

#Cleanup
if ((Test-Path -Path $templateFilePathFolder -ErrorAction SilentlyContinue)) {
    Remove-Item -Path $templateFilePathFolder -Force -Recurse -ErrorAction Continue
}

if ((Test-Path -Path $LocalAVDpath -ErrorAction SilentlyContinue)) {
    Remove-Item -Path $LocalAVDpath -Force -Recurse -ErrorAction Continue
}

#############
#    END    #
#############