#--------------------------------------------------------------------------------------------------
# Are we building ITK (ON by default)
#--------------------------------------------------------------------------------------------------
OPTION(BUILD_ITK "Build ITK" ON)
if("${BUILD_ITK}" STREQUAL "OFF")
  return()
endif()

set(extProjectName "ITK")
set(ITK_GIT_TAG "v4.13.2")
set(ITK_VERSION "4.13.2")
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
  set(CXX_FLAGS "-stdlib=libc++ -std=c++11")
  set(HDF5_CMAKE_MODULE_DIR "${HDF5_INSTALL}/share/cmake/hdf5")
elseif("${BUILD_ITK}" STREQUAL "ON")
  set(BINARY_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
  set(ITK_INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
  set(CXX_FLAGS "-std=c++11")
  set(HDF5_CMAKE_MODULE_DIR "${HDF5_INSTALL}/share/cmake/hdf5")
else()
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CXX_FLAGS "-stdlib=libc++ -std=c++11")
  else()
    set(CXX_FLAGS "-std=c++11")
  endif()
  set(HDF5_CMAKE_MODULE_DIR "${HDF5_INSTALL}/share/cmake/hdf5")
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
    -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
    -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_CXX_FLAGS=${CXX_FLAGS}
    ${APPLE_CMAKE_ARGS}

    -DCMAKE_CXX_STANDARD=11 
    -DCMAKE_CXX_STANDARD_REQUIRED=ON

    -DBUILD_DOCUMENTATION=OFF
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTING=OFF
   
    -DKWSYS_USE_MD5=ON
        
    -DDITK_LEGACY_REMOVE=ON
    -DITK_FUTURE_LEGACY_REMOVE=ON
    -DITK_LEGACY_SILENT=OFF

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

    
    -DCMAKE_SKIP_INSTALL_RPATH=OFF
		-DCMAKE_SKIP_RPATH=OFF
		-DUSE_COMPILER_HIDDEN_VISIBILITY=OFF


  
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
FILE(APPEND ${DREAM3D_SDK_FILE} "set(ITK_VERSION \"${ITK_VERSION}\" CACHE STRING \"\")\n")

