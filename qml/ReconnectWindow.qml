import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 2.1

Window {
    id: reconnectWindow;
    visible: false;
    x: root.x + ( ( root.width / 2 ) - ( width / 2 ) );
    y: root.y + ( ( root.height / 2 ) - ( height / 2 ) );
    width: 600;
    height: 300;

    modality: Qt.ApplicationModal;
    flags: Qt.Dialog;

    color: "#332f2f";

    Rectangle {
        anchors {
            top: errMsg.bottom;
            horizontalCenter: errMsg.horizontalCenter;
            margins: 12;
        }

        width: 130;
        height: 40;
        radius: 3;
        color: "transparent";
        border {
            width: 2;
            color: "#aa5a5a"
        }

        Text {
            anchors.centerIn: parent;
            text: qsTr("Quit");
            font {
                bold: true;
                pixelSize: 12;
            }
            color: "#f1f1f1";
        }

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                Qt.quit();
            }
            onPressed: {
                parent.color = Theme.enabledButtonColor;
            }
            onReleased: {
                parent.color = "transparent";
            }
            onEntered: {
                parent.border.color = Theme.highlighterColor;
            }
            onExited: {
                parent.border.color = "#5a5a5a";
            }
        }
    }
    Text {
        id: errMsg;
        anchors { centerIn: parent; }
        text: "Connection lost, attempting to reconnect...";
    }
}
