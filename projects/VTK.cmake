#cmake -G Ninja -DCMAKE_BUILD_TYPE=Release 
# -DQt5_DIR=/Users/Shared/DREAM3D_SDK/Qt5.12.4/5.12.4/clang_64/lib/cmake/Qt5 
# -DVTK_Group_Qt=ON -DVTK_QT_VERSION=5 
#  -DModule_vtkGUISupportQtOpenGL=ON 
# -DVTK_BUILD_QT_DESIGNER_PLUGIN=ON 
# -DVTK_USE_SYSTEM_HDF5=ON 
# -DHDF5_C_INCLUDE_DIR=/Users/Shared/DREAM3D_SDK/hdf5-1.10.4-Release/include 
# -DHDF5_hdf5_LIBRARY_RELEASE=/Users/Shared/DREAM3D_SDK/hdf5-1.10.4-Release/lib/libhdf5.dylib 
# -DHDF5_hdf5_hl_LIBRARY_RELEASE=/Users/Shared/DREAM3D_SDK/hdf5-1.10.4-Release/lib/libhdf5_hl.dylib  
# ../VTK



#cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug -DQt5_DIR=/Users/Shared/DREAM3D_SDK/Qt5.12.4/5.12.4/clang_64/lib/cmake/Qt5 -DVTK_Group_Qt=ON -DVTK_QT_VERSION=5 -DModule_vtkGUISupportQtOpenGL=ON -DVTK_BUILD_QT_DESIGNER_PLUGIN=ON -DVTK_USE_SYSTEM_HDF5=ON -DHDF5_C_INCLUDE_DIR=/Users/Shared/DREAM3D_SDK/hdf5-1.10.4-Debug/include -DHDF5_hdf5_LIBRARY_DEBUG=/Users/Shared/DREAM3D_SDK/hdf5-1.10.4-Debug/lib/libhdf5_debug.dylib -DHDF5_hdf5_hl_LIBRARY_DEBUG=/Users/Shared/DREAM3D_SDK/hdf5-1.10.4-Debug/lib/libhdf5_hl_debug.dylib  ../VTK

set(extProjectName "VTK")

set(VTK_GIT_TAG "v8.2.0")
set(VTK_VERSION "8.2.0")
message(STATUS "External Project: ${extProjectName}: ${VTK_VERSION}" )

set(VTK_URL "	https://gitlab.kitware.com/vtk/vtk.git")

set(VTK_BIN_DIR_SUFFIX "-${CMAKE_BUILD_TYPE}")
if(MSVC_IDE)
  set(VTK_BIN_DIR_SUFFIX "")
endif()


set(SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}")
set(VTK_INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}-${VTK_VERSION}${VTK_BIN_DIR_SUFFIX}")
set(BINARY_DIR "${DREAM3D_SDK}/${extProjectName}-${VTK_VERSION}${VTK_BIN_DIR_SUFFIX}")

if( CMAKE_BUILD_TYPE MATCHES Debug )
  set(HDF5_SUFFIX "_debug")
  set(upper "DEBUG")
else()
  set(HDF5_SUFFIX "")
  set(upper "RELEASE")
endif( CMAKE_BUILD_TYPE MATCHES Debug )
set(HDF_ROOT "${HDF5_INSTALL}")


#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#
# The next section about setting the HDF5_CMAKE_MODULE_DIR directory is VERY 
# dependent on the version of HDF5 that is being used.

if(WIN32)
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
elseif(APPLE)
  set(APPLE_CMAKE_ARGS "-DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET} -DCMAKE_OSX_SYSROOT=${OSX_SDK} -DCMAKE_SKIP_INSTALL_RPATH=OFF -DCMAKE_SKIP_RPATH=OFF")
else()
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CXX_FLAGS "-stdlib=libc++ -std=c++14")
  else()
    set(CXX_FLAGS "-std=c++14")
  endif()
endif()

set_property(DIRECTORY PROPERTY EP_BASE ${DREAM3D_SDK}/superbuild)
set(D3DSP_BASE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}")

#------------------------------------------------------------------------------
# In the below we are using VTK 8.2.0 from the 8.2.0 tag.
ExternalProject_Add(${extProjectName}
  # ========== This is for downloading and building a git tag of VTK
  GIT_REPOSITORY "https://gitlab.kitware.com/vtk/vtk.git"
  GIT_PROGRESS 1
  GIT_TAG ${VTK_GIT_TAG}
  TMP_DIR "${D3DSP_BASE_DIR}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${D3DSP_BASE_DIR}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${D3DSP_BASE_DIR}
  SOURCE_DIR "${SOURCE_DIR}"
  BINARY_DIR "${BINARY_DIR}"
  INSTALL_DIR "${D3DSP_BASE_DIR}/Install"
  INSTALL_COMMAND ""
  
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:STRING=${BUILD_SHARED_LIBS}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_CXX_FLAGS=${CXX_FLAGS}
    ${APPLE_CMAKE_ARGS}

    -DCMAKE_CXX_STANDARD_REQUIRED:BOOL=ON

    -DBUILD_DOCUMENTATION:BOOL=OFF
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
   
    -DQt5_DIR=${Qt5_DIR} 
    -DVTK_Group_Qt=ON -DVTK_QT_VERSION=5 
    -DModule_vtkGUISupportQtOpenGL=ON 
    -DVTK_BUILD_QT_DESIGNER_PLUGIN=ON 
    -DVTK_USE_SYSTEM_HDF5=ON 
    -DHDF5_ROOT:STRING=${HDF5_INSTALL}

  DEPENDS hdf5
  DEPENDS Qt5
  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)


#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# VTK ${VTK_VERSION} Library Location\n")
if(WIN32)
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(VTK_DIR \"\${DREAM3D_SDK_ROOT}/VTK-${VTK_VERSION}\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(VTK_DIR \"\${DREAM3D_SDK_ROOT}/VTK-${VTK_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${VTK_DIR})\n")
