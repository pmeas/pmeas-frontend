import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import Theme 1.0

Rectangle {
    id: controlBar;

    height: 40;
    color: "transparent"

    RowLayout {

        anchors {
            fill: parent;

            leftMargin: 12;
            rightMargin: 12;
            bottomMargin: 12;
        }

        spacing: 6;

        Rectangle {
            id: settingsArea;

            width: 150;

            Layout.fillHeight: true;

            anchors {
                left: parent.left;
            }

            radius: 3;

            color: "transparent";

            border {
                width: 2;
                color: "#5a5a5a";
            }

            RowLayout {
                anchors.centerIn: parent;
                spacing: 12;
                Image {
                    id: settingsIcon;
                    source: "./icons/cog-2x.png";
                    height: 14;
                    width: height;
                    sourceSize {
                        width: 14;
                        height: 14;
                    }
                }

                Text {
                    text: qsTr( "Settings" );
                    font {
                        bold: true;
                        pixelSize: 12;
                    }
                    color: "#f1f1f1";
                }
            }

            SettingsWindow {
                id: settingsWindow;
            }

            MouseArea {
                anchors.fill: settingsArea;
                onClicked: {
                    settingsWindow.show();
                }
                onPressed: {
                    parent.color = Theme.enabledButtonColor;
                }
                onReleased: {
                    parent.color = Theme.inactiveButtonColor;
                }
            }
        }

        Rectangle{
            id: savePreset
            width: 150;

            Layout.fillHeight: true;

            color: "transparent";
            radius: 3;

            border {
                width: 2;
                color: "#5a5a5a";
            }

            FileDialog {
                id: saveSetlistDialog;
                nameFilters: ["JSON files (*.json)"];
            }
            RowLayout{
                anchors {
                    centerIn: parent;
                    leftMargin: 30
                }

                spacing: 12;

                Image {
                    source: "./icons/document-2x.png";
                    sourceSize {
                        height: 14;
                        width: height;
                    }

                }
                Text {
                    text: qsTr( "Save Preset" );
                    font {
                        bold: true;
                        pixelSize: 12;
                    }
                    color: "#f1f1f1";
                }
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        saveSetlistDialog.open();
                    }
                    onPressed: {
                        savePreset.color = Theme.enabledButtonColor;
                    }
                    onReleased: {
                        savePreset.color = Theme.inactiveButtonColor;
                    }
                }
            }
        }

        Rectangle{
            id: loadPreset
            width: 150;

            Layout.fillHeight: true;

            color: "transparent";
            radius: 3;

            border {
                width: 2;
                color: "#5a5a5a";
            }

            FileDialog {
                id: loadSetlistDialog;
                nameFilters: ["JSON files (*.json)"];
                onAccepted: {
                    enabledEffectsListView.model.loadSetlist( fileUrl.toString().replace( "file://", "" ) )
                }
            }

            RowLayout{
                anchors {
                    centerIn: parent;
                    leftMargin: 30
                }
                spacing: 12;
                Image {
                    source: "./icons/data-transfer-upload-2x.png";
                    sourceSize {
                        height: 14;
                        width: height;
                    }
                }
                Text {
                    text: qsTr( "Load Preset" );
                    font {
                        bold: true;
                        pixelSize: 12;
                    }
                    color: "#f1f1f1";
                }
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        loadSetlistDialog.open();
                    }
                    onPressed: {
                        loadPreset.color = Theme.enabledButtonColor;
                    }
                    onReleased: {
                        loadPreset.color = Theme.inactiveButtonColor;
                    }
                }
            }
        }

        Rectangle{
            id: tutorial;
            width: 150;
            Layout.fillHeight: true;

            color: "transparent";
            radius: 3;

            border {
                width: 2;
                color: "#5a5a5a";
            }

            RowLayout{
                anchors {
                    centerIn: parent;
                    leftMargin: 35
                }
                spacing: 12;
                Image {
                    source: "./icons/question-mark.png";
                    sourceSize {
                        height: 14;
                        width: height;
                    }
                }
                Text {
                    text: qsTr( "Tutorial" );
                    font {
                        bold: true;
                        pixelSize: 12;
                    }
                    color: "#f1f1f1";
                }
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        //TODO: Open tutorial popup
                    }
                    onPressed: {
                        tutorial.color = Theme.enabledButtonColor;
                    }
                    onReleased: {
                        tutorial.color = Theme.inactiveButtonColor;
                    }
                }
            }
        }

        Rectangle{
            id: volumeControl;

            Layout.fillHeight: true;

            anchors {
                right: parent.right;
            }

            Layout.fillWidth: true;

            color: "transparent";

            RowLayout{

                anchors {
                    centerIn: parent;
                }

                spacing: 12;

                Image {
                    id: speakerIcon
                    source: "./icons/speaker-icon.png"
                    sourceSize {
                        height: 18;
                        width: height;
                    }
                }

                PSlider {
                    implicitWidth: 125;
                    height: 17;
                }
            }
        }
    }
}
