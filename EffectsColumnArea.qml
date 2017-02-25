import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {

    property string currentModelKey: "Distortion";

    ColumnLayout {
        id: effectsColumn;
        anchors {
            fill: parent;
        }

        spacing: 3;

        ExclusiveGroup { id: effectsExclusiveGroup; }

        property bool dragInProgress: false;

        ListView {
            id: enabledEffetsListView;
            interactive: false;
            Layout.fillWidth: true;
            height: 150;
            spacing: 6;

            property int dragItemIndex: -1

            DropArea {
                id: enabledDropArea;
                anchors { fill: parent; }
                onDropped: {
                    effectsColumn.dragInProgress = false;
                    enabledEffetsListView.model.append( { "effectName": drop.source.text } );
                }
            }

            model: ListModel {}

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

                    Rectangle {
                        id: removeEnableEffectButton;
                        z: parent.z + 1;
                        width: 16;
                        height: width;
                        radius: width / 2;
                        color: "red";
                        anchors {
                            verticalCenter: parent.verticalCenter;
                            left: parent.left;
                            leftMargin: 12;
                        }

                        Text {
                            anchors { centerIn: parent; }
                            text: qsTr( "X" );
                            font { bold: true; }
                            color: "white";
                        }

                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                console.log("click")
                                enabledEffetsListView.model.remove( index, 1 );
                            }
                        }
                    }

                    Text {
                        anchors {
                            left: removeEnableEffectButton.right;
                            leftMargin: 12;
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

            model: ListModel {
                ListElement { effectName: "Distortion"; }
                ListElement { effectName: "Delay"; }
                ListElement { effectName: "Frequency Shift"; }
                ListElement { effectName: "Chorus"; }
                ListElement { effectName: "Harmonize"; }
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
                    width: parent.width;
                    height: parent.height;
                    color: parent.checked ? "white" : "white";

                    property alias text: effectButtonText.text;

                    Text {
                        id: effectButtonText;
                        anchors {
                            verticalCenter: parent.verticalCenter;
                            left: parent.left;
                            leftMargin: 12 * 2;
                        }

                        text: effectName;
                    }

                    MouseArea {
                        id: effectButtonMouseArea;
                        anchors.fill: parent;

                        drag.target: parent;
                        drag.onActiveChanged: {
                            if (drag.active) {
                                effectsColumn.dragInProgress = true;
                                enabledEffetsListView.dragItemIndex = index;
                            } else {
                                var oldIndex = index;
                                var oldEffectName = effectName;
                                effectsListView.model.remove( oldIndex, 1 );
                                effectsListView.model.insert( oldIndex, { "effectName": oldEffectName } );
                            }

                            effectButtonBackground.Drag.drop();
                        }

                        onClicked: {
                            currentModelKey = modelData;
                            console.log("Clicked 'All Effects' " + modelData + " button" );
                            allEffectItem.checked = true;
                        }

                    }

                    Drag.active: effectButtonMouseArea.drag.active;
                    Drag.hotSpot {
                        x: width / 2;
                        y: height / 2;
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
