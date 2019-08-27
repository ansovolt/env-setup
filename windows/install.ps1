##########################################################
# This script installs all the software found in spec.txt
# file. If mode upgrade is specified then it also
# upgrades any previously installed software.
#
# Examples:
# .\install.ps1
# .\install.ps1 -mode upgrade
##########################################################

param (
    [string]$mode = "install"
)
$ChocoSpec = "choco-spec.txt"

function Choco-Check-Install {
    param (
        [string]$name,
        [string]$version
    )
    $result = choco list -lo | Where-object { $_.ToLower().StartsWith($name.ToLower()) }
    if($result -ne $null){
        $parts = $result.Split(' ');
        if ($version -ne ""){
            return $parts[1] -eq $version;
        }
        else {
            return $true
        }
    }
    return $false;
}

function Choco-Install {
    param(
        [string]$name,
        [string]$version
    )
    if ($version.Trim() -eq ""){
        Invoke-Expression "choco install $name -fy"
    }
    else {
        Invoke-Expression "choco install $name -version=$version -fy"
    }
}

function Choco-Upgrade {
    param(
        [string]$name,
        [string]$version
    )
    if ($version.Trim() -eq ""){
        Invoke-Expression "choco upgrade $name -fy"
    }
    else {
        Invoke-Expression "choco upgrade $name -version=$version -fy"
    }
}

function Choco-Uninstall {
    param(
        [string]$name
    )
    Invoke-Expression "choco uninstall $name -fy"

}

function Choco-Get-Spec {
    $RetVal = @()
    $Packages = Get-Content -Path $ChocoSpec
    foreach ($p in $Packages) {
        if ($p -match "#" -Or $p.trim() -eq "") {
            continue
        }
        $RetVal += $p.trim()
    }
    return $RetVal
}

function Choco-Get-Installed {
    $RetVal = @(choco list -lo)
    return $RetVal 
}

function Choco-Diff {

    Write-Host "Installed packages"
    (Choco-Get-Installed).ForEach({$_})

}

$StartTime = (Get-Date).Milisecond
Write-Host "Start"
$Packages = Choco-Get-Spec
foreach ($p in $Packages) {
    if ($p -match "#" -Or $p.trim() -eq "") {
        continue
    }
    $pcmd = $p.trim()
    $parts = $pcmd.Split('')
    $pname = $parts[0]
    $pversion = ""
    if ($parts.length -eq 2) {
        $splits = $parts[1].Split('=')
        $pversion = $splits[1]
    }
    
    if (Choco-Check-Install $pname $pversion) {
        Write-Host "$pname with version $pversion exists. Skipping installation."

    }
    else {
        Write-Host "Installing $pname with version $pversion"
        Choco-Install $pname $pversion
    }
}

Write-Host "Installed packages"
(Choco-Get-Installed).foreach({$_})

$EndTime = (Get-Date).Milisecond
Write-Host "End [$($EndTime - $StartTime) miliseconds]"



