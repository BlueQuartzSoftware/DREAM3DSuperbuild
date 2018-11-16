
set(extProjectName "Python")
message(STATUS "External Project: ${extProjectName}" )

find_package(PythonInterp REQUIRED 3.5)
execute_process(
              COMMAND
                ${PYTHON_EXECUTABLE} "-c" "print('Hello, world!')"
              RESULT_VARIABLE _status
              OUTPUT_VARIABLE _hello_world
#             ERROR_QUIET
              OUTPUT_STRIP_TRAILING_WHITESPACE
              )

if(PYTHONINTERP_FOUND) 
  message(STATUS "Python (${PYTHON_VERSION_STRING}) Found: ${PYTHON_EXECUTABLE}")
else()
  message(STATUS "Python NOT Found.")
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
  execute_process(
    COMMAND
      ${PYTHON_EXECUTABLE} "-c" "import re, sys;\nimport mkdocs\nprint(re.compile('/__init__.py.*').sub('',mkdocs.__file__))"
    RESULT_VARIABLE _mkdocs_status
    OUTPUT_VARIABLE _mkdocs_location
    #ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )

  # message(STATUS "_mkdocs_status: ${_mkdocs_status}")
  # message(STATUS "_mkdocs_location: ${_mkdocs_location}")
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
  message(FATAL_ERROR "The python module 'mkdocs' is needed.\n\
  One would typically install it using 'pip install mkdocs-material'\n\
  You may also need to do 'pip install msgpack'")
else()
  message(STATUS "Mkdocs (${_mkdocs_version}) Found: ${_mkdocs_location}")
endif()



FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# Python Version ${PYTHON_VERSION_STRING}\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# Python is needed if you want to build the documentation using Mkdocs which will produce\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# nice looking documentation. If there is no python environment found then DREAM3D will \n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# use the 'discount' library to generate the help files.\n")
if(PYTHONINTERP_FOUND AND Mkdocs_FOUND)
  file(TO_CMAKE_PATH ${_mkdocs_location} _mkdocs_location)
  FILE(APPEND ${DREAM3D_SDK_FILE} "# A suitable Python and mkdocs were found.\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(PYTHON_EXECUTABLE \"${PYTHON_EXECUTABLE}\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(MKDOCS_EXECUTABLE \"${_mkdocs_location}\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(SIMPL_USE_DISCOUNT OFF)\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(SIMPL_USE_MKDOCS ON)\n")
else()
  FILE(APPEND ${DREAM3D_SDK_FILE} "# A suitable Python and mkdocs were NOT found. Disabling the building of docs using mkdocs.\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "#set(PYTHON_EXECUTABLE \"${PYTHON_EXECUTABLE}\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "#set(MKDOCS_EXECUTABLE \"${_mkdocs_location}\")\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(SIMPL_USE_DISCOUNT ON)\n")
  FILE(APPEND ${DREAM3D_SDK_FILE} "set(SIMPL_USE_MKDOCS OFF)\n")
endif()
