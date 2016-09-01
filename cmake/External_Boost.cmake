set(extProjectName "boost")
message(STATUS "External Project: ${extProjectName}" )
set(boost_version "1.60.0")
set(boost_version_u "1_60_0")
set(boost_url "http://pilotfiber.dl.sourceforge.net/project/boost/boost/${boost_version}/boost_${boost_version_u}.tar.gz")
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

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(am 64)
else()
  set(am 32)
endif()

set(boost_with_args
  # --with-date_time
  # --with-filesystem
  # --with-iostreams
  # --with-program_options
  # --with-system
  # --with-thread
  # --with-chrono
)

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
  endif()

  list(APPEND boost_with_args "--layout=system" "toolset=${_toolset} --build-dir=x${am}")

  set(boost_cmds
    CONFIGURE_COMMAND bootstrap.bat
    BUILD_COMMAND b2 -j${CoreCount} --prefix=${boost_INSTALL} address-model=${am} ${boost_with_args} variant=debug,release link=static threading=multi
    INSTALL_COMMAND b2 -j${CoreCount} --prefix=${boost_INSTALL} address-model=${am} ${boost_with_args} variant=debug,release link=static threading=multi install
  )
else()
  set(boost_cmds
    CONFIGURE_COMMAND ./bootstrap.sh
    BUILD_COMMAND ./b2 -j${CoreCount} --prefix=${boost_INSTALL} address-model=${am} ${boost_with_args} variant=release link=shared threading=multi runtime-link=shared 
    INSTALL_COMMAND ./b2 -j${CoreCount} --prefix=${boost_INSTALL} address-model=${am} ${boost_with_args} variant=release link=shared threading=multi runtime-link=shared install
  )
endif()

ExternalProject_Add(${extProjectName}
  DOWNLOAD_NAME ${extProjectName}-${boost_version}.tar.gz
  URL ${boost_url}

  TMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/tmp"
  STAMP_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Stamp"
  DOWNLOAD_DIR ${DREAM3D_SDK}/superbuild/${extProjectName}
  SOURCE_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Source/${extProjectName}"
  #BINARY_DIR "${boost_BINARY_DIR}"
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

