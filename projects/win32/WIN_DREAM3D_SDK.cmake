if(NOT DEFINED DREAM3D_FIRST_CONFIGURE)
  message(STATUS "*******************************************************")
  message(STATUS "* DREAM.3D First Configuration Run                    *")
  message(STATUS "* DREAM3D_SDK Loading from ${CMAKE_CURRENT_LIST_DIR}  *")
  message(STATUS "*******************************************************")
endif()

#--------------------------------------------------------------------------------------------------
# These settings are specific to DREAM3D. DREAM3D needs these variables to
# configure properly.
set(BUILD_TYPE ${CMAKE_BUILD_TYPE})
if("${BUILD_TYPE}" STREQUAL "")
    set(BUILD_TYPE "Release" CACHE STRING "" FORCE)
endif()
set(SIMPL_DISABLE_MSVC_WARNINGS "ON")
