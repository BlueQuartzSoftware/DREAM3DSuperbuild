# Making an SDK (OS X) #

<a name="prerequisites">

## Prerequisites ##

</a>

These prerequisites need to be completed before making a DREAM.3D SDK.

If you have already fulfilled all of these prerequisites, skip to the [Procedure](#procedure) section.

<a name="compiler_suite">

### Install a Compiler Suite ###

</a>

A compatible compiler needs to be installed on your system to be able to build DREAM.3D.

For more information, please visit [Installing a Compiler Suite](http://dream3d.bluequartz.net/binaries/Help/DREAM3D/compiler_suite.html).

## Procedure ##

#### Basic Setup ####

**1: Create a folder called DREAM3D_SDK in the /Users/Shared folder**
![](Images/OSX/create_sdk_folder.png)

**2: Download and install CMake from https://cmake.org/download:**

Scroll down the page until you see the **Latest Release** section.  The latest release may be a higher version than 3.7.2.
![](Images/OSX/cmake_download_page.png)
Press the download link to download the tar.gz file of the latest release of CMake.  Again, the latest release may be a higher version than 3.8.2 but that is ok.

Click on the tar.gz file that you just downloaded to expand it into a folder.

Move the newly expanded folder into the **DREAM3D_SDK** folder that we created earlier.
![](Images/OSX/cmake_in_sdk_folder.png)

**3: Download and install the "Ninja" build system from https://github.com/ninja-build/ninja/releases:**

![](Images/OSX/ninja_download_page.png)
Press the download link to download the **ninja-mac.zip** file.
Click on the zip file that you just downloaded to expand it into the ninja executable.

Place the executable in **/usr/local/bin**.
![](Images/OSX/ninja_placement.png)

**4: Download and install Doxygen from http://www.stack.nl/~dimitri/doxygen/download.html:**

Scroll down until you see the **Sources and Binaries** section.  Press the http download link to download the .dmg file of the latest release of Doxygen.
![](Images/OSX/doxygen_download_page.png)

Open the .dmg file and copy the app into **/Applications**. You may need admin privileges on your computer to complete this step.

**5: Download and install Xcode from the App Store located at /Applications/App Store.app**
After Xcode has been downloaded and installed, open it so that *Xcode Command Line Tools* will be installed.  **You CANNOT continue with setup until *Xcode Command Line Tools* has been installed!**

#### Clone Repository ####

Create a folder called **Workspace** in your home directory, and then use git to clone the DREAM.3D Superbuild repository at https://github.com/bluequartzsoftware/DREAM3DSuperbuild to the **Workspace** folder that you just created.

    git clone https://github.com/bluequartzsoftware/DREAM3DSuperbuild.git
    
![](Images/OSX/dream3d_superbuild_placement.png)

#### Instructions ####

1. Open CMake and set the **Where is the source code** path to */Users/[YOUR-HOME-FOLDER]/Workspace/DREAM3DSuperbuild*.
![](Images/OSX/source_code_path.png)

2. Set the **Where to build the binaries** path to */Users/[YOUR-HOME-FOLDER]/Workspace/Builds/DREAM3DSuperbuild-Build/Debug*.
![](Images/OSX/build_binaries_debug.png)

3. We are going to create a CMake variable.  Press the **Add Entry** button.
![](Images/OSX/add_entry.png)

4. Set the **Name** to *DREAM3D_SDK*.  Set the **Type** to *PATH* and set the **Value** to the location of the DREAM3D_SDK folder that we created earlier (*/Users/Shared/DREAM3D_SDK*)
![](Images/OSX/create_cmake_variable.png)

5. Repeat steps 3 & 4, except set **Name** to *CMAKE_MAKE_PROGRAM*, **Type** to *FILEPATH*, and **Value** to the path to our ninja executable that we added earlier (*/usr/local/bin/ninja*).

6. You should now have two variables, DREAM3D_SDK and CMAKE_MAKE_PROGRAM.
![](Images/OSX/cmake_before_configuration.png)

7. Press the **Configure** button in CMake. At this point, Qt 5 will be automatically downloaded and installed.  Since the Qt download is over 1 GB in size, this may take some time so please be patient.
![](Images/OSX/downloading_qt.png)
Sometimes there is a pause between the download completing and the installer popping up, so just wait a minute or so for the installer to appear.
![](Images/OSX/qt_installer.png)

8. When the installer is finished, make sure that **CMAKE_BUILD_TYPE** is set to *Debug*.
![](Images/OSX/configure_debug.png)

9. Press the **Configure** button in CMake again.
![](Images/OSX/debug_configured.png)

10. Press the **Generate** button in CMake to generate the build files.
![](Images/OSX/debug_generated.png)

11. Repeat steps 1-10, except use path */Users/[YOUR-HOME-FOLDER]/Workspace/Builds/DREAM3DSuperbuild-Build/Release* for step 2 and set **CMAKE_BUILD_TYPE** to *Release* in step 8.

    *Note*: Although you still need to press **Configure** in step 7, Qt will not download or install again because it was already downloaded and installed the first time through.

12. Open Terminal, and navigate to **/Users/*[YOUR-HOME-FOLDER]*/Workspace/Builds/DREAM3DSuperbuild-Build/Debug**.

13. Execute the command:

    `ninja`
    
    It will build the Debug version of the SDK.  Please be patient, it takes a while to build all the dependent libraries.

14. When the Debug version of the SDK is done building, navigate to **/Users/*[YOUR-HOME-FOLDER]*/Workspace/Builds/DREAM3DSuperbuild-Build/Release**.

15. Execute the command:

    `ninja`
    
    It will build the Release version of the SDK.  Please be patient, it takes a while to build all the dependent libraries.

16. Navigate to **/Users/Shared/DREAM3D_SDK**. This is your newly created SDK and can be used to compile DREAM.3D.

## Additional Notes ##

The procedure above builds the following libraries:

+ Eigen 3.3.5 or higher
+ HDF5 1.20.3.20 or higher
+ ITK 4.13.2 or higher
+ Qt 5.11.1 or higher
+ Qwt 6.1.3 or higher
+ TBB 2018_20180618 or higher

---
**Previous Page**: [Installing a Compiler Suite](http://dream3d.bluequartz.net/binaries/Help/DREAM3D/compiler_suite.html)