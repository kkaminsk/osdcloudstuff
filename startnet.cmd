@ECHO OFF
wpeinit
cd\
title OSD 25.7.5.3
PowerShell -Nol -C Initialize-OSDCloudStartnet
PowerShell -Nol -C Initialize-OSDCloudStartnetUpdate
@ECHO OFF
ECHO Start-OSDCloud
start /wait PowerShell -NoL -W Ma -C Start-OSDCloud -ImageFileUrl "http://PFCOMDC1/install.wim" -imageindex 3
start /wait PowerShell -NoL -W Mi -C restart-computer -force
@ECHO ON
