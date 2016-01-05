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

// Slide 2
Component {
    id: slide2
    Item {
        id: slide1Container

        Image {
            anchors {
                top: parent.top
                bottom: introductionText.top
                bottomMargin: units.gu(6)
                horizontalCenter: parent.horizontalCenter
            }
            fillMode: Image.PreserveAspectFit
            source: Qt.resolvedUrl("../graphics/rotate.png")
        }

        Label {
            id: introductionText
            anchors.centerIn: parent
            elide: Text.ElideRight
            fontSize: "x-large"
            maximumLineCount: 2
            text: i18n.tr("Discover Scientific Calculator")
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: Text.WordWrap
        }

        Label {
            id: finalMessage
            anchors {
                top: introductionText.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: units.gu(1)
                topMargin: units.gu(4)
            }
            horizontalAlignment: Text.AlignHCenter
            text: i18n.tr("You can rotate for the Scientific Calculator")
            wrapMode: Text.WordWrap
        }
    }
}
