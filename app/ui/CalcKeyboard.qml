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
import QtQuick 2.3
import Ubuntu.Components 1.1

Rectangle {
    id: virtualKeyboard
    height: flickableKeyboard.height + units.gu(1)

    property int pressedKey: -1
    property string pressedKeyText: ""

    default property alias children: keyboardsRow.children

    Flickable {
        id: flickableKeyboard
        anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
        flickableDirection: Flickable.HorizontalFlick
        contentWidth: virtualKeyboard.width * keyboardsRow.children.length
        contentHeight: keyboardsRow.height + units.gu(1)
        height: contentHeight
        boundsBehavior: Flickable.DragOverBounds

        property int currentIndex: 0

        onDragEnded: {
            var index = 0;
            if (horizontalVelocity > units.gu(50)) {
                index = Math.min(keyboardsRow.children.length - 1, currentIndex + 1)
            } else if (horizontalVelocity < -units.gu(50)) {
                index = Math.max(0, currentIndex - 1)
            } else {
                index = Math.round(contentX / (width + keyboardsRow.spacing))
                index = Math.max(0, index)
                index = Math.min(keyboardsRow.children.length - 1, index)
            }

            currentIndex = index;
            snapAnimation.to = index * (flickableKeyboard.width)
            snapAnimation.start()
        }

        UbuntuNumberAnimation {
            id: snapAnimation
            target: flickableKeyboard
            to: 0
            property: "contentX"
            duration: UbuntuAnimation.BriskDuration
        }

        Row {
            id: keyboardsRow
            anchors { left: parent.left; right: parent.right }

            onChildrenChanged: {
                for (var i = 0; i < children.length; i++) {
                    children[i].width = Qt.binding(function() {
                        return (keyboardsRow.width - spacing * (children.length - 2)) / children.length;
                    }
                    )
                }
            }
        }
    }
}
