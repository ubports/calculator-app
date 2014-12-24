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

import "../upstreamcomponents"
import "../engine/formula.js" as Formula

ListItemWithActions {
    id: root

    color: "white"
    Row {
        id: row
        width: parent.width
        anchors.right: parent.right

        layoutDirection: Qt.RightToLeft
        spacing: units.gu(1)

        Text {
            id: result

            anchors.bottom: formula.bottom

            text: mathJs.format(Number(model.result), 11);
            font.pixelSize: units.gu(3.5)
            lineHeight: units.gu(2)
            lineHeightMode: Text.FixedHeight
        }

        Text {
            id: equal

            anchors.bottom: formula.bottom

            text: " = "
            font.pixelSize: units.gu(2.5)
            lineHeight: units.gu(1) + 1
            lineHeightMode: Text.FixedHeight
        }

        Text {
            id: formula

            width: parent.width - equal.width - result.width
            anchors.bottom: parent.bottom

            text: Formula.returnFormulaToDisplay(model.formula)
            font.pixelSize: units.gu(2.5)
            lineHeight: units.gu(1) + 1
            lineHeightMode: Text.FixedHeight

            elide: Text.ElideLeft
            horizontalAlignment: Text.AlignRight
        }
    }
}
