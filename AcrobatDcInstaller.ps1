<#Author       : Heinrich Wewers
# Usage        : Install Adobe Acrobat Reader
#>

#######################################
#     Install Acrobat Reader          #
#######################################

Param (

    [Parameter(Mandatory=$true)]
        [string]$AcroDCInstaller
)

######################
#    AVD Variables   #
######################
$LocalAVDpath            = "c:\temp\avd\"
$AcroDCInstaller             = 'AcroRdrDC_en_US.zip'
$templateFilePathFolder = "C:\AVDImage"

####################################
#    Test/Create Temp Directory    #
####################################
if((Test-Path c:\temp) -eq $false) {
    Write-Host "AVD AIB Customization - Install Adobe Acrobat Reader : Creating temp directory"
    New-Item -Path c:\temp -ItemType Directory
}
else {
    Write-Host "AVD AIB Customization - Install Adobe Acrobat Reader : C:\temp already exists"
}
if((Test-Path $LocalAVDpath) -eq $false) {
    Write-Host "AVD AIB Customization - Install Adobe Acrobat Reader : Creating directory: $LocalAVDpath"
    New-Item -Path $LocalAVDpath -ItemType Directory
}
else {
    Write-Host "AVD AIB Customization - Install Adobe Acrobat Reader : $LocalAVDpath already exists"
}

#################################
#    Download AVD Components    #
#################################
Write-Host "AVD AIB Customization - Install Adobe Acrobat Reader : Downloading Acrobat Reader DC from URI: $AcroDCInstaller"
Invoke-WebRequest -Uri $AcroDCInstaller -OutFile "$LocalAVDpath$AcroDCInstaller"


##############################
#    Prep for AVD Install    #
##############################
Write-Host "AVD AIB Customization - Install Adobe Acrobat Reader : Unzipping AcrobatDC installer"
Expand-Archive `
    -LiteralPath "C:\temp\avd\$AcroDCInstaller" `
    -DestinationPath "$LocalAVDpath\AcrobatDC" `
    -Force `
    -Verbose
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-Location $LocalAVDpath 
Write-Host "AVD AIB Customization - Install Adobe Acrobat Reader : UnZip of AcrobatDC complete"


#########################
#    AcrobatDC Install    #
#########################
Write-Host "AVD AIB Customization - Install Adobe Acrobat Reader : Starting to install AcrobatDC"
$AcrobatDC_deploy_status = Start-Process `
    -FilePath "$LocalAVDpath\AcrobatDC\AcroRdrDC_en_US.exe" `
    -ArgumentList "/install /silent /norestart" `
    -Wait `
    -Passthru

Write-Host "AVD AIB Customization - Install Adobe Acrobat Reader : Finished installing Adobe Acrobat Reader agent"

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
