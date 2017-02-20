set(extProjectName "ITK")
message(STATUS "External Project: ${extProjectName}" )

set(ITK_VERSION "4.11.0")
#set(ITK_URL "http://pilotfiber.dl.sourceforge.net/project/itk/itk/4.9/InsightToolkit-${ITK_VERSION}.tar.gz")
set(ITK_URL "http://dream3d.bluequartz.net/binaries/SDK/Sources/ITK/InsightToolkit-${ITK_VERSION}.tar.gz")



#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
if(0)

  if(MSVC90)
    message(FATAL_ERROR "Visual Studio Version 9 is NOT supported.")
  endif(MSVC90)
  if(MSVC10)
    message(FATAL_ERROR "Visual Studio Version 10 is NOT supported.")
  endif(MSVC10)
  if(MSVC11)
    message(FATAL_ERROR "Visual Studio Version 11 is NOT supported.")
  endif(MSVC11)
  if(MSVC12)
    set(ITK_VS_VERSION "12.0")
    set(ITK_CMAKE_GENERATOR "Visual Studio 12 2013 Win64")
  endif(MSVC12)
  if(MSVC14)
    set(ITK_CMAKE_GENERATOR "Visual Studio 14 2015 Win64")
    set(ITK_VS_VERSION "14.0")
  endif()

  get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

  configure_file(
    "${_self_dir}/ITK/Build_ITK.bat.in"
    "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/Build_ITK.bat"
    @ONLY
    )
  configure_file(
    "${_self_dir}/ITK/Build_ITK.cmake.in"
    "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/Build_ITK.cmake"
    @ONLY
    )


  # execute_process(COMMAND "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/Build_ITK.bat"
  #                 OUTPUT_FILE "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/Build_ITK.log"
  #                 ERROR_FILE "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/Build_ITK-err.log"
  #                 ERROR_VARIABLE installer_error
  #                 WORKING_DIRECTORY "${DREAM3D_SDK}/superbuild/${extProjectName}/Build" )

  #-------------------------------------------------------------------------------
  #- This copies all the Prebuilt Pipeline files into the Build directory so the help
  #- works from the Build Tree
  add_custom_target(BUILD_Itk ALL
              COMMAND "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/Build_ITK.bat"
              COMMENT "Building ITK ${ITK_VERSION}.")
  set_target_properties(BUILD_Itk PROPERTIES DEPENDS hdf5)


else()




set(SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}")
set(ITK_INSTALL_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/${extProjectName}-${ITK_VERSION}-${CMAKE_BUILD_TYPE}")
if(WIN32)
  set(CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
  set(HDF5_CMAKE_MODULE_DIR "${HDF5_INSTALL}/cmake")
elseif(APPLE)
  set(ITK_INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}/${extProjectName}-${ITK_VERSION}")
  set(CXX_FLAGS "-stdlib=libc++ -std=c++11")
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
  BINARY_DIR "${DREAM3D_SDK}/ITK-${ITK_VERSION}"
  INSTALL_DIR "${ITK_INSTALL_DIR}"
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
		-DModule_SCIFIO=ON
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

endif()

#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# ITK Library Location\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(ITK_DIR \"\${DREAM3D_SDK_ROOT}/ITK-${ITK_VERSION}-\${CMAKE_BUILD_TYPE}\" CACHE PATH \"\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(DREAM3D_USE_ITK \"ON\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${ITK_DIR})\n")

