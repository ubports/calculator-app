import QtQuick 2.3
import Ubuntu.Components 1.1

CalcKeyboard {
    id: calcKeyboard

    KeyboardPage {
        buttonRatio: 0.7

        keyboardModel: new Array(
            { text: "←", name: "clear", action: "delete" },
            { text: "+/-", name: "sign", action: "changeSign" },
            { text: "÷", name: "divide", pushText: "/" },
            { text: "×", name: "multiply", pushText: "*" },
            { number: 7, name: "seven" },
            { number: 8, name: "eight" },
            { number: 9, name: "nine" },
            { text: "−", name: "minus", pushText: "-" },
            { number: 4, name: "four" },
            { number: 5, name: "five" },
            { number: 6, name: "six" },
            { text: "+", name: "plus" },
            { number: 1, name: "one" },
            { number: 2, name: "two" },
            { number: 3, name: "three" },
            { text: "=", name: "equals", hFactor: 2, action: "calculate" },
            { number: 0, name: "zero", wFactor: 2, forceNumber: true },
            { text: decimalPoint, name: "point" }
        )
    }

    KeyboardPage {
        buttonRatio: 0.7

        keyboardModel: new Array(
            { text: "xⁿ", name: "power", pushText: "^" },
            { text: "x²", name: "square", pushText: "^2" },
            { text: "x³", name: "cube", pushText: "^3" },
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
