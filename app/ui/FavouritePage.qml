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
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

import "../engine"
import "../upstreamcomponents"

Page {
    anchors.fill: parent

    property var removedFavourites: []

    head.backAction: Action {
        iconName: "back"
        onTriggered: {
            if (removedFavourites.length > 0) {
                calculationHistory.removeFavourites(removedFavourites);
            }
            mainStack.pop();
        }
    }

    EmptyState {
        title: i18n.tr("No favourites")
        subTitle: i18n.tr("Swipe calculations to the left\nto mark as favourites")
        iconName: "starred"
        anchors.centerIn: parent
        visible: calculationHistory.numberOfFavourites == 0;
    }

    ListView {
        id: favouriteListview
        anchors.fill: parent
        model: calculationHistory.getContents();

        delegate: ListItem.Empty {
            visible: model.isFavourite && model.dbId != -1
            height: visible ? units.gu(6) : 0

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (favouriteIcon.name == "starred") {
                        favouriteIcon.name = "non-starred";
                        removedFavourites.push(model.dbId);
                    } else {
                        favouriteIcon.name = "starred";
                        removedFavourites.splice(removedFavourites.indexOf(model.dbId), 1);
                    }
                }
            }

            RowLayout {
                height: units.gu(5)
                spacing: units.gu(2)
                width: parent.width - units.gu(4)
                anchors.horizontalCenter: parent.horizontalCenter
                Icon {
                    id: favouriteIcon
                    height: parent.height - units.gu(2)
                    width: height

                    Layout.alignment: Qt.AlignVCenter

                    name: "starred"
                }

                Text {
                    text: (model.favouriteText.length === 0) ?
                              Qt.formatDateTime(new Date(model.date), i18n.tr("dd MMM yyyy")) :
                              model.favouriteText
                    Layout.fillWidth: true
                }

                Text {
                    text: model.result
                    font.bold: true
                }
            }
        }
    }
}
