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



function Formula() {
    var formula = '';
    var previousFormula = {};
    var previousFormulaCounter = -1;
    var lookupTbl = {
        '-': '−',
        '/': '÷',
        '*': '×'
    };
    var table = {
        "65" : "+",
        "66" : "-",
        "67" : "*",
        "68" : "/"
    }

    var isLastResult = false;   // This var becames true if the last button pressed by user is equal
    var isChangeSign = false;   // This var becames true if user want to change the sign of a result

    function operatorToString(digit) {
    }

    // Check if the given digit is one of the valid operators or not.
    function isOperator(digit){
    }

    var _calculate = function(func){
    }

    this.push = function(digit){
    };

    this.pop = function() { 
    };

    this.numeralPop = function() {
    };


    this.calculate = function() {

    }

    this.changeSign = function() {
        
    }

    this.hasResults = function(){
    }

    this.restorePreviousFormula = function() {
        if (previousFormulaCounter > -1) {
            formula = previousFormula[previousFormulaCounter];
            previousFormulaCounter--;
        }
    }
}
