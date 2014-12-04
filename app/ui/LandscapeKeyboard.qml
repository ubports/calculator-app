import QtQuick 2.3
import Ubuntu.Components 1.1

CalcKeyboard {
    id: calcKeyboard

    KeyboardPage {
       buttonRatio: mainListView.height > mainListView.width ? 0.5 : 0.4

       model: new Array(
            { text: "dummy", wFactor: 3},
            { text: "dummy2",  hFactor: 3 },
            { text: "a" },
            { text: "b" },
            { text: "c" },
            { text: "d" },
            { text: "e" },
            { text: "f" }
        )
    }
}
