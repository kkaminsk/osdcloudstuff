#Set my working OSDCloud Template 

Set-OSDCloudTemplate -Name 'TestOSD'
New-OSDCloudWorkspace -WorkspacePath C:\OSDCloud\TestOSD
Set-OSDCloudWorkspace C:\OSDCloud\TestOSD

#Cleanup Languages 

$KeepTheseDirs = @('boot','efi','en-us','sources','fonts','resources') 

Get-ChildItem "$(Get-OSDCloudWorkspace)\Media" | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force 

Get-ChildItem "$(Get-OSDCloudWorkspace)\Media\Boot" | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force 

Get-ChildItem "$(Get-OSDCloudWorkspace)\Media\EFI\Microsoft\Boot" | Where {$_.PSIsContainer} | Where {$_.Name -notin $KeepTheseDirs} | Remove-Item -Recurse -Force 

# Not doing for now Add Windows install.wim to C:\osdcloud\TestOSD\Media\OSDCloud\OS 