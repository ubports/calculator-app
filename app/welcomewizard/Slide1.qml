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

import QtQuick 2.3
import Ubuntu.Components 1.1

// Slide 1
Component {
    id: slide1
    Item {
        id: slide1Container

        Image {
            anchors {
                top: parent.top
                bottom: introductionText.top
                bottomMargin: units.gu(6)
                horizontalCenter: parent.horizontalCenter
            }
            source: Qt.resolvedUrl("../graphics/ubuntu-calculator-app.png")
            fillMode: Image.PreserveAspectFit
            antialiasing: true
        }

        Label {
            id: introductionText
            text: i18n.tr("Welcome to Calculator")
            fontSize: "x-large"
            height: contentHeight
            anchors.centerIn: parent
        }

        Label {
            id: bodyText
            text: i18n.tr("Enjoy the power of math by using Calculator.")
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: units.gu(1)
            anchors.top: introductionText.bottom
            anchors.topMargin: units.gu(4)
            anchors.bottom: swipeText.top
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            id: swipeText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: units.gu(1)
            anchors.bottom: parent.bottom
            color: "grey"
            fontSize: "small"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            text: i18n.tr("Swipe to move between pages")

        }
    }
}
