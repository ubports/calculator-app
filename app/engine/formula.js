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
        var removeSize = 1;
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
