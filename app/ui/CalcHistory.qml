/*
 * Copyright 2013-2014 Canonical Ltd.
 *
 * This file is part of ubuntu-calculator-app.
 *
 * ubuntu-calculator-app is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * ubuntu-calculator-app is distributed in the hope that it will be useful,
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

Item {
    id: root
    width: parent.width
    height: row.height

    property int operationsWidth: operatorLabel.width+formulaLabel.width
    property string operation: ""
    property string numbers: ""
    property int numbersHeight: units.gu(4)
    property string numbersColor: '#0000000'
    property bool isLast: false

    Row{
        id: row
        height: numbersHeight
        width: parent.width
        anchors.left: parent.left

        Label {
            id: operatorLabel
            width: units.gu(2)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: numbersHeight
            color: "#0E0E0E"
            text: root.operation
        }
        Label {
            id: formulaLabel

            // this property is used by autopilot tests to find the correct item
            // FIXME: implement it in a better way
            property bool isLast: root.isLast

            objectName: "formulaLabel"
            width: parent.width - operatorLabel.width
            color: numbersColor
            anchors.bottom: parent.bottom
            font.pixelSize: numbersHeight
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignRight
            // If is a new calculation or if last calculation as been deleted print 0, else the number
            text: ((isLast && !newCalculation) || (root.numbers === "" && formulaView.headerItem.state !== "newPush")) ? "0" : root.numbers
        }
    }
}
