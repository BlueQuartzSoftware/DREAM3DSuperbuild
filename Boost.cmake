#---------------------------------------------------------------------------
# Get and build boost

message( "External project - Boost" )

set(BOOST_VERSION "1.56.0")
set(BOOST_PREFIX "${CMAKE_BINARY_DIR}/Boost")

set(BOOST_BINARY_DIR "${BOOST_PREFIX}/boost-${BOOST_VERSION}")

set(BOOST_SOURCE_DIR "${BOOST_PREFIX}/boost-${BOOST_VERSION}")
set(BOOST_STAMP_DIR "${BOOST_PREFIX}/Stamp")
set(BOOST_TEMP_DIR "${BOOST_PREFIX}/Tmp")
set(BOOST_INSTALL_DIR "${DREAM3D_SDK_INSTALL}/boost-${BOOST_VERSION}")

STRING(REPLACE "." "_" BOOST_DL_VERSION ${BOOST_VERSION}  )

set(BOOST_URL "http://softlayer-dal.dl.sourceforge.net/project/boost/boost/${BOOST_VERSION}/boost_${BOOST_DL_VERSION}.zip")

set_property(DIRECTORY PROPERTY EP_BASE ${BOOST_PREFIX})

# Check to see if we have already downloaded the archive
if(EXISTS "${BOOST_PREFIX}/Download/boost/boost_${BOOST_DL_VERSION}.zip")
  set(BOOST_URL "file://${BOOST_PREFIX}/Download/boost/boost_${BOOST_DL_VERSION}.zip")
endif()


set( Boost_Bootstrap_Command )
if( UNIX )
  set( Boost_Bootstrap_Command ${BOOST_BINARY_DIR}/bootstrap.sh )
  set( Boost_b2_Command ${BOOST_BINARY_DIR}/b2 )
else()
  if( WIN32 )
    set( Boost_Bootstrap_Command ${BOOST_BINARY_DIR}/bootstrap.bat )
    set( Boost_b2_Command ${BOOST_BINARY_DIR}/b2.exe )
  endif()
endif()

message(STATUS "Boost_b2_Command: ${Boost_b2_Command}")

ExternalProject_Add(boost
  #--Download step--------------
  #   GIT_REPOSITORY ""
  #   GIT_TAG ""
  URL ${BOOST_URL}
  URL_MD5
  #--Update/Patch step----------
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  #--Configure step-------------
  SOURCE_DIR "${BOOST_SOURCE_DIR}"
  CONFIGURE_COMMAND ${Boost_Bootstrap_Command}
  #--Build step-----------------
  BINARY_DIR "${BOOST_BINARY_DIR}"  
  BUILD_COMMAND  ${Boost_b2_Command}
    --prefix=${DREAM3D_SDK}/boost-1.56.0
    --build-type=complete
    --build-dir=x64
    --layout=tagged
    architecture=x86
    address-model=64
    threading=multi
    link=shared
    variant=release variant=debug
    -j${PARALLEL_BUILD}
    install
  #--Install step-----------------
  INSTALL_DIR "${BOOST_INSTALL_DIR}"
  INSTALL_COMMAND ""
  DEPENDS ${BOOST_DEPENDENCIES}
)



#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${DREAM3D_SDK_FILE} "set(BOOST_ROOT \"\${DREAM3D_SDK_ROOT}/boost-${BOOST_VERSION}\" CACHE PATH \"\")\n")


    # --without-chrono
    # --without-context
    # --without-coroutine
    # --without-exception
    # --without-filesystem
    # --without-graph
    # --without-graph_parallel
    # --without-iostreams
    # --without-locale
    # --without-log
    # --without-math
    # --without-mpi
    # --without-python
    # --without-program_options
    # --without-regex
    # --without-serialization
    # --without-signals
    # --without-system
    # --without-test
    # --without-thread
    # --without-timer
    # --without-wave
    # --disable-icu

