/*
 * Copyright 2013-2014 Canonical Ltd.
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
import "../formula.js" as F
import "../components/math.js" as MathJs

Page {
    property var formula: new F.Formula()
    property var screenFormula: [{_text:'', _operation: '', _number:''}]
    property var separator: Qt.locale().decimalPoint
    /*
     * hasToAddDot became true if dot is last pressed button.
     * It is necessary only for +/-
     * See https://code.launchpad.net/~rpadovani/ubuntu-calculator-app/plusminus/+merge/186003/comments/426285
     */
    property bool hasToAddDot: false
    /*
     * Fix for bug #1240566: Jamming buttons causes freeze and crash
     * When user click on device onMovementEnded is called, multiple instances of onMovementEnded that cause a sigsegv
     * This var becomes false on start of onMovementEnded and return true at the end, to avoid to call all functions of onMovementEnded
     * This is enough to avoid crashes
     * https://bugs.launchpad.net/ubuntu-calculator-app/+bug/1240566
     */
    property bool isFinished: true

    property variant keyboardButtons: null

    id: page
    objectName: "simplepage"

    function formulaPush(visual) {
        screenFormula[screenFormula.length - 1]._number += visual.toString();
        formulaView.currentOperatorsChanged();
        formulaView.forceActiveFocus();
        return true;
    }

    function changeSign(){
        formula.changeSign();
        formulaView.currentOperatorsChanged();
    }

    function calculate() {
        console.log("Formula: " + screenFormula[screenFormula.length - 1]._number)
        var result = MathJs.eval(screenFormula[screenFormula.length - 1]._number);
        result = result.toString();
        if (result === "NaN") {
            // TRANSLATORS: Not a Number. For example, 0/0 is undefined as a real number, and so is represented by NaN
            result = i18n.tr("NaN");
        } else if (result === "Infinity") {
            result = "+∞";
        } else if (result === "-Infinity") {
            result = "-∞";
        }
        screenFormula[screenFormula.length - 1]._number += "=" + result;
        screenFormula.push({_text:'', _operation: "", _number: result});
        formulaView.currentOperatorsChanged();
    }

    function formulaPop() {
        if(screenFormula.length <= 1){
            clear();
            return;
        }
        //If last display row is calculate result, then delete it and restore the previous formula, if any
        if (screenFormula[screenFormula.length - 1]._operation !== '=') {
            formula.pop();
        }
        else if (formula[screenFormula.length - 1] === undefined) {
            formula.restorePreviousFormula();
        }
        screenFormula.pop();
        formulaView.currentOperatorsChanged();
    }

    function numeralPop() {
        if ((screenFormula.length > 0) &&
            (screenFormula[screenFormula.length - 1]._operation !== '=') &&
            (screenFormula[screenFormula.length - 1]._number.length > 0)) {

            screenFormula[screenFormula.length - 1]._number = screenFormula[screenFormula.length - 1]._number.slice(0, -1);
            formulaView.currentOperatorsChanged();
            formulaView.forceActiveFocus();
            return;
        }
        formulaPop();
    }

    function clear(){
        formulaView.headerItem.state = "";
        screenFormula = [{_text:'', _operation: '', _number:''}];
        formula = new F.Formula();
        formulaView.currentOperatorsChanged();
    }

    function addFromMemory(numberToAdd) {
        try{
            var temp = new CALC.Scanner(numberToAdd, new CALC.Context());
        }catch(e){
            return;
        }
        if(temp.tokens.length === 1 && temp.tokens.last().type === CALC.T_NUMBER){
            formulaPush(numberToAdd);
        }
    }

    // When user click on a calc, if is not in view scroll on the screen
    function goToIndex(index) {
        // Position
        var startPosition = formulaView.contentY;
        var endPosition;
        formulaView.positionViewAtIndex(index, ListView.Contain)
        endPosition = formulaView.contentY;

        // Animation
        scrollAnimation.from = startPosition;
        scrollAnimation.to = endPosition;
        scrollAnimation.running = true;
    }

    // Scroll animation on desktop with up/down arrow
    function scrollWithKeyboard(pixel) {
        // Position
        var startPosition = formulaView.contentY;
        var endPosition = formulaView.contentY + pixel;

        // Animation
        scrollKeyboardAnimation.from = startPosition;
        scrollKeyboardAnimation.to = endPosition;
        scrollKeyboardAnimation.running = true;
    }

    NumberAnimation {id: scrollAnimation; target: formulaView; property: "contentY"; duration: 500;}
    NumberAnimation {id: scrollKeyboardAnimation; target: formulaView; property: "contentY"; duration: 100;}

    Rectangle {
        anchors.fill: parent
        color: "#e7e8ea"

        ListView {
            id: formulaView
            anchors.fill: parent
            verticalLayoutDirection: ListView.BottomToTop
            clip: true
            focus: true

            /* We need to override default behavior: when user click on up or down key
             * screen has to go up or down of always the same size
             * By default with up and down QT changes the focus and scrolls only if
             * focused Item is not on screen
             */
            Keys.onUpPressed: {
                if (!formulaView.atYBeginning)
                    scrollWithKeyboard(-100);
            }
            Keys.onDownPressed: {
                if (!formulaView.atYEnd)
                    scrollWithKeyboard(100);
            }

            function buttonClicked(buttonName) {
                keyboardButtons[buttonName].clicked();
            }

            function buttonReleased(buttonName) {
                keyboardButtons[buttonName].released();
            }

            Keys.onPressed: {
                if (event.key === Qt.Key_Escape || event.key === Qt.Key_Delete) {
                    formulaView.atYEnd ? buttonClicked('clear') : formulaView.positionViewAtBeginning();
                } else if (event.key === Qt.Key_Backspace) {
                    numeralPop();
                } else if (event.key === Qt.Key_Enter ||
                            event.key === Qt.Key_Return ||
                            event.key === Qt.Key_Equal) {
                    (event.modifiers & Qt.ControlModifier) ? tearedOff() : buttonClicked('=');
                } else if ((!isNaN(event.text) ||
                            event.text === "+" ||
                            event.text === "-" ||
                            event.text === "*" ||
                            event.text === "/" ||
                            event.text === "=") &&
                            event.text !== "") {
                    buttonClicked(event.text)
                } else if (event.text === separator) {
                    buttonClicked('.');
                }
            }

            Keys.onReleased: {
                if (event.key === Qt.Key_Escape || event.key === Qt.Key_Delete) {
                    buttonReleased('clear');
                } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Equal) {
                    buttonReleased('=');
                } else if ((!isNaN(event.text) ||
                event.text === "+" ||
                event.text === "-" ||
                event.text === "*" ||
                event.text === "/" ||
                event.text === "=") &&
                event.text !== "") {
                    buttonReleased(event.text)
                } else if (event.text === separator) {
                    buttonReleased('.');
                }
            }

            property bool __wasAtYBegining: false
            property int __initialContentY: 0
            property bool __toBeRefresh: false
            property int __displaceDist: contentY - __initialContentY

            signal currentOperatorsChanged()

            function addCurrentToMemory() {
                if (screenFormula[screenFormula.length-1]._operation === '=') {
                    var currentDate = new Date();
                    memory.get(0).isLastItem = false
                    // TRANSLATORS: this is a time formatting string,
                    // see http://qt-project.org/doc/qt-5/qml-qtqml-date.html#details for valid expressions
                    memory.get(0).dateText = Qt.formatDateTime(currentDate, i18n.tr("dd MMM yy, hh:mm"))
                    memory.get(0).timeStamp = currentDate.getTime()
                    memory.setProperty(0, "timeStamp", currentDate.getTime());
                    memory.insert(0,{'dbId': -1, 'dateText': "", 'operators': [{_text:'', _operation:'', _number:''}], 'isLastItem': true});
                    positionViewAtBeginning();

                    return true;
                }
            }

            remove: Transition{
                NumberAnimation {property: "opacity"; to: 0; duration: 200 }
            }

            displaced: Transition{
                SequentialAnimation{
                    NumberAnimation {property: "scale"; to: 0.9; duration: 50 }
                    NumberAnimation {property: "y"; duration: 300 }
                    NumberAnimation {property: "scale"; to: 1; duration: 50 }
                }
            }

            onCurrentOperatorsChanged: {
                memory.set(0, {"operators": screenFormula});
                positionViewAtBeginning();
            }

            currentIndex: -1;

            model: Memory{
                id: memory
                Component.onCompleted: {
                    storage.getCalculations(function(calc){
                        memory.append(calc);
                    });
                    formulaView.forceActiveFocus();
                }
            }

            header: CalcKeyboard {
                id: calcKeyboard
            }

            delegate: Screen {
                id: screen
                objectName: "screen" + index
                width: formulaView.width
                ops: operators

                onUseAnswer: addFromMemory(answerToUse, formulaData)

                onRemoveItem: {
                    storage.removeCalculation(memory.get(index));
                    memory.remove(index)
                }
            }

            Scrollbar {
                flickableItem: formulaView
                align: Qt.AlignTrailing
            }

            Component.onCompleted: {
                currentOperatorsChanged();
                // We need active focus to scroll listview with keyboard
                formulaView.forceActiveFocus();
            }

            onMovementStarted: {
                __wasAtYBegining = atYEnd
                __initialContentY = contentY
            }
            onContentYChanged: {
                if (__wasAtYBegining) {
                    if (__displaceDist > units.gu(5)) {
                        __toBeRefresh = true;
                    }
                    else if (dragging) {
                        __toBeRefresh = false;
                    }
                }
            }
            onMovementEnded: {
                if (__toBeRefresh) {
                    tearedOff();
                    __toBeRefresh = false
                }
            }

            function tearedOff(){
                if (isFinished) {
                    isFinished = false;

                    if (formulaView.addCurrentToMemory()) {
                        //Save the calculation when the user tears it off
                        var calculations = []

                        var operators = memory.get(1).operators;

                        var newop = [];
                        if (operators.count !== undefined){
                            for(var j=0; j< operators.count; j++){
                                newop.push(operators.get(j));
                            }
                        } else {
                            newop = operators
                        }
                        var newElement = {'dbId': memory.get(1).dbId,
                            'isLastItem': false,
                            'operators': newop};
                        calculations.push({"calc": newElement, "date": memory.get(1).timeStamp})

                        storage.saveCalculations(calculations);
                    }
                    clear();
                    hasToAddDot=false;
                    isFinished = true;
                }
            }
        }
    }
}
