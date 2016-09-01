set(extProjectName "Qt")
message(STATUS "External Project: ${extProjectName}" )
set(qt5_version "5.6.1")
set(qt5_url "http://qt.mirror.constant.com/archive/qt/5.6/${qt5_version}-1/qt-opensource-mac-x64-clang-${qt5_version}-1.dmg")
set(qt5_INSTALL "${DREAM3D_SDK}/${extProjectName}${qt5_version}")
set(qt5_BINARY_DIR "${DREAM3D_SDK}/superbuild/${extProjectName}/Build")

get_filename_component(_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

set(QT_INSTALL_LOCATION "${DREAM3D_SDK}/${extProjectName}${qt5_version}")
set(JSFILE "${DREAM3D_SDK}/superbuild/${extProjectName}/Build/Qt_HeadlessInstall.js")
configure_file(
  "${_self_dir}/Qt_HeadlessInstall.js"
  "${JSFILE}"
  @ONLY
)

if(APPLE)
  set(QT_OSX_BASE_NAME qt-opensource-mac-x64-clang-${qt5_version})
  if(NOT EXISTS "${DREAM3D_SDK}/superbuild/${extProjectName}/qt-opensource-mac-x64-clang-${qt5_version}-1.dmg")
    message(STATUS "===============================================================")
    message(STATUS "   Downloading ${extProjectName}${qt5_version}")
    message(STATUS "   Large Download!! This can take a bit... Please be patient")
    file(DOWNLOAD ${qt5_url} "${DREAM3D_SDK}/superbuild/${extProjectName}/qt-opensource-mac-x64-clang-${qt5_version}-1.dmg" SHOW_PROGRESS)
  endif()

  if(NOT EXISTS "${DREAM3D_SDK}/${extProjectName}${qt5_version}")

    if(NOT EXISTS "/Volumes/${QT_OSX_BASE_NAME}/${QT_OSX_BASE_NAME}.app/Contents/MacOS/${QT_OSX_BASE_NAME}")
      message(STATUS " Mounting the Qt Installer Disk Image... ")
      execute_process(COMMAND hdiutil mount "${DREAM3D_SDK}/superbuild/${extProjectName}/qt-opensource-mac-x64-clang-${qt5_version}-1.dmg"
                      OUTPUT_VARIABLE MOUNT_OUTPUT
                      RESULT_VARIABLE did_run
                      ERROR_VARIABLE mount_error
                      WORKING_DIRECTORY ${qt5_BINARY_DIR} )
    endif()

    message(STATUS " Executing the Qt5 Installer... ")
    execute_process(COMMAND "/Volumes/${QT_OSX_BASE_NAME}/${QT_OSX_BASE_NAME}.app/Contents/MacOS/${QT_OSX_BASE_NAME}" --script ${JSFILE}
                    OUTPUT_VARIABLE INSTALLER_OUTPUT
                    RESULT_VARIABLE did_run
                    ERROR_VARIABLE installer_error
                    WORKING_DIRECTORY ${qt5_BINARY_DIR} )

    if(EXISTS "/Volumes/${QT_OSX_BASE_NAME}")
      message(STATUS " UnMounting the Qt Installer Disk Image... ")
      execute_process(COMMAND hdiutil unmount "/Volumes/${QT_OSX_BASE_NAME}"
                      OUTPUT_VARIABLE MOUNT_OUTPUT
                      RESULT_VARIABLE did_run
                      ERROR_VARIABLE mount_error
                      WORKING_DIRECTORY ${qt5_BINARY_DIR} )    
    endif()
  endif()
  set(QMAKE_EXECUTABLE ${QT_INSTALL_LOCATION}/5.6/clang_64/bin/qmake)
endif()

#-- Append this information to the DREAM3D_SDK CMake file that helps other developers
#-- configure DREAM3D for building
FILE(APPEND ${DREAM3D_SDK_FILE} "\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "#--------------------------------------------------------------------------------------------------\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "# Qt ${qt5_version} Library\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(Qt5_DIR \"\${DREAM3D_SDK_ROOT}/${extProjectName}${qt5_version}/5.6/clang_64/lib/cmake/Qt5\" CACHE PATH \"\")\n")
FILE(APPEND ${DREAM3D_SDK_FILE} "set(CMAKE_MODULE_PATH \${CMAKE_MODULE_PATH} \${Qt5_DIR})\n")


