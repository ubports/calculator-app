/*
 * Copyright (C) 2012-2015 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.2

VisualDataModel {
    id: visualModel

    groups: [
        VisualDataGroup {
            id: selectedGroup

            name: "selected"
        }
    ]

    property Item currentSwipedItem: null
    property alias selectedItems: selectedGroup
    // This property holds if the selection will accept multiple items or single items
    property bool multipleSelection: true

    // This property holds a list with the index of selected items
    property string state: ""
    readonly property bool isInSelectionMode: state === "selection"

    function updateSwipeState(item) {
        if (item.swipping) {
            return;
        }

        if (item.swipeState !== "Normal") {
            if (currentSwipedItem !== item) {
                if (currentSwipedItem) {
                    currentSwipedItem.resetSwipe();
                }
                currentSwipedItem = item;
            } else if (item.swipeState !== "Normal" && currentSwipedItem === item) {
                currentSwipedItem = null;
            }
        }
    }
    /*!
     This handler is called when the selection mode is finished without be canceled
     */
    signal selectionDone(var items)
    /*!
     This handler is called when the selection mode is canceled
     */
    signal selectionCanceled()

    /*!
     Start the selection mode on the list view.
     */
    function startSelection() {
        state = "selection";
    }
    /*!
     Check if the item is selected
     Returns true if the item was marked as selected or false if the item is unselected
     */
    function isSelected(item) {
        if (item && item.VisualDataModel) {
            return (item.VisualDataModel.inSelected === true);
        } else {
            return false;
        }
    }
    /*!
     Mark the item as selected
     Returns true if the item was marked as selected or false if the item is already selected
     */
    function selectItem(item) {
        if (item.VisualDataModel.inSelected) {
            return false;
        } else {
            if (!multipleSelection) {
                clearSelection();
            }
            item.VisualDataModel.inSelected = true;
            return true;
        }
    }
    /*!
     Remove the index from the selected list
     */
    function deselectItem(item) {
        var result = false;
        if (item.VisualDataModel.inSelected) {
            item.VisualDataModel.inSelected = false;
            result = true;
        }
        return result;
    }
    /*!
     Finish the selection mode with sucess
     */
    function endSelection() {
        selectionDone(visualModel.selectedItems);
        clearSelection();
        state = "";
    }
    /*!
     Cancel the selection
     */
    function cancelSelection() {
        selectionCanceled();
        clearSelection();
        state = "";
    }
    /*!
     Remove any selected item from the selection list
     */
    function clearSelection() {
        if (selectedItems.count > 0) {
            selectedItems.remove(0, selectedItems.count);
        }
    }
    /*!
     Select all items in the list
     */
    function selectAll() {
        if (multipleSelection && selectedItems.count < visualModel.items.count) {
            visualModel.items.addGroups(0, visualModel.items.count, ["selected"] );
        } else {
            clearSelection();
        }
    }

    function getModelIndexFromIndex(index) {
        return visualModel.modelIndex(index);
    }
}
