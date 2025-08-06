# **Make Windows Media for Windows 11**

### **Prerequisites**

Before you begin, make sure you have the following ready:

* A **Hyper-V Server**: This will be used to host your reference virtual machine.  
* **Windows 11 Media**: You'll need the original ISO file for Windows 11\.  
* **Windows Assessment and Deployment Kit (ADK)**: This must be installed on your host server.  
* **Windows PE add-on for the ADK**: This is also required and should be installed on the host server.

---

### **Step 1: Create and Prepare the Reference VM**

The first phase involves creating a "golden image"—a perfectly configured Windows 11 environment that will be duplicated.

1. **Create a new Virtual Machine** on your Hyper-V server.  
2. **Install Windows 11** on the VM using your standard Windows 11 ISO.  
3. During setup, ensure the VM is **not joined to a domain** (keep it in a workgroup).  
4. Once Windows 11 is installed, **install all necessary applications**, software, and apply the latest Windows updates.  
5. After all customizations are complete, you need to prepare the image for duplication using the **System Preparation Tool (Sysprep)**. Open Command Prompt as an administrator and run the following command. This command generalizes the image, sets it to the "Out-of-Box Experience" (OOBE) for the following user, and shuts down the VM. The /mode:vm switch is crucial as it readies the virtual disk for cloning.

   sysprep.exe /generalize /oobe /shutdown /mode:vm

6. If you encounter any issues during the sysprep process, you can find detailed error logs in the following file: C:\\Windows\\System32\\Sysprep\\panther\\setupact.log.

---

### **Step 2: Capture the Custom Image**

Now that your reference VM is prepared and shut down, you will capture its state into a .wim file.

1. On your Hyper-V host server, locate the **VHDX file** for the VM you just sysprepped.  
2. **Attach this VHDX file** to the host server through Disk Management. This will mount the virtual disk as a new drive.  
3. Take note of the **drive letter** assigned to the mounted virtual disk (e.g., E:).  
4. Open Command Prompt as an administrator on the host server and use the **Deployment Image Servicing and Management (DISM)** tool to capture the image. This command creates a new install.wim file from the contents of your reference VM's drive.

   dism /Capture-Image /ImageFile:C:\\temp\\W11WIM\\install.wim /CaptureDir:E:\\ /Name:"Your Custom Image Name" /Description:"A description for your image"

   * Make sure the destination directory (C:\\temp\\W11WIM\\ in this example) exists before running the command.  
   * Replace "Your Custom Image Name" and the description with your own details.

---

### **Step 3: Build the Custom ISO**

The final phase is to build a new bootable ISO that includes your custom install.wim.

1. **Copy the entire contents** of the original Windows 11 ISO to a new folder on your host server (e.g., C:\\Win11ISOFiles).  
2. Navigate to the sources folder within this new directory (C:\\Win11ISOFiles\\sources\\).  
3. **Replace the default install.wim** in this folder with the custom install.wim you created in the previous step (C:\\temp\\W11WIM\\install.wim).  
4. Finally, use the **OSCDIMG** command-line tool (part of the ADK) to create the new bootable ISO file. This command makes the ISO bootable using the correct boot sector file.

   oscdimg \-m \-u2 \-bC:\\Win11ISOFiles\\boot\\etfsboot.com C:\\Win11ISOFiles C:\\temp\\W11custom.iso

   * \-m: Allows for the creation of images larger than the CD-ROM limit.  
   * \-u2: Creates a UDF file system.  
   * \-b: Specifies the location of the boot sector file.

You will now have a custom, bootable Windows 11 ISO located at C:\\temp\\W11custom.iso that you can use for deployments.