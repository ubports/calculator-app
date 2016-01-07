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

// Slide 1
//Component {
//    id: slide1
//    Item {
//        id: slide1Container

//        Image {
//            anchors {
//                top: parent.top
//                bottom: introductionText.top
//                bottomMargin: units.gu(6)
//                horizontalCenter: parent.horizontalCenter
//            }
//            source: Qt.resolvedUrl("../graphics/ubuntu-calculator-app.png")
//            fillMode: Image.PreserveAspectFit
//            antialiasing: true
//        }

//        Label {
//            id: introductionText
//            text: i18n.tr("Welcome to Calculator")
//            fontSize: "x-large"
//            height: contentHeight
//            anchors.centerIn: parent
//        }

//        Label {
//            id: bodyText
//            text: i18n.tr("Enjoy the power of math by using Calculator.")
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.margins: units.gu(1)
//            anchors.top: introductionText.bottom
//            anchors.topMargin: units.gu(4)
//            anchors.bottom: swipeText.top
//            wrapMode: Text.WordWrap
//            horizontalAlignment: Text.AlignHCenter
//        }

//        Label {
//            id: swipeText
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.margins: units.gu(1)
//            anchors.bottom: parent.bottom
//            color: "grey"
//            fontSize: "small"
//            wrapMode: Text.WordWrap
//            horizontalAlignment: Text.AlignHCenter
//            text: i18n.tr("Swipe to move between pages")

//        }
//    }
//}
//Component {
//    id: slideBase

//    Flow {
//        id: flow

//        width: parent.width
//        spacing: 0

//        Item {
//            id: imageContainer

//            width: isLandscape ? slideBase.width/2 : slideBase.width
//            height: isLandscape ? slideBase.height : slideBase.height/2

//            Image {
//                width: parent.width
//                anchors.centerIn: parent
//                source: Qt.resolvedUrl("../graphics/ubuntu-calculator-app.png")
//                fillMode: Image.PreserveAspectFit
//                antialiasing: true
//            }
//        }

//        Item {
//            id: textContainer

//            width: isLandscape ? slideBase.width/2 : slideBase.width
//            height: isLandscape ? slideBase.height : slideBase.height/2

//            Flickable {
//                anchors.fill: parent
//                contentHeight:  textColumn.height + units.gu(2)
//                clip: true

//                Column {
//                    id: textColumn

//                    spacing: units.gu(2)
//                    anchors {
//                        top: parent.top
//                        left: parent.left
//                        right: parent.right
//                        leftMargin: units.gu(2)
//                        rightMargin: units.gu(2)
//                    }

//                    Label {
//                        id: introductionText
//                        text: i18n.tr("Welcome to Calculator ")
//                        textSize: Label.XLarge
//                        horizontalAlignment: Text.AlignHCenter
//                        wrapMode: Text.WordWrap
//                        width: parent.width
//                    }

//                    Label {
//                        id: bodyText
//                        text: i18n.tr("Enjoy the power of math by using Calculator.")
//                        wrapMode: Text.WordWrap
//                        horizontalAlignment: Text.AlignHCenter
//                        width: parent.width
//                    }
//                }
//            }
//        }
//    }
//}
Component {
    id: slide1

    SlideBase {
        slideTitle: i18n.tr("Welcome to Calculator")
        slideDescription: i18n.tr("Enjoy the power of math by using Calculator.")
        slideImage: "../graphics/ubuntu-calculator-app.png"
    }
}
