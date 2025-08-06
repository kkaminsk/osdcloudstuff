# **Custom Editing for Unattended Imaging**

#### **Prerequisites**

Before you begin, ensure the Windows 11 machine you are using has the **Windows ADK** and the **PE addon** installed.

---

#### **Step 1: Create a Mount Directory**

First, create the folder that will be used to mount the Windows Imaging (WIM) file. Open a command prompt and create the following directory:

C:\\WinPE\\mount

---

#### **Step 2: Mount the Boot Image**

Next, you'll need to mount the boot.wim file from your OSDCloud media source into the directory you just created. You must modify the command below to point to the correct path of your WIM file.

Execute the following DISM command:

dism /mount-wim /wimfile:"C:\\osdcloud\\TestOSD\\Media\\sources\\boot.wim" /index:1 /mountdir:"C:\\WinPE\\mount"

---

#### **Step 3: Add Customizations**

With the image mounted, you can now add your custom scripts and configurations.

1. Edit Startnet.cmd: Modify your Startnet.cmd script and place it in the following location within the mounted image directory:  
   C:\\WinPE\\mount\\windows\\system32\\  
2. Add Custom Scripts: Create a new folder named OSDCustom inside the root of the mounted image. Place your custom PowerShell scripts, such as Custom1-start.ps1 and Custom2-end.ps1, into this new folder. The final path will be:  
   C:\\WinPE\\mount\\OSDCustom\\

---

#### **Step 4: Commit Changes**

Once you have completed your customizations, unmount the WIM file and commit the changes to save them permanently.

Run the following command:

dism /unmount-wim /mountdir:"C:\\WinPE\\mount" /commit

---

#### **Troubleshooting**

If you encounter issues during this process, the following commands can be helpful.

* Check Mounted Images: To see a list of all currently mounted WIM images, use this command:  
  dism /get-mountedwiminfo  
* Discard Changes: If you cannot commit the image or need to revert your changes, you can unmount the image without saving by using the /discard switch:  
  dism /unmount-wim /mountdir:"C:\\WinPE\\mount" /discard  
* Cleanup WIM: To help resolve potential corruption issues with the WIM file, use the cleanup command:  
  dism /cleanup-wim