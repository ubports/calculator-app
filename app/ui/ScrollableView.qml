import QtQuick 2.3

Flickable {
    id: flickable

    default property alias data: column.children
    contentHeight: column.childrenRect.height
    boundsBehavior: Flickable.DragOverBounds

    property double initContentY

    onMovementStarted: {
        initContentY = contentY;
    }

    onMovementEnded: {
        if (contentY <= 0) {
            return;
        }
        var posy = flickable.height + flickable.visibleArea.yPosition * flickable.contentHeight
        // FIXME:
        // It's column.width - units.gu(2) because of the weird alignment of TextField
        var obj = column.childAt(column.width - units.gu(2), posy)
        if (Math.abs(posy - obj.y) < obj.height / 2) {
            console.log("scroll up", obj.y);
            flickable.contentY = obj.y - flickable.height
        } else {
            console.log("scroll down", obj.y);
            flickable.contentY = obj.y + obj.height - flickable.height
        }
    }

    Behavior on contentY {
        NumberAnimation { duration: 300; easing.type: Easing.OutQuad}
    }

    Column {
        id: column
        anchors {
            left: parent.left
            right: parent.right
        }
        spacing: 0
    }
}
