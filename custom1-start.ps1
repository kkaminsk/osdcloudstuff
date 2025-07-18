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

# This variable will hold the final, validated full name.
$user = $null

# This flag controls the validation loop.
$isNameValid = $false

# Use a do-while loop to repeatedly prompt the user until valid input is received.
do {
    # Prompt the user to enter a full name.
    # The prompt clearly states that pressing Enter will select the default value.
    $inputName = Read-Host -Prompt "Please enter the user's full name (Press Enter for 'Default User')"

    # Determine the name to validate. If the user pressed Enter without typing
    # anything, the input will be null or whitespace. In that case, we use
    # our default value. Otherwise, we use the name they entered.
    $candidateName = if ([string]::IsNullOrWhiteSpace($inputName)) {
        "Default User"
    } else {
        $inputName
    }

    # --- VALIDATION LOGIC ---
    # The "Full Name" field for a local user account is stored in the "Comment"
    # attribute, which has a maximum length of 256 characters.

    if ($candidateName.Length -gt 256) {
        # If the name is too long, display a warning message.
        # The $isNameValid flag remains $false, so the loop will run again.
        Write-Warning "❌ The name provided is too long. A full name cannot exceed 256 characters. Please try again."
    }
    else {
        # If the name is valid, assign it to the final $user variable.
        $user = $candidateName

        # Set the flag to $true to exit the do-while loop.
        $isNameValid = $true

        # Provide positive feedback to the user.
        Write-Host "✅ Success! The user's full name has been set to '$user'." -ForegroundColor Green
    }

} while ($isNameValid -eq $false)

# --- SCRIPT CONTINUATION ---
# You can now confidently use the $user variable elsewhere in your script,
# knowing it contains a valid value.
Write-Host "------------------------------------------------"
Write-Host "The script can now proceed."
Write-Host "The user name is set to: $user"
Write-Host "Proceeding with computer name: $computerName"
Write-Host "------------------------------------------------"
pause

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