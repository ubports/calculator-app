/*
 * Copyright 2014 Canonical Ltd.
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

ListItemWithActions {
    id: root
    color: "white"
    Row {
        id: row
        anchors.right: parent.right
        Text {
            text: formulaToDisplay
            font.pixelSize: units.gu(3)

            //verticalAlignment: Text.AlignBottom
            anchors.bottom: parent.bottom
        }
        Text {
            text: " = "
            font.pixelSize: units.gu(4)

            //verticalAlignment: Text.AlignBottom
            anchors.bottom: parent.bottom
        }
        Text {
            text: result
            font.bold: true
            font.pixelSize: units.gu(4)

            verticalAlignment: Text.AlignBottom
            anchors.bottom: parent.bottom
        }
    }
}
