import QtQuick 2.3
import Ubuntu.Components 1.1

CalcKeyboard {
    id: calcKeyboard

    KeyboardPage {
        buttonRatio: 0.7
        columns: 8

        keyboardModel: new Array(
            { text: "←", name: "clear", action: "delete", kbdKeys: [Qt.Key_Backspace] },
            { text: "( )", name: "universalBracket", pushText: "()" },
            { text: "÷", name: "divide", pushText: "/", kbdKeys: [Qt.Key_Slash] },
            { text: "×", name: "multiply", pushText: "*", kbdKeys: [Qt.Key_Asterisk] },
            { text: "xⁿ", name: "power", pushText: "^", kbdKeys: [Qt.Key_AsciiCircum] },
            { text: "x²", name: "square", pushText: "^2" },
            { text: "x³", name: "cube", pushText: "^3" },
            { text: i18n.tr("log"), name: "logarithm", pushText: "log(", kbdKeys: [Qt.Key_L] },
            { number: 7, name: "seven" },
            { number: 8, name: "eight" },
            { number: 9, name: "nine" },
            { text: "−", name: "minus", pushText: "-", kbdKeys: [Qt.Key_Minus] },
            { text: "e", name: "eNumber", pushText: "E", kbdKeys: [Qt.Key_E] },
            { text: "π", name: "piNumber", pushText: "pi", kbdKeys: [Qt.Key_P] },
            { text: i18n.tr("mod"), name: "modulo", pushText: "%", kbdKeys: [Qt.Key_Percent] },
            { text: "!", name: "factorialNumber", kbdKeys: [Qt.Key_Exclam] },
            { number: 4, name: "four" },
            { number: 5, name: "five" },
            { number: 6, name: "six" },
            { text: "+", name: "plus" },
            { text: "√", name: "sqrt", pushText: "sqrt("},
            { text: "1/x", name: "multiplicativeInverse", pushText: "^-1" },
            { text: "1/x²", name: "multiplicativeInverse2", pushText: "^-2" },
            { text: "1/x³", name: "multiplicativeInverse3", pushText: "^-3" },
            { number: 1, name: "one" },
            { number: 2, name: "two" },
            { number: 3, name: "three" },
            { text: "=", name: "equals", hFactor: 2, action: "calculate", kbdKeys: [Qt.Key_Enter, Qt.Key_Return] },
            { text: "eⁿ", name: "exp", pushText: "exp("},
            { text: "sin", name: "sinus", pushText: "sin(", kbdKeys: [Qt.Key_S] },
            { text: "cos", name: "cos", pushText: "cos(", kbdKeys: [Qt.Key_C] },
            { text: "tan", name: "tangens", pushText: "tan(", kbdKeys: [Qt.Key_T] },
            { number: 0, name: "zero", wFactor: 2, forceNumber: true },
            { text: decimalPoint, name: "point", pushText: "." },
            { text: "abs", name: "abs", pushText: "abs(", kbdKeys: [Qt.Key_A] },
            { text: "sin⁻¹", name: "arcsinus", pushText: "asin(" },
            { text: "cos⁻¹", name: "arccos", pushText: "acos(" },
            { text: "tan⁻¹", name: "arctangens", pushText: "atan(" }
        )
    }
}
