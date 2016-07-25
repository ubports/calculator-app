/*
 * Copyright (C) 2015 Canonical Ltd
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

AbstractButton {
    id: abstractButton

    property alias iconName: _icon.name
    property alias color: _icon.color

    Rectangle {
        visible: abstractButton.pressed
        anchors.fill: parent
        color:  UbuntuColors.orange
    }

    Icon {
        id: _icon
        width: units.gu(2.5)
        height: width
        anchors.centerIn: parent
        color:  UbuntuColors.orange
        asynchronous: true
    }
}
