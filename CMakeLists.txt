project(com.ubuntu.calculator)
cmake_minimum_required(VERSION 2.8.9)

find_program(INTLTOOL_MERGE intltool-merge)
if(NOT INTLTOOL_MERGE)
  message(FATAL_ERROR "Could not find intltool-merge, please install the intltool package")
endif(NOT INTLTOOL_MERGE)

find_program(INTLTOOL_EXTRACT intltool-extract)
if(NOT INTLTOOL_EXTRACT)
  message(FATAL_ERROR "Could not find intltool-extract, please install the intltool package")
endif(NOT INTLTOOL_EXTRACT)

set(UBUNTU_MANIFEST_PATH "manifest.json.in" CACHE INTERNAL "Tells QtCreator location and name of the manifest file")

find_package(Qt5Core REQUIRED)
find_package(Qt5Qml REQUIRED)
find_package(Qt5Quick REQUIRED)
# Find_package(ubuntu-sdk-libs)

#automatically create moc files
set(CMAKE_AUTOMOC ON)


option(INSTALL_TESTS "Install the tests on make install" on)
option(CLICK_MODE "Installs to a contained location" on)

include(GNUInstallDirs)

set(APP_NAME                        Calculator)
set(APP_HARDCODE                    ubuntu-calculator-app)
set(AUTOPILOT_DIR                   ubuntu_calculator_app)
set(MAIN_QML                        ${APP_HARDCODE}.qml)
set(ICON_FILE                       "${APP_HARDCODE}.png")
set(DESKTOP_FILE                    "${APP_HARDCODE}.desktop")
set(APP_VERSION                     2.3.3)
set(AUTOPILOT_DIR                   ubuntu_calculator_app)

if(CLICK_MODE)
  set(CMAKE_INSTALL_PREFIX "/")
  set(UBUNTU-CALCULATOR-APP_DIR    "${CMAKE_INSTALL_DATADIR}/qml")

  set(QT_IMPORTS_DIR "${CMAKE_INSTALL_LIBDIR}")
  set(EXEC "qmlscene -qt5 $@ ${UBUNTU-CALCULATOR-APP_DIR}/${MAIN_QML}")
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

if(CLICK_MODE)
  message("-- Configuring manifest.json")

  execute_process(
    COMMAND dpkg-architecture -qDEB_HOST_ARCH
            OUTPUT_VARIABLE CLICK_ARCH
            OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  configure_file(${UBUNTU_MANIFEST_PATH} ${CMAKE_CURRENT_BINARY_DIR}/manifest.json)
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json DESTINATION ${CMAKE_INSTALL_PREFIX})
  install(FILES "${APP_HARDCODE}.apparmor" DESTINATION ${CMAKE_INSTALL_PREFIX})
  set(ICON ${ICON_FILE})
else(CLICK_MODE)
  set(ICON ${CMAKE_INSTALL_PREFIX}/${UBUNTU-CALCULATOR-APP_DIR}/${ICON_FILE})
  set(EXEC ${APP_HARDCODE})
  configure_file(app/${APP_HARDCODE}.in
    ${CMAKE_CURRENT_BINARY_DIR}/${APP_HARDCODE})
  install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${APP_HARDCODE}
    DESTINATION ${CMAKE_INSTALL_BINDIR})
endif(CLICK_MODE)

install(FILES app/${ICON_FILE} DESTINATION ${UBUNTU-CALCULATOR-APP_DIR}/graphics)

file(GLOB_RECURSE I18N_SRC_FILES
     RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/po
     *.qml *.js)
list(APPEND I18N_SRC_FILES  ${CMAKE_CURRENT_BINARY_DIR}/po/${DESKTOP_FILE}.in.in.h)
list(SORT I18N_SRC_FILES)

configure_file(app/${DESKTOP_FILE}.in.in ${DESKTOP_FILE}.in)

add_custom_target(${DESKTOP_FILE} ALL
  COMMENT "Merging translations into ${DESKTOP_FILE}"
  COMMAND LC_ALL=C ${INTLTOOL_MERGE} -d -u ${CMAKE_SOURCE_DIR}/po ${DESKTOP_FILE}.in ${DESKTOP_FILE}
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE}
        DESTINATION ${CMAKE_INSTALL_DATADIR}/applications)

# Tests
enable_testing()

add_subdirectory(app)
add_subdirectory(tests)
add_subdirectory(po)
