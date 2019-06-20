set(extProjectName "ITK")

set(ITK_VERSION "5.0.0")
message(STATUS "External Project: ${extProjectName}: ${ITK_VERSION}" )

#set(ITK_URL "http://dream3d.bluequartz.net/binaries/SDK/Sources/ITK/InsightToolkit-${ITK_VERSION}.tar.gz")
set(ITK_URL "https://github.com/InsightSoftwareConsortium/ITK/archive/${ITK_VERSION}.tar.gz")

option(ITK_SCIFIO_SUPPORT "Add support for SCIFIO to the ITK build" OFF)
set(SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}")
set(ITK_INSTALL_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
set(BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build-${CMAKE_BUILD_TYPE}")

#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#!#
# The next section about setting the HDF5_CMAKE_MODULE_DIR directory is VERY 
# dependent on the version of HDF5 that is being used.

if(WIN32)
  set(SOURCE_DIR "${DREAM3D_SDK}/${extProjectName}-src")
  set(BINARY_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}")
  set(ITK_INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}")
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
  set(HDF5_CMAKE_MODULE_DIR "${HDF5_INSTALL}/cmake/hdf5")
elseif(APPLE)
  set(APPLE_CMAKE_ARGS "-DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET} -DCMAKE_OSX_SYSROOT=${OSX_SDK} -DCMAKE_SKIP_INSTALL_RPATH=OFF -DCMAKE_SKIP_RPATH=OFF")
  set(BINARY_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
  set(ITK_INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
  set(CXX_FLAGS "-stdlib=libc++ -std=c++14")
  set(HDF5_CMAKE_MODULE_DIR "${HDF5_INSTALL}/share/cmake/hdf5")
elseif("${BUILD_ITK}" STREQUAL "ON")
  set(BINARY_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
  set(ITK_INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
  set(CXX_FLAGS "-std=c++14")
  set(HDF5_CMAKE_MODULE_DIR "${HDF5_INSTALL}/share/cmake/hdf5")
else()
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CXX_FLAGS "-stdlib=libc++ -std=c++14")
  else()
    set(CXX_FLAGS "-std=c++14")
  endif()
endif()

if( CMAKE_BUILD_TYPE MATCHES Debug )
  set(HDF5_SUFFIX "_debug")
  set(upper "DEBUG")
else()
  set(HDF5_SUFFIX "")
  set(upper "RELEASE")
endif( CMAKE_BUILD_TYPE MATCHES Debug )

set_property(DIRECTORY PROPERTY EP_BASE ${DREAM3D_SDK}/superbuild)
set(D3DSP_BASE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}")

#------------------------------------------------------------------------------
# In the below we are using ITK 5.0 from the 5.0.0 tag.
ExternalProject_Add(${extProjectName}

  GIT_REPOSITORY "https://github.com/InsightSoftwareConsortium/ITK.git"
  GIT_PROGRESS 1
  GIT_TAG v5.0.0

  TMP_DIR "${D3DSP_BASE_DIR}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${D3DSP_BASE_DIR}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${D3DSP_BASE_DIR}
  SOURCE_DIR "${SOURCE_DIR}"
  BINARY_DIR "${BINARY_DIR}"
  INSTALL_DIR "${D3DSP_BASE_DIR}/Install"
  INSTALL_COMMAND ""
  
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
    -DCMAKE_BUILD_TYPE:=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_CXX_FLAGS=${CXX_FLAGS}
    ${APPLE_CMAKE_ARGS}

    -DCMAKE_CXX_STANDARD=14
    -DCMAKE_CXX_STANDARD_REQUIRED=ON

    -DBUILD_DOCUMENTATION=OFF
    -DBUILD_EXAMPLES=OFF
    -DBUILD_TESTING=OFF
   
    -DKWSYS_USE_MD5=ON
    
    -DITK_LEGACY_REMOVE=OFF
    -DITK_FUTURE_LEGACY_REMOVE=ON
    -DITK_LEGACY_SILENT=OFF
    -DITKV4_COMPATIBILITY=ON
    
    -DITK_USE_SYSTEM_HDF5=ON
    -DHDF5_DIR=${HDF5_CMAKE_MODULE_DIR}

		-DITKGroup_Core=ON
		-DITKGroup_Filtering=ON
		-DITKGroup_Registration=ON
		-DITKGroup_Segmentation=ON

    -DITK_BUILD_DEFAULT_MODULES=OFF
    -DModule_ITKIOMRC=ON
    -DModule_ITKReview=ON   
    -DModule_SCIFIO=${ITK_SCIFIO_SUPPORT}

    -DModule_ITKMetricsv4=ON
    -DModule_ITKOptimizersv4=ON
    -DModule_ITKRegistrationMethodsv4=ON
    -DModule_ITKIOTransformBase=ON
    -DModule_ITKConvolution=ON
    -DModule_ITKDenoising=ON
    -DModule_ITKImageNoise=ON

    -DModule_Montage=ON
    -DREMOTE_GIT_TAG_Montage:STRING=master
  
  DEPENDS hdf5
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
FILE(APPEND ${DREAM3D_SDK_FILE} "# ITK Library Location\n")
if(WIN32)
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(ITK_DIR \"\${DREAM3D_SDK_ROOT}/ITK-${ITK_VERSION}\" CACHE PATH \"\")\n")
else()
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(ITK_DIR \"\${DREAM3D_SDK_ROOT}/ITK-${ITK_VERSION}-\${BUILD_TYPE}\" CACHE PATH \"\")\n")
endif()
FILE(APPEND ${DREAM3D_SDK_FILE} "set(DREAM3D_USE_ITK \"ON\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${ITK_DIR})\n")

