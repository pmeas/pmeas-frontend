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

    property int tutorialState: 0;

    ReconnectWindow {
        id: reconnectWindow;
    }

    Component.onCompleted: {
        bridge.lostConnection.connect(function () {
            console.log("Lost Connection");
            reconnectWindow.show();
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


        ControlBar {
            id: controlBar;

            Layout.fillWidth: true;
            anchors {
                bottom: parent.bottom
            }


        }

    }

    Rectangle {
        id: tutorialTip;
        width: 400;
        height: 250;
        x: (root.width - width) / 2;
        y: (root.height - height) / 2;
        Text {
            id: tutorialText;
            text: qsTr("Welcome to the PMEAS System!");
        }
        visible: false;

        Rectangle {
            id: tutorialExit;
            anchors {
                bottom: parent.bottom;
                left: parent.left;
                leftMargin: 20;
                bottomMargin: 10;
            }
            width: 50;
            height: 25;
            Text {
                anchors.centerIn: parent;
                text: qsTr("Exit");
            }

            MouseArea {
                anchors.fill: parent;

                onClicked: {
                    tutorialState = 0;
                    tutorialTip.visible = false;
                    tutorialText.text = "Welcome to the PMEAS System!";
                    tutorialTip.width = 400;
                    tutorialTip.height = 250;
                    tutorialTip.x = (root.width - tutorialTip.width) / 2;
                    tutorialTip.y = (root.height - tutorialTip.height) / 2;
                    tutorialNext.visible = true;
                }
            }
        }

        Rectangle {
            id: tutorialNext;
            anchors {
                bottom: parent.bottom;
                right: parent.right;
                rightMargin: 20;
                bottomMargin: 10;
            }
            width: 50;
            height: 25;
            Text {
                anchors.centerIn: parent;
                text: qsTr("Next");
            }

            MouseArea {
                anchors.fill: parent;

                onClicked: {
                    if(tutorialState === 0) {
                        console.log("Next button clicked");
                        tutorialText.text = "This area is where all the effects are located.\n" +
                                "Drag an effect into the area above to enable the effect!";
                        tutorialTip.x = effectsColumnArea.allEffectsAlias.x + 150;
                        tutorialTip.y = effectsColumnArea.allEffectsAlias.y;
                        tutorialTip.width = 400;
                        tutorialTip.height = 75;
                        tutorialNext.visible = false;
                        tutorialState++;
                    } else {
                        tutorialState = 0;
                        tutorialTip.visible = false;
                        tutorialText.text = "Welcome to the PMEAS System!";
                        tutorialTip.width = 400;
                        tutorialTip.height = 250;
                        tutorialTip.x = (root.width - tutorialTip.width) / 2;
                        tutorialTip.y = (root.height - tutorialTip.height) / 2;
                        tutorialNext.visible = true;
                    }

                }
            }
        }
    }

    property var splashWindow: Splash {
        onTimeout: root.visible = true;


    }
}
