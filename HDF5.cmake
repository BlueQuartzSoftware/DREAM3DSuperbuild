
message( "External project - HDF5" )


set(HDF5_VERSION "1.8.13")
set(HDF5_PREFIX "${CMAKE_BINARY_DIR}/HDF5")

set(HDF5_BINARY_DIR "${HDF5_PREFIX}/hdf5-${HDF5_VERSION}-Build")

set(HDF5_SOURCE_DIR "${HDF5_PREFIX}/hdf5-${HDF5_VERSION}")
set(HDF5_STAMP_DIR "${HDF5_PREFIX}/Stamp")
set(HDF5_TEMP_DIR "${HDF5_PREFIX}/Tmp")
set(HDF5_INSTALL_DIR "${DREAM3D_SDK_INSTALL}/hdf5-${HDF5_VERSION}")

set(HDF5_URL "http://www.hdfgroup.org/ftp/HDF5/prev-releases/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.gz")

set_property(DIRECTORY PROPERTY EP_BASE ${HDF5_PREFIX})


# Check to see if we have already downloaded the archive
if(EXISTS ${HDF5_PREFIX}/Download/${PROJ_NAME}/hdf5-${HDF5_VERSION}.tar.gz)
	set(HDF5_URL ${HDF5_PREFIX}/Download/${PROJ_NAME}/hdf5-${HDF5_VERSION}.tar.gz)
endif()

# We need this for the next command
include(ExternalProject)

ExternalProject_Add( hdf5
	#--Download step--------------
	#   GIT_REPOSITORY ""
	#   GIT_TAG ""
	URL ${HDF5_URL}
	URL_MD5
	#--Update/Patch step----------
	UPDATE_COMMAND ""
  	PATCH_COMMAND ""
	#--Configure step-------------
	SOURCE_DIR "${HDF5_SOURCE_DIR}"
	CMAKE_ARGS
		-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
		-DBUILD_TESTING:BOOL=OFF
		-DBUILD_EXAMPLES:BOOL=OFF
		-DHDF5_BUILD_CPP_LIB=ON
		-DHDF5_BUILD_HL_LIB=ON
		-DHDF5_BUILD_TOOLS=ON
		-DHDF5_BUILD_WITH_INSTALL_NAME=ON
		-DHDF5_ENABLE_DEPRECATED_SYMBOLS=OFF
		-DCMAKE_INSTALL_PREFIX=${DREAM3D_SDK}/hdf5-${HDF5_VERSION}
		-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
	#--Build step-----------------
	BINARY_DIR "${HDF5_BINARY_DIR}"
	#--Install step-----------------
	INSTALL_DIR "${HDF5_INSTALL_DIR}"
	#INSTALL_COMMAND ""
	DEPENDS ${HDF5_DEPENDENCIES}
)

#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${DREAM3D_SDK_FILE} "set(HDF5_INSTALL_DIR \"${HDF5_INSTALL_DIR}\")\n")



