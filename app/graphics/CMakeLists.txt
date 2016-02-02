file(GLOB GRAPHICS_FILES
  access-sci-keyboard.png
  delete-item-from-history.png
  gift.png
  copy-formula.png
  edit-formula.png
  rotate-keyboard.png
  copy-item-from-history.png
  edit-item-from-history.png
  select-multiple-item-from-history.png
  delete-formula.png
  fav-item-from-history.png
  ubuntu-calculator-app.png
)

install(FILES ${GRAPHICS_FILES} DESTINATION ${UBUNTU-CALCULATOR-APP_DIR}/graphics)
