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
import QtQuick.LocalStorage 2.0

Item {
    property var calculationHistoryDatabase: null
    readonly property int lastDatabaseVersion: 1
    property int numberOfFavourites: 0

    ListModel {
        id: history

        Component.onCompleted: {
            getCalculations(function(calc) {
                // Also if isFavourite is set as BOOL, LocalStorage saves it as
                // int, so we need to convert it before adding the calc to
                // the history
                if (calc.isFavourite === 1) {
                    calc.isFavourite = true;
                    numberOfFavourites++;
                } else {
                    calc.isFavourite = false;
                }
                history.append(calc);
            });
        }

        ListElement {
            dbId: -1
            formula: ''
            result: ''
            date: 0
            isFavourite: false
            favouriteText: ''
        }
    }

    Timer {
        id: timer
        interval: 500
        property var execute: []
        onTriggered: {
            for (var i = 0; i < execute.length; i++) {
                execute[i]();
            }
            execute = [];
        }
    }

    function openDatabase() {
        // Check if the database was already opened
        if (calculationHistoryDatabase !== null) return;

        calculationHistoryDatabase = LocalStorage.openDatabaseSync(
            "com.ubuntu.calculator_reboot", "", "", 5000);

        // Update (or create) the database if needed
        if (calculationHistoryDatabase.version !== lastDatabaseVersion) {
            upgradeDatabase(calculationHistoryDatabase.version);
        }
    }

    function upgradeDatabase(currentDatabaseVersion) {
        // Array with all the SQL needed to create database and update versions
        var sqlcode = [
            'CREATE TABLE IF NOT EXISTS Calculations(
                dbId INTEGER PRIMARY KEY,
                formula TEXT NOT NULL,
                result TEXT NOT NULL,
                date INTEGER NOT NULL DEFAULT 0,
                isFavourite BOOL DEFAULT false,
                favouriteText TEXT
            )'
        ];

        // Start the upgrade
        calculationHistoryDatabase.changeVersion(currentDatabaseVersion,
            lastDatabaseVersion, function(tx) {
                // Create the database
                if (currentDatabaseVersion < lastDatabaseVersion) {
                    tx.executeSql(sqlcode[0]);
                    console.log("Database upgraded to " + lastDatabaseVersion.toString());
                }
            }
        );
    }

    function getCalculations(callback) {
        openDatabase();

        // Do a transaction to take all calculations
        calculationHistoryDatabase.transaction(
            function (tx) {
                var results = tx.executeSql('SELECT * FROM Calculations');

                for (var i = 0; i < results.rows.length; i++) {
                    callback(results.rows.item(i));
                }
            }
        );
    }

    function addCalculationToScreen(formula, result, isFavourite, favouriteText) {
        // The function add the last formula to the model, and leave to
        // addCalculationToDatabase the job to add it to the database
        // that is called only after the element has been added to the
        // model
        if (isFavourite) {
            numberOfFavourites++;
        }
        var date = Date.now();
        history.append({"formula": formula,
            "result": result,
            "date": date,
            "isFavourite": isFavourite,
            "favouriteText": favouriteText});
        var index = history.count - 1;
        // TODO: move this function to a plave that retards the execution to
        // improve performances
        timer.execute.push(function() {
            calculationHistory.addCalculationToDatabase(formula, result, date, index, isFavourite, favouriteText);
        });
        timer.start();
    }

    function addCalculationToDatabase(formula, result, date, index, isFavourite, favouriteText) {
        openDatabase();
        calculationHistoryDatabase.transaction(
            function (tx) {
                var results = tx.executeSql('INSERT INTO Calculations (
                    formula, result, date, isFavourite, favouriteText) VALUES(
                    ?, ?, ?, ?, ?)',
                    [formula, result, date, isFavourite, favouriteText]
                );
                // we need to update the listmodel unless we would have dbId = 0 on the
                // last inserted item
                history.setProperty(index, "dbId", parseInt(results.insertId));
            }
        );
    }

    function updateCalculationInDatabase(listIndex, dbId, isFavourite, favouriteText) {
        openDatabase();
        calculationHistoryDatabase.transaction(
            function (tx) {
                var results = tx.executeSql('UPDATE Calculations
                    SET isFavourite=?, favouriteText=?
                    WHERE dbId=?',
                    [isFavourite, favouriteText, dbId]
                );
                if (!history.get(listIndex).isFavourite && isFavourite) {
                    numberOfFavourites++;
                }
                if (history.get(listIndex).isFavourite && !isFavourite) {
                    numberOfFavourites--;
                }
                history.setProperty(listIndex, "isFavourite", isFavourite);
                history.setProperty(listIndex, "favouriteText", favouriteText);
            }
        );
    }

    function getContents() {
        return history;
    }

    function deleteCalc(dbId, id) {
        openDatabase();
        if (history.get(id).isFavourite) {
            numberOfFavourites--;
        }
        history.setProperty(id, "dbId", -1);

        timer.execute.push(function () {
            calculationHistoryDatabase.transaction(
                function (tx) {
                    tx.executeSql('DELETE FROM Calculations WHERE dbId = ?', [dbId]);
                }
            );
        });
        timer.start();
    }

    function removeFavourites(removedFavourites) {
        openDatabase();
        var sql = "UPDATE Calculations SET isFavourite = 'false' WHERE dbId IN (";
        var removed = removedFavourites[0];
        history.setProperty(removedFavourites[0], "isFavourite", false);
        removedFavourites.splice(0, 1);
        numberOfFavourites--;

        for (var index in removedFavourites) {
            numberOfFavourites--;
            history.setProperty(removedFavourites[index], "isFavourite", false);
            removed += "," + removedFavourites[index];
        }

        sql += removed + ")";

        calculationHistoryDatabase.transaction(
            function (tx) {
                var result = tx.executeSql(sql);
            }
        );
    }
}
