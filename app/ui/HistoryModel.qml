/*
 * Copyright (C) 2014 Canonical, Ltd.
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
import QtQuick 2.3
import Ubuntu.Components 1.1
import U1db 1.0 as U1db

Item {
    U1db.Database {
        id: calcDatabase
        path: "com.ubuntu.calculator"
    }

    U1db.Document {
        id: exampleCalc
        database: calcDatabase
    }

    U1db.Index {
        id: index
        database: calcDatabase
        name: "byDocId"
        expression: ["calc", "result"]
    }

    U1db.Query {
        id: query
        index: index
    }

    SortFilterModel {
        id: sortedHistory
        model: query
        sort.property: "docId"
        sort.order: Qt.DescendingOrder
    }

    function createCalc(calc, result) {
        var docId = calcDatabase.listDocs().length;
        var newDocument = exampleCalc;

        newDocument.docId = docId;
        newDocument.contents = {
            'calc': calc,
            'result': result
        };

        newDocument.create = true;
    }

    function getContents() {
        return sortedHistory;
    }

    function deleteCalc(docId) {
        calcDatabase.deleteDoc(docId);
    }
}
