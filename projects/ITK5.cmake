#--------------------------------------------------------------------------------------------------
# Are we building ITK (ON by default)
#--------------------------------------------------------------------------------------------------
OPTION(BUILD_ITK "Build ITK" ON)
if("${BUILD_ITK}" STREQUAL "OFF")
  return()
endif()

set(extProjectName "ITK")
set(ITK_GIT_TAG "v5.1.1")
set(ITK_VERSION "5.1.1")
message(STATUS "Building: ${extProjectName} ${ITK_VERSION}: -DBUILD_ITK=${BUILD_ITK}" )

option(ITK_SCIFIO_SUPPORT "Add support for SCIFIO to the ITK build" OFF)
set(SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}-${ITK_VERSION}/Source/${extProjectName}")
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
set(D3DSP_BASE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}-${ITK_VERSION}")

#------------------------------------------------------------------------------
# In the below we are using ITK 5.1.1 from the 5.1.1 tag.
ExternalProject_Add(${extProjectName}
  GIT_REPOSITORY "https://github.com/InsightSoftwareConsortium/ITK.git"
  GIT_PROGRESS 1
  GIT_TAG ${ITK_GIT_TAG}
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

    -DCMAKE_CXX_STANDARD:STRING=14
    -DCMAKE_CXX_STANDARD_REQUIRED:BOOL=ON
    -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
    
    -DBUILD_DOCUMENTATION:BOOL=OFF
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
   
    -DKWSYS_USE_MD5:BOOL=ON
    
    -DITK_LEGACY_REMOVE:BOOL=OFF
    -DITK_FUTURE_LEGACY_REMOVE:BOOL=ON
    -DITK_LEGACY_SILENT:BOOL=OFF
    -DITKV4_COMPATIBILITY:BOOL=ON
    -DITK_USE_SYSTEM_EIGEN:BOOL=ON
    -DITK_USE_SYSTEM_HDF5:BOOL=ON
    -DHDF5_DIR=${HDF5_CMAKE_MODULE_DIR}

		-DITKGroup_Core:BOOL=ON
		-DITKGroup_Filtering:BOOL=ON
		-DITKGroup_Registration:BOOL=ON
		-DITKGroup_Segmentation:BOOL=ON

    -DITK_BUILD_DEFAULT_MODULES:BOOL=OFF
    -DModule_ITKIOMRC:BOOL=ON
    -DModule_ITKReview:BOOL=ON
    -DModule_SCIFIO=${ITK_SCIFIO_SUPPORT}

    -DModule_ITKMetricsv4:BOOL=ON
    -DModule_ITKOptimizersv4:BOOL=ON
    -DModule_ITKRegistrationMethodsv4:BOOL=ON
    -DModule_ITKIOTransformBase:BOOL=ON
    -DModule_ITKConvolution:BOOL=ON
    -DModule_ITKDenoising:BOOL=ON
    -DModule_ITKImageNoise:BOOL=ON

    -DModule_Montage:BOOL=ON
    -DModule_Montage_GIT_TAG:STRING=v0.5.3

    -DModule_TotalVariation:BOOL=ON
    -DModule_TotalVariation_GIT_TAG:STRING=v0.2.0

    -DEigen3_DIR:PATH=${Eigen3_DIR}
  
  DEPENDS hdf5
  DEPENDS Eigen
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
FILE(APPEND ${DREAM3D_SDK_FILE} "set(ITK_VERSION \"${ITK_VERSION}\" CACHE PATH \"\")\n")

