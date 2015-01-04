/*
 * Copyright (C) 2014 Canonical Ltd
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
import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.Themes.Ambiance 0.1

import "ui"
import "upstreamcomponents"
import "engine"
import "engine/math.js" as MathJs
import "engine/formula.js" as Formula

MainView {
    id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "calculator";
    applicationName: "com.ubuntu.calculator";

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false;
    automaticOrientation: true

    width: units.gu(40);
    height: units.gu(70);
    focus: true

    // This is our engine
    property var mathJs: MathJs.mathJs;

    // Long form of formula, which are saved in the storage/history
    property string longFormula: "";

    // Engine's short form of formula. It is displayed in TextInput field
    property string shortFormula: "";

    // The formula converted to human eye, which will be displayed in text input field
    property string displayedInputText: "";

    // If this is true we calculate a temporary result to show in the bottom label
    property bool isFormulaIsValidToCalculate: false;

    // Last immission
    property var previousVisual;

    // Becomes true after an user presses the "="
    property bool isLastCalculate: false;

    property var decimalPoint: Qt.locale().decimalPoint

    state: visualModel.isInSelectionMode ? "selection" : "default"
    states: [
        State {
            name: "default"
            StateChangeScript {
                script: header.hide()
            }
        },
        State {
            name: "selection"
            StateChangeScript {
                script: header.show()
            }
        }
    ]

    /**
     * The function calls the Formula.deleteLastFormulaElement function and
     * place the result in right vars
     */
    function deleteLastFormulaElement() {
        longFormula = Formula.deleteLastFormulaElement(isLastCalculate, longFormula);
        shortFormula = longFormula;
        displayedInputText = Formula.returnFormulaToDisplay(longFormula);
    }

    function validateStringForAddingToFormula(formula, stringToAddToFormula) {
        if (Formula.isOperator(stringToAddToFormula)) {
            return Formula.couldAddOperator(formula, stringToAddToFormula);
        }

        if (stringToAddToFormula === ".") {
            return Formula.couldAddDot(formula);
        }

        if (stringToAddToFormula === ")") {
            return Formula.couldAddCloseBracket(formula);
        }

        return true;
    }

    function formulaPush(visual) {
        // If the user press a number after the press of "=" we start a new
        // formula, otherwise we continue with the old one
        if (!isNaN(visual) && isLastCalculate) {
            longFormula = displayedInputText = shortFormula = "";
        }
        isLastCalculate = false;
        if (validateStringForAddingToFormula(longFormula.slice(0, textInputField.cursorPosition) , visual) === false) {
            return;
        }

        // We save the value until next value is pushed
        previousVisual = visual;

        // If we add an operator after an operator we know has priority,
        // we display a temporary result instead the all operation
        if (isNaN(visual) && (visual.toString() !== ".") && isFormulaIsValidToCalculate) {
            try {
                shortFormula = mathJs.eval(shortFormula);
            } catch(exception) {
                console.log("Error: " + exception.toString() + " engine formula:" + shortFormula);
            }

            isFormulaIsValidToCalculate = false;
        }

        // Adding the new operator to the formula
        if (textInputField.cursorPosition === displayedInputText.length ) {
            longFormula += visual.toString();
            shortFormula += visual.toString();
        } else {
            longFormula = longFormula.slice(0, textInputField.cursorPosition) + visual.toString() + longFormula.slice(textInputField.cursorPosition, longFormula.length);
            shortFormula = longFormula;
        }

        var preservedCursorPosition = textInputField.cursorPosition;
        displayedInputText = Formula.returnFormulaToDisplay(shortFormula);
        textInputField.cursorPosition = preservedCursorPosition + visual.length;

        // Add here operators that have always priority
        if ((visual.toString() === "*") || (visual.toString() === ")")) {
            isFormulaIsValidToCalculate = true;
        }
    }

    function calculate() {
        if ((longFormula === '') || (isLastCalculate === true)) {
            return;
        }

        try {
            var result = mathJs.eval(longFormula);
        } catch(exception) {
            console.log("Error: math.js" + exception.toString() + " engine formula:" + longFormula);
            return false;
        }

        result = result.toString()

        isLastCalculate = true;
        if (result === longFormula) {
            return;
        }

        displayedInputText = Formula.returnFormulaToDisplay(result);

        calculationHistory.addCalculationToScreen(longFormula, result);
        longFormula = result;
        shortFormula = result;
    }

    CalculationHistory {
        id: calculationHistory
    }

    Keys.onPressed: {
        keyboardLoader.item.pressedKey = event.key;
        keyboardLoader.item.pressedKeyText = event.text;
    }

    Keys.onReleased: {
        keyboardLoader.item.pressedKey = -1;
        keyboardLoader.item.pressedKeyText = "";
    }

    Header {
        id: header
        visible: true
        useDeprecatedToolbar: false
        config: PageHeadConfiguration {
            backAction: Action {
                objectName: "cancelSelectionAction"
                iconName: "close"
                text: i18n.tr("Cancel")
                onTriggered: visualModel.cancelSelection()
            }
            actions: [
                Action {
                    id: selectAllAction
                    objectName: "selectAllAction"
                    iconName: "select"
                    onTriggered: visualModel.selectAll()
                },
                Action {
                    id: multiDeleteAction
                    objectName: "multiDeleteAction"
                    iconName: "delete"
                    onTriggered: visualModel.endSelection()
                }
            ]
        }
    }

    MultipleSelectionVisualModel {
        id: visualModel
        model: calculationHistory.getContents()

        onSelectionDone: {
            for (var i = 0; i < items.count; i++) {
                calculationHistory.deleteCalc(items.get(i).model.dbId, items.get(i).model.index);
            }
        }

        delegate: Screen {
            id: screenDelegate
            width: parent ? parent.width : 0

            visible: model.dbId != -1

            selectionMode: visualModel.isInSelectionMode
            selected: visualModel.isSelected(screenDelegate)

            property var removalAnimation
            function remove() {
                removalAnimation.start();
            }

            onSwippingChanged: {
                visualModel.updateSwipeState(screenDelegate);
            }

            onSwipeStateChanged: {
                visualModel.updateSwipeState(screenDelegate);
            }

            onItemClicked: {
                if (visualModel.isInSelectionMode) {
                    if (!visualModel.selectItem(screenDelegate)) {
                        visualModel.deselectItem(screenDelegate);
                    }
                }
            }

            onItemPressAndHold: {
                visualModel.startSelection();
                visualModel.selectItem(screenDelegate);
            }

            leftSideAction: Action {
                iconName: "delete"
                text: i18n.tr("Delete")
                onTriggered: {
                    screenDelegate.remove();
                }
            }

            removalAnimation: SequentialAnimation {
                alwaysRunToEnd: true

                ScriptAction {
                    script: {
                        if (visualModel.currentSwipedItem === screenDelegate) {
                            visualModel.currentSwipedItem = null;
                        }
                    }
                }

                UbuntuNumberAnimation {
                    target: screenDelegate
                    property: "height"
                    to: 0
                }

                ScriptAction {
                    script: {
                        calculationHistory.deleteCalc(dbId, index);
                    }
                }
            }
        }

    }

    ScrollableView {
        anchors {
            top: header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        id: scrollableView
        objectName: "scrollableView"
        clip: true

        Repeater {
            id: formulaView
            model: visualModel
        }

        TextField {
            id: textInputField
            objectName: "textInputField"
            width: contentWidth + units.gu(3)
            // TODO: Make sure this bug gets fixed in SDK:
            // https://bugs.launchpad.net/ubuntu/+source/ubuntu-ui-toolkit/+bug/1320885
            //width: parent.width
            height: units.gu(6)

            // remove ubuntu shape
            style: TextFieldStyle {
                background: Item {
                }
            }

            text: displayedInputText
            font.pixelSize: height * 0.7
            //horizontalAlignment: TextInput.AlignRight
            anchors {
                right: parent.right
                rightMargin: units.gu(1)
            }

            readOnly: true
            selectByMouse: true
            cursorVisible: true
            onCursorPositionChanged: if (cursorPosition !== displayedInputText.length ) {
                var preservedCursorPosition = cursorPosition;
                displayedInputText = Formula.returnFormulaToDisplay(longFormula);
                cursorPosition = preservedCursorPosition;
            } else {
                displayedInputText = Formula.returnFormulaToDisplay(shortFormula);
            }
        }

        Loader {
            id: keyboardLoader
            width: parent.width
            source: mainView.width > mainView.height ? "ui/LandscapeKeyboard.qml" : "ui/PortraiKeyboard.qml"
        }

    }
}

