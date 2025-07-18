# Define the path to the temporary unattend.xml file
$tempUnattendFile = "X:\Windows\Temp\unattend.xml"

# Check if the temporary unattend.xml file exists and delete it
if (Test-Path $tempUnattendFile) {
    Remove-Item $tempUnattendFile -Force
}

# Prompt the user for the computer name
# $computerName = Read-Host "Enter the desired computer name"

# Loop indefinitely until a valid name is provided.
while ($true) {
    # Prompt the user for input.
    $computerName = Read-Host "Enter the desired computer name"

    # --- VALIDATION CHECKS ---

    # 1. Check length: Must be between 1 and 15 characters.
    if ($computerName.Length -lt 1 -or $computerName.Length -gt 15) {
        Write-Warning "❌ Name must be between 1 and 15 characters long. Please try again."
        continue # Restart the loop.
    }

    # 2. Check allowed characters: Only letters, numbers, and hyphens.
    if ($computerName -notmatch '^[a-zA-Z0-9-]+$') {
        Write-Warning "❌ Name can only contain letters (A-Z), numbers (0-9), and hyphens (-). Please try again."
        continue
    }

    # 3. Check for all-numeric names.
    if ($computerName -match '^\d+$') {
        Write-Warning "❌ Name cannot consist entirely of numbers. Please try again."
        continue
    }

    # 4. Check for leading or trailing hyphens.
    if ($computerName.StartsWith("-") -or $computerName.EndsWith("-")) {
        Write-Warning "❌ Name cannot start or end with a hyphen. Please try again."
        continue
    }

    # --- VALIDATION PASSED ---

    # If all checks are passed, confirm the name is valid and exit the loop.
    Write-Host -ForegroundColor Green "✅ '$computerName' is a valid computer name."
    break
}



Write-Host "Proceeding with computer name: $computerName"

# Define the content for the new unattend.xml file
$unattendContent = @"
<?xml version="1.0" encoding="utf-8"?>
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <TimeZone>Pacific Standard Time</TimeZone>
            <RegisteredOwner>Organization Inc.</RegisteredOwner>
            <OEMName>IT Department</OEMName>
            <ComputerName>$computername</ComputerName>
        </component>
    </settings>
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <UserData>
                <AcceptEula>true</AcceptEula>
                <FullName>$user</FullName>
                <Organization>Organization Name</Organization>
            </UserData>
        </component>
        <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <InputLocale>0409:00000409</InputLocale>
            <SystemLocale>en-US</SystemLocale>
            <UILanguage>en-US</UILanguage>
            <UILanguageFallback></UILanguageFallback>
            <UserLocale>en-US</UserLocale>
        </component>
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <UserAccounts>
                <LocalAccounts>
                    <LocalAccount wcm:action="add">
                        <Password>
                            <Value>MQAyADMANAA1ADYAUABhAHMAcwB3AG8AcgBkAA==</Value>
                            <PlainText>false</PlainText>
                        </Password>
                        <DisplayName>Default Admin</DisplayName>
                        <Group>Administrators</Group>
                        <Name>Defadmin</Name>
                    </LocalAccount>
                </LocalAccounts>
            </UserAccounts>
        </component>
    </settings>
    <cpi:offlineImage cpi:source="wim:c:/temp/install.wim#Windows 11 Enterprise" xmlns:cpi="urn:schemas-microsoft-com:cpi" />
</unattend>
"@

$unattendContent | Out-File -FilePath $tempUnattendFile -Encoding utf8