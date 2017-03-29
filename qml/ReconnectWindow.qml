import QtQuick 2.3
import QtQuick.Window 2.0

Window {
    id: reconnectWindow;
    visible: false;
    x: root.x + ( ( root.width / 2 ) - ( width / 2 ) );
    y: root.y + ( ( root.height / 2 ) - ( height / 2 ) );
    width: 500;
    height: 250;

    modality: Qt.ApplicationModal;
    flags: Qt.Window | Qt.FramelessWindowHint;

    Text {
        anchors { centerIn: parent; }
        text: "Connection Lost, attempting reconnection...";
    }
}
