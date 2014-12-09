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

/**
 * Function which will delete last element in the formula
 * It could be literal, operator, const (eg. "pi") or function (eg. "sin(" )
 *
 * @param bool isLastCalculate: if in the textfield there is the result of a
 *          calc this is true and the function delete all
 * @param string longFormula: the formula in the textfield
 * @return a string with the new formula
 */
function deleteLastFormulaElement(isLastCalculate, longFormula) {
    if (isLastCalculate === true) {
        return '';
    }

    if (longFormula !== '') {
        // The biggest lenght of block we can delete is 5.
        var numberOfCharsToKeep = longFormula.length < 5 ? longFormula.length : 5;
        var lastChars = longFormula.substring(longFormula.length - numberOfCharsToKeep,
            longFormula.length);

        // We choose how many chars remove checking if in the end of the string
        // there is a special operation. Default: 1
        var removeSize = 1;

        // 5 chars: sqrt(, asin(, acos(, atan(
        if (lastChars.indexOf('sqrt(') !== -1 ||
            lastChars.indexOf('asin(') !== -1 ||
            lastChars.indexOf('acos(') !== -1 ||
            lastChars.indexOf('atan(') !== -1) {
            removeSize = 5;
        }
        // 4 chars: log(, exp(, sin(, cos(, tan(, abs(
        else if (lastChars.indexOf('log(') !== -1 ||
                lastChars.indexOf('exp(') !== -1 ||
                lastChars.indexOf('sin(') !== -1 ||
                lastChars.indexOf('cos(') !== -1 ||
                lastChars.indexOf('tan(') !== -1 ||
                lastChars.indexOf('abs(') !== -1) {
            removeSize = 4;
        }
        // 2 chars: pi
        else if (lastChars.indexOf('pi') !== -1) {
            removeSize = 2;
        }

        longFormula = longFormula.substring(0, longFormula.length - removeSize);
    }

    return longFormula;
}

/**
 * Function to check if a char is an operator
 *
 * @param char digit: the digit to check if is a valid operator
 * @return bool that indicates if the digit is a valid operator
 */
function isOperator(digit) {
    switch(digit) {
        case "+":
        case "-":
        case "*":
        case "/":
        case "%":
        case "^":
            return true;
        default:
            return false;
    }
}

/**
 * Function to replace some chars in the visual textfield
 *
 * @param string engineFormulaToDisplay: the string where we have to replace chars
 * @return a string based on param with changes in chars
 */
function returnFormulaToDisplay(engineFormulaToDisplay) {
    var engineToVisualMap = {
        '-': '−',
        '/': '÷',
        '*': '×',
        'pi': 'π',
        '.': decimalPoint,
        'NaN': i18n.tr("NaN"),
        'Infinity': '∞'
    }

    if (engineFormulaToDisplay !== undefined) {
        for (var engineElement in engineToVisualMap) {
            // FIXME: need to add 'g' flag, but "new RegExp(engineElement, 'g');"
            // is not working for me
            engineFormulaToDisplay = engineFormulaToDisplay.replace(
                engineElement, engineToVisualMap[engineElement]);
        }
    }
    else {
        engineFormulaToDisplay = '';
    }

    return engineFormulaToDisplay;
}

/**
 * Function to check if an operator could be added to the formula
 *
 * @param char operatorToAdd: the operator that will be added to the formula
 * @param string longFormula: the actual formula
 * @return bool: true if the operator could be added, false otherwise
 */
function couldAddOperator(operatorToAdd, longFormula) {
    // No two operators one after other
    if (isOperator(longFormula.slice(-1))) {
        // But a minus after a * or a / is allowed
        if (!(operatorToAdd === "-" && (longFormula.slice(-1) === "*" ||
                                        longFormula.slice(-1) === "/"))) {
            return false;
        }
    }

    // No operator after a dot
    if (longFormula.slice(-1) === ".") {
        return false;
    }

    // No operator after an open brackets, but minus
    if (longFormula.slice(-1) === "(" && operatorToAdd !== "-") {
        return false;
    }

    // No operator at beginning (but minus)
    if (longFormula === "" && operatorToAdd !== "-") {
        return false;
    }

    return true;
}

/**
 * Function to check if could be add a dot at the end of a formula
 *
 * @param string longFormula: the formula where we have to add the dot
 * @return bool: true if the dot could be added, false otherwhise
 */
function couldAddDot(longFormula) {
    // A dot could be only after a number
    if (isNaN(longFormula.slice(-1))) {
        return false;
    }

    // If is after a number and it's the first dot of the calc it could be added
    if (longFormula.indexOf('.') === -1) {
        return true;
    }

    // If there is already a dot we have to check if it isn't in the same operation
    // So we take all the string since the last occurence of dot to the end
    var lastOperation = longFormula.substring(longFormula.lastIndexOf('.') + 1);

    // If there isn't something different from a number we can't add a dot
    if (!isNaN(lastOperation)) {
        return false;
    }

    // If the only thing different from a number is a pi we cannot add a dot
    if (lastOperation.indexOf('pi') !== -1) {
        if (!isNaN(lastOperation.replace('pi', ''))) {
            return false;
        }
    }

    return true;
}

/**
 * Function to check if could be add a close bracket at the end of a formula
 *
 * @param string longFormula: the formula where we have to add the close bracket
 * @return bool: true if the close bracket could be added, false otherwhise
 */
function couldAddCloseBracket(longFormula) {
    // Don't close a bracket just after opened it
    if (longFormula.slice(-1) === "(") {
        return false;
    }

    // Calculate how many brackets are opened
    numberOfOpenedBrackets = (longFormula.match(/\(/g) || []).length -
                             (longFormula.match(/\)/g) || []).length;

    if (numberOfOpenedBrackets < 1) {
        return false;
    }

    return true;
}
