/*
 * Copyright (C) 2015 Canonical Ltd
 *
 * This file is part of Ubuntu Calculator App
 *
 * Ubuntu Calculator App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Calculator App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.4
import Ubuntu.Components 1.3

Grid {
    id: keyboardRoot

    /*
      You can change the columns. Better not touching the rows property.
      The keyboard will resize itelf in height depending on how many buttons you add
    */
    columns: 4

    /* Set a model which describes the keys. For example:
      model: new Array(
                 { number: 1 },
                 { number: 2, wFactor: 2 },
                 { text: "cos" }
             )

      This would add 3 keys to the keyboard, 1, 2 and a cos button. The button 2 is stretched over 2 columns.

      There can be more properties:
      * number: A number to be displayed on the key (integer)
      * text: A text to be displayed on the key (string)
      * name: Used for the key's objectName for testing. (e.g. name: "foo" -> objectName: "fooButton") (string)
      * forceNumber: If you assign a text and a number, or the number 0 you can force the number to be displayed over text. (bool)
      * wFactor: The width factor to stretch the button over multiple columns (int)
      * hFactor: the height factor to stretch the button over multiple rows (int)
      * action: The action to execute on button press. Can be "push", "delete", "changeSign" or "calculate". Default is "push".
      * pushText: The text that will be pushed to the formula when the button is pressed and the action is "push"
      * kbdKeys: Normally a key would hightlight itself when "text" matches the currently pressed key. This doesn't work with
                 special keys or if you want multiple keyboard keys to trigger a button. You can override this behavor by
                 specifying kbdKeys with a list of keyboard keys.
                 E.g. [Qt.Key_Return, Qt.Key_Enter] to trigger the = button on Enter and Return.
    */
    property var keyboardModel: null

    /*
      Defines the Width/Height ratio of the buttons.
      1 means square buttons
      0.5 means the button's height will be half the button's width
    */
    property real buttonRatio: 0.7
    property real buttonMaxHeight: units.gu(10)

    //Space between the buttons
    spacing: 0

    property bool completed: false
    Component.onCompleted: {
        buildModel();
        completed = true;
    }

    onKeyboardModelChanged: {
        if (completed) {
            buildModel();
        }
    }

    function buildModel() {
        generatedModel.clear();

        var emptyPlaces = new Array();

        for (var i = 0; i < keyboardRoot.keyboardModel.length; i++) {
            var entry = keyboardRoot.keyboardModel[i];
            var text = entry.number || entry.forceNumber ? Number(entry.number).toLocaleString(Qt.locale(), "f", 0) : entry.text ? entry.text : "";
            generatedModel.append(
                        {
                            text: text,
                            wFactor: entry.wFactor ? entry.wFactor : 1,
                            hFactor: entry.hFactor ? entry.hFactor : 1,
                            action: entry.action ? entry.action : "push",
                            objectName: entry.name ? entry.name + "Button" : "",
                            pushText: entry.pushText ? entry.pushText : text,
                            kbdKeys: entry.kbdKeys ? JSON.stringify(entry.kbdKeys) : JSON.stringify([]),
                            secondaryAction: entry.secondaryAction ? entry.secondaryAction : "",
                            textColor: entry.textColor ? entry.textColor : "#5a5a5c"
                        }
                    )

            if (entry.wFactor && entry.wFactor > 1) {
                for (var j = 1; j < entry.wFactor; j++) {
                    generatedModel.append({text: ""})
                }
                for (var j = 0; j < emptyPlaces.length; j++) {
                    emptyPlaces[j] = emptyPlaces[j] - entry.wFactor + 1;
                }
            }

            if (entry.hFactor && entry.hFactor > 1) {
                for (var j = 1; j < entry.hFactor; j++) {
                    emptyPlaces.push(i + columns * j);
                }
            }
            if (i + 1 === emptyPlaces[0]) {
                generatedModel.append({text: ""})
                emptyPlaces = emptyPlaces.splice(1, emptyPlaces.length);
            }
        }
    }


    Repeater {
        id: repeater
        model: ListModel {
            id: generatedModel
        }
        property real baseSize: keyboardRoot.width / keyboardRoot.columns - keyboardRoot.spacing

        Loader {
            sourceComponent: model.text ? buttonComponent : undefined

            height: Math.min(width * keyboardRoot.buttonRatio, keyboardRoot.buttonMaxHeight)
            width: keyboardRoot.width / keyboardRoot.columns - keyboardRoot.spacing

            Component {
                id: buttonComponent

                Item {
                    KeyboardButton {
                        height: Math.min(repeater.baseSize * keyboardRoot.buttonRatio, keyboardRoot.buttonMaxHeight) *
                                model.hFactor + (keyboardRoot.spacing * (model.hFactor - 1))
                        width: repeater.baseSize * model.wFactor + (keyboardRoot.spacing * (model.wFactor - 1))
                        text: model.text
                        textColor: model.textColor
                        objectName: model.objectName
                        onClicked: {
                            //If key pressed then scroll down

                            switch (model.action) {
                            case "push":
                                formulaPush(model.pushText);
                                scrollableView.scrollToBottom();
                                break;
                            case "delete":
                                deleteLastFormulaElement();
                                scrollableView.scrollToBottom();
                                break;
                            case "calculate":
                                calculate();
                                historyPosition = calculationHistory.getContents().count;
                                scrollableView.scrollToBottom();
                                break;
                            }
                        }
                        onPressAndHold: {
                            //If key pressed then scroll down
                            switch (model.secondaryAction) {
                            case "clearFormula":
                                clearFormula();
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
}
