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

Item {
    width: parent.width
    height: grid.height+units.gu(2)

    property int calcGridUnit: width / 50
    property variant keyboardButtons: {'0': zeroButton,
                                       '1': oneButton,
                                       '2': twoButton,
                                       '3': threeButton,
                                       '4': fourButton,
                                       '5': fiveButton,
                                       '6': sixButton,
                                       '7': sevenButton,
                                       '8': eightButton,
                                       '9': nineButton,
                                       '+': plusButton,
                                       '-': minusButton,
                                       '*': multiplyButton,
                                       '/': divideButton,
                                       '=': equalsButton,
                                       '.': pointButton,
                                       'clear': clearButton}

    Text {
        visible: formulaView.__wasAtYBegining && formulaView.__displaceDist > units.gu(2)
        font.pixelSize: units.gu(2)
        text: formulaView.__toBeRefresh ? i18n.tr("Release to start new calculation") : i18n.tr("Pull to start new calculation")
        anchors.horizontalCenter: parent.horizontalCenter
        color: '#757373'
    }

    Rectangle {
        width: parent.width
        height: grid.height+units.gu(2)
        color: "#ffffff"

        anchors{
            top: parent.top
            topMargin: formulaView.__wasAtYBegining & formulaView.__displaceDist > 0 ? formulaView.__displaceDist : 0
        }

        Item {
            id: grid

            width: (calcGridUnit*12)*4 + (calcGridUnit)*3
            height: (calcGridUnit*9)*5 + (calcGridUnit)*4

            anchors{
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: units.gu(1)
            }

            KeyboardButton {
                objectName: "clearButton"
                id: clearButton
                x: 0
                y: 0
                // TRANSLATORS: Refers to Clear, keep the translation to 2 characters
                text: i18n.tr("<-")
                onClicked: {
                    formulaPop();
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "signButton"
                id: signButton
                x: (calcGridUnit*13)
                y: 0
                text: "+/-"
                onClicked: {
                    changeSign();
                }
            }

            KeyboardButton {
                objectName: "divideButton"
                id: divideButton
                x: (calcGridUnit*13)*2
                y: 0
                text: "÷"
                onClicked: {
                    formulaPush('/');
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "multiplyButton"
                id: multiplyButton
                x: (calcGridUnit*13)*3
                y: 0
                text: "×"
                onClicked: {
                    formulaPush('*');
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "sevenButton"
                id: sevenButton
                x: 0
                y: (calcGridUnit*10)
                text: Number(7).toLocaleString(Qt.locale(), "f", 0)
                onClicked: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "eightButton"
                id: eightButton
                x: (calcGridUnit*13)
                y: (calcGridUnit*10)
                text: Number(8).toLocaleString(Qt.locale(), "f", 0)
                onClicked: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "nineButton"
                id: nineButton
                x: (calcGridUnit*13)*2
                y: (calcGridUnit*10)
                text: Number(9).toLocaleString(Qt.locale(), "f", 0)
                onClicked: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "minusButton"
                id: minusButton
                x: (calcGridUnit*13)*3
                y: (calcGridUnit*10)
                text: "−"
                onClicked: {
                    formulaPush('-');
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "fourButton"
                id: fourButton
                x: 0
                y: (calcGridUnit*10)*2
                text: Number(4).toLocaleString(Qt.locale(), "f", 0)
                onClicked: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "fiveButton"
                id: fiveButton
                x: (calcGridUnit*13)
                y: (calcGridUnit*10)*2
                text: Number(5).toLocaleString(Qt.locale(), "f", 0)
                onClicked: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "sixButton"
                id: sixButton
                x: (calcGridUnit*13)*2
                y: (calcGridUnit*10)*2
                text: Number(6).toLocaleString(Qt.locale(), "f", 0)
                onClicked: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "plusButton"
                id: plusButton
                x: (calcGridUnit*13)*3
                y: (calcGridUnit*10)*2
                text: "+"
                onClicked: {
                    formulaPush(text);
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "oneButton"
                id: oneButton
                x: 0
                y: (calcGridUnit*10)*3
                text: Number(1).toLocaleString(Qt.locale(), "f", 0)
                onClicked: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "twoButton"
                id: twoButton
                x: (calcGridUnit*13)
                y: (calcGridUnit*10)*3
                text: Number(2).toLocaleString(Qt.locale(), "f", 0)
                onClicked: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "threeButton"
                id: threeButton
                x: (calcGridUnit*13)*2
                y: (calcGridUnit*10)*3
                text: Number(3).toLocaleString(Qt.locale(), "f", 0)
                onClicked: {
                    formulaPush(text);                    
                }
            }

            KeyboardButton {
                objectName: "equalsButton"
                id: equalsButton
                x: (calcGridUnit*13)*3
                y: (calcGridUnit*10)*3
                height: (calcGridUnit*19)
                text: "="
                onClicked: {
                    calculate();
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "zeroButton"
                id: zeroButton
                x: 0
                y: (calcGridUnit*10)*4
                width: (calcGridUnit*12)*2+calcGridUnit
                text: Number(0).toLocaleString(Qt.locale(), "f", 0)
                onClicked: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "pointButton"
                id: pointButton
                x: (calcGridUnit*13)*2
                y: (calcGridUnit*10)*4
                text: separator
                onClicked: {
                    if (!hasToAddDot) { // To avoid multiple dots
                        hasToAddDot = formulaPush('.'); // Engine uses dot, but on screen there is local separator
                    }
                }
            }
        }
    }

}
