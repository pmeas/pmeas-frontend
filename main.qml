import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

ApplicationWindow {
    visible: true;
    width: 640;
    height: 480;
    title: qsTr("PMEAS");

    RowLayout {

        anchors {
            fill: parent;
            margins: 12;
        }

        Rectangle {
            Layout.fillHeight: true;
            width: 150;

            color: "orange";

            ListView {
                id: effectsListView;
                anchors.fill: parent;
                model: [ "Distortion", "Delay", "Frequency Shift", "Chorus", "Harmonize" ];

                spacing: 6;
                delegate: Item {
                    height: 35;
                    width: parent.width;
                    property bool checked: index === effectsListView.currentIndex;

                    Rectangle {
                        id: effectButtonBackground;
                        anchors.fill: parent;
                        color: parent.checked ? "white" : "white";

                        Text {
                            anchors.centerIn: parent;
                            text: modelData;
                        }

                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                console.log("enabled " + modelData );
                                effectsListView.currentIndex = index;
                            }
                        }
                    }


                    DropShadow {
                        visible: parent.checked;
                        source: effectButtonBackground;
                        anchors.fill: source;
                        horizontalOffset: 0;
                        verticalOffset: 0;
                        radius: 16.0
                        samples: radius * 2;
                        color: "black";
                    }
                }
            }
        }


        Rectangle {
            Layout.fillHeight: true;
            Layout.fillWidth: true;

            color: "green";

            Rectangle  {
                color: "blue";

                anchors {
                    top: parent.top;
                    bottom: parent.bottom;
                    left: parent.left;
                    right: parent.right;
                    margins: 50;
                }


                ListView {
                   // height: 500;
                    interactive: false;
                    height: parent.height;
                    anchors {
                        left: parent.left;
                        right: parent.right;
                       // verticalCenter: parent.verticalCenter;
                        margins: 24;
                    }


                    model: ListModel {
                        ListElement { effectName: "Effect Level" }
                        ListElement { effectName: "Distorion" }
                        ListElement { effectName: "Feedback" }
                    }

                    spacing: 12;

                    delegate: Rectangle {
                        id: parameterBlock;
                        height: 100;
                        color: "yellow";
                        radius: 6;

                        anchors {
                            left: parent.left;
                            right: parent.right;
                            margins: 24;
                        }

                        ColumnLayout {
                            anchors.centerIn: parent;
                            spacing: 6;

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

                                    text: effectName;
                                    font {
                                        pixelSize: 18;
                                    }
                                }

                           //}

                            Slider {
                                id: parameterSlider;
                                minimumValue: 0;
                                maximumValue: 100;
                                value: 50;
                                implicitWidth: parameterBlock.width * 0.75;
                                anchors {
                                    horizontalCenter: parent.horizontalCenter;
                                }
                                stepSize: 1;
                            }
                            Rectangle {
                                height: 25;
                                width: height;
                                radius: 3;
                                anchors {
                                    horizontalCenter: parent.horizontalCenter;
                                }
                                Text {
                                    anchors { centerIn: parent; }
                                    text: parameterSlider.value;
                                }
                            }

                        }
                    }
                }
            }

        }



    }

}
