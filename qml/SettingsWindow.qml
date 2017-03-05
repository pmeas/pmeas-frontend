import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

Window {
    id: settingsWindow
    title: qsTr( "Settings" );
    visible: false;
    x: root.x + ( ( root.width / 2 ) - ( width / 2 ) );
    y: root.y + ( ( root.height / 2 ) - ( height / 2 ) );
    width: 300;
    height: 200;

    //modality: Qt.WindowModal;
    flags: Qt.WindowStaysOnTopHint | Qt.Window;

    color: "#E3E3E5";

    ColumnLayout {


        anchors { centerIn: parent; }
        //RowLayout {
        //    anchors.centerIn: parent;
            spacing: 12;

            Text {
                text: "Audio Input";
            }

            ComboBox {
                model: [ "Microphone", "Guitar" ];
                implicitWidth: 150;
            }

            Text {
                text: "Audio Output";
            }

            ComboBox {
                model: [ "Speakers", "Surround Sound" ];
                implicitWidth: 150;
            }

            RowLayout {

                Rectangle {
                    id: cancelSettings;
                    anchors.right: sendSettings;
                    width: 75;
                    height: 50;
                    color: "#FFFFFF";
                    border.color: "#000000";
                    border.width: 1;
                    radius: 4;

                    Text {
                        anchors.centerIn: parent;
                        text: qsTr("Cancel");
                    }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            console.log("Cancel settings page");
                        }

                        onPressed: {
                            parent.color = "#E19854";
                        }

                        onReleased: {
                            parent.color = "#FFFFFF";
                        }
                    }
                }

                Rectangle {
                    id: sendSettings;
                    width: 75;
                    height: 50;
                    color: "#FFFFFF";
                    border.color: "#000000";
                    border.width: 1;
                    radius: 4;

                    Text {
                        anchors.centerIn: parent;
                        text: qsTr("Update");
                    }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            console.log("Update server ports here :^)");
                        }

                        onPressed: {
                            parent.color = "#E19854";
                        }

                        onReleased: {
                            parent.color = "#FFFFFF";
                        }

                    }
                }

            }

        //}
    }
}
