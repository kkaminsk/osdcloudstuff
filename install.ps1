# Script to check for and install or update the OSD module

# Define the name of the module
$moduleName = "OSD"

# Get the installed module, suppressing errors if it's not found
$installedModule = Get-InstalledModule -Name $moduleName -ErrorAction SilentlyContinue

# Find the latest version of the module in the PowerShell Gallery
$galleryModule = Find-Module -Name $moduleName

# Check if the module is installed
if ($installedModule) {
    # If the module is installed, compare its version to the latest version in the gallery
    if ($installedModule.Version -lt $galleryModule.Version) {
        # If the installed version is older, update it
        Write-Host "The $moduleName module is outdated. $($moduleName.Version)"
        Write-Host "Updating now..."
        Install-Module -Name $moduleName -Force
        Write-Host "$moduleName has been updated to version. $($galleryModule.Version)"
    } else {
        # If the installed version is current, do nothing
        Write-Host "The $moduleName module is already installed and up to date. $($installedmodule.version)"
    }
} else {
    # If the module is not installed, install it
    Write-Host "$moduleName is not installed. Installing now..."
    Install-Module -Name $moduleName -Force
    Write-Host "$moduleName has been installed."
}