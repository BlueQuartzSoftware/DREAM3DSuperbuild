set(extProjectName "AWS")
message(STATUS "External Project: ${extProjectName}" )

set(AWS_URL "https://github.com/aws/aws-sdk-cpp/archive/master.zip")
set(SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}_src")

if(WIN32)
  set(AWS_CXX_FLAGS "/DWIN32 /D_WINDOWS /W3 /GR /EHsc /MP")
elseif(APPLE)
  set(AWS_CXX_FLAGS "-stdlib=libc++ -std=c++11")
else()
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(AWS_CXX_FLAGS "-stdlib=libc++ -std=c++11")
  else()
    set(AWS_CXX_FLAGS "-std=c++11")
  endif()
endif()

get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

set_property(DIRECTORY PROPERTY EP_BASE ${DREAM3D_SDK}/superbuild)

set(AWS_COMPONENTS "core,transfer") # Use commas as separators instead of semicolons

ExternalProject_Add(${extProjectName}-${CMAKE_BUILD_TYPE}
  DOWNLOAD_NAME ${extProjectName}.zip
  URL ${AWS_URL}
  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp/${CMAKE_BUILD_TYPE}"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp/${CMAKE_BUILD_TYPE}"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}
  SOURCE_DIR ${SOURCE_DIR}
  BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/${CMAKE_BUILD_TYPE}"
  INSTALL_DIR "${DREAM3D_SDK}/${extProjectName}-${CMAKE_BUILD_TYPE}"
  
  # This is needed because the BUILD_ONLY CMake variable needs to be passed the AWS_COMPONENTS list with a different
  # separator other than the default semicolon because otherwise the ExternalProject_Add function misinterprets the delimited list as 
  # multiple arguments instead of one argument
  LIST_SEPARATOR ,
  
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DBUILD_ONLY=${AWS_COMPONENTS}

    -DCMAKE_CXX_FLAGS=${AWS_CXX_FLAGS}
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT=${OSX_SDK}
    -DCMAKE_CXX_STANDARD=11 
    -DCMAKE_CXX_STANDARD_REQUIRED=ON
    -Wno-dev

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)



#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# AWS\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(AWSSDK_DIR \"\${DREAM3D_SDK_ROOT}/AWS-\${BUILD_TYPE}/lib/cmake/AWSSDK\" CACHE PATH \"\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(aws-cpp-sdk-core_DIR \"\${DREAM3D_SDK_ROOT}/AWS-\${BUILD_TYPE}/lib/cmake/aws-cpp-sdk-core\" CACHE PATH \"\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(aws-cpp-sdk-transfer_DIR \"\${DREAM3D_SDK_ROOT}/AWS-\${BUILD_TYPE}/lib/cmake/aws-cpp-sdk-transfer\" CACHE PATH \"\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(aws-cpp-sdk-s3_DIR \"\${DREAM3D_SDK_ROOT}/AWS-\${BUILD_TYPE}/lib/cmake/aws-cpp-sdk-s3\" CACHE PATH \"\")\n")


