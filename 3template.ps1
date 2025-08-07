New-OSDCloudTemplate
#Set my working OSDCloud Template 

Set-OSDCloudTemplate -Name 'TestOSD'
New-OSDCloudWorkspace -WorkspacePath C:\OSDCloud\TestOSD
Set-OSDCloudWorkspace C:\OSDCloud\TestOSD