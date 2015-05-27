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
    objectName: modelname + "Button"

    property real baseSize: 1
    property alias text: buttonText.text
    property string buttonColor: "#eeeeee"
    property string pressedColor: "#E2E1E4"
    property alias textColor: buttonText.color

    readonly property bool kbdPressed: JSON.parse(model.kbdKeys).indexOf(pressedKey) > -1 || (pressedKeyText == text)

    onClicked: {
        //We need to force active focus to hide Favourites tab from bottom edge
        textInputField.forceActiveFocus();
    }

    onKbdPressedChanged: {
        if (!kbdPressed) {
            buttonRect.clicked();
        }
    }

    Rectangle {
        anchors.fill: parent
        border.color: "#d0d0d0"
        border.width: units.dp(0.5)
        color: buttonRect.pressed || buttonRect.kbdPressed ? pressedColor : buttonColor

        Behavior on color {
            ColorAnimation {
                duration: UbuntuAnimation.SnapDuration
            }
        }
    }

    Text {
        id: buttonText
        anchors.centerIn: parent
        color: "#5a5a5c"
        font.pixelSize: 0.5 * parent.height

        styleColor: "gray"
    }
}
