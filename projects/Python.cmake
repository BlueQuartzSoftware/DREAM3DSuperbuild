#--------------------------------------------------------------------------------------------------
# Are we using Python (ON by default)
#--------------------------------------------------------------------------------------------------
OPTION(USE_PYTHON "Use Python" ON)
if("${USE_PYTHON}" STREQUAL "OFF")
  message(FATAL_ERROR "Python is used to build the documentation and optionally to create Python bindings for the various DREAM.3D Libraries.\
  If you do not check for a valid Python distribution then configuring DREAM.3D may not work.")
  return()
endif()

set(extProjectName "Python")
set(python_VERSION 3.5)
message(STATUS "Using: ${extProjectName} ${python_VERSION}: -DUSE_PYTHON=${USE_PYTHON}" )

find_package(PythonInterp REQUIRED ${python_VERSION})
execute_process(
              COMMAND
                ${PYTHON_EXECUTABLE} "-c" "print('Hello, world!')"
              RESULT_VARIABLE _status
              OUTPUT_VARIABLE _hello_world
#             ERROR_QUIET
              OUTPUT_STRIP_TRAILING_WHITESPACE
              )

if(NOT PYTHONINTERP_FOUND) 
  message(STATUS "Python NOT Found. Do you need to 'conda activate [virtual environment]'?")
endif()

# -----------------------------------------------------------------------------
# This is valid for an Anaconda installation on Windows. Not sure if this will
# work for other Python distributions
if(WIN32)
  get_filename_component(PYTHON_DIR  ${PYTHON_EXECUTABLE} DIRECTORY)
  set(_mkdocs_location "${PYTHON_DIR}/Scripts/mkdocs.exe")
  execute_process(
              COMMAND
              ${_mkdocs_location} "--version"
              RESULT_VARIABLE _mkdocs_status
              OUTPUT_VARIABLE _output
#             ERROR_QUIET
              OUTPUT_STRIP_TRAILING_WHITESPACE
              )
  # message(STATUS "_status: ${_status}")
  # message(STATUS "_output: ${_output}")
else()            
  # This should work for Anaconda on macOS or Linux
  get_filename_component(PYTHON_DIR  ${PYTHON_EXECUTABLE} DIRECTORY)
  set(_mkdocs_location "${PYTHON_DIR}/mkdocs")
  execute_process(
              COMMAND
              ${_mkdocs_location} "--version"
              RESULT_VARIABLE _mkdocs_status
              OUTPUT_VARIABLE _output
#             ERROR_QUIET
              OUTPUT_STRIP_TRAILING_WHITESPACE
              )
  # message(STATUS "_status: ${_status}")
  # message(STATUS "_output: ${_output}")
endif()

if(NOT _mkdocs_status)
  set(Mkdocs ${_mkdocs_location} CACHE STRING "Location of mkdocs")
endif()

execute_process(
  COMMAND
    ${PYTHON_EXECUTABLE} "-c" "import mkdocs;\nprint(mkdocs.__version__)"
  OUTPUT_VARIABLE _mkdocs_version
#  ERROR_QUIET
  OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Mkdocs
  FOUND_VAR Mkdocs_FOUND
  REQUIRED_VARS Mkdocs
  VERSION_VAR _mkdocs_version
)

if(NOT Mkdocs_FOUND)
  message("Mkdocs is missing or not defined and will impact your ability to generate the documentation.\n\
  When building DREAM3D, set SIMPL_USE_MKDOCS = OFF and SIMPL_USE_DISCOUNT = ON\n\
  or disable the generation of the documentation by setting SIMPLView_BUILD_DOCUMENTATION=OFF.\n\
  One would typically install mkdocs using 'pip install mkdocs-material'\n\
  You may also need to do 'pip install msgpack'")
endif()



FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# Python Version ${PYTHON_VERSION_STRING}\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# Python is needed if you want to build the documentation using Mkdocs which will produce\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# nice looking documentation. If there is no python environment found then DREAM3D will \n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# use the 'discount' library to generate the help files.\n")
if(PYTHONINTERP_FOUND AND Mkdocs_FOUND)
  file(TO_CMAKE_PATH "${_mkdocs_location}" _mkdocs_location)
  FILE(APPEND ${DREAM3D_SDK_FILE} "# A suitable Python and mkdocs were found.\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "if(NOT DEFINED DREAM3D_FIRST_CONFIGURE)\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "  set(PYTHON_EXECUTABLE \"${PYTHON_EXECUTABLE}\" CACHE FILEPATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "  set(MKDOCS_PYTHON_EXECUTABLE \"${PYTHON_EXECUTABLE}\" CACHE FILEPATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "  set(MKDOCS_EXECUTABLE \"${_mkdocs_location}\" CACHE FILEPATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "  # set(SIMPL_USE_DISCOUNT OFF)\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "  # set(SIMPL_USE_MKDOCS ON)\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "endif()\n")
else()
  FILE(APPEND ${DREAM3D_SDK_FILE} "# A suitable Python and mkdocs were NOT found. Documentation will be built with discount.\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "if(NOT DEFINED DREAM3D_FIRST_CONFIGURE)\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "  # set(PYTHON_EXECUTABLE \"${PYTHON_EXECUTABLE}\" CACHE FILEPATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "  # set(MKDOCS_PYTHON_EXECUTABLE \"${PYTHON_EXECUTABLE}\" CACHE FILEPATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "  # set(MKDOCS_EXECUTABLE \"${_mkdocs_location}\" CACHE FILEPATH \"\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "  set(SIMPL_USE_DISCOUNT ON)\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "  set(SIMPL_USE_MKDOCS OFF)\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "endif()\n")
endif()
