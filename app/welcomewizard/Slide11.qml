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

// Slide 11
Component {
    id: slide11

    Flow {
        id: flow

        width: parent.width
        spacing: 0

        Item {
            id: imageContainer

            width: isLandscape ? slide11.width/2 : slide11.width
            height: isLandscape ? slide11.height : slide11.height/2

            Image {
                width: Math.min(parent.width, parent.height)
                anchors.centerIn: parent
                source: Qt.resolvedUrl("../graphics/gift.png")
                fillMode: Image.PreserveAspectFit
            }
        }

        Item {
            id: textContainer

            width: imageContainer.width
            height: imageContainer.height

            Flickable {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    bottom: continueButton.top
                    bottomMargin: units.gu(2)
                }

                contentHeight: textColumn.height
                clip: true

                Column {
                    id: textColumn

                    spacing: units.gu(2)
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        topMargin: units.gu(2)
                        leftMargin: units.gu(2)
                        rightMargin: units.gu(2)
                    }

                    Label {
                        id: introductionText
                        text: i18n.tr("Enjoy")
                        fontSize: "x-large"
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }

                    Label {
                        id: bodyText
                        text: i18n.tr("We hope you enjoy using Calculator!")
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                    }
                }
            }

            Button {
                id: continueButton
                anchors {
                    bottom: parent.bottom
                    bottomMargin: units.gu(3)
                    horizontalCenter: parent.horizontalCenter
                }
                height: units.gu(6)
                width: parent.width/1.3
                color: UbuntuColors.green
                text: i18n.tr("Finish")
                onClicked: finished()
            }
        }
    }

}
