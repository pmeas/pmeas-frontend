import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

import Theme 1.0

Window {
    id: initPortsWindow
    title: qsTr( "Select audio devices" );
    visible: false;
    x: root.x + ( ( root.width / 2 ) - ( width / 2 ) );
    y: root.y + ( ( root.height / 2 ) - ( height / 2 ) );
    width: 600;
    height: 300;
    modality: Qt.ApplicationModal;
    flags: Qt.Dialog;
    color: "#332f2f";

    onVisibleChanged: {
        if(visible === true) {
            bridge.getPorts();
        }
    }

    ColumnLayout {
        id: devicesColumn;
        anchors {
            centerIn: parent;
            verticalCenterOffset: -20;
        }
        spacing: 12;

        Text {
            text: "Audio Input";
            color: "#ffffff";
        }

        ComboBox {
            id: inputs;
            implicitWidth: initPortsWindow.width * 0.75;
            model: bridge.inports;
        }

        Text {
            text: "Audio Output";
            color: "#ffffff";
        }

        ComboBox {
            id: outputs;
            implicitWidth: settingsWindow.width * 0.75;
            model: bridge.outports;
        }

    }

    RowLayout {
        anchors {
            top: devicesColumn.bottom;
            horizontalCenter: devicesColumn.horizontalCenter;
            margins: 12;
        }

        Rectangle {
            id: sendSettings;
            width: 130;
            height: 40;
            radius: 3;
            color: "transparent";
            border {
                width: 2;
                color: "#5a5a5a"
            }

            Text {
                text: qsTr("Accept");
                anchors.centerIn: parent;
                font {
                    bold: true;
                    pixelSize: 12;
                }
                color: "#f1f1f1";
            }

            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    bridge.currentIn = inputs.currentText;
                    bridge.currentOut = outputs.currentText;
                    bridge.sendPorts();
                    initPortsWindow.close();
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
    }
}
