project(com.ubuntu.calculator)
cmake_minimum_required(VERSION 2.8.9)

find_program(INTLTOOL_MERGE intltool-merge)
if(NOT INTLTOOL_MERGE)
    message(FATAL_ERROR "Could not find intltool-merge, please install the intltool package")
endif()

find_program(INTLTOOL_EXTRACT intltool-extract)
if(NOT INTLTOOL_EXTRACT)
    message(FATAL_ERROR "Could not find intltool-extract, please install the intltool package")
endif()

set(UBUNTU_MANIFEST_PATH "manifest.json.in" CACHE INTERNAL "Tells QtCreator location and name of the manifest file")

find_package(Qt5Core)
find_package(Qt5Qml)
find_package(Qt5Quick)
# Find_package(ubuntu-sdk-libs)

#automatically create moc files
set(CMAKE_AUTOMOC ON)

# option(INSTALL_TESTS "Install the tests on make install" on)
option(CLICK_MODE "Installs to a contained location" on)

include(GNUInstallDirs)

set(APP_NAME                        ubuntu-calculator-app)
set(APP_HARDCODE                    ubuntu-calculator-app)
set(MAIN_QML                        ${APP_HARDCODE}.qml)
set(ICON                            "graphics/${APP_HARDCODE}.png")
set(DESKTOP_FILE                    "${APP_HARDCODE}.desktop")

if(CLICK_MODE)
  set(CMAKE_INSTALL_PREFIX "/")
  set(UBUNTU-CALCULATOR-APP_DIR    "${CMAKE_INSTALL_DATADIR}/qml")

  set(QT_IMPORTS_DIR "${CMAKE_INSTALL_LIBDIR}")
  set(EXEC "qmlscene $@ ${UBUNTU-CALCULATOR-APP_DIR}/${MAIN_QML}")
  set(MODULE_PATH ${QT_IMPORTS_DIR})
  if(NOT BZR_REVNO)
    execute_process(
      COMMAND bzr revno
              OUTPUT_VARIABLE BZR_REVNO
              WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
              OUTPUT_STRIP_TRAILING_WHITESPACE
      )
  endif(NOT BZR_REVNO)
  if(NOT BZR_SOURCE)
    set(BZR_SOURCE lp:${APP_HARDCODE})
    message("-- Setting BZR_SOURCE to ${BZR_SOURCE}")
  endif(NOT BZR_SOURCE)
else(CLICK_MODE)
  set(UBUNTU-CALCULATOR-APP_DIR "${CMAKE_INSTALL_DATADIR}/${APP_HARDCODE}")
  execute_process(
    COMMAND qmake -query QT_INSTALL_QML
            OUTPUT_VARIABLE QT_IMPORTS_DIR
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif(CLICK_MODE)

if(${CLICK_MODE})
  message("-- Configuring manifest.json")

  execute_process(
    COMMAND dpkg-architecture -qDEB_HOST_ARCH
    OUTPUT_VARIABLE CLICK_ARCH
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  configure_file(${UBUNTU_MANIFEST_PATH} ${CMAKE_CURRENT_BINARY_DIR}/manifest.json)
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json DESTINATION ${CMAKE_INSTALL_PREFIX})
  install(FILES "${APP_HARDCODE}.json" DESTINATION ${CMAKE_INSTALL_PREFIX})
else(CLICK_MODE)
  set(EXEC "qmlscene $@ -I ${MODULE_PATH}  ${CMAKE_INSTALL_PREFIX}/${UBUNTU-CALCULATOR-APP_DIR}/${MAIN_QML}")
endif()

#file(GLOB_RECURSE I18N_SRC_FILES
#    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/po
#    *.qml *.js)
#list(APPEND I18N_SRC_FILES ${DESKTOP_FILE})
#list(SORT I18N_SRC_FILES)

configure_file(${DESKTOP_FILE} ${DESKTOP_FILE})

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE}
        DESTINATION ${CMAKE_INSTALL_DATADIR}/applications)

add_subdirectory(app)
#add_subdirectory(po)
