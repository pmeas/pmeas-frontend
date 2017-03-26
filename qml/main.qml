import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

import Networking 1.0


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
        socketServer.lostConnection.connect(function () {
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

            Layout.fillWidth: true;

            anchors {

                bottom: parent.bottom;
            }

            height: 25;

            color: "#E39A53";

            Text {
                anchors { centerIn: parent; }
                text: qsTr( "Submit Me, Pls :(" );
                color: "#ffffff";
            }

            MouseArea {
                anchors { fill: parent; }
                onClicked: {
                    console.log( "Clicked the submit button" );
                    Bridge.broadcastDatagram();
                }
                onEntered: {
                    parent.color = "#01891e";
                }
                onExited: {
                    parent.color = "#E39A53";
                }
            }
        }
    }

    property var splashWindow: Splash {
        onTimeout: root.visible = true;


    }
}
