set(WELCOMEWIZARD_QML_JS_FILES WelcomeWizard.qml Slide1.qml Slide2.qml Slide3.qml)

# Make the files visible in the qtcreator tree
add_custom_target(calculator_welcomewizard_QMlFiles ALL SOURCES ${WELCOMEWIZARD_QML_JS_FILES})

install(FILES ${WELCOMEWIZARD_QML_JS_FILES} DESTINATION ${UBUNTU-CALCULATOR-APP_DIR}/welcomewizard)


