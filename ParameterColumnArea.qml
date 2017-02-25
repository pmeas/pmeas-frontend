import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {


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
