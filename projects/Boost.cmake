set(extProjectName "boost")
message(STATUS "External Project: ${extProjectName}" )
set(boost_version "1.66.0")
set(boost_version_u "1_66_0")
set(boost_url "http://dream3d.bluequartz.net/binaries/SDK/Sources/Boost/boost_${boost_version_u}.tar.gz")

set(boost_INSTALL "${DREAM3D_SDK}/${extProjectName}-${boost_version}")
set(boost_BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build")

# Build boost via its bootstrap script. The build tree cannot contain a space.
# This boost b2 build system yields errors with spaces in the name of the
# build dir.
#
if("${CMAKE_CURRENT_BINARY_DIR}" MATCHES " ")
  message(FATAL_ERROR "cannot use boost bootstrap with a space in the name of the build dir")
endif()

if(NOT DEFINED use_bat)
  if(WIN32)
    set(use_bat 1)
  else()
    set(use_bat 0)
  endif()
endif()

#if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(am 64)
#else()
#  set(am 32)
#endif()

set(boost_with_args "")

if(use_bat)

  if(MSVC90)
    set(_toolset "msvc-9.0")
  elseif(MSVC10)
    set(_toolset "msvc-10.0")
  elseif(MSVC11)
    set(_toolset "msvc-11.0")
  elseif(MSVC12)
    set(_toolset "msvc-12.0")
  elseif(MSVC13)
    set(_toolset "msvc-13.0")
  elseif(MSVC14)
    set(_toolset "msvc-14.0")
  elseif(MSVC15)
    set(_toolset "msvc-15.0")
  else()
    set(_toolset "UNKNOWN_TOOLSET")
  endif()

#b2 --build-dir=Build toolset=msvc --prefix=C:/DREAM3D_SDK/boost-1.57.0 --layout=system variant=debug,release link=static threading=multi address-model=64 install

  list(APPEND boost_with_args "--build-dir=x${am}" 
    "toolset=${_toolset}" 
    "--prefix=${boost_INSTALL}" 
    "--layout=versioned"  
    "variant=debug,release" 
    "link=static,shared" 
    "threading=multi" 
    "address-model=${am}"
    )

  set(bootstrap_cmd "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}/bootstrap.bat")
  set(b2_cmd "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}/b2.exe")

  set(boost_cmds
    CONFIGURE_COMMAND ${bootstrap_cmd}
    BUILD_COMMAND ${b2_cmd} -j${CoreCount} ${boost_with_args} 
    INSTALL_COMMAND ${b2_cmd} -j${CoreCount} ${boost_with_args} install
  )
else()

  list(APPEND boost_with_args "--build-dir=x${am}" 
    #"toolset=${_toolset}" 
    "--prefix=${boost_INSTALL}" 
    "--layout=system"  
    "--without-python"
    "variant=release" 
    "link=shared" 
    "threading=multi"
    "runtime-link=shared"
    "address-model=${am}"
    )

  set(bootstrap_cmd "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}/bootstrap.sh")
  set(b2_cmd "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}/b2")

  set(boost_cmds
    CONFIGURE_COMMAND ${bootstrap_cmd}
    BUILD_COMMAND ${b2_cmd} -j${CoreCount} ${boost_with_args}    
    INSTALL_COMMAND ${b2_cmd} -j${CoreCount} ${boost_with_args} install
  )


  if(APPLE)
    set(output_file "${DREAM3D_SDK}/superbuild/${extProjectName}/Download/OSX_UpdateRPaths.sh")
    set(boost_fix_rpaths_FILE "apple/OSX_UpdateRPaths.sh.in")
    get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)
    set(INSTALL_PREFIX "${boost_INSTALL}")
    configure_file(
      "${_self_dir}/${boost_fix_rpaths_FILE}"
      "${output_file}"
      @ONLY
    )
    # We do this because CMake can not figure out how to let us do an ExternalProject-Add-Step
    # and actually have that command run AFTER the install command. So we write a shell script,
    # configure it with the proper path, and then execute that script after the install. Stupid.
    set(boost_cmds
      CONFIGURE_COMMAND ${bootstrap_cmd}
      BUILD_COMMAND ${b2_cmd} -j${CoreCount} ${boost_with_args}    
      INSTALL_COMMAND ${b2_cmd} -j${CoreCount} ${boost_with_args} install COMMAND ${output_file}
    )

  endif()


endif()

ExternalProject_Add(${extProjectName}
  DOWNLOAD_NAME ${extProjectName}-${boost_version}.tar.gz
  URL ${boost_url}

  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}"

  INSTALL_DIR "${boost_INSTALL}"
  BUILD_IN_SOURCE 1

  ${boost_cmds}

  LOG_DOWNLOAD 1
  LOG_UPDATE 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_TEST 1
  LOG_INSTALL 1
)



ExternalProject_Get_Property(boost install_dir)
set(BOOST_ROOT "${install_dir}" CACHE INTERNAL "")


#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# Boost Library Location\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(BOOST_ROOT \"\${DREAM3D_SDK_ROOT}/${extProjectName}-${boost_version}\" CACHE PATH \"\")\n")

