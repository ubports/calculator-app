if(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
  file(GLOB QML_JS_FILES *.qml *.js)
  add_custom_target(ubuntu-calculator-app_QMlFiles ALL SOURCES ${QML_JS_FILES})
endif(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")

if(CLICK_MODE)
  install(FILES graphics/${ICON_FILE} DESTINATION ${CMAKE_INSTALL_PREFIX})
  install(FILES ${MAIN_QML} DESTINATION ${CMAKE_INSTALL_PREFIX})
else (CLICK_MODE)
  install(FILES graphics/${ICON_FILE} DESTINATION ${CMAKE_INSTALL_PREFIX}/${UBUNTU-CALCULATOR-APP_DIR})
  install(FILES ${MAIN_QML} DESTINATION ${CMAKE_INSTALL_PREFIX}/${UBUNTU-CALCULATOR-APP_DIR})
endif(CLICK_MODE)


add_subdirectory(engine)
add_subdirectory(graphics)
add_subdirectory(ui)
add_subdirectory(upstreamcomponents)
