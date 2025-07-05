@ECHO OFF
wpeinit
cd\
title OSD 25.7.5.3
PowerShell -Nol -C Initialize-OSDCloudStartnet
PowerShell -Nol -C Initialize-OSDCloudStartnetUpdate
@ECHO OFF
ECHO Start-OSDCloudGUI
start /wait PowerShell -NoL -W Mi -C Start-OSDCloud -Brand 'OSDCloud' -ImageFileUrl "http://PFCOMDC1/install.wim"
shutdown /r /i /t:30 /c "OSDCloud Complete"
@ECHO ON
