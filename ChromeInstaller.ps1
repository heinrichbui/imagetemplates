<#Author       : Heinrich Wewers
# Usage        : Install Google Chrome Standalone Enterprise
#>

#######################################################
#     Install Google Chrome Standalone Enterprise     #
#######################################################

Param (

    [Parameter(Mandatory=$true)]
        [string]$ChromeInstallerURL
)

######################
#    AVD Variables   #
######################
$LocalAVDpath            = "c:\temp\avd\"
$ChromeInstaller         = 'googlechromestandaloneenterprise64.zip'
$templateFilePathFolder  = "C:\AVDImage"
$msiFilePath             = "$LocalAVDpath\GoogleChrome\googlechromestandaloneenterprise64.msi"

####################################
#    Test/Create Temp Directory    #
####################################
if((Test-Path c:\temp) -eq $false) {
    Write-Host "AVD AIB Customization - Install Adobe Google Chrome : Creating temp directory"
    New-Item -Path c:\temp -ItemType Directory
}
else {
    Write-Host "AVD AIB Customization - Install Adobe Google Chrome : C:\temp already exists"
}
if((Test-Path $LocalAVDpath) -eq $false) {
    Write-Host "AVD AIB Customization - Install Adobe Google Chrome : Creating directory: $LocalAVDpath"
    New-Item -Path $LocalAVDpath -ItemType Directory
}
else {
    Write-Host "AVD AIB Customization - Install Google Chrome : $LocalAVDpath already exists"
}

#################################
#    Download AVD Components    #
#################################
Write-Host "AVD AIB Customization - Install Google Chrome : Downloading Google Chrome DC from URI: $ChromeInstallerURL"
Invoke-WebRequest -Uri $ChromeInstallerURL -OutFile "$LocalAVDpath$AcroDCInstaller"


##############################
#    Prep for AVD Install    #
##############################
Write-Host "AVD AIB Customization - Install Google Chrome : Unzipping Chrome installer"
Expand-Archive `
    -LiteralPath "C:\temp\avd\$ChromeInstaller" `
    -DestinationPath "$LocalAVDpath\GoogleChrome" `
    -Force `
    -Verbose
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-Location $LocalAVDpath 
Write-Host "AVD AIB Customization - Install Google Chrome : UnZip of Chrome Installer complete"


#########################
#    AcrobatDC Install    #
#########################
Write-Host "AVD AIB Customization - Install Google Chrome : Starting to install Google Chrome"
$AcrobatDC_deploy_status = Start-Process `
    -FilePath misexec `
    -ArgumentList '/I $msiFilePath /quiet' `
    -Wait `
    -Passthru

Write-Host "AVD AIB Customization - Install Google Chrome : Finished installing Google Chrome agent"

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