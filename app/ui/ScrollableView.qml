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

Flickable {
    id: flickable

    default property alias data: column.children
    property double oldContentHeight: 0
    contentHeight: column.height
    boundsBehavior: Flickable.DragOverBounds
    property bool snap: true

    onMovementEnded: {
        if (contentY <= 0 || !snap) {
            return;
        }
        var posy = flickable.height + flickable.visibleArea.yPosition * flickable.contentHeight
        // FIXME see ubuntu-calculator-app:269:
        // It's column.width - units.gu(2) because of the weird alignment of TextField
        var obj = column.childAt(column.width - units.gu(2), posy)
        if (Math.abs(posy - obj.y) < obj.height / 2) {
            // scroll up
            var destY = obj.y - flickable.height;
            // don't go out of bound
            if (destY < 0) destY = 0;
            scrollingAnimation.to = destY;
        } else {
            // scroll down
            scrollingAnimation.to = obj.y + obj.height - flickable.height;
        }
        scrollingAnimation.start()
    }

    NumberAnimation on contentY {
        id: scrollingAnimation
        duration: 300
        easing.type: Easing.OutQuad
    }

    function scrollToBottom() {
        if (column.height > flickable.height) {
            flickable.contentY = flickable.contentHeight - flickable.height;
        }
    }

    Connections {
        target: column
        onHeightChanged: {
            // scroll to bottom only when something is inserted.
            if (oldContentHeight < contentHeight) {
                flickable.scrollToBottom();
            }
            oldContentHeight = contentHeight;
        }
    }

    Item {
        id: padding
        anchors {
            left: parent.left
            right: parent.right
        }
        height: flickable.height > column.height ? flickable.height - column.height : 0
        visible: height > 0
    }

    Column {
        id: column
        anchors {
            top: padding.bottom
            left: parent.left
            right: parent.right
        }
        spacing: 0
    }
}
