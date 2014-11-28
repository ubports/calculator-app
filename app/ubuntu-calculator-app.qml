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

import "ui"
import "engine/math.js" as MathJs

MainView {
    id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "calculator";
    applicationName: "com.ubuntu.calculator";

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false;

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

    //Function which will delete last formula element.
    // It could be literal, operator, const (eg. "pi") or function (eg. "sin(" )
    function deleteLastFormulaElement() {
        if (isLastCalculate === true) {
            longFormula = '';
        }

        if (longFormula !== '') {
            var removeSize = 1;
            if (longFormula[longFormula.length - 1] === ".") {
                isAllowedToAddDot = true;
            }
            longFormula = longFormula.substring(0, longFormula.length - removeSize);
        }
        shortFormula = longFormula;
        displayedInputText = returnFormulaToDisplay(longFormula);
    }

    // Check if the given digit is one of the valid operators or not.
    function isOperator(digit) {
        switch(digit) {
        case "+":
        case "-":
        case "*":
        case "/":
        case "%":
        case "^":
            return true;
        default:
            return false;
        }
    }

    function validateStringForAddingToFormula(stringToAddToFormula) {
        if (isOperator(stringToAddToFormula)) {
            if ((longFormula === '') && (stringToAddToFormula !== '-')) {
                // Do not add operator at beginning
                return false;
            }

            if ((isOperator(previousVisual) && previousVisual !== ")")) {
                // Not two operator one after other
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

    function returnFormulaToDisplay(engineFormulaToDisplay) {
        var engineToVisualMap = {
            '-': '−',
            '/': '÷',
            '*': '×',
            '.': Qt.locale().decimalPoint,
            'NaN': i18n.tr("NaN"),
            'Infinity': '∞'
        }

        for (var engineElement in engineToVisualMap) {
            //FIXME need to add 'g' flag, but "new RegExp(engineElement, 'g');" is not working for me
            engineFormulaToDisplay = engineFormulaToDisplay.replace(engineElement, engineToVisualMap[engineElement]);
        }
        return engineFormulaToDisplay;
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
            displayedInputText = returnFormulaToDisplay(shortFormula);
        } catch(exception) {
            console.log("Error: " + exception.toString());
            return;
        }

        // Add here operators that have always priority
        if ((visual.toString() === "*") || (visual.toString() === ")")) {
            isFormulaIsValidToCalculate = true;
        }
    }

    function calculate() {
        if (longFormula === '') {
            return;
        }

        try {
            var result = mathJs.eval(longFormula);
        } catch(exception) {
            console.log("Error: math.js" + exception.toString() + " engine formula:" + longFormula);
            return false;
        }

        isLastCalculate = true;

        result = result.toString();

        try {
            displayedInputText = returnFormulaToDisplay(result)
        } catch(exception) {
            console.log("Error: " + exception.toString());
            return;
        }

        historyModel.append({"formulaToDisplay":returnFormulaToDisplay(longFormula), "result":displayedInputText});
        longFormula = result;
        shortFormula = result;
        numberOfOpenedBrackets = 0;
        isAllowedToAddDot = false;
    }

    ListModel {
        // TODO: create a separate component with storage management
        id: historyModel
    }

    ListView {
        id: formulaView
        anchors.fill: parent
        clip: true

        model: historyModel

        delegate: Screen {
            width: parent.width
        }

        footer: Column {
            width: parent.width

            Text {
                width: parent.width
                height: units.gu(5)
                text: displayedInputText
            }

            // TODO: insert here actual screen

            CalcKeyboard {
                id: calcKeyboard
            }
        }
    }
}

