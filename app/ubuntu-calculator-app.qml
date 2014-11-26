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

    property var mathJs: MathJs.mathJs
    property var formula: ""

    function formulaPush(visual) {
        formula += visual.toString();
    }

    function calculate() {
        console.log("Formula: " + formula)
        var result = MathJs.eval(formula);
        result = result.toString();
        console.log("Result: " + result);
        formula = '';

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

            // TODO: insert here actual screen

            CalcKeyboard {
                id: calcKeyboard
            }
        }
    }
}

