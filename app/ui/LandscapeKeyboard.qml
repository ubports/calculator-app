/*
 * Copyright (C) 2015 Canonical Ltd
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

import QtQuick 2.4
import Ubuntu.Components 1.3

CalcKeyboard {
    id: calcKeyboard

    KeyboardPage {
        buttonRatio: 0.6
        buttonMaxHeight: scrollableView.height / 10.0
        columns: 8

        keyboardModel: new Array(
            { text: "←", name: "delete", wFactor: 2, action: "delete", kbdKeys: [Qt.Key_Backspace, Qt.Key_Delete], secondaryAction: "clearFormula" },
            { text: "√", name: "sqrt", pushText: "sqrt(" },
            { text: "÷", name: "divide", pushText: "/", kbdKeys: [Qt.Key_Slash] },
            { text: "xⁿ", name: "power", pushText: "^", kbdKeys: [Qt.Key_AsciiCircum, 16781906] }, //Number needed to make key work with the German keyboard layout as that character is normally typed by pressing the circumflex key twice but that does not work here
            { text: "x²", name: "square", pushText: "^2", kbdKeys: [Qt.Key_twosuperior] },
            { text: "x³", name: "cube", pushText: "^3", kbdKeys: [Qt.Key_threesuperior] },
            { text: i18n.tr("log"), name: "logarithm", pushText: "log(", kbdKeys: [Qt.Key_L] },
            { number: 7, name: "seven", textColor: "#DD4814" },
            { number: 8, name: "eight", textColor: "#DD4814" },
            { number: 9, name: "nine", textColor: "#DD4814" },
            { text: "×", name: "multiply", pushText: "*", kbdKeys: [Qt.Key_Asterisk] },
            { text: "ℯ", name: "eNumber", pushText: "E", kbdKeys: [Qt.Key_E] },
            { text: "π", name: "piNumber", pushText: "pi", kbdKeys: [Qt.Key_P] },
            { text: i18n.tr("mod"), name: "modulo", pushText: "%", kbdKeys: [Qt.Key_Percent] },
            { text: "!", name: "factorialNumber", kbdKeys: [Qt.Key_Exclam] },
            { number: 4, name: "four", textColor: "#DD4814" },
            { number: 5, name: "five", textColor: "#DD4814" },
            { number: 6, name: "six", textColor: "#DD4814" },
            { text: "−", name: "minus", pushText: "-", kbdKeys: [Qt.Key_Minus] },
            { text: "ℯⁿ", name: "exp", pushText: "E^"},
            { text: "1/x", name: "multiplicativeInverse", pushText: "^-1" },
            { text: "1/x²", name: "multiplicativeInverse2", pushText: "^-2" },
            { text: "1/x³", name: "multiplicativeInverse3", pushText: "^-3" },
            { number: 1, name: "one", textColor: "#DD4814" },
            { number: 2, name: "two", textColor: "#DD4814" },
            { number: 3, name: "three", textColor: "#DD4814" },
            { text: "+", name: "plus" },
            { text: "i", name: "i", pushText: "i", kbdKeys: [Qt.Key_I] },
            { text: "sin", name: "sinus", pushText: "sin(", kbdKeys: [Qt.Key_S] },
            { text: "cos", name: "cos", pushText: "cos(", kbdKeys: [Qt.Key_C] },
            { text: "tan", name: "tangens", pushText: "tan(", kbdKeys: [Qt.Key_T] },
            { text: decimalPoint, name: "point", pushText: ".", textColor: "#DD4814" },
            { number: 0, name: "zero", textColor: "#DD4814", forceNumber: true },
            { text: "( )", name: "universalBracket", pushText: "()", textColor: "#DD4814", kbdKeys: [Qt.Key_ParenLeft, Qt.Key_ParenRight, Qt.Key_BracketLeft, Qt.Key_BracketRight] },
            { text: "=", name: "equals", action: "calculate", kbdKeys: [Qt.Key_Enter, Qt.Key_Return] },
            { text: "|x|", name: "abs", pushText: "abs(", kbdKeys: [Qt.Key_A, Qt.Key_Bar] },
            { text: "sin⁻¹", name: "arcsinus", pushText: "asin(" },
            { text: "cos⁻¹", name: "arccos", pushText: "acos(" },
            { text: "tan⁻¹", name: "arctangens", pushText: "atan(" }
        )
    }
}
