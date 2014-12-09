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

    property int numberOfOpenedBrackets: 0;

    // Property needed to
    property bool isAllowedToAddDot: true;

    property var decimalPoint: Qt.locale().decimalPoint

    /**
     * The function calls the Formula.deleteLastFormulaElement function and
     * place the result in right vars
     */
    function deleteLastFormulaElement() {
        if (longFormula[longFormula.length - 1] === ".") {
            isAllowedToAddDot = true;
        }

        longFormula = Formula.deleteLastFormulaElement(isLastCalculate, longFormula);
        shortFormula = longFormula;
        displayedInputText = returnFormulaToDisplay(longFormula);
    }

    function validateStringForAddingToFormula(stringToAddToFormula) {
        if (Formula.isOperator(stringToAddToFormula)) {
            if ((longFormula === '') && (stringToAddToFormula !== '-')) {
                // Do not add operator at beginning
                return false;
            }

            if ((Formula.isOperator(previousVisual) && previousVisual !== ")")) {
                // Not two operator one after otQt.locale().decimalPointher
                return false;
            }
        }

        if (isNaN(stringToAddToFormula)) {
            if (stringToAddToFormula !== ".") {
                isAllowedToAddDot = true
            }
        }

        if (stringToAddToFormula[stringToAddToFormula.length - 1] === "(") {
            numberOfOpenedBrackets = numberOfOpenedBrackets + 1
        } else if (stringToAddToFormula === ")") {
            // Do not allow closing brackets after opening bracket
            // and do not allow adding too much closing brackets
            if ((previousVisual === "(") || (numberOfOpenedBrackets < 1)) {
                return false;
            }
            numberOfOpenedBrackets = numberOfOpenedBrackets - 1
        } else if (stringToAddToFormula === ".") {
            //Do not allow to have two decimal separators in the same number
            if (isAllowedToAddDot === false) {
                return false;
            }

            isAllowedToAddDot = false;
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

        try {
            if (validateStringForAddingToFormula(visual) === false) {
                return;
            }
        } catch(exception) {
            console.log("Error: " + exception.toString());
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
                console.log("Error: math.js" + exception.toString() + " engine formula:" + shortFormula);
            }

            isFormulaIsValidToCalculate = false;
        }

        // Adding the new operator to the formula
        longFormula += visual.toString();
        shortFormula += visual.toString();

        try {
            displayedInputText = Formula.returnFormulaToDisplay(shortFormula);
        } catch(exception) {
            console.log("Error: " + exception.toString());
            return;
        }

        // Add here operators that have always priority
        if ((visual.toString() === "*") || (visual.toString() === ")")) {
            isFormulaIsValidToCalculate = true;
        }
        textInputField.cursorVisible = true
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

        try {
            displayedInputText = Formula.returnFormulaToDisplay(result)
        } catch(exception) {
            console.log("Error: " + exception.toString());
            return;
        }

        calculationHistory.addCalculationToDatabase(longFormula, result);
        longFormula = result;
        shortFormula = result;
        numberOfOpenedBrackets = 0;
        if (result % 1 != 0) {
            isAllowedToAddDot = false;
        } else {
            isAllowedToAddDot = true;
        }
    }

    CalculationHistory {
        id: calculationHistory
    }

    VisualItemModel {
        id: calculatorVisualModel

        Loader {
            id: keyboardLoader
            width: parent.width
            source: mainListView.width > mainListView.height ? "ui/LandscapeKeyboard.qml" : "ui/PortraiKeyboard.qml"
            focus: true
            onItemChanged: {
                if (item && keyboardLoader.focus) {
                    item.forceActiveFocus();
                }
            }
        }

        TextField {
            id: textInputField
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
            font.pixelSize: height * 0.8
            //horizontalAlignment: TextInput.AlignRight
            anchors.right: parent.right
            anchors.rightMargin: units.gu(1)
            readOnly: true
            selectByMouse: true
            cursorVisible: true
            onCursorPositionChanged: if (cursorPosition !== displayedInputText.length ) {
                var preservedCursorPosition = cursorPosition;
                displayedInputText = returnFormulaToDisplay(longFormula);
                cursorPosition = preservedCursorPosition;
            } else {
                displayedInputText = returnFormulaToDisplay(shortFormula);
            }
        }

        ListView {
            id: formulaView
            width: parent.width
            height: contentHeight
            model: calculationHistory.getContents()
            interactive: false

            property var _currentSwipedItem: null

            delegate: Screen {
                id: screenDelegate
                width: parent.width

                property var removalAnimation
                function remove() {
                    removalAnimation.start();
                }

                onSwippingChanged: {
                    formulaView._updateSwipeState(screenDelegate);
                }

                onSwipeStateChanged: {
                    formulaView._updateSwipeState(screenDelegate);
                }

                leftSideAction: Action {
                    iconName: "delete"
                    text: i18n.tr("Delete")
                    onTriggered: {
                        screenDelegate.remove();
                    }
                }

                ListView.onRemove: ScriptAction {
                    script: {
                        if (formulaView._currentSwipedItem === screenDelegate) {
                            formulaView._currentSwipedItem = null;
                        }
                    }
                }

                removalAnimation: SequentialAnimation {
                    alwaysRunToEnd: true

                    PropertyAction {
                        target: screenDelegate
                        property: "ListView.delayRemove"
                        value: true
                    }

                    UbuntuNumberAnimation {
                        target: screenDelegate
                        property: "height"
                        to: 0
                    }

                    PropertyAction {
                        target: screenDelegate
                        property: "ListView.delayRemove"
                        value: false
                    }

                    ScriptAction {
                        script: {
                            calculationHistory.deleteCalc(docId);
                        }
                    }
                }
            }

            function _updateSwipeState(item) {
                if (item.swipping) {
                    return
                }

                if (item.swipeState !== "Normal") {
                    if (formulaView._currentSwipedItem !== item) {
                        if (formulaView._currentSwipedItem) {
                            formulaView._currentSwipedItem.resetSwipe()
                        }
                        formulaView._currentSwipedItem = item
                    } else if (item.swipeState !== "Normal"
                        && formulaView._currentSwipedItem === item) {
                        formulaView._currentSwipedItem = null
                    }
                }
            }
        }
    }

    ListView {
        id: mainListView
        anchors.fill: parent
        model: calculatorVisualModel
        verticalLayoutDirection: ListView.BottomToTop
        snapMode: ListView.SnapToItem
    }
}

