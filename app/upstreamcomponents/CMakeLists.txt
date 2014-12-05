file(GLOB UPSTREAMCOMPONENTS_QML_JS_FILES *.qml *.js)

# Make the files visible in the qtcreator tree
add_custom_target(ubuntu-calculator-app_upstreamcomponents_QMlFiles ALL SOURCES ${UPSTREAMCOMPONENTS_QML_JS_FILES})

install(FILES ${UPSTREAMCOMPONENTS_QML_JS_FILES} DESTINATION ${UBUNTU-CALCULATOR-APP_DIR}/upstreamcomponents)
