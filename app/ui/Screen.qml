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
import Ubuntu.Components.Themes.Ambiance 0.1
import Ubuntu.Components.ListItems 1.0 as ListItem

ListItem.Standard {
    id: root
    height: _content.height + divider.height
    transformOrigin: Item.Bottom

    removable: !isLastItem
    confirmRemoval: true
    onItemRemoved: root.removeItem()
    showDivider: false

    property var ops
    property bool newCalculation: false
    signal useAnswer(string answerToUse, string formulaData)
    signal removeItem()

    Item {
        id: _content
        width: parent.width
        height: inputs.height+units.gu(2)

        Column {
            id: inputs
            anchors.top: parent.top
            anchors.topMargin: units.gu(2)
            width: parent.width - units.gu(3)
            anchors.centerIn: parent

            Repeater{
                id: repeater
                model: ops
                Column{
                    width: inputs.width
                    spacing: units.gu(0.5)
                    Rectangle{
                        visible: (_operation == '=')
                        height: units.gu(0.1)
                        width: formulaLabel.operationsWidth
                        anchors.right: parent.right
                        color: "#FEFEFE"
                    }
                    Item {
                        visible: (_operation == '=')
                        height: units.gu(0.9)
                        width: formulaLabel.operationsWidth
                    }
                    CalcHistory {
                        objectName: _operation == "=" ? "result" : "operand" + index
                        id: formulaLabel
                        numbers: _number
                        operation: _operation == "=" ? "" : _operation
                        numbersHeight: FontUtils.sizeToPixels("x-large")
                        isLast: (isLastItem && index === repeater.model.count-1)

                        onNumbersChanged: {
                            newCalculation = true
                        }

                        onOperationChanged: {
                            newCalculation = true
                        }

                        /*
                         * Fix for bug 1207687
                         * See https://bugs.launchpad.net/ubuntu-calculator-app/+bug/1207687/comments/7
                         * onPressed has to be added to all parts of calc that on first click don't swipe
                         */
                        MouseArea {
                            onPressed: {}
                            propagateComposedEvents: true
                        }
                    }
                }
            }

            /* Empty space */
            Item {
                height: units.gu(3)
                width: parent.width
            }
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true

            onPressed: {
                mouse.accepted = false
            }
        }
    }

    ListItem.Divider {
        id: divider
        visible: !isLastItem
        width: parent.width
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
