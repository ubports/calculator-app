/*
 * Copyright 2014-2015 Canonical Ltd.
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

    function formatDate(date) {
        var now = new Date();
        var calcDate = new Date(date);

        var difference = now.getTime() - calcDate.getTime();

        difference = difference / 1000 / 60;

        if (difference < 10) {
            return i18n.tr("Just now");
        } else if (difference < 60 * 24 && now.getDay() === calcDate.getDay()) {
            var today = i18n.tr("Today ");
            // TRANSLATORS: this is a time formatting string, see
            // http://qt-project.org/doc/qt-5/qml-qtqml-date.html#details for
            // valid expressions
            return today + Qt.formatDateTime(calcDate, i18n.tr("hh:mm"));
        } else if (difference < 60 * 48 && now.getDay() === calcDate.getDay() + 1) {
            return i18n.tr("Yesterday");
        }

        // TRANSLATORS: this is a time formatting string, see
        // http://qt-project.org/doc/qt-5/qml-qtqml-date.html#details for valid
        // expressions
        return Qt.formatDateTime(calcDate, i18n.tr("dd MMM yyyy"));
    }

    color: "white"
    Column {
        anchors.fill: parent
        Row {
            id: creationDateRow
            width: parent.width
            anchors.right: parent.right
            spacing: units.gu(1)

            layoutDirection: Qt.RightToLeft

            Text {
                id: creationTimeText
                color: UbuntuColors.darkGrey
                text: formatDate(model.date)
                font.pixelSize: units.gu(1.5)
                font.italic: true
            }

            Icon {
                id: favouriteIcon
                height: units.gu(1.8)
                width: height
                name: model.isFavourite ? "starred" : "non-starred"
                color: model.isFavourite ? UbuntuColors.orange : "white"
            }

            Text {
                id: favouriteDescriptionText
                color: UbuntuColors.orange
                text: model.favouriteText
                //width: creationDateRow.width - creationTimeText.width -favouriteIcon.width - units.gu(3)
                width: paintedWidth + units.gu(3)
                font.pixelSize: units.gu(1.5)
                font.bold: true
            }
        }
        Row {
            id: calculationRow
            width: parent.width
            anchors.right: parent.right

            layoutDirection: Qt.RightToLeft
            spacing: units.gu(1)

            Text {
                id: result
                objectName: "result"

                anchors.bottom: formula.bottom

                color: UbuntuColors.darkGrey
                text: isNaN(model.result) ? Formula.returnFormulaToDisplay(model.result) : Formula.returnFormulaToDisplay(mathJs.format(model.result))
                font.pixelSize: units.gu(3.5)
                lineHeight: units.gu(2)
                lineHeightMode: Text.FixedHeight
            }

            Text {
                id: equal

                anchors.bottom: formula.bottom

                color: UbuntuColors.darkGrey
                text: " = "
                font.pixelSize: units.gu(2.5)
                lineHeight: units.gu(1) + 1
                lineHeightMode: Text.FixedHeight
            }

            Text {
                id: formula
                objectName: "formula"

                width: parent.width - equal.width - result.width
                anchors.bottom: parent.bottom

                color: UbuntuColors.darkGrey
                text: Formula.returnFormulaToDisplay(model.formula)
                font.pixelSize: units.gu(2.5)
                lineHeight: units.gu(1) + 1
                lineHeightMode: Text.FixedHeight

                elide: Text.ElideLeft
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}
