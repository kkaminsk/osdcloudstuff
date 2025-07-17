# Define the path to the temporary unattend.xml file
$tempUnattendFile = "X:\Windows\Temp\unattend.xml"

# Copy the file to its final location
Copy-Item -Path $tempUnattendFile -Destination "C:\Windows\Panther\unattend.xml" -Force