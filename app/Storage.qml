/*
 * Copyright 2013 Canonical Ltd.
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
import QtQuick.LocalStorage 2.0

Item {
    property var db: null

    function openDB() {
        if(db !== null) return;

        db = LocalStorage.openDatabaseSync("ubuntu-calculator-app", "", "Default Ubuntu touch calculator", 100000);
        if (db.version !== "0.2")
            upgradeDB(db.version);
    }

    /* We need this function because db.version is in the .ini file, that is update only by Javascript Garbage Collection.
     * So, we have to upgrade from actual version to the last version using only once db.changeVersion.
     * To avoid to have a lot of switch and spaghetti-code, this function allow to add new db version without modify old sql
     *
     * IMPORTANT: NUMBER OF VERSION HAVE TO BE INT (e.g. 0.1, not 0.1.1)
     */
    function upgradeDB() {
        // This is the array with all the sql code, insert your update at the last
        var sqlcode = [
            'CREATE TABLE IF NOT EXISTS Calculations(id INTEGER PRIMARY KEY, calc TEXT)',
            'ALTER TABLE Calculations ADD insertDate INTEGER NOT NULL DEFAULT 0'
        ]

        // This is the last version of the DB, remember to update when you insert a new version
        var lastVersion = "0.2";

        // Hack for change old numeration with new one
        if (db.version === "0.1.1") {
            db.changeVersion("0.1.1", "0.2");
            console.log("Fixed DB!");
        }

        // So, let's start the version change...
        db.changeVersion(db.version, lastVersion,
            function(tx) {
                if (db.version < 0.1) {
                    tx.executeSql(sqlcode[0]);
                    console.log('Database upgraded to 0.1');
                }
                if (db.version < 0.2) {
                    tx.executeSql(sqlcode[1]);
                    console.log('Database upgraded to 0.2');
                }
                
                /* This is the structure of the update:
                 * n is the number of version that sql update to
                 * m is the number of the sql element in the array. Remember that the number of the first element of array is 0 ;)
                if (db.version < n) {
                    tx.executeSql(sqlcode[m]);
                    console.log('Database upgraded to n');
                }
                */
            }); // Finish db.changeVersion
    }

    function getCalculation(dbId) {
        openDB();
        var calc;
        db.transaction(
                    function(tx){
                        var calculation = tx.executeSql('SELECT calc FROM Calculations WHERE id = ?', dbId);
                        calc = JSON.parse(calculation.rows.item(0).calc);
                    });
        return calc;
    }

    function getCalculations(callback){
        openDB();
        db.transaction(
                    function(tx){
                        var res = tx.executeSql('SELECT * FROM Calculations');
                        for(var i=res.rows.length - 1; i >= 0; i--){
                            var obj = JSON.parse(res.rows.item(i).calc);
                            obj.dbId = res.rows.item(i).id;
                            // TRANSLATORS: this is a time formatting string,
                            // see http://qt-project.org/doc/qt-5/qml-qtqml-date.html#details for valid expressions
                            obj.dateText = Qt.formatDateTime(parseDate(res.rows.item(i).insertDate), i18n.tr("MMM dd yyyy, hh:mm"))

                            if (!('mainLabel' in obj))
                                obj.mainLabel = ''

                            callback(obj);
                        }
                    }
                    );
    }

    function parseDate(dateAsStr) {
        return new Date(dateAsStr);
    }

    function saveCalculations(calculations){
        openDB();
        var res;
        db.transaction( function(tx){
            var r = tx.executeSql('INSERT INTO Calculations(calc, insertDate) VALUES(?, ?)', [JSON.stringify(calculations[0].calc), calculations[0].date]);
            res = r.insertId;
        });
        return res;
    }

    function updateCalculation(calculation, dbId){
        openDB();
        db.transaction(
                    function(tx){
                        tx.executeSql('UPDATE Calculations SET calc = ? WHERE id = ?', [JSON.stringify(calculation[0].calc), dbId]);
                    });
    }

    function removeCalculation(calc){
        openDB();
        db.transaction(function(tx){
            tx.executeSql('DELETE FROM Calculations WHERE id = ?', [calc.dbId]);
        });
    }
}
