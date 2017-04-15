import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 2.1

Window {
    id: reconnectWindow;
    visible: false;
    x: root.x + ( ( root.width / 2 ) - ( width / 2 ) );
    y: root.y + ( ( root.height / 2 ) - ( height / 2 ) );
    width: 500;
    height: 250;

    modality: Qt.ApplicationModal;
    flags: Qt.Window | Qt.FramelessWindowHint;

    Button {
        text: "CLOSE APP"
        onClicked: Qt.quit()
    }

    Text {
        anchors { centerIn: parent; }
        text: "Connection Lost, attempting reconnection...";
    }
}
