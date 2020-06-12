# Making an SDK (Windows) #

<a name="prerequisites">

## Prerequisites ##

</a>

These prerequisites need to be completed before making a DREAM.3D SDK.

If you have already fulfilled all of these prerequisites, skip to the [Procedure](#procedure) section.

<a name="compiler_suite">

### Install a Compiler Suite ###

</a>

A compatible compiler needs to be installed on your system to be able to build DREAM.3D.

| Product | Product Version | Compiler Version | MSVC++ Toolset |
| ------- | --------------- | ---------------- | -------------- |
| Visual Studio 2017 Pro & Community | 15.8 | 19.15 | 14.15 |

This tutorial uses Visual Studio to build an SDK from DREAM3DSuperbuild.  Ensure you have the proper Version of Visual Studio installed.  Version 2017 is supported in this release and should be usable.  Both the **Professional** and **Community** versions will work.

If you are using VS2019 please ensure that when you installed VS2019 that you also installed the VS2017 (v141) toolset. It will be needed later on in the process.

You will also need a compatible python environment. Python version 3.6 or 3.7 is needed as a base with the added dependency of the "mkdocs" system which is used to generate the user facing documentation for DREAM.3D. The easiest way to do this is to open a python command prompt and do

        pip install mkdocs-material

DREAM.3D Developers specifically use Anaconda3 environments for development and have the most experience with those python environments. If you want to use python from another distribution it *should* be usable as long as you install "mldocs-material" through pip. 

For more information, please visit [Installing a Compiler Suite](http://www.dream3d.io/6_Developer/CompilerSuite/index.html).

### Install Git ###

Git needs to be installed on your system to be able to clone repositories from Github.

To install Git, please visit the [Git website](https://git-scm.com/downloads).

**Note**: During the installation ensure that the "Windows command prompt" can use Git.

<a name="procedure">

## Procedure ##

</a>

### Basic Setup ###

**1: Create a folder called DREAM3D_SDK on your C:\ drive**
![](Images/Windows/create_sdk_folder.png)

**2: Download and install CMake from https://cmake.org/download:**

Scroll down the page until you see the **Latest Release** section.  The latest release may be a higher version than 3.13.0

![](Images/Windows/cmake_download_page.png)

Press the download link to download the zip file of the latest release of CMake.  It does not matter if the download is for 32-bit (win32-x86) or 64-bit (win64-x64).  Again, the latest release may be a higher version than 3.13.0, but that is ok.

Click on the zip file that you just downloaded to extract it into a folder.

Move the newly extracted folder into the **DREAM3D_SDK** folder that we created earlier.
![](Images/Windows/cmake_in_sdk_folder.png)

### Clone Repository ###

Create a folder called **workspace** in your home directory (C:\Users\\[username]), and then use git to clone the DREAM.3D Superbuild repository at [https://github.com/bluequartzsoftware/DREAM3DSuperbuild](https://github.com/bluequartzsoftware/DREAM3DSuperbuild) to the **workspace** folder that you just created.  For quick access to the git terminal at a given directory, right-click on the directory and select "Git Bash Here" once git has been installed.  Then, type the following command to create a copy of the source code in the current directory:

    git clone https://github.com/bluequartzsoftware/DREAM3DSuperbuild.git

![](Images/Windows/dream3d_superbuild_placement.png)

*Note*: If you use git through command prompt, the coloring in your terminal will be different, but the command to clone the repository will be the same.

### Instructions ###

1. Open CMake and set the **Where is the source code** path to *C:\Users\\[username]\Workspace\DREAM3DSuperbuild*.

  ![Open CMake](Images/Windows/source_code_path.png)

2. Set the **Where to build the binaries** path to *C:\Users\\[username]\Workspace\DREAM3DSuperbuild\Build*.

  ![Setting binary directory](Images/Windows/build_binaries.png)

3. We are going to create a CMake variable.  Press the **Add Entry** button.

    ![Create a CMake variable](Images/Windows/add_entry.png)

4. Set the **Name** to *DREAM3D_SDK*.  Set the **Type** to *PATH* and set the **Value** to the location of the DREAM3D_SDK folder that we created earlier (*C:\DREAM3D_SDK*).

  ![Set Name of CMake variable](Images/Windows/create_cmake_variable.png)

5. You should now have a few variables, DREAM3D_SDK.

  ![CMake before configure](Images/Windows/cmake_before_configuration.png)

6. Press the **Configure** button in CMake.  If the build directory specified does not already exist, CMake will ask if you want to create the directory.  Click "Yes".

7. CMake will ask you which generator should be used for this project.

+ If you are using Visual Studio 2019, select Visual Studio 16 2019.
+ If you are using Visual Studio 2017, select Visual Studio 15 2017 Win64.
+ If you are using Visual Studio 2015, select Visual Studio 14 2015 Win64.

### VS2019 WARNING ###

Due to an incompatibility between VS2019 and ITK 4.13.x when configuring DREAM3DSuperbuild the user will need to also add "v141" to the "Optional toolset to use" text field. This just tells the compiler to use the compilers from VS2017 instead of the newer compilers from VS2019. No functionality is lost when doing this but this is the only way to allow the compilation to finish without any errors.

  ![Select a Generator](Images/Windows/cmake_select_generator.png)

  Click **Finish**.  If the selected Visual Studio and its C++ compiler are not installed, CMake will throw an error and will not allow you to proceed until you have done so.

8. At this point, Qt 5 will be automatically downloaded and installed.  Sometimes during the installation of Qt the Qt installer application will crash.  Simply try configuring again to relaunch the Qt installer.  Since the Qt download is over 1 GB in size, this may take some time so please be patient.

  ![Downloading Qt](Images/Windows/downloading_qt.png)

  Sometimes there is a pause between the download completing and the installer popping up, so just wait a minute or so for the installer to appear.
  ![Installing Qt5](Images/Windows/qt_installer.png)

9. Press the **Configure** button in CMake again.

  ![Debug Configured](Images/Windows/debug_configured.png)

10. Press the **Generate** button in CMake to generate the build files.

  ![Generating Solution](Images/Windows/cmake_generated.png)

  *Note*: Although you still need to press **Configure** in step 9, Qt will not download or install again because it was already downloaded and installed the first time through.

11. Click "Open Project" to launch Visual Studio with the DREAM3DSuperBuild Project. Check that ALL_BUILD and Debug are selected.

  ![Visual Studio](Images/Windows/visual_studio_project.png)

12. Click Build -> Build Solution to begin building the SDK.  This will take some time.  Please be patient as your SDK builds. Once the build starts all of the dependent libaries are either built or downloaded. All libraries are installed into the DREAM3D_SDK folder that you specified earlier. Nothing that DREAM.3D depends on is installed into any system directories.
In addition all of the needed source codes for DREAM.3D itself will be cloned from GitHub and stored in directories rooted at the same level as the DREAM3DSuperbuild directory. You can override this behavior by specifying the **DREAM3D_WORKSPACE** CMake variable.

13. Change Debug selection to Release and repeat Step 12.

## Building DREAM.3D ##

Now that you have all of the dependent libraries built you are now ready to compile DREAM.3D. For the examples below we are going to assume the following folder structure:

* DREAM3D_SDK is located at C:/DREAM3D_SDK
* DREAM3D_WORKSPACE is located at C:/Users/\[USERNAME\]/Workspace

There are 6 basic git repositories that need to be cloned:

    git clone https://www.github.com/bluequartzsoftware/CMP.git
    git clone https://www.github.com/bluequartzsoftware/H5Support.git
    git clone https://www.github.com/bluequartzsoftware/EbsdLib.git
    git clone https://www.github.com/bluequartzsoftware/SIMPL.git
    git clone https://www.github.com/bluequartzsoftware/SIMPLView.git
    git clone https://www.github.com/bluequartzsoftware/DREAM3D.git

In addition there are a few extra repositories that are always built as part of the standard DREAM3D build:

    git clone https://www.github.com/bluequartzsoftware/ITKImageProcessing DREAM3D_Plugins/ITKImageProcessing
    git clone https://www.github.com/bluequartzsoftware/SimulationIO DREAM3D_Plugins/SimulationIO
    git clone https://www.github.com/dream3d/DREAM3DReview DREAM3D_Plugins/DREAM3DReview
    git clone https://www.github.com/dream3d/UCSBUtilities DREAM3D_Plugins/UCSBUtilities

After you have finished cloning the sources your *Workspace* folder should look like this:

    Workspace/CMP
    Workspace/EbsdLib
    Workspace/H5Support
    Workspace/DREAM3D
    Workspace/DREAM3D_Plugins/ITKImageProcessing
    Workspace/DREAM3D_Plugins/SimulationIO
    Workspace/DREAM3D_Plugins/DREAM3DReview
    Workspace/DREAM3D_Plugins/UCSBUtilities
    Workspace/SIMPL
    Workspace/SIMPLView

Use CMake-GUI to configure the DREAM.3D project. Before clicking the configure button it should look like the following (NOTE: Your username will be different than mine)

![Images/Windows/DREAM3D_Configure.png](Images/Windows/Configure_DREAM3D_1.png)

Click the **Configure** button and select the proper Generator. We are using Visual Studio 15 2017 in this example. On CMake versions starting at 15.0 you now need to also select the "Platform" for the generator. In our case we want __x64__ because we are going to compile as a 64 bit application. Note that all of the selections should mirror what you selected when building the DREAM3D SDK.

![Selecting the compiler toolset](Images/Windows/Configure_DREAM3D_2.png)

Click **Finish** and let CMake configure the project for you.

When the configuration completes you should click the **Generate** button to actually generate the DREAM3DProj.sln file for Visual Studio to use. Once the generation step is complete you can use the **Open Project** button to open the project in Visual Studio. Once the project is open, in a similar fashion, go to the "Build->Build Solution" menul to build DREAM.3D. The defualt configuration is Debug.

If you are interested in building from a command line using alternate IDEs (such as QtCreator, CLion, VSCode) all of these steps are repeatable through command line invocations.
