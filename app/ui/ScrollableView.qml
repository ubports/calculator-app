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
    id: flickableHistory

    default property alias data: column.children
    property double oldContentHeight: 0
    contentHeight: flickableHistory.height > column.height ? flickableHistory.height : column.height
    boundsBehavior: Flickable.DragOverBounds
    property bool snap: true

    onMovementEnded: {
        if (contentY <= 0 || !snap) {
            return;
        }
        var posy = flickableHistory.height + flickableHistory.visibleArea.yPosition * flickableHistory.contentHeight
        // FIXME see ubuntu-calculator-app:269:
        // It's column.width - units.gu(2) because of the weird alignment of TextField
        var obj = column.childAt(column.width - units.gu(2), posy)
        if (Math.abs(posy - obj.y) < obj.height / 2) {
            // scroll up
            var destY = obj.y - flickableHistory.height;
            // don't go out of bound
            if (destY < 0) destY = 0;
            scrollingAnimation.to = destY;
        } else {
            // scroll down
            scrollingAnimation.to = obj.y + obj.height - flickableHistory.height;
        }
        scrollingAnimation.start()
    }

    onHeightChanged: {
        if (atYEnd) {
            scrollToBottom();
        }
    }

    NumberAnimation on contentY {
        id: scrollingAnimation
        duration: 300
        easing.type: Easing.OutQuad
    }

    function scrollToBottom() {
        if (column.height > flickableHistory.height) {
            flickableHistory.contentY = flickableHistory.contentHeight - flickableHistory.height;
        }
    }

    Connections {
        target: column
        onHeightChanged: {
            // scroll to bottom only when something is inserted.
            if (oldContentHeight < contentHeight) {
                flickableHistory.scrollToBottom();
            }
            oldContentHeight = contentHeight;
        }
    }

    Column {
        id: column
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        spacing: 0
    }
}
