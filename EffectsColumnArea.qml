import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {

    property string currentModelKey: "Distortion";

    ColumnLayout {
        anchors {
            fill: parent;
        }

        ExclusiveGroup { id: effectsExclusiveGroup; }

        ListView {
            id: enabledEffetsListView;
            interactive: false;
            Layout.fillWidth: true;
            height: 150;
            spacing: 6;

            model: ListModel {
                ListElement { effectName: "Distortion"; }
                ListElement { effectName: "Chorus"; }
            }

            header: Rectangle {
                color: "green";
                height: 25;
                width: parent.width;

                Text {
                    anchors {
                        left: parent.left;
                        verticalCenter: parent.verticalCenter;
                        leftMargin: 12;
                    }

                    font {
                        bold: true;
                        pixelSize: 13;
                    }

                    text: qsTr( "Enabled" );
                }
            }

            delegate: Item {
                id: enabledEffectItem;
                height: 35;
                width: parent.width;

                property bool checked: false;
                property ExclusiveGroup exclusiveGroup: effectsExclusiveGroup
                onExclusiveGroupChanged: {
                    if (exclusiveGroup) {
                        exclusiveGroup.bindCheckable(enabledEffectItem)
                    }
                }


                onCheckedChanged: {
                    enabledEffetsListView.currentIndex = index;
                }

                Rectangle {
                    id: enabledEffectBackground;
                    anchors.fill: parent;
                    color: "white";

                    Text {
                        anchors {
                            left: parent.left;
                            leftMargin: 12 * 2;
                            verticalCenter: parent.verticalCenter;
                        }
                        text: effectName;

                    }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            console.log("Clicked 'Enabled' " + effectName + " button" );
                            currentModelKey = effectName;
                            enabledEffectItem.checked = true;
                        }
                    }
                }

                DropShadow {
                    visible: parent.checked;
                    source: enabledEffectBackground;
                    anchors.fill: source;
                    horizontalOffset: 0;
                    verticalOffset: 0;
                    radius: 16.0
                    samples: radius * 2;
                    color: "black";
                }
            }
        }

        ListView {
            id: effectsListView;
            interactive: false;
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            spacing: 6;

            model: [ "Distortion", "Delay", "Frequency Shift", "Chorus", "Harmonize" ];

            header: Rectangle {
                color: "green";
                height: 25;
                width: parent.width;

                Text {
                    anchors {
                        left: parent.left;
                        verticalCenter: parent.verticalCenter;
                        leftMargin: 12;
                    }

                    font {
                        bold: true;
                        pixelSize: 13;
                    }

                    text: qsTr( "All Effects" );
                }
            }

            delegate: Item {
                id: allEffectItem;
                height: 35;
                width: parent.width;
                property bool checked: false;

                property ExclusiveGroup exclusiveGroup: effectsExclusiveGroup;
                onExclusiveGroupChanged: {
                    if (exclusiveGroup) {
                        exclusiveGroup.bindCheckable(allEffectItem);
                    }
                }


                onCheckedChanged: {
                    effectsListView.currentIndex = index;
                }

                Rectangle {
                    id: effectButtonBackground;
                    anchors.fill: parent;
                    color: parent.checked ? "white" : "white";

                    Text {
                        anchors {
                            verticalCenter: parent.verticalCenter;
                            left: parent.left;
                            leftMargin: 12 * 2;
                        }

                        text: modelData;
                    }

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            currentModelKey = modelData;
                            console.log("Clicked 'All Effects' " + modelData + " button" );
                            allEffectItem.checked = true;
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

        Rectangle {
            id: settingsArea;
            Layout.fillWidth: true;
            height: 50;
            anchors {
                bottom: parent.bottom;
            }

            color: "silver";

            Text {
                anchors { centerIn: parent; }
                text: qsTr( "Settings" );
            }
        }
    }
}
