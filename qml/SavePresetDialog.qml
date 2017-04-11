import QtQuick 2.7
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

Item {
    id: savePresetDialog;
    height: savePopup.height;
    width: savePopup.width;

    visible: false;

    MouseArea {
        anchors.fill: parent;
        propagateComposedEvents: false;

    }

    //property alias color: savePopup.color;

    function open() {
        visible = true;
    }

    function close() {
        visible = false;
    }

    anchors {
        bottom: parent.top;
        bottomMargin: 12;
        horizontalCenter: parent.horizontalCenter;
    }

    Rectangle {
        id: savePopup;
        z: 100;
        height: 45;
        visible: parent.visible;
        width: saveRow.width + 24;

        radius: 6;


        Row {
            id: saveRow;
            anchors {
                centerIn: parent;
            }
            spacing: 12;

            TextField {
                id: textField;
                implicitHeight: 25;
                implicitWidth: 150;
                placeholderText: "Save As..."
                focus: savePresetDialog.visible === true;
            }
            Button {
                implicitHeight: 25;
                implicitWidth: 50;
                text: "Save";

                onClicked: {
                    effectsColumnArea.effectsListView.model.saveSetlist( textField.text );
                    savePresetDialog.close();
                }
            }

        }

        Rectangle {
            anchors {
                bottom: parent.bottom;
                bottomMargin: -height / 2;
                horizontalCenter: parent.horizontalCenter;
            }

            height: 12;
            width: height;
            rotation: 45;
        }
    }

    DropShadow {
        anchors.fill: savePopup
        source: savePopup
        horizontalOffset: 0
        verticalOffset: 2;
        radius: 8.0 * 2
        samples: 16;
        color: "#80000000"
    }
}
