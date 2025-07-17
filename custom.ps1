# Define the path to the temporary unattend.xml file
$tempUnattendFile = "X:\Windows\Temp\unattend.xml"

# Check if the temporary unattend.xml file exists and delete it
if (Test-Path $tempUnattendFile) {
    Remove-Item $tempUnattendFile -Force
}

# Define the computer name
$computerName = "WORKSTATION-01"

# Define the content for the new unattend.xml file
$unattendContent = @"
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <ComputerName>$computerName</ComputerName>
        </component>
    </settings>
</unattend>
"@

$unattendContent | Out-File -FilePath $tempUnattendFile -Encoding utf8