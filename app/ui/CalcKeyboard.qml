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
    id: virtualKeyboard
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
                                       '%': moduloButton,
                                       '^': powerButton,
                                       '(': openBracketButton,
                                       ')': closeBracketButton,
                                       'E': eNumberButton,
                                       'pi': piNumberButton,
                                       'square': squareButton,
                                       'clear': clearButton,
                                       'backspace': backspaceButton }

    Text {
        visible: formulaView.__wasAtYBegining && formulaView.__displaceDist > units.gu(2)
        font.pixelSize: units.gu(2)
        text: formulaView.__toBeRefresh ? i18n.tr("Release to start new calculation") : i18n.tr("Pull to start new calculation")
        anchors.horizontalCenter: parent.horizontalCenter
        color: '#757373'
    }

    Flickable {
        id: flickableKeyboard
        anchors.fill: parent
        flickableDirection: Flickable.HorizontalFlick
        contentWidth: virtualKeyboard.width * 2
        contentHeight: grid.height + units.gu(4)
        boundsBehavior: Flickable.DragOverBounds

        onMovementEnded: {
            // if we are not on the border of the virtual calculator keyboard
            // then trigger flick
            if (!flickableKeyboard.atXBeginning && !flickableKeyboard.atXEnd) {
                if (contentX < virtualKeyboard.width / 2) {
                    flickableKeyboard.flick( units.gu(200), 0);
                } else {
                    flickableKeyboard.flick( -units.gu(200), 0);
                }
            }
        }
    Rectangle {
        width: virtualKeyboard.width * 2
        height: grid.height + units.gu(2)
        color: "#ffffff"

        anchors{
            top: parent.top
            topMargin: formulaView.__wasAtYBegining & formulaView.__displaceDist > 0 ? formulaView.__displaceDist : 0
        }

        Item {
            id: grid

            // 8 keys and 7 space between and border
            width: (calcGridUnit*12)*8 + (calcGridUnit)*7 + calcGridUnit
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
                text: i18n.tr("←")
                onReleased: {
                    numeralPop();
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "signButton"
                id: signButton
                x: (calcGridUnit*13)
                y: 0
                text: "+/-"
                onReleased: {
                    changeSign();
                }
            }

            KeyboardButton {
                objectName: "divideButton"
                id: divideButton
                x: (calcGridUnit*13)*2
                y: 0
                text: "÷"
                onReleased: {
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
                onReleased: {
                    formulaPush('*');
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "powerButton"
                id: powerButton
                x: (calcGridUnit*13)*4 + calcGridUnit
                y: 0
                text: "xⁿ"
                onReleased: {
                    formulaPush('^');
                    hasToAddDot = true;
                }
            }


            KeyboardButton {
                objectName: "squareButton"
                id: squareButton
                x: (calcGridUnit*13)*5 + calcGridUnit
                y: 0
                text: "x²"
                onReleased: {
                    if (formulaPush('^') === true) {
                        hasToAddDot = true
                        formulaPush('2')
                    }
                }
            }

            KeyboardButton {
                objectName: "cubeButton"
                id: cubeButton
                x: (calcGridUnit*13)*6 + calcGridUnit
                y: 0
                text: "x³"
                onReleased: {
                    if (formulaPush('^') === true) {
                        //make sure that we have integers (to avoid expressions like 2^2.1)
                        hasToAddDot = true
                        formulaPush('3')
                    }
                }
            }

            KeyboardButton {
                objectName: "backspaceButton"
                id: backspaceButton
                x: (calcGridUnit*13)*7 + calcGridUnit
                y: 0
                text: "←"
                onReleased: {
                    numeralPop();
                }
            }

            KeyboardButton {
                objectName: "sevenButton"
                id: sevenButton
                x: 0
                y: (calcGridUnit*10)
                text: Number(7).toLocaleString(Qt.locale(), "f", 0)
                onReleased: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "eightButton"
                id: eightButton
                x: (calcGridUnit*13)
                y: (calcGridUnit*10)
                text: Number(8).toLocaleString(Qt.locale(), "f", 0)
                onReleased: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "nineButton"
                id: nineButton
                x: (calcGridUnit*13)*2
                y: (calcGridUnit*10)
                text: Number(9).toLocaleString(Qt.locale(), "f", 0)
                onReleased: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "minusButton"
                id: minusButton
                x: (calcGridUnit*13)*3
                y: (calcGridUnit*10)
                text: "−"
                onReleased: {
                    formulaPush('-');
                    hasToAddDot = false;
                }
            }


            KeyboardButton {
                objectName: "eNumberButton"
                id: eNumberButton
                x: (calcGridUnit*13)*4 + calcGridUnit
                y: (calcGridUnit*10)
                text: "e"
                onReleased: {
                    formulaPush('E');
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "piNumberButton"
                id: piNumberButton
                x: (calcGridUnit*13)*5 + calcGridUnit
                y: (calcGridUnit*10)
                text: "π"
                onReleased: {
                    formulaPush('pi');
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "moduloButton"
                id: moduloButton
                x: (calcGridUnit*13)*6 + calcGridUnit
                y: (calcGridUnit*10)
                // TRANSLATORS: Refers to Modulo - operation that finds the remainder of division of one number by another.
                text: i18n.tr("mod")
                onReleased: {
                    formulaPush('%');
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "factorialNumberButton"
                id: factorialNumberButton
                x: (calcGridUnit*13)*7 + calcGridUnit
                y: (calcGridUnit*10)
                text: "!"
                onReleased: {
                    formulaPush('!');
                    hasToAddDot = false;
                }
            }
  
            KeyboardButton {
                objectName: "fourButton"
                id: fourButton
                x: 0
                y: (calcGridUnit*10)*2
                text: Number(4).toLocaleString(Qt.locale(), "f", 0)
                onReleased: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "fiveButton"
                id: fiveButton
                x: (calcGridUnit*13)
                y: (calcGridUnit*10)*2
                text: Number(5).toLocaleString(Qt.locale(), "f", 0)
                onReleased: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "sixButton"
                id: sixButton
                x: (calcGridUnit*13)*2
                y: (calcGridUnit*10)*2
                text: Number(6).toLocaleString(Qt.locale(), "f", 0)
                onReleased: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "plusButton"
                id: plusButton
                x: (calcGridUnit*13)*3
                y: (calcGridUnit*10)*2
                text: "+"
                onReleased: {
                    formulaPush(text);
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "openBracketButton"
                id: openBracketButton
                x: (calcGridUnit*13)*4 + calcGridUnit
                y: (calcGridUnit*10)*2
                text: "("
                onReleased: {
                    formulaPush('(');
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "closeBracketButton"
                id: closeBracketButton
                x: (calcGridUnit*13)*5 + calcGridUnit
                y: (calcGridUnit*10)*2
                text: ")"
                onReleased: {
                    formulaPush(')');
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "multiplicativeInverseButton"
                id: multiplicativeInverseButton
                x: (calcGridUnit*13)*6 + calcGridUnit
                y: (calcGridUnit*10)*2
                text: "1/x"
                onReleased: {
                    if (formulaPush('^') === true) {
                        //make sure that we have integers (to avoid expressions like 2^2.1)
                        hasToAddDot = true
                        formulaPush('-1')
                    }
                }
            }

            KeyboardButton {
                objectName: "multiplicativeInverseButton2"
                id: multiplicativeInverseButton2
                x: (calcGridUnit*13)*7 + calcGridUnit
                y: (calcGridUnit*10)*2
                text: "1/x²"
                onReleased: {
                    if (formulaPush('^') === true) {
                        //make sure that we have integers (to avoid expressions like 2^2.1)
                        hasToAddDot = true
                        formulaPush('-2')
                    }
                }
            }

            KeyboardButton {
                objectName: "oneButton"
                id: oneButton
                x: 0
                y: (calcGridUnit*10)*3
                text: Number(1).toLocaleString(Qt.locale(), "f", 0)
                onReleased: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "twoButton"
                id: twoButton
                x: (calcGridUnit*13)
                y: (calcGridUnit*10)*3
                text: Number(2).toLocaleString(Qt.locale(), "f", 0)
                onReleased: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "threeButton"
                id: threeButton
                x: (calcGridUnit*13)*2
                y: (calcGridUnit*10)*3
                text: Number(3).toLocaleString(Qt.locale(), "f", 0)
                onReleased: {
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
                onReleased: {
                    calculate();
                    hasToAddDot = false;
                }
            }

            KeyboardButton {
                objectName: "sqrtButton"
                id: sqrtButton
                x: (calcGridUnit*13)*4 + calcGridUnit
                y: (calcGridUnit*10)*3
                text: "√ "
                onReleased: {
                    formulaPush('sqrt(')
                    hasToAddDot = true
                }
            }

            KeyboardButton {
                objectName: "cosinusButton2"
                id: cosinusButton2
                x: (calcGridUnit*13)*5 + calcGridUnit
                y: (calcGridUnit*10)*3
                text: "cos"
                onReleased: {
                    formulaPush('cos(')
                    hasToAddDot = true
                }
            }

            KeyboardButton {
                objectName: "tangensButton2"
                id: tangensButton2
                x: (calcGridUnit*13)*6 + calcGridUnit
                y: (calcGridUnit*10)*3
                text: "tan"
                onReleased: {
                    formulaPush('tan(')
                    hasToAddDot = true
                }
            }

            KeyboardButton {
                objectName: "cotangensButton2"
                id: cotangensButton2
                x: (calcGridUnit*13)*7 + calcGridUnit
                y: (calcGridUnit*10)*3
                text: "ctg"
                onReleased: {
                    formulaPush('atan(')
                    hasToAddDot = true
                }
            }

            KeyboardButton {
                objectName: "zeroButton"
                id: zeroButton
                x: 0
                y: (calcGridUnit*10)*4
                width: (calcGridUnit*12)*2+calcGridUnit
                text: Number(0).toLocaleString(Qt.locale(), "f", 0)
                onReleased: {
                    formulaPush(text);
                }
            }

            KeyboardButton {
                objectName: "pointButton"
                id: pointButton
                x: (calcGridUnit*13)*2
                y: (calcGridUnit*10)*4
                text: separator
                onReleased: {
                    if (!hasToAddDot) { // To avoid multiple dots
                        hasToAddDot = formulaPush('.'); // Engine uses dot, but on screen there is local separator
                    }
                }
            }

            KeyboardButton {
                objectName: "sinusButton"
                id: sinusButton
                x: (calcGridUnit*13)*4 + calcGridUnit
                y: (calcGridUnit*10)*4
                text: "sin"
                onReleased: {
                    formulaPush('sin(')
                    hasToAddDot = true
                }
            }

            KeyboardButton {
                objectName: "cosinusButton"
                id: cosinusButton
                x: (calcGridUnit*13)*5 + calcGridUnit
                y: (calcGridUnit*10)*4
                text: "cos"
                onReleased: {
                    formulaPush('cos(')
                    hasToAddDot = true
                }
            }

            KeyboardButton {
                objectName: "tangensButton"
                id: tangensButton
                x: (calcGridUnit*13)*6 + calcGridUnit
                y: (calcGridUnit*10)*4
                text: "tan"
                onReleased: {
                    formulaPush('tan(')
                    hasToAddDot = true
                }
            }

            KeyboardButton {
                objectName: "cotangensButton"
                id: cotangensButton
                x: (calcGridUnit*13)*7 + calcGridUnit
                y: (calcGridUnit*10)*4
                text: "ctg"
                onReleased: {
                    formulaPush('atan(')
                    hasToAddDot = true
                }
            }
        }
    }
    }

    Component.onCompleted: page.keyboardButtons = keyboardButtons
}
