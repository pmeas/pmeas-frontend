import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2
import Networking 1.0
import QtQuick.Controls.Styles 1.4
import Theme 1.0


/*
 * This is the main entry point for the GUI.
 *
 * QML is a css-like environment where you can also add in javascript functions and code.
 * All of the widgets are actually rendered with OpenGL, and so can be themed and styled
 * in a dynamic way.
 *
 * Tips:
 *      1. Property assignment is done with the colon ':'
 *      2. The lefthand side property values like 'width' and 'height' are predefined inside of the widget.
 *      3. The righthand side of property values, which is the value, is a javascript expression. So
           you can do things like 'width: {
                                       var w = 300;
                                       return w;
                                   }
                                  '
 *      4. Do not use a 'this' variable insided of javascript functions, it's just a big no-no and
 *         QML will complain if you do, it really messes things up.
 */

// This is the root level of the GUI, hence why the 'id: root' exists.
ApplicationWindow {
    id: root;
    visible: false;
    width: 800;
    height: 600;
    minimumWidth: 800;
    minimumHeight: 600;

    color: "#332f2f";
    title: qsTr("Portable Multi-Effects Audio Software");

    Component.onCompleted: {
        bridge.lostConnection.connect(function () {
            console.log("Lost Connection");
        });
    }

    // This is defined in the cpp code and is then exposed to this QML enviroment
    Bridge {
        id: bridge;
    }

    ColumnLayout {

        anchors {
            fill: parent;
            margins: 1;
        }

        spacing: 10;

        RowLayout {

            Layout.fillWidth: true;
            Layout.fillHeight: true;
            spacing: 2;

            // This is defined in the QML file of the same name.
            EffectsColumnArea {
                id: effectsColumnArea;
                Layout.fillHeight: true;
                width: 170;

                color: "#332f2f";
                z: parameterColumnArea.z + 1;
            }

            Rectangle {
                anchors {
                    top: parent.top;
                    bottom: parent.bottom;
                    topMargin: 12;
                    bottomMargin: 8;
                }

                radius: 6;
                width: 2;
                opacity: 0.25;
                color: "black";
            }

            DirectionalBlur {
                anchors.fill: source;
                source: parameterColumnArea
                angle: 90
                length: 32
                samples: 24
                visible: inOutAnimation.running;
                cached: true;
            }

            // This is defined in the QML file of the same name.
            ParameterColumnArea {
                id: parameterColumnArea;
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                color: "#332f2f";

                visible: !inOutAnimation.running;

                property bool modelWasUndefined: false;

                Component.onCompleted: modelWasUndefined = ( effectsColumnArea.currentParameterModel === undefined );

                Connections {
                    target: effectsColumnArea;
                    onCurrentParameterModelChanged: {
                        if ( effectsColumnArea.currentParameterModel === undefined ) {
                            parameterColumnArea.modelWasUndefined = true;
                        }

                        if ( parameterColumnArea.modelWasUndefined ) {
                            parameterColumnArea.modelWasUndefined = false;
                        } else {
                            inOutAnimation.running = true;
                        }
                    }
                }


                SequentialAnimation {
                    id: inOutAnimation;
                    running: false
                    alwaysRunToEnd: true;

                    NumberAnimation {
                        target: parameterColumnArea;
                        property: "x";
                        to: root.width + 100;
                        duration: 150;

                    }
                    NumberAnimation {
                        target: parameterColumnArea;
                        property: "x";
                        to: 175;
                        duration: 200;
                        easing.type: Easing.OutCirc
                    }
                }

            }

        }

        Rectangle {
            id: controlBar
            Layout.fillWidth: true
            anchors {
                bottom: parent.bottom
            }

            height: 25
            color: "#444"

            Rectangle {
                id: settingsArea;
                height: parent.height;
                width: 120;
                anchors {
                    top: parent.top;
                    bottom: parent.bottom;
                    left: parent.left;
                }
                border.color: "#332f2f"
                border.width: 1
                color: parent.color;
                radius: 3;

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
                    anchors.fill: parent;
                    onClicked: {
                        settingsWindow.show();
                    }
                    onPressed: {
                        parent.color = "#6ff7c9";
                    }
                    onReleased: {
                        parent.color = "#444";
                    }
                }
            }

            Rectangle{
                id: savePreset
                height: parent.height;
                width: 120;
                anchors {
                    top: parent.top;
                    bottom: parent.bottom;
                    left: settingsArea.right;
                }
                border.color: "#332f2f"
                border.width: 1
                color: parent.color;

                FileDialog {
                    id: saveSetlistDialog;
                    nameFilters: ["JSON files (*.json)"];
                }
                RowLayout{
                    anchors.centerIn: parent;
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
                    }
                }
            }

            Rectangle{
                id: loadPreset
                height: parent.height;
                width: 120;
                anchors {
                    top: parent.top;
                    bottom: parent.bottom;
                    left: savePreset.right;
                }
                border.color: "#332f2f"
                border.width: 1
                color: parent.color;

                FileDialog {
                    id: loadSetlistDialog;
                    nameFilters: ["JSON files (*.json)"];
                    onAccepted: {
                        enabledEffectsListView.model.loadSetlist( fileUrl.toString().replace( "file://", "" ) )
                    }
                }

                RowLayout{
                    anchors.centerIn: parent;
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
                    }
                }
            }

            Rectangle{
                id: tutorial
                height: parent.height;
                width: 120;
                anchors {
                    top: parent.top;
                    bottom: parent.bottom;
                    left: loadPreset.right;
                }
                border.color: "#332f2f"
                border.width: 1
                color: parent.color;
                RowLayout{
                    anchors.centerIn: parent;
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
                            //Open tutorial popup
                        }
                    }
                }
            }

            Rectangle{
                id: volumeControl
                anchors {
                    top: parent.top;
                    bottom: parent.bottom;
                    left: tutorial.right;
                    right: controlBar.right;
                }
                border.color: "#332f2f"
                border.width: 1
                color: parent.color;
                RowLayout{
                    anchors.centerIn: parent;
                    spacing: 12;
                    Image {
                        id: speakerIcon
                        source: "./icons/speaker-icon.png"
                        sourceSize {
                            height: 18;
                            width: height;
                        }
                    }
                    Slider {
                        id: volumeSlider
                        anchors {
                            rightMargin: 20
                        }
                        minimumValue: 0
                        maximumValue: 100
                        value: 80
                        style: SliderStyle {
                            groove: Rectangle {
                                implicitWidth: 100
                                implicitHeight: 2
                                color: "#bdbebf"
                                radius: 2
                            }
                            handle: Rectangle {
                                anchors.centerIn: parent
                                color: "#fff"
                                border.color: "#000"
                                border.width: 1
                                implicitWidth: 15
                                implicitHeight: 15
                                radius: 12
                            }
                        }
                    }
                }
            }
        }
    }

    property var splashWindow: Splash {
        onTimeout: root.visible = true;


    }
}
