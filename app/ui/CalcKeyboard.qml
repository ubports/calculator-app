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

Rectangle {
    id: virtualKeyboard
    height: flickableKeyboard.height + units.gu(1)
    property real buttonRatio: 1

    Flickable {
        id: flickableKeyboard
        anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
        flickableDirection: Flickable.HorizontalFlick
        contentWidth: virtualKeyboard.width * keyboardsRow.children.length
        contentHeight: keyboardsRow.height + units.gu(1)
        height: contentHeight
        boundsBehavior: Flickable.DragOverBounds

        onDragEnded: {
            if (horizontalVelocity > units.gu(50)) {
                snapAnimation.to = width
            } else if (horizontalVelocity < -units.gu(50)) {
                snapAnimation.to = 0
            } else {
                snapAnimation.to = contentX < width / 2 ? 0 : width
            }
            snapAnimation.start()
        }

        UbuntuNumberAnimation {
            id: snapAnimation
            target: flickableKeyboard
            to: 0
            property: "contentX"
            duration: UbuntuAnimation.BriskDuration
        }

        Row {
            id: keyboardsRow
            anchors { left: parent.left; right: parent.right; margins: units.gu(1) }
            spacing: units.gu(1)
            property real baseSize: ((width - spacing) / 8) - spacing

            KeyboardPage {
                width: parent.width / 2
                spacing: parent.spacing
                buttonRatio: virtualKeyboard.buttonRatio

                model: new Array(
                    { text: "←",   name: "clear", action: "delete" },
                    { text: "+/-", name: "sign", action: "changeSign" },
                    { text: "÷",   name: "divide", pushText: "/" },
                    { text: "*",   name: "multiply" },
                    { number: 7,   name: "seven" },
                    { number: 8,   name: "eight" },
                    { number: 9,   name: "nine" },
                    { text: "-",   name: "minus" },
                    { number: 4,   name: "four" },
                    { number: 5,   name: "five" },
                    { number: 6,   name: "six" },
                    { text: "+",   name: "plus" },
                    { number: 1,   name: "one" },
                    { number: 2,   name: "two" },
                    { number: 3,   name: "three" },
                    { text: "=",   name: "equals", hFactor: 2, action: "calculate" },
                    { number: 0,   name: "zero", wFactor: 2, forceNumber: true },
                    { text: ".",   name: "point" }
                )
            }

            KeyboardPage {
                width: parent.width / 2
                spacing: parent.spacing
                buttonRatio: virtualKeyboard.buttonRatio

                model: new Array(
                    { text: "xⁿ",  name: "power", pushText: "^" },
                    { text: "x²",  name: "square", pushText: "^2" },
                    { text: "x³",  name: "cube", pushText: "^3" },
                    { text: i18n.tr("log"), name: "logarithm", pushText: "log(" },
                    { text: "e", name: "eNumber", pushText: "E" },
                    { text: "π", name: "piNumber", pushText: "pi" },
                    { text: i18n.tr("mod"), name: "modulo", pushText: "%" },
                    { text: "!", name: "factorialNumber" },
                    { text: "(", name: "openBracket" },
                    { text: ")", name: "closeBracket" },
                    { text: "1/x", name: "multiplicativeInverse", pushText: "^-1" },
                    { text: "1/x²", name: "multiplicativeInverse2", pushText: "^-2" },
                    { text: "√", name: "sqrt", pushText: "sqrt("},
                    { text: "sin", name: "sinus", pushText: "sin(" },
                    { text: "cos", name: "cos", pushText: "cos(" },
                    { text: "tan", name: "tangens", pushText: "tan(" },
                    { text: "abs", name: "abs", pushText: "abs("},
                    { text: "sin⁻¹", name: "arcsinus", pushText: "asin(" },
                    { text: "cos⁻¹", name: "arccos", pushText: "acos(" },
                    { text: "tan⁻¹", name: "arctangens", pushText: "atan(" }
                )
            }
        }
    }
}
