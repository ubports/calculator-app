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
    contentHeight: column.childrenRect.height
    boundsBehavior: Flickable.DragOverBounds

    onMovementEnded: {
        if (contentY <= 0) {
            return;
        }
        var posy = flickable.height + flickable.visibleArea.yPosition * flickable.contentHeight
        // FIXME:
        // It's column.width - units.gu(2) because of the weird alignment of TextField
        var obj = column.childAt(column.width - units.gu(2), posy)
        if (Math.abs(posy - obj.y) < obj.height / 2) {
            console.log("scroll up", obj.y);
            flickable.contentY = obj.y - flickable.height
        } else {
            console.log("scroll down", obj.y);
            flickable.contentY = obj.y + obj.height - flickable.height
        }
    }

    Behavior on contentY {
        NumberAnimation { duration: 300; easing.type: Easing.OutQuad}
    }

    Column {
        id: column
        anchors {
            left: parent.left
            right: parent.right
        }
        spacing: 0
    }
}
