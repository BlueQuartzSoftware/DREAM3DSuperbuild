#--------------------------------------------------------------------------------------------------
# Are we using Python (ON by default)
#--------------------------------------------------------------------------------------------------
option(USE_PYTHON "Use Python" ON)
if(NOT USE_PYTHON)
  message(FATAL_ERROR "Python is used to build the documentation and optionally to create Python bindings for the various DREAM.3D Libraries.\
  If you do not check for a valid Python distribution then configuring DREAM.3D may not work.")
  return()
endif()

set(PYTHON_REQ_VERSION 3.6)
message(STATUS "Using: Python ${PYTHON_REQ_VERSION}: -DUSE_PYTHON=${USE_PYTHON}" )

find_package(Python ${PYTHON_REQ_VERSION} COMPONENTS Interpreter)

if(Python_Interpreter_FOUND)
  message(STATUS "Found: Python ${Python_VERSION}: \"${Python_EXECUTABLE}\"")
  execute_process(COMMAND ${Python_EXECUTABLE} "-m" "mkdocs" "--version"
    RESULT_VARIABLE _mkdocs_version_result
    OUTPUT_VARIABLE _mkdocs_version_output
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  if(${_mkdocs_version_result} STREQUAL "0")
    string(REGEX MATCH "[0-9]+.[0-9]+(.[0-9]+)?" MKDOCS_VERSION ${_mkdocs_version_output})
  endif()
  
  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(mkdocs
    REQUIRED_VARS MKDOCS_VERSION
    VERSION_VAR MKDOCS_VERSION
  )

  set(MKDOCS_COMMAND ${Python_EXECUTABLE} "-m" "mkdocs")
else()
  message(STATUS "Python not found")
endif()

if(NOT MKDOCS_FOUND)
  message("   mkdocs is missing or not defined and will impact your ability to generate the documentation.\n\
   When building DREAM3D, set '-DSIMPL_USE_MKDOCS=OFF' and '-DSIMPL_USE_DISCOUNT=ON'\n\
   or disable the generation of the documentation by setting '-DSIMPLView_BUILD_DOCUMENTATION=OFF'.\n\n\
   One would typically install mkdocs using 'pip install mkdocs-material'\n\
   You may also need to do 'pip install msgpack'")
else()
  message(STATUS "Found: mkdocs ${MKDOCS_VERSION}")
endif()

file(APPEND ${DREAM3D_SDK_FILE} "\n")
file(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
file(APPEND ${DREAM3D_SDK_FILE} "# Python Version ${Python_VERSION}\n")
file(APPEND ${DREAM3D_SDK_FILE} "# Python is needed if you want to build the documentation using Mkdocs which will produce\n")
file(APPEND ${DREAM3D_SDK_FILE} "# nice looking documentation. If there is no python environment found then DREAM3D will \n")
file(APPEND ${DREAM3D_SDK_FILE} "# use the 'discount' library to generate the help files.\n")
if(Python_Interpreter_FOUND AND MKDOCS_FOUND)
  file(APPEND ${DREAM3D_SDK_FILE} "# A suitable Python and mkdocs were found.\n")
  file(APPEND ${DREAM3D_SDK_FILE} "if(NOT DEFINED DREAM3D_FIRST_CONFIGURE)\n")
  file(APPEND ${DREAM3D_SDK_FILE} "  set(PYTHON_EXECUTABLE \"${Python_EXECUTABLE}\" CACHE FILEPATH \"\")\n")
  file(APPEND ${DREAM3D_SDK_FILE} "  set(MKDOCS_PYTHON_EXECUTABLE \"${Python_EXECUTABLE}\" CACHE FILEPATH \"\")\n")
  file(APPEND ${DREAM3D_SDK_FILE} "  set(MKDOCS_EXECUTABLE \"${MKDOCS_COMMAND}\" CACHE STRING \"\")\n")
  file(APPEND ${DREAM3D_SDK_FILE} "  # set(SIMPL_USE_DISCOUNT OFF)\n")
  file(APPEND ${DREAM3D_SDK_FILE} "  # set(SIMPL_USE_MKDOCS ON)\n")
  file(APPEND ${DREAM3D_SDK_FILE} "endif()\n")
else()
  file(APPEND ${DREAM3D_SDK_FILE} "# A suitable Python and mkdocs were NOT found. Documentation will be built with discount.\n")
  file(APPEND ${DREAM3D_SDK_FILE} "if(NOT DEFINED DREAM3D_FIRST_CONFIGURE)\n")
  file(APPEND ${DREAM3D_SDK_FILE} "  # set(PYTHON_EXECUTABLE \"${Python_EXECUTABLE}\" CACHE FILEPATH \"\")\n")
  file(APPEND ${DREAM3D_SDK_FILE} "  # set(MKDOCS_PYTHON_EXECUTABLE \"${Python_EXECUTABLE}\" CACHE FILEPATH \"\")\n")
  file(APPEND ${DREAM3D_SDK_FILE} "  # set(MKDOCS_EXECUTABLE \"${MKDOCS_COMMAND}\" CACHE STRING \"\")\n")
  file(APPEND ${DREAM3D_SDK_FILE} "  set(SIMPL_USE_DISCOUNT ON)\n")
  file(APPEND ${DREAM3D_SDK_FILE} "  set(SIMPL_USE_MKDOCS OFF)\n")
  file(APPEND ${DREAM3D_SDK_FILE} "endif()\n")
endif()
