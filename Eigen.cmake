
message( "External project - Eigen" )


set(EIGEN_VERSION "3.2.1")
set(EIGEN_PREFIX "${CMAKE_BINARY_DIR}/Eigen")

set(EIGEN_BINARY_DIR "${EIGEN_PREFIX}/Eigen-${EIGEN_VERSION}-Build")

set(EIGEN_SOURCE_DIR "${EIGEN_PREFIX}/Eigen-${EIGEN_VERSION}")
set(EIGEN_STAMP_DIR "${EIGEN_PREFIX}/Stamp")
set(EIGEN_TEMP_DIR "${EIGEN_PREFIX}/Tmp")
set(EIGEN_INSTALL_DIR "${DREAM3D_SDK_INSTALL}/Eigen-${EIGEN_VERSION}")

set(EIGEN_URL "https://bitbucket.org/eigen/eigen/get/${EIGEN_VERSION}.tar.gz")

set_property(DIRECTORY PROPERTY EP_BASE ${EIGEN_PREFIX})

#-- THIS IS NEEDED other wise the configure step will fail
FILE(WRITE ${EIGEN_BINARY_DIR}/DartConfiguration.tcl "")

# Check to see if we have already downloaded the archive
if(EXISTS ${EIGEN_PREFIX}/Download/${PROJ_NAME}/Eigen-${EIGEN_VERSION}.tar.gz)
	set(EIGEN_URL ${EIGEN_PREFIX}/Download/${PROJ_NAME}/Eigen-${EIGEN_VERSION}.tar.gz)
endif()



ExternalProject_Add( Eigen
	#--Download step--------------
	#   GIT_REPOSITORY ""
	#   GIT_TAG ""
	URL ${EIGEN_URL}
	URL_MD5
	#--Update/Patch step----------
	UPDATE_COMMAND ""
  	PATCH_COMMAND ""
	#--Configure step-------------
	SOURCE_DIR "${EIGEN_SOURCE_DIR}"
	CMAKE_ARGS
		-DBUILD_SHARED_LIBS:BOOL=OFF
		-DBUILD_TESTING:BOOL=OFF
		-DBUILD_EXAMPLES:BOOL=OFF
		-DCMAKE_INSTALL_PREFIX=${DREAM3D_SDK}/Eigen-${EIGEN_VERSION}
		-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
	#--Build step-----------------
	BINARY_DIR "${EIGEN_BINARY_DIR}"
	#--Install step-----------------
	INSTALL_DIR "${EIGEN_INSTALL_DIR}"
	#INSTALL_COMMAND ""
	DEPENDS ${EIGEN_DEPENDENCIES}
)

#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${DREAM3D_SDK_FILE} "set(EIGEN_INSTALL_DIR \"${EIGEN_INSTALL_DIR}\")\n")


