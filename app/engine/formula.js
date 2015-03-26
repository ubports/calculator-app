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
 * @param string formulaToCheck: the formula in the textfield
 * @return a string with the new formula
 */
function deleteLastFormulaElement(isLastCalculate, formulaToCheck) {
    if (isLastCalculate === true) {
        return '';
    }

    if (formulaToCheck !== '') {
        // We choose how many chars remove checking if in the end of the string
        // there is a special operation. Default: 1
        var removeSize = 1;

        // 5 chars: sqrt(, asin(, acos(, atan(
        if (formulaToCheck.slice(-5) === 'sqrt(' ||
            formulaToCheck.slice(-5) === 'asin(' ||
            formulaToCheck.slice(-5) === 'acos(' ||
            formulaToCheck.slice(-5) === 'atan(') {
            removeSize = 5;
        }
        // 4 chars: log(, exp(, sin(, cos(, tan(, abs(
        else if (formulaToCheck.slice(-4) === 'log(' ||
                 formulaToCheck.slice(-4) === 'exp(' ||
                 formulaToCheck.slice(-4) === 'sin(' ||
                 formulaToCheck.slice(-4) === 'cos(' ||
                 formulaToCheck.slice(-4) === 'tan(' ||
                 formulaToCheck.slice(-4) === 'abs(') {
            removeSize = 4;

        }
        // 2 chars: pi
        else if (formulaToCheck.slice(-2) === 'pi') {
            removeSize = 2;
        }
        formulaToCheck = formulaToCheck.substring(0, formulaToCheck.length - removeSize);
    }

    return formulaToCheck;
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
        case "!":
            return true;
        default:
            return false;
    }
}

function validateStringForAddingToFormula(formula, stringToAddToFormula) {
    // We are checking first character to validate strings with number eg. "^3"
    if (isOperator(stringToAddToFormula[0])) {
        return couldAddOperator(formula, stringToAddToFormula[0]);
    }

    if (stringToAddToFormula === ".") {
        return couldAddDot(formula);
    }

    if (stringToAddToFormula === ")") {
        return couldAddCloseBracket(formula);
    }

    // Validate complex numbers
    if ((stringToAddToFormula === "i") || (!isNaN(stringToAddToFormula))){
        if (formula.slice(-1) === "i") {
            return false;
        }
    }
    return true;
}

/**
 * Function to check if could be add a close bracket at the end of a formula
 *
 * @param string formulaToCheck: the formula where we have to add the close bracket
 * @return bool: true if the close bracket could be added, false otherwhise
 */
function couldAddCloseBracket(formulaToCheck) {
    // Don't close a bracket just after opened it
    if (formulaToCheck.slice(-1) === "(") {
        return false;
    }

    // Calculate how many brackets are opened
    var numberOfOpenedBrackets = (longFormula.match(/\(/g) || []).length -
                                (longFormula.match(/\)/g) || []).length;

    if (numberOfOpenedBrackets < 1) {
        return false;
    }

    return true;
}

/**
 * Function to determine what bracket needs to be added after press
 * universal bracket
 * @param string formulaToCheck: formula which will be analysed
 * @return a string contains bracket to add
 */
function determineBracketTypeToAdd(formulaToCheck) {
    if (formulaToCheck === '') {
        return "(";
    }
    var lastChar = longFormula.substring(formulaToCheck.length - 1, formulaToCheck.length);

    if (isNaN(lastChar) && lastChar !== ")" && lastChar !== "i" && lastChar !== "E"  && lastChar !== "!") {
        return "(";
    } else if (couldAddCloseBracket(formulaToCheck) === true) {
        return ")";
    }

    return "*("
}

/**
 * Function to replace some chars in the visual textfield
 *
 * @param string engineFormulaToConvert: the string where we have to replace chars
 * @return a string based on param with changes in chars
 */
function returnFormulaToDisplay(engineFormulaToConvert) {
    // The deletion of " is necessary for MathJs.format function - it returns a
    // string surrounded by ", and they're useless, so we remove them
    var engineToVisualMap = {
        '-': '−',
        '\\/': '÷',
        '\\*': '×',
        '\\.': decimalPoint,
        'NaN': i18n.tr("NaN"),
        'E': 'ℯ',
        'Infinity': '∞',
        '"': '',
        ' ': ''
    }

    if (engineFormulaToConvert !== undefined) {
        for (var engineElement in engineToVisualMap) {
            var regExp = new RegExp(engineElement, 'g');
            engineFormulaToConvert = engineFormulaToConvert.replace(regExp, engineToVisualMap[engineElement]);
        }
    } else {
        engineFormulaToConvert = '';
    }

    return engineFormulaToConvert;
}

/**
 * Function to check if an operator could be added to the formula
 *
 * @param char operatorToAdd: the operator that will be added to the formula
 * @param string formulaToCheck: the actual formula
 * @return bool: true if the operator could be added, false otherwise
 */
function couldAddOperator(formulaToCheck, operatorToAdd) {
    // No two operators one after other, except factorial operator
    if (isOperator(formulaToCheck.slice(-1)) && formulaToCheck.slice(-1) !== "!") {
        // But a minus after a * or a / is allowed
        if (!(operatorToAdd === "-" && (formulaToCheck.slice(-1) === "*" ||
                                        formulaToCheck.slice(-1) === "/"))) {
            return false;
        }
    }

    // No operator after a dot
    if (formulaToCheck.slice(-1) === ".") {
        return false;
    }

    // No operator after an open brackets, but minus
    if (formulaToCheck.slice(-1) === "(" && operatorToAdd !== "-") {
        return false;
    }

    // No operator at beginning (but minus)
    if (formulaToCheck === "" && operatorToAdd !== "-") {
        return false;
    }

    return true;
}

/**
 * Function to check if could be add a dot at the end of a formula
 *
 * @param string formulaToCheck: the formula where we have to add the dot
 * @return bool: true if the dot could be added, false otherwhise
 */
function couldAddDot(formulaToCheck) {
    // A dot could be only after a number
    if ((isNaN(formulaToCheck.slice(-1))) || (formulaToCheck === "")) {
        return false;
    }

    // If is after a number and it's the first dot of the calc it could be added
    if (formulaToCheck.indexOf('.') === -1) {
        return true;
    }

    // If there is already a dot we have to check if it isn't in the same operation
    // So we take all the string since the last occurence of dot to the end
    var lastOperation = formulaToCheck.substring(formulaToCheck.lastIndexOf('.') + 1);

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

