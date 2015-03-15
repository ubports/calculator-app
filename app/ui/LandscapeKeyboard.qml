import QtQuick 2.3
import Ubuntu.Components 1.1

CalcKeyboard {
    id: calcKeyboard

    KeyboardPage {
        buttonRatio: 0.6
        buttonMaxHeight: scrollableView.height / 10.0
        columns: 8

        keyboardModel: new Array(
            { text: "←", name: "delete", wFactor: 2, action: "delete", kbdKeys: [Qt.Key_Backspace], secondaryAction: "clearFormula" },
            { text: "√", name: "sqrt", pushText: "sqrt(" },
            { text: "÷", name: "divide", pushText: "/", kbdKeys: [Qt.Key_Slash] },
            { text: "xⁿ", name: "power", pushText: "^", kbdKeys: [Qt.Key_AsciiCircum] },
            { text: "x²", name: "square", pushText: "^2" },
            { text: "x³", name: "cube", pushText: "^3" },
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
            { text: "( )", name: "universalBracket", pushText: "()", textColor: "#DD4814" },
            { text: "=", name: "equals", action: "calculate", kbdKeys: [Qt.Key_Enter, Qt.Key_Return] },
            { text: "|x|", name: "abs", pushText: "abs(", kbdKeys: [Qt.Key_A] },
            { text: "sin⁻¹", name: "arcsinus", pushText: "asin(" },
            { text: "cos⁻¹", name: "arccos", pushText: "acos(" },
            { text: "tan⁻¹", name: "arctangens", pushText: "atan(" }
        )
    }
}
