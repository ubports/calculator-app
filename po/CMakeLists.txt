include(FindGettext)

# Find the translation tools
find_program(INTLTOOL_MERGE intltool-merge)
if(NOT INTLTOOL_MERGE)
  message(FATAL_ERROR "Could not find intltool-merge, please install the intltool package")
endif()

find_program(INTLTOOL_EXTRACT intltool-extract)
if(NOT INTLTOOL_EXTRACT)
  message(FATAL_ERROR "Could not find intltool-extract, please install the intltool package")
endif()

find_program(GETTEXT_XGETTEXT_EXECUTABLE xgettext)

set(DOMAIN ${PROJECT_NAME})
set(POT_FILE ${DOMAIN}.pot)
file(GLOB PO_FILES *.po)

# Creates the .pot file containing the translations template
add_custom_target(${POT_FILE} ALL
  COMMENT "Generating translation template"
  # Extract the translatable messages from the desktop file 
  COMMAND ${INTLTOOL_EXTRACT} --update --type=gettext/ini
          --srcdir=${CMAKE_SOURCE_DIR}/app ${DESKTOP_FILE}.in.in
  # Update the translation file
  COMMAND ${GETTEXT_XGETTEXT_EXECUTABLE} -o ${POT_FILE}
          --from-code=UTF-8
          --c++ --qt --add-comments=TRANSLATORS
          --keyword=tr --keyword=tr:1,2 --keyword=N_
          --package-name='${PROJECT}'
          --copyright-holder='Canonical Ltd.'
          -D ${CMAKE_CURRENT_SOURCE_DIR} 
          ${I18N_SRC_FILES}
)

# Builds the binary translations catalog. For each language
# it finds source translations (*.po) for generating mo files
foreach(PO_FILE ${PO_FILES})
  get_filename_component(LANG ${PO_FILE} NAME_WE)
  gettext_process_po_files(${LANG} ALL PO_FILES ${PO_FILE})
  set(INSTALL_DIR ${CMAKE_INSTALL_LOCALEDIR}/${LANG}/LC_MESSAGES)
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${LANG}.gmo
  DESTINATION ${INSTALL_DIR}
  RENAME ${DOMAIN}.mo)
endforeach(PO_FILE)


# make the translation files visible on qtcreator
file(GLOB TRANSLATION_FILES
     RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
     *.po *.pot)

add_custom_target(com_ubuntu_calculator_translation_files ALL SOURCES ${TRANSLATION_FILES})

