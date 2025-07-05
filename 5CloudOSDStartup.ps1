# Custom editing for custom image.

# Create folder
# C:\WinPE\mount

# Run
dism /mount-wim /wimfile:"C:\osdcloud\TestOSD\Media\sources\boot.wim" /index:1 /mountdir:"C:\WinPE\mount"
# Add
start /wait PowerShell -NoL -W Mi -C Start-OSDCloud -ImageFileUrl "http://PFCOMDC1/install.wim" -imageindex 3

# Unmount WIM
dism /unmount-wim /mountdir:"C:\WinPE\mount" /commit

New-OSDCloudISO