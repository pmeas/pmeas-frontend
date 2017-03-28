import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

Window {
    id: settingsWindow
    title: qsTr( "Settings" );
    visible: false;
    color: "#332f2f";
    x: root.x + ( ( root.width / 2 ) - ( width / 2 ) );
    y: root.y + ( ( root.height / 2 ) - ( height / 2 ) );
    width: 300;
    height: 250;

    modality: Qt.ApplicationModal;
    flags: Qt.Window;

    ColumnLayout {
        id: devicesColumn;
        anchors { centerIn: parent; }
        spacing: 12;

        Text {
            text: "Audio Input";
            color: "#f1f1f1";
        }

        ComboBox {
            model: [ "Microphone", "Guitar" ];
            implicitWidth: 150;
        }

        Text {
            text: "Audio Output";
            color: "#f1f1f1";
        }

        ComboBox {
            model: [ "ALSA (3.5mm)", "USB" ];
            implicitWidth: 150;
        }

    }

    RowLayout {
        anchors {
            top: devicesColumn.bottom;
            horizontalCenter: parent.horizontalCenter;
            margins: 12;
        }

        Button {
            id: cancelSettings;
            anchors {
                //right: sendSettings.left;
                rightMargin: 20;
            }
            width: 75;
            height: 35;

            Text {
                anchors.centerIn: parent;
                text: qsTr("Cancel");
            }

            onClicked: {
                console.log("Cancel settings page");
                settingsWindow.close();
            }
        }

        Button {
            id: sendSettings;
            width: 75;
            height: 35;
            Text {
                anchors.centerIn: parent;
                text: qsTr("Accept");
            }

            onClicked: {
                console.log("Update server ports here :^)");
            }
        }
    }
}
