$credential = Get-Credential
New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\PFCOMDC1\OSDCloud" -Credential $credential -Persist