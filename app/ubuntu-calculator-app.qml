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
import "js/math.js" as MathJs

MainView {
    id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "calculator"
    applicationName: "com.ubuntu.calculator"

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(40)
    height: units.gu(70)

    // This is our engine
    property var mathJs: MathJs.mathJs
    // The formula we save in the storage and we show in the history
    property var formula: ""
    // The formula we show while user is typing
    property var tempResult: ""
    // If this is true we calculate a temporary result to show in the bottom label
    property bool isTempResultToCalc: false
    // Last immission
    property var previousVisual
    // Becomes true after an user presses the "="
    property bool isLastCalculate: false

    function formulaPush(visual) {
        // If the user press a number after the press of "=" we start a new
        // formula, otherwise we continue with the old one
        if (!isNaN(visual) && isLastCalculate) {
            formula = tempResult = "";
        }
        isLastCalculate = false;

        // Check if the value is valid
        if (isNaN(visual) && (isNaN(previousVisual) &&
            previousVisual != ")")) {
            // Not two operator one after other
            return;
        }

        // We save the value until next value is pushed
        previousVisual = visual;

        // Adding the new operator to the formula
        formula += visual.toString();

        // If we add an operator after an operator we know has priority,
        // we display a temporary result instead the all operation
        if (isNaN(visual) && isTempResultToCalc) {
            tempResult = mathJs.eval(tempResult);
            isTempResultToCalc = false;
        }

        tempResult += visual.toString();

        // Add here operators that have always priority
        if (visual.toString() == "*") {
            isTempResultToCalc = true;
        }
    }

    function calculate() {
        if (isNaN(previousVisual) && previousVisual !== ")") {
            // If the last char isn't a number or a ) we don't calculate the result
            return;
        }
        isLastCalculate = true;
        var result = mathJs.eval(formula);
        result = result.toString();
        console.log(formula +" = " + result);
        formula = result;
        tempResult = result;

        historyModel.append({"result":result});
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
                text: tempResult
            }

            // TODO: insert here actual screen

            CalcKeyboard {
                id: calcKeyboard
            }
        }
    }
}

