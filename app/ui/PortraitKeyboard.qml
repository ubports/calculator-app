import QtQuick 2.3
import Ubuntu.Components 1.1

CalcKeyboard {
    id: calcKeyboard

    KeyboardPage {
        buttonRatio: 0.6
        buttonMaxHeight: scrollableView.height / 10.0

        keyboardModel: new Array(
            { text: "←", name: "delete", wFactor: 2, action: "delete", kbdKeys: [Qt.Key_Backspace], secondaryAction: "clearFormula" },
            { text: "√", name: "sqrt", pushText: "sqrt("},
            { text: "÷", name: "divide", pushText: "/", kbdKeys: [Qt.Key_Slash] },
            { number: 7, name: "seven" },
            { number: 8, name: "eight" },
            { number: 9, name: "nine" },
            { text: "×", name: "multiply", pushText: "*", kbdKeys: [Qt.Key_Asterisk] },
            { number: 4, name: "four" },
            { number: 5, name: "five" },
            { number: 6, name: "six" },
            { text: "−", name: "minus", pushText: "-", kbdKeys: [Qt.Key_Minus] },
            { number: 1, name: "one" },
            { number: 2, name: "two" },
            { number: 3, name: "three" },
            { text: "+", name: "plus" },
            { text: decimalPoint, name: "point", pushText: "." },
            { number: 0, name: "zero", forceNumber: true },
            { text: "( )", name: "universalBracket", pushText: "()" },
            { text: "=", name: "equals", action: "calculate", kbdKeys: [Qt.Key_Enter, Qt.Key_Return] }
        )
    }

    KeyboardPage {
        buttonRatio: 0.6
        buttonMaxHeight: scrollableView.height / 10.0

        keyboardModel: new Array(
            { text: "xⁿ", name: "power", pushText: "^", kbdKeys: [Qt.Key_AsciiCircum] },
            { text: "x²", name: "square", pushText: "^2" },
            { text: "x³", name: "cube", pushText: "^3" },
            { text: i18n.tr("log"), name: "logarithm", pushText: "log(", kbdKeys: [Qt.Key_L] },
            { text: "ℯ", name: "eNumber", pushText: "E", kbdKeys: [Qt.Key_E] },
            { text: "π", name: "piNumber", pushText: "pi", kbdKeys: [Qt.Key_P] },
            { text: i18n.tr("mod"), name: "modulo", pushText: "%", kbdKeys: [Qt.Key_Percent] },
            { text: "!", name: "factorialNumber", kbdKeys: [Qt.Key_Exclam] },
            { text: "ℯⁿ", name: "exp", pushText: "E^"},
            { text: "1/x", name: "multiplicativeInverse", pushText: "^-1" },
            { text: "1/x²", name: "multiplicativeInverse2", pushText: "^-2" },
            { text: "1/x³", name: "multiplicativeInverse3", pushText: "^-3" },
            { text: "i", name: "i", pushText: "i", kbdKeys: [Qt.Key_I] },
            { text: "sin", name: "sinus", pushText: "sin(", kbdKeys: [Qt.Key_S] },
            { text: "cos", name: "cos", pushText: "cos(", kbdKeys: [Qt.Key_C]  },
            { text: "tan", name: "tangens", pushText: "tan(", kbdKeys: [Qt.Key_T]  },
            { text: "abs", name: "abs", pushText: "abs(", kbdKeys: [Qt.Key_A] },
            { text: "sin⁻¹", name: "arcsinus", pushText: "asin(" },
            { text: "cos⁻¹", name: "arccos", pushText: "acos(" },
            { text: "tan⁻¹", name: "arctangens", pushText: "atan(" }
        )
    }

}
