/*
 * Copyright (C) 2014-2015 Canonical Ltd
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
import Ubuntu.Components.Themes.Ambiance 1.3

import "ui"
import "upstreamcomponents"
import "engine"
import "engine/math.js" as MathJs
import "engine/formula.js" as Formula

MainView {
    id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "calculator";
    applicationName: "com.ubuntu.calculator";

    automaticOrientation: true
    anchorToKeyboard: textInputField.visible ? false : true

    width: units.gu(80);
    height: units.gu(60);

    // This is our engine
    property var mathJs: MathJs.mathJs;

    // Long form of formula, which are saved in the storage/history
    property string longFormula: "";

    // Engine's short form of formula. It is displayed in TextInput field
    property string shortFormula: "";

    // The formula converted to human eye, which will be displayed in text input field
    property string displayedInputText: "";

    // If this is true we calculate a temporary result to show in the bottom label
    property bool isFormulaIsValidToCalculate: false;

    // Last immission
    property var previousVisual;

    // Becomes true after an user presses the "="
    property bool isLastCalculate: false;

    property var decimalPoint: Qt.locale().decimalPoint

    // Var used to save favourite calcs
    property bool isFavourite: false

    // Var used to store currently edited calculation history item
    property int editedCalculationIndex: -1

    // By default we delete selected calculation from history.
    // If it is set to false, then editing will be invoked
    property bool deleteSelectedCalculation: true;

    /**
     * The function calls the Formula.deleteLastFormulaElement function and
     * place the result in right vars
     */
    function deleteLastFormulaElement() {
        isFormulaIsValidToCalculate = false;
        if (textInputField.cursorPosition === textInputField.length) {
            longFormula = Formula.deleteLastFormulaElement(isLastCalculate, longFormula)
        } else {
            var truncatedSubstring = Formula.deleteLastFormulaElement(isLastCalculate, longFormula.slice(0, textInputField.cursorPosition))
            longFormula = truncatedSubstring + longFormula.slice(textInputField.cursorPosition, longFormula.length);
        }
        shortFormula = longFormula;

        displayedInputText = longFormula;
        if (truncatedSubstring) {
            textInputField.cursorPosition = truncatedSubstring.length;
        }
    }

    /**
     * Function to clear formula in input text field
     */
    function clearFormula() {
        isFormulaIsValidToCalculate = false;
        shortFormula = "";
        longFormula = "";
        displayedInputText = "";
    }

    /**
     * Format bigNumber
     */
    function formatBigNumber(bigNumberToFormat) {

        // Maximum length of the result number
        var NUMBER_LENGTH_LIMIT = 14;

        if (bigNumberToFormat.toString().length > NUMBER_LENGTH_LIMIT) {
            var resultLength = mathJs.format(bigNumberToFormat, {exponential: {lower: 1e-10, upper: 1e10},
                                            precision: NUMBER_LENGTH_LIMIT}).toString().length;

            return mathJs.format(bigNumberToFormat, {exponential: {lower: 1e-10, upper: 1e10},
                                 precision: (NUMBER_LENGTH_LIMIT - resultLength + NUMBER_LENGTH_LIMIT)}).toString();
        }
        return bigNumberToFormat.toString()
    }

    function formulaPush(visual) {
        mathJs.config({
                number: 'bignumber'
        });
        // If the user press a number after the press of "=" we start a new
        // formula, otherwise we continue with the old one
        if ((!isNaN(visual) || (visual === ".")) && isLastCalculate) {
            isFormulaIsValidToCalculate = false;
            longFormula = displayedInputText = shortFormula = "";
        }
        // Add zero when decimal separator is not after number
        if ((visual === ".") && ((isNaN(displayedInputText.slice(textInputField.cursorPosition - 1, textInputField.cursorPosition))) || (longFormula === ""))) {
            visual = "0.";
        }
        isLastCalculate = false;

        // Validate whole longFormula if the cursor is at the end of string
        if (textInputField.cursorPosition === textInputField.length) {
            if (visual === "()") {
                visual = Formula.determineBracketTypeToAdd(longFormula)
            }
            if (Formula.validateStringForAddingToFormula(longFormula, visual) === false) {
                errorAnimation.restart();
                return;
            }
        } else {
            if (visual === "()") {
                visual = Formula.determineBracketTypeToAdd(longFormula.slice(0, textInputField.cursorPosition))
            }
            if (Formula.validateStringForAddingToFormula(longFormula.slice(0, textInputField.cursorPosition), visual) === false) {
                errorAnimation.restart();
                return;
            }
        }

        // We save the value until next value is pushed
        previousVisual = visual;

        // If we add an operator after an operator we know has priority,
        // we display a temporary result instead the all operation
        if (isNaN(visual) && (visual.toString() !== ".") && isFormulaIsValidToCalculate) {
            try {
                shortFormula = formatBigNumber(mathJs.eval(shortFormula));
            } catch(exception) {
                console.log("Debug: Temp result: " + exception.toString() + " engine formula: " + shortFormula);
            }

            isFormulaIsValidToCalculate = false;
        }

        // Adding the new operator to the formula
        if (textInputField.cursorPosition === textInputField.length ) {
            longFormula += visual.toString();
            shortFormula += visual.toString();
            displayedInputText = shortFormula;
        } else {
            longFormula = longFormula.slice(0, textInputField.cursorPosition) + visual.toString() + longFormula.slice(textInputField.cursorPosition, longFormula.length);
            shortFormula = longFormula;
            var preservedCursorPosition = textInputField.cursorPosition;
            displayedInputText = shortFormula;
            textInputField.cursorPosition = preservedCursorPosition + visual.length;
        }

        // Add here operators that have always priority
        if (visual.toString() === ")") {
            isFormulaIsValidToCalculate = true;
        }
    }

    function calculate() {
        mathJs.config({
                number: 'bignumber'
        });
        if ((longFormula === '') || (isLastCalculate === true)) {
            errorAnimation.restart();
            return;
        }

        // We try to balance brackets to avoid mathJs errors
        var numberOfOpenedBrackets = (longFormula.match(/\(/g) || []).length -
                                        (longFormula.match(/\)/g) || []).length;

        for (var i = 0; i < numberOfOpenedBrackets; i++) {
            formulaPush(')');
        }

        try {
            var result = mathJs.eval(longFormula);

            result = formatBigNumber(result)

        } catch(exception) {
            // If the formula isn't right and we added brackets, we remove them
            for (var i = 0; i < numberOfOpenedBrackets; i++) {
                deleteLastFormulaElement();
            }
            errorAnimation.restart();
            return false;
        }

        isLastCalculate = true;

        if (result === longFormula) {
            errorAnimation.restart();
            return;
        }

        calculationHistory.addCalculationToScreen(longFormula, result, false, "");
        editedCalculationIndex = -1;
        longFormula = result;
        shortFormula = result;
        favouriteTextField.text = "";
        displayedInputText = result;
    }

    PageStack {
        id: mainStack

        Component.onCompleted: {
            push(calculatorPage);
            calculatorPage.forceActiveFocus();
        }

        onHeightChanged: scrollableView.scrollToBottom();
        anchors.fill: parent

        PageWithBottomEdge {
            id: calculatorPage

            title: i18n.tr("Calculator")
            anchors.fill: parent

            bottomEdgeTitle: i18n.tr("Favorite")

            bottomEdgePageComponent: FavouritePage {
                anchors.fill: parent

                title: i18n.tr("Favorite")
            }

            bottomEdgeEnabled: textInputField.visible

            state: visualModel.isInSelectionMode ? "selection" : "default"
            states: [
                State {
                    name: "default"
                    PropertyChanges {
                        target: scrollableView
                        clip: false
                    }
                    PropertyChanges {
                        target: calculatorPage.head
                        visible: false
                        preset: ""
                    }
                },
                State {
                    name: "selection"
                    PropertyChanges {
                        target: scrollableView
                        clip: true
                    }
                    PropertyChanges {
                        target: calculatorPage.head
                        visible: true
                        preset: "select"
                    }
                }
            ]

            CalculationHistory {
                id: calculationHistory
            }

            // Some special keys like backspace captured in TextField,
            // are for some reason not sent to the application but to the text input
            Keys.onPressed: textInputField.keyPress(event)
            Keys.onReleased: textInputField.keyRelease(event)

            head.visible: false
            head.locked: true
            head.backAction: Action {
                objectName: "cancelSelectionAction"
                iconName: "close"
                text: i18n.tr("Cancel")
                onTriggered: visualModel.cancelSelection()
            }
            head.actions: [
                Action {
                    id: selectAllAction
                    objectName: "selectAllAction"
                    iconName: visualModel.selectedItems.count < visualModel.items.count ?
                                        "select" : "select-none"
                    text: visualModel.selectedItems.count < visualModel.items.count ?
                            i18n.tr("Select All") : i18n.tr("Select None")
                    onTriggered: visualModel.selectAll()
                },
                Action {
                    id: copySelectedAction
                    objectName: "copySelectedAction"
                    iconName: "edit-copy"
                    text: i18n.tr("Copy")
                    onTriggered: calculatorPage.copySelectedCalculations()
                    enabled: visualModel.selectedItems.count > 0
                },
                Action {
                    id: multiDeleteAction
                    objectName: "multiDeleteAction"
                    iconName: "delete"
                    text: i18n.tr("Delete")
                    onTriggered: calculatorPage.deleteSelectedCalculations()
                    enabled: visualModel.selectedItems.count > 0
                }
            ]

            Component {
                id: emptyDelegate
                Item { }
            }

            Component {
                id: screenDelegateComponent
                Screen {
                    id: screenDelegate
                    width: parent ? parent.width : 0

                    property var model: itemModel
                    visible: model.dbId !== -1

                    selectionMode: visualModel.isInSelectionMode
                    selected: visualModel.isSelected(visualDelegate)

                    property var removalAnimation
                    function remove() {
                        removalAnimation.start();
                    }

                    // parent is the loader component
                    property var visualDelegate: parent ? parent : null

                    onSwippingChanged: {
                        visualModel.updateSwipeState(screenDelegate);
                    }

                    onSwipeStateChanged: {
                        visualModel.updateSwipeState(screenDelegate);
                    }

                    onItemClicked: {
                        if (visualModel.isInSelectionMode) {
                            if (!visualModel.selectItem(visualDelegate)) {
                                visualModel.deselectItem(visualDelegate);
                            }
                        }
                    }

                    onItemPressAndHold: {
                        visualModel.startSelection();
                        visualModel.selectItem(visualDelegate);
                    }

                    rightSideActions: [ screenDelegateCopyAction.item,
                                        screenDelegateEditAction.item,
                                        screenDelegateFavouriteAction.item ]
                    leftSideAction: screenDelegateDeleteAction.item

                    Loader {
                        id: screenDelegateCopyAction
                        sourceComponent: Action {
                            iconName: "edit-copy"
                            text: i18n.tr("Copy")
                            onTriggered: {
                                var mimeData = Clipboard.newData();
                                mimeData.text = model.formula + "=" + model.result;
                                Clipboard.push(mimeData);
                            }
                        }
                    }

                    Loader {
                        id: screenDelegateEditAction
                        sourceComponent: Action {
                            iconName: "edit"
                            text: i18n.tr("Edit")
                            onTriggered: {
                                longFormula = model.formula;
                                shortFormula =  model.result;
                                displayedInputText = model.formula;
                                isLastCalculate = false;
                                previousVisual = "";
                                scrollableView.scrollToBottom();
                            }
                        }
                    }
                    Loader {
                        id: screenDelegateFavouriteAction
                        sourceComponent: Action {
                            iconName: (mainView.editedCalculationIndex == model.index || model.isFavourite) ? "starred" : "non-starred"

                            text: i18n.tr("Add to favorites")
                            onTriggered: {

                                if (model.isFavourite) {
                                    calculationHistory.updateCalculationInDatabase(model.index, model.dbId, !model.isFavourite, "");
                                    editedCalculationIndex = -1;
                                    textInputField.visible = true;
                                    textInputField.forceActiveFocus();
                                } else {
                                    editedCalculationIndex = model.index;
                                    textInputField.visible = false;
                                    favouriteTextField.forceActiveFocus();
                                    scrollableView.scrollToBottom();
                                }

                                model.isFavourite = !model.isFavourite;
                            }
                        }
                    }
                    Loader {
                        id: screenDelegateDeleteAction
                        sourceComponent: Action {
                            iconName: "delete"
                            text: i18n.tr("Delete")
                            onTriggered: {
                                screenDelegate.remove();
                            }
                        }
                    }

                    removalAnimation: SequentialAnimation {
                        alwaysRunToEnd: true

                        ScriptAction {
                            script: {
                                if (visualModel.currentSwipedItem === screenDelegate) {
                                    visualModel.currentSwipedItem = null;
                                }
                            }
                        }

                        UbuntuNumberAnimation {
                            target: screenDelegate
                            property: "height"
                            to: 0
                        }

                        ScriptAction {
                            script: {
                                calculationHistory.deleteCalc(model.dbId, model.index);
                            }
                        }
                    }
                }
            }

            function deleteSelectedCalculations() {
                deleteSelectedCalculation = true;
                visualModel.endSelection();
            }

            function copySelectedCalculations() {
                deleteSelectedCalculation = false;
                visualModel.endSelection();
            }

            MultipleSelectionVisualModel {
                id: visualModel
                model: calculationHistory.getContents()

                onSelectionDone: {
                    if(deleteSelectedCalculation === true) {
                        for(var i = 0; i < items.count; i++) {
                            calculationHistory.deleteCalc(items.get(i).model.dbId, items.get(i).model.index);
                        }
                    } else {
                        var mimeData = Clipboard.newData();
                        mimeData.text = "";
                        for(var j = 0; j < items.count; j++) {
                            if (items.get(j).model.dbId !== -1) {
                                mimeData.text = mimeData.text + items.get(j).model.formula + "=" + items.get(j).model.result + "\n";
                            }
                        }
                        Clipboard.push(mimeData);
                    }
                }

                delegate: Component {
                    Loader {
                        property var itemModel: model
                        width: parent.width
                        height: model.dbId !== -1 ? item.height : 0;
                        sourceComponent: screenDelegateComponent
                        opacity: ((y + height) >= scrollableView.contentY) && (y <= (scrollableView.contentY + scrollableView.height)) ? 1 : 0
                        onOpacityChanged: {
                            if (this.hasOwnProperty('item') && this.item !== null) {
                                if (opacity > 0) {
                                    sourceComponent = screenDelegateComponent;
                                } else {
                                    this.item.visible = false;
                                    sourceComponent = emptyDelegate;
                                }
                            }
                        }
                    }
                }
            }

            ScrollableView {
                anchors {
                    fill: parent
                    bottomMargin: textInputField.visible ? 0 : -keyboardLoader.height
                }
                id: scrollableView
                objectName: "scrollableView"

                Component.onCompleted: {
                    // FIXME: workaround for qtubuntu not returning values depending on the grid unit definition
                    // for Flickable.maximumFlickVelocity and Flickable.flickDeceleration
                    var scaleFactor = units.gridUnit / 8;
                    maximumFlickVelocity = maximumFlickVelocity * scaleFactor;
                    flickDeceleration = flickDeceleration * scaleFactor;
                }

                Repeater {
                    id: formulaView
                    model: visualModel
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(6)

                    TextField {
                        id: favouriteTextField

                        anchors {
                            right: parent.right
                            rightMargin: units.gu(1)
                        }
                        width: parent.width - units.gu(3)
                        height: parent.height
                        visible: !textInputField.visible

                        font.italic: true
                        font.pixelSize: height * 0.5
                        verticalAlignment: TextInput.AlignVCenter

                        // TRANSLATORS: this is a time formatting string, see
                        // http://qt-project.org/doc/qt-5/qml-qtqml-date.html#details for
                        // valid expressions
                        placeholderText: Qt.formatDateTime(new Date(), i18n.tr("dd MMM yyyy"))

                        // remove ubuntu shape
                        style: TextFieldStyle {
                            background: Item {
                            }
                        }

                        onAccepted: {
                            textInputField.visible = true;
                            textInputField.forceActiveFocus();
                            if (editedCalculationIndex >= 0) {
                                calculationHistory.updateCalculationInDatabase(editedCalculationIndex,
                                  calculationHistory.getContents().get(editedCalculationIndex).dbId,
                                  true,
                                  favouriteTextField.text);
                                favouriteTextField.text = "";
                                editedCalculationIndex = -1;
                            }
                        }
                    }

                    TextField {
                        id: textInputField
                        objectName: "textInputField"
                        width: parent.width - units.gu(2)
                        height: parent.height

                        color: UbuntuColors.orange
                        // remove ubuntu shape
                        style: TextFieldStyle {
                            background: Item {
                                Rectangle {
                                    color: "#EFEEEE"
                                    width: parent.width
                                    height: parent.height
                                }
                            }
                        }

                        text: Formula.returnFormulaToDisplay(displayedInputText)
                        font.pixelSize: height * 0.7
                        horizontalAlignment: TextInput.AlignRight
                        anchors {
                            right: parent.right
                            rightMargin: units.gu(1)
                        }

                        // Need to capture special keys like backspace here,
                        // as they are for some reason not sent to the application but to the text input
                        Keys.onPressed: keyPress(event)
                        Keys.onReleased: keyRelease(event)

                        function keyPress(event) {
                            if (!(event.modifiers & Qt.ControlModifier || event.modifiers & Qt.AltModifier)) { // Shift needs to be passed through as it may be required for some special keys
                                keyboardLoader.item.pressedKey = event.key;
                                keyboardLoader.item.pressedKeyText = event.text;
                            } else if (event.modifiers & Qt.ControlModifier) {
                                if (event.key === Qt.Key_C) { // Copy action
                                    var mimeData = Clipboard.newData();
                                    mimeData.text = textInputField.selectedText;
                                    Clipboard.push(mimeData);
                                } else if (event.key === Qt.Key_V) { // Paste action
                                    if (Clipboard.data.text && Clipboard.data.text !== "") {
                                        var data = Clipboard.data.text;

                                        // Get all accepted characters (i.e. those which can be entered) from the current keyboard
                                        var acceptedBits = [];
                                        for (var i = 0; i < keyboardLoader.item.children.length; i++) {
                                            var model = keyboardLoader.item.children[i].keyboardModel;
                                            if (model) {
                                                for (var j = 0; j < model.length; j++) {
                                                    var item = model[j];
                                                    if (!item.action) {
                                                        if (item.number || item.forceNumber)
                                                            acceptedBits.push({ "chars": item.number, "push": item.number });
                                                        if (item.pushText)
                                                            acceptedBits.push({ "chars": item.pushText, "push": item.pushText });
                                                        if (item.text)
                                                            acceptedBits.push({ "chars": item.text, "push": item.pushText ? item.pushText : item.text });
                                                    }
                                                }
                                            }
                                        }

                                        // Extract the part of the clipboard data which can be pasted
                                        var paste = "";
                                        var pos = 0;
                                        while (pos < data.length) {
                                            // Check if the string starts with an accepted string
                                            for (i = 0; i < acceptedBits.length; i++) {
                                                if (data.substring(pos, pos + (acceptedBits[i].chars.length ? acceptedBits[i].chars.length : 1)) === acceptedBits[i].chars.toString()) {
                                                    paste += acceptedBits[i].push;
                                                    pos += acceptedBits[i].chars.length ? acceptedBits[i].chars.length : 1;
                                                    break;
                                                }
                                            }
                                            // Skip one char if it could not be found
                                            if (i === acceptedBits.length)
                                                pos++;
                                        }

                                        // Push the paste string
                                        formulaPush(paste);
                                    } else {
                                        console.log("Debug: paste failed as the clipboard contains no text");
                                    }

                                    scrollableView.scrollToBottom();
                                }
                            }
                        }

                        function keyRelease(event) {
                            keyboardLoader.item.pressedKey = -1;
                            keyboardLoader.item.pressedKeyText = "";
                        }

                        readOnly: true
                        selectByMouse: true
                        cursorVisible: true
                        onCursorPositionChanged:
                            if (cursorPosition !== length ) {
                                // Count cursor position from the end of line
                                var preservedCursorPosition = length - cursorPosition;
                                displayedInputText = longFormula;
                                cursorPosition = length - preservedCursorPosition;
                            } else {
                                displayedInputText = shortFormula;
                            }

                        SequentialAnimation {
                            id: errorAnimation
                            running: false
                            PropertyAnimation {
                                target: textInputField
                                properties: "color"
                                to: "#000000"
                                duration: UbuntuAnimation.SnapDuration
                            }
                            PauseAnimation {
                                duration: UbuntuAnimation.SnapDuration
                            }
                            PropertyAnimation {
                                target: textInputField
                                properties: "color"
                                to: UbuntuColors.orange
                                duration: UbuntuAnimation.SnapDuration
                            }
                        }
                    }
                }

                Loader {
                    id: keyboardLoader
                    width: parent.width
                    source: scrollableView.width > scrollableView.height ? "ui/LandscapeKeyboard.qml" : "ui/PortraitKeyboard.qml"
                    opacity: ((y + height) >= scrollableView.contentY) &&
                             (y <= (scrollableView.contentY + scrollableView.height)) ? 1 : 0
                }
            }
        }
    }
}
