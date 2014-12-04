import QtQuick 2.3
import Ubuntu.Components 1.1

Grid {
    id: root
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
    */
    property var model: null

    property real buttonRatio: 1

    Component.onCompleted: {
        buildModel();
    }
    onModelChanged: {
        buildModel();
    }

    function buildModel() {
        generatedModel.clear();

        var emptyPlaces = new Array();

        for (var i = 0; i < root.model.length; i++) {
            var entry = root.model[i];
            var text = entry.number || entry.forceNumber ? Number(entry.number).toLocaleString(Qt.locale(), "f", 0) : entry.text ? entry.text : "";
            generatedModel.append(
                        {
                            text: text,
                            wFactor: entry.wFactor ? entry.wFactor : 1,
                            hFactor: entry.hFactor ? entry.hFactor : 1,
                            action: entry.action ? entry.action : "push",
                            objectName: entry.name ? entry.name + "Button" : "",
                            pushText: entry.pushText ? entry.pushText : text
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
            if (i+1 === emptyPlaces[0]) {
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

        Loader {
            sourceComponent: model.text ? buttonComponent : undefined

            height: width * root.buttonRatio
            width: root.width / root.columns - root.spacing

            Component {
                id: buttonComponent

                Item {
                    KeyboardButton {
                        height: keyboardsRow.baseSize * root.buttonRatio * model.hFactor + (root.spacing * (model.hFactor - 1))
                        width: keyboardsRow.baseSize * model.wFactor + (root.spacing * (model.wFactor - 1))
                        text: model.text
                        objectName: model.objectName
                        onClicked: {
                            print("invoking:")
                            switch (model.action) {
                            case "push":
                                formulaPush(model.pushText);
                                break;
                            case "delete":
                                deleteLastFormulaElement();
                                break;
                            case "changeSign":
                                // TODO: Implement changeSign() function
                                //changeSign()
                                break;
                            case "calculate":
                                calculate();
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
}
