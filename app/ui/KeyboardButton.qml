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

AbstractButton {
    id: buttonRect

    property alias text: buttonText.text
    property string buttonColor: "#babbbc"
    property string pressedColor: "#E2E1E4"
    property alias textColor: buttonText.color

    Rectangle {
        anchors.fill: parent
        border.color: "#bdbec0"
        border.width: units.dp(2)
        color: buttonMA.pressed ? pressedColor : buttonColor
    }

    Text {
        id: buttonText
        anchors.centerIn: parent
        color: "#5a5a5c"
        font.pixelSize: buttonRect.height * 0.8
        font.bold: true
    }

    MouseArea {
        id: buttonMA
        anchors.fill: parent
        onClicked: buttonRect.clicked();
    }
}
