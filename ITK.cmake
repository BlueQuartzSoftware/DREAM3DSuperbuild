

set(ITK_PREFIX "${DREAM3D_SDK_INSTALL}/ItkTemp")
#-- ITK is different in that one can not really install a redistributable Release/Debug build of ITK_STAMP_DIR
# so we need to actually build BOTH Debug and Release directly into where we want ITK installed.
set(ITK_BINARY_DIR "${DREAM3D_SDK_INSTALL}/ITK-4.5.1")

set(ITK_SOURCE_DIR "${ITK_PREFIX}/InsightToolkit-4.5.1")
set(ITK_STAMP_DIR "${ITK_PREFIX}/Stamp")
set(ITK_TEMP_DIR "${ITK_PREFIX}/Tmp")
set(ITK_INSTALL_DIR "${DREAM3D_SDK_INSTALL}/ITK-4.5.1")
set(ITK_URL "http://dream3d.bluequartz.net/binaries/InsightToolkit-4.5.1.zip")
if(EXISTS "${DREAM3D_SDK}/InsightToolkit-4.5.1.zip")
	set(ITK_URL "file://${DREAM3D_SDK}/InsightToolkit-4.5.1.zip")
endif()

set_property(DIRECTORY PROPERTY EP_BASE ${ITK_PREFIX})

if(0)
if( NOT ${DREAM3D_SDK} STREQUAL "" )
	set(ITK_URL "http://dream3d.bluequartz.net/binaries/InsightToolkit-4.5.1.zip")
	if(EXISTS "${DREAM3D_SDK}/InsightToolkit-4.5.1.zip")
		set(ITK_URL "file://${DREAM3D_SDK}/InsightToolkit-4.5.1.zip")
	endif()
	set(ITK_PREFIX ${DREAM3D_SDK}/ITK)
	set(ITK_BINARY_DIR "${DREAM3D_SDK}/ITK-4.5.1")
	set(ITK_SOURCE_DIR "${DREAM3D_SDK}/InsightToolkit-4.5.1")
endif()
endif()


# We need this for the next command
include(ExternalProject)
# ITK has not been built yet, so (possibly) download and build it as an external project
ExternalProject_Add( itk
	PREFIX "${ITK_PREFIX}"
#	TEMP_DIR "${ITK_TEMP_DIR}"
#	STAMP_DIR "${ITK_STAMP_DIR}"
	#--Download step--------------
	#   GIT_REPOSITORY "git://itk.org/ITK.git"
	#   GIT_TAG "421d314ff85ad542ad5c0f3d3c115fa7427b1c64"
	URL ${ITK_URL}
	URL_MD5 a0989ac0c87f9979b05f7a2f50243506
	#--Update/Patch step----------
	UPDATE_COMMAND ""
	#--Configure step-------------
	SOURCE_DIR "${ITK_SOURCE_DIR}"
	CMAKE_ARGS
	  -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:STRING=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
	  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
	  -DBUILD_TESTING:BOOL=OFF
	  -DBUILD_EXAMPLES:BOOL=OFF
	  -DITK_LEGACY_REMOVE:BOOL=ON
	  -DKWSYS_USE_MD5:BOOL=ON
	  -DModule_ITKReview:BOOL=ON
	  -DITK_BUILD_DEFAULT_MODULES=OFF
	  -DITKGroup_Core=ON
	  -DITKGroup_Filtering=ON
	  -DITKGroup_Registration=ON
	  -DITKGroup_Segmentation=ON
	  -DITK_USE_SYSTEM_HDF5=ON
	#--Build step-----------------
	BINARY_DIR "${ITK_BINARY_DIR}"

	#--Install step-----------------
	INSTALL_DIR "${ITK_INSTALL_DIR}"
	INSTALL_COMMAND ""
	DEPENDS ${ITK_DEPENDENCIES}
)


#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${DREAM3D_SDK_FILE} "set(ITK_DIR \"${ITK_INSTALL_DIR}\")\n")

