import QtQuick 2.3
import Ubuntu.Components 1.1

CalcKeyboard {
    id: calcKeyboard

    KeyboardPage {
       buttonRatio: 1
       columns: 6

       model: new Array(
            { text: "dummy", wFactor: 3},
            { text: "dummy2", hFactor: 2 },
            { text: "a" },
            { text: "b" },
            { text: "c" },
            { text: "d" },
            { text: "e" },
            { text: "f" },
            { text: "x" },
            { text: "dummy3", wFactor: 3},
            { text: "y" },
            { text: "dummy4", hFactor: 2 },
            { text: "x" },
            { text: "a" },
            { text: "b" },
            { text: "dummy5", wFactor: 2 },
            { text: "foo" }
        )
    }
}
