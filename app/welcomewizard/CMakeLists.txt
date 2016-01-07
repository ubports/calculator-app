set(WELCOMEWIZARD_QML_JS_FILES WelcomeWizard.qml SlideBase.qml Slide1.qml Slide2.qml Slide3.qml Slide4.qml Slide5.qml Slide6.qml Slide7.qml Slide8.qml Slide9.qml Slide10.qml Slide11.qml)

# Make the files visible in the qtcreator tree
add_custom_target(calculator_welcomewizard_QMlFiles ALL SOURCES ${WELCOMEWIZARD_QML_JS_FILES})

install(FILES ${WELCOMEWIZARD_QML_JS_FILES} DESTINATION ${UBUNTU-CALCULATOR-APP_DIR}/welcomewizard)


