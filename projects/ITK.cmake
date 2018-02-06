set(extProjectName "ITK")
message(STATUS "External Project: ${extProjectName}" )

if(NOT ITK_VERSION)
  set(ITK_VERSION 4.13.0 CACHE STRING "Choose ITK version." FORCE)

  # Set the possible values of ITK_VERSION for cmake-gui
  set_property(CACHE ITK_VERSION PROPERTY STRINGS
    "4.13.0"
    "5.0.0"
    )
endif()

if(ITK_VERSION STREQUAL "4.13.0")
  set(ITK_URL "http://dream3d.bluequartz.net/binaries/SDK/Sources/ITK/InsightToolkit-${ITK_VERSION}.tar.gz")
elseif(ITK_VERSION STREQUAL "5.0.0")
  set(ITK_URL "https://codeload.github.com/InsightSoftwareConsortium/ITK/zip/v5.0a01")
else()
  message(FATAL_ERROR "Unable to find requested version of ITK: ${ITK_VERSION}")
endif()

option(ITK_SCIFIO_SUPPORT "Add support for SCIFIO to the ITK build" ON)
set(SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}")
set(ITK_INSTALL_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
set(BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build-${CMAKE_BUILD_TYPE}")

if(WIN32)
  set(SOURCE_DIR "${DREAM3D_SDK}/${extProjectName}-src")
  set(BINARY_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}")
  set(ITK_INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}")
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
  set(HDF5_CMAKE_MODULE_DIR "${HDF5_INSTALL}/cmake")
elseif(APPLE)
  set(BINARY_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
  set(ITK_INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
  set(CXX_FLAGS "-stdlib=libc++ -std=c++11")
  set(HDF5_CMAKE_MODULE_DIR "${HDF5_INSTALL}/share/cmake")
elseif("${BUILD_ITK}" STREQUAL "ON")
  set(BINARY_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
  set(ITK_INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
  set(CXX_FLAGS "-std=c++11")
  set(HDF5_CMAKE_MODULE_DIR "${HDF5_INSTALL}/share/cmake")
else()
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CXX_FLAGS "-stdlib=libc++ -std=c++11")
  else()
    set(CXX_FLAGS "-std=c++11")
  endif()
  set(HDF5_CMAKE_MODULE_DIR "${HDF5_INSTALL}/share/cmake")
endif()

if( CMAKE_BUILD_TYPE MATCHES Debug )
  set(HDF5_SUFFIX "_debug")
  set(upper "DEBUG")
else()
  set(HDF5_SUFFIX "")
  set(upper "RELEASE")
ENDif( CMAKE_BUILD_TYPE MATCHES Debug )


set_property(DIRECTORY PROPERTY EP_BASE ${DREAM3D_SDK}/superbuild)

ExternalProject_Add(${extProjectName}
  DOWNLOAD_NAME ${extProjectName}-${ITK_VERSION}.tar.gz
  URL ${ITK_URL}
  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${SOURCE_DIR}"
  #BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  BINARY_DIR "${BINARY_DIR}"
  INSTALL_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Install"
  INSTALL_COMMAND ""
  
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
    -DCMAKE_BUILD_TYPE:=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_CXX_FLAGS=${CXX_FLAGS}
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DCMAKE_CXX_STANDARD=11 
    -DCMAKE_CXX_STANDARD_REQUIRED=ON

		-DBUILD_DOCUMENTATION=OFF
		-DITK_USE_SYSTEM_HDF5=ON
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTING=OFF
		-DDITK_LEGACY_REMOVE=ON
		-DKWSYS_USE_MD5=ON
		-DModule_ITKReview=ON
		-DITK_BUILD_DEFAULT_MODULES=OFF
		-DITKGroup_Core=ON
		-DITKGroup_Filtering=ON
		-DITKGroup_Registration=ON
		-DITKGroup_Segmentation=ON
		-DModule_SCIFIO=${ITK_SCIFIO_SUPPORT}
    -DModule_ITKIOMRC=ON
		-DCMAKE_SKIP_INSTALL_RPATH=OFF
		-DCMAKE_SKIP_RPATH=OFF
		-DUSE_COMPILER_HIDDEN_VISIBILITY=OFF

		-DHDF5_DIR=${HDF5_CMAKE_MODULE_DIR}
		-DHDF5_CXX_COMPILER_EXECUTABLE=HDF5_CXX_COMPILER_EXECUTABLE-NOTFOUND
		-DHDF5_CXX_INCLUDE_DIR=${HDF5_INSTALL}/include
		-DHDF5_C_COMPILER_EXECUTABLE=HDF5_C_COMPILER_EXECUTABLE-NOTFOUND
		-DHDF5_C_INCLUDE_DIR=${HDF5_INSTALL}/include

		-DHDF5_DIFF_EXECUTABLE=${HDF5_INSTALL}/bin/h5diff
		-DHDF5_DIR=${HDF5_CMAKE_MODULE_DIR}
		-DHDF5_Fortran_COMPILER_EXECUTABLE=HDF5_Fortran_COMPILER_EXECUTABLE-NOTFOUND
		-DHDF5_IS_PARALLEL=OFF

		-DHDF5_CXX_LIBRARY=${HDF5_INSTALL}/lib/libhdf5_cpp${HDF5_SUFFIX}.${HDF5_VERSION}.dylib
    -DHDF5_C_LIBRARY=${HDF5_INSTALL}/lib/libhdf5${HDF5_SUFFIX}.${HDF5_VERSION}.dylib
    -DHDF5_hdf5_LIBRARY_${upper}=${HDF5_INSTALL}/lib/libhdf5${HDF5_SUFFIX}.dylib
    -DHDF5_hdf5_cpp_LIBRARY_${upper}=${HDF5_INSTALL}/lib/libhdf5_cpp${HDF5_SUFFIX}.dylib
  
  DEPENDS hdf5
  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)

if(ITK_VERSION VERSION_GREATER 4.13.0)
  message(STATUS "Building ITKMontage remote module.")
  set(extProjectName-Addon ITKMontage)
  ExternalProject_Add(${extProjectName-Addon}
    GIT_REPOSITORY https://github.com/InsightSoftwareConsortium/${extProjectName-Addon}.git
    GIT_TAG 18439a81bc3d5666e5b6f4b83eba0a2aa5f39c2c
    SOURCE_DIR "${DREAM3D_SDK}/${extProjectName-Addon}"
    BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName-Addon}/Build"
    INSTALL_DIR "${DREAM3D_SDK}/superbuild/${extProjectName-Addon}/Install"
    INSTALL_COMMAND ""

    CMAKE_ARGS
      -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
      -DCMAKE_BUILD_TYPE:=${CMAKE_BUILD_TYPE}
      -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
      -DCMAKE_CXX_FLAGS=${CXX_FLAGS}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
      -DCMAKE_OSX_SYSROOT=${OSX_SDK}
      -DCMAKE_CXX_STANDARD=11
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
      -DITK_DIR:PATH=${BINARY_DIR}
		  -DBUILD_TESTING=OFF
    DEPENDS ITK
  )
endif()

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

