
message( "External project - Threading Building Blocks" )


set(TBB_VERSION "tbb42_20140601oss")
set(TBB_PREFIX "${CMAKE_BINARY_DIR}/TBB")

set(TBB_BINARY_DIR "${TBB_PREFIX}/TBB-${TBB_VERSION}-Build")

set(TBB_SOURCE_DIR "${TBB_PREFIX}/TBB-${TBB_VERSION}")
set(TBB_STAMP_DIR "${TBB_PREFIX}/Stamp")
set(TBB_TEMP_DIR "${TBB_PREFIX}/Tmp")
set(TBB_INSTALL_DIR "${DREAM3D_SDK_INSTALL}/TBB-${TBB_VERSION}")

if(WIN32)
	set(TBB_URL "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/windows/${TBB_VERSION}_win.zip")
elseif(APPLE)
	set(TBB_URL "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/${TBB_VERSION}_src.tgz")
else()
	set(TBB_URL "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/linux/${TBB_VERSION}_lin.tgz")
endif()

set_property(DIRECTORY PROPERTY EP_BASE ${TBB_PREFIX})



#-- On OS X systems we are going to simply download TBB and copy the .app bundle to the /Applications DIRECTORY
#-- which is where CMake expects to find it.
if(APPLE)
	configure_file(${Dream3DSdkBuild_SOURCE_DIR}/tbb_osx_install.sh.in
				   ${TBB_PREFIX}/Download/Install.sh @ONLY)

	execute_process(COMMAND "${TBB_PREFIX}/Download/Install.sh")

elseif(WIN32)
	message(FATAL_ERROR "Windows Configure/Build needs to be implemented")
	
else()

ExternalProject_Add( TBB
	#--Download step--------------
	#   GIT_REPOSITORY ""
	#   GIT_TAG ""
	URL ${TBB_URL}
	URL_MD5
	#--Update/Patch step----------
	UPDATE_COMMAND ""
  	PATCH_COMMAND ""
	#--Configure step-------------
	SOURCE_DIR "${TBB_SOURCE_DIR}"
	CONFIGURE_COMMAND ""
	#--Build step-----------------
	BINARY_DIR "${TBB_BINARY_DIR}"
	BUILD_COMMAND ""
	#--Install step-----------------
	INSTALL_DIR "${TBB_INSTALL_DIR}"
	INSTALL_COMMAND ""
	DEPENDS ${TBB_DEPENDENCIES}
)

endif()

#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${DREAM3D_SDK_FILE} "set(DREAM3D_USE_MULTITHREADED_ALGOS ON CACHE BOOL \"\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(TBB_INSTALL_DIR \"${TBB_INSTALL_DIR}\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(TBB_ARCH_TYPE \"intel64\" CACHE STRING \"\n")


