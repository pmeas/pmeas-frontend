import QtQuick 2.5
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {

    id: effectsColumnArea;

    property string currentModelKey: "chorusEffect";

    property var parameterMapModel: {
        "Distortion": [ "Distortion", "Tone", "Distortion", "Tone", "Distortion", "Tone", "Distortion", "Tone"],
        "Delay": [ "Feed Back", "Delay Time"],
        "Chorus": [ "Effect Level", "Rate", "Depth" ],
        "Harmonizer": [ "Balance", "Shift" ],
        "Frequency Shift": [ "Balance", "Pitch" ],
        "Reverb": [ "Effect Level", "Tone", "Delay", "Room Size"],
    }

    Rectangle  {
        color: "transparent";

        anchors {
            top: parent.top;
            bottom: parent.bottom;
            left: parent.left;
            right: parent.right;
        }

        ScrollBar {
            flickable: parameterListView;
            width: 8;
            anchors {
                top: parent.top;
                right: parent.right;
                bottom: parent.bottom;
                rightMargin: 18 ;
                topMargin: 32;
                bottomMargin: 18;

            }
        }

        ListView {
            id: parameterListView;
           // height: 500;
            interactive: true;
            anchors {
                fill: parent;
                margins: 0;
                topMargin: 32;
                bottomMargin: 18;
            }

            model: parameterMapModel[ currentModelKey ];
            spacing: 12;

            delegate: Rectangle {
                id: parameterBlock;
                height: 112;
                color: "transparent";
                radius: 6;

                property bool mouseEntered: false;

                border {
                    width: 3;
                    color: mouseEntered ? "#6ff7c9" : "#4a4a4a";
                }

                Behavior on border.color {
                    PropertyAnimation {
                        duration: 350;
                        easing.type: Easing.InCubic;
                    }
                }

                anchors {
                    left: parent.left;
                    right: parent.right;
                    margins: 48;
                }

                MouseArea {
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onEntered: mouseEntered = true;
                    onExited: mouseEntered = false;
                    z: 100;
                    propagateComposedEvents: true;

                    // Pass on the mouse events to the sliders below;
                    onClicked: mouse.accepted = false;
                    onPressed: mouse.accepted = false;
                    onReleased: mouse.accepted = false;
                    onDoubleClicked: mouse.accepted = false;
                    onPositionChanged: mouse.accepted = false;
                    onPressAndHold: mouse.accepted = false;
                }


                ColumnLayout {
                    anchors.centerIn: parent;
                    spacing: 12;

//                            Rectangle {
//                                color: "red";
//                                height: 50;
//                                width: 100

//                                anchors {
//                                    horizontalCenter: parent.horizontalCenter;
//                                }

                        Text {
                            //anchors.centerIn: parent;
                            anchors {
                                horizontalCenter: parent.horizontalCenter;
                            }

                            text: modelData;
                            font {
                                pixelSize: 15;
                                bold: true;
                            }

                            color: "#f1f1f1";
                        }

                   //}

                    Slider {
                        id: parameterSlider;
                        minimumValue: 0;
                        maximumValue: 100;
                        value: 50;
                        height: 17;
                        implicitWidth: parameterBlock.width * 0.75;
                        anchors {
                            horizontalCenter: parent.horizontalCenter;
                        }
                        stepSize: 1;

                        // This is extremely hacky and probably bad.
                        // This removes the annoying mouse scrolling that sliders have.
                        // It interferes with the ScrollView;
                        Component.onCompleted: {
                            for (var i = 0; i < children.length; ++i) {
                                if (children[i].hasOwnProperty("onVerticalWheelMoved")
                                        && children[i].hasOwnProperty("onHorizontalWheelMoved")) {
                                    children[i].destroy()
                                }
                            }
                        }

                        style: SliderStyle {
                            handle: Item {
                                height: parameterSlider.height;
                                width: height;

                                Rectangle {
                                    id: sliderHandleBackground;
                                    color: mouseEntered ? "#6ef6c0" : "#7a7a7a";
                                    anchors.fill: parent;
                                    radius: width / 2;

                                    Behavior on color {
                                        PropertyAnimation {
                                            duration: 350;
                                            easing.type: Easing.InCubic;
                                        }
                                    }

                                }

                                DropShadow {
                                    anchors.fill: source;
                                    horizontalOffset: 0;
                                    verticalOffset: 1;
                                    radius: 8.0
                                    samples: radius * 2;
                                    color: "#80000000"
                                    source: sliderHandleBackground
                                }

                            }

                            groove: Rectangle {
                                radius: 6;
                                border {
                                    width: 0;
                                    color: "#5e70f9";
                                }
                                color: "#262323";
                                height: 6;
                                width: height;

                                Rectangle {
                                    id: handleTail;
                                    height: parent.height;
                                    width: ( parameterSlider.width * (  parameterSlider.value / parameterSlider.maximumValue ) );
                                    radius: 3;
                                    anchors {
                                        verticalCenter: parent.verticalCenter;
                                    }
                                    color: mouseEntered ? "#6ff7c9" : "#4a4a4a";

                                    Behavior on color {
                                        PropertyAnimation {
                                            duration: 350;
                                            easing.type: Easing.InCubic;
                                        }
                                    }
                                }

                                DropShadow {
                                    anchors.fill: source;
                                    horizontalOffset: 0;
                                    verticalOffset: 1;
                                    radius: 5.0
                                    samples: 32;
                                    color: "black";
                                    source: handleTail;

                                }

                            }
                        }
                    }

                    Rectangle {
                        height: 25;
                        width: height;
                        color: "transparent";
                        border {
                            width: 0;
                            color: "transparent";
                        }

                        radius: width / 2;
                        anchors {
                            horizontalCenter: parent.horizontalCenter;
                        }
                        Text {
                            anchors { centerIn: parent; }
                            text: parameterSlider.value;
                            color: mouseEntered ? "#f1f1f1" : "#919191";
                            font {
                                pixelSize: 14;
                                bold: true;
                            }

                            Behavior on color {
                                PropertyAnimation {
                                    duration: 350;
                                    easing.type: Easing.InCubic;
                                }
                            }
                        }
                    }

                }
            }
        }

    }
}
