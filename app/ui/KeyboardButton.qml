/*
 * Copyright 2013 Canonical Ltd.
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

Rectangle {
    id: buttonRect
    width: (calcGridUnit*12)
    height: (calcGridUnit*9)
    color: "#bdbec0"

    property alias text: buttonText.text
    property string buttonColor: "#babbbc"
    property string pressedColor: "#E2E1E4"
    property alias textColor: buttonText.color

    signal clicked()
    signal pressAndHold()
    signal released()

    onClicked: rectangle.color = pressedColor;
    onReleased: rectangle.color = buttonColor;

    Rectangle {
        id: rectangle
        width: parent.width-2
        height: parent.height-2
        anchors.centerIn: parent
        color: buttonColor

        Text {
            id: buttonText
            anchors.centerIn: parent
            color: "#5a5a5c"
            font.pixelSize: (calcGridUnit*4)
            font.bold: true
        }

        MouseArea {
            id: buttonMA
            anchors.fill: parent
            onPressed: buttonRect.clicked()
            onReleased: buttonRect.released()
            onPressAndHold: buttonRect.pressAndHold();
            onCanceled: buttonRect.released()
        }
    }
}
