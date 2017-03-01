import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {

    property string currentModelKey: "Distortion";

    ColumnLayout {
        id: effectsColumn;
        anchors {
            fill: parent;
        }

        spacing: 0;

        ExclusiveGroup { id: effectsExclusiveGroup; }

        property bool dragInProgress: false;
        ScrollView {
            Layout.fillWidth: true;
            style: ScrollViewStyle {
                    handle: Rectangle {
                        implicitWidth: 4
                        implicitHeight: 5
                        color: "#E1DDDC"
                    }
                    scrollBarBackground: Rectangle {
                        implicitWidth: 4
                        implicitHeight: 5
                        color: "#777777"
                    }
                    decrementControl: Rectangle {
                        implicitWidth: 4
                        implicitHeight: 0
                        color: "#E1DDDC"
                    }
                    incrementControl: Rectangle {
                        implicitWidth: 4
                        implicitHeight: 0
                        color: "#E1DDDC"
                    }
            }
            ListView {
                id: enabledEffectsListView;
                interactive: false;
                width: parent.width;
                height: 150;
                spacing: 6;

                property int dragItemIndex: -1

                property int indexToMoveTo: -1;

                DropArea {
                    id: enabledDropArea;
                    anchors { fill: parent; }
                    onDropped: {
                        effectsColumn.dragInProgress = false;
                        if ( drop.source.category === "allEffects" ) {
                            enabledEffectsListView.model.append( { "effectName": drop.source.text } );
                        } else if ( drop.source.category === "enabledEffects" ) {
                            console.log("dropped enabled");
                            enabledEffectsListView.model.move( )
                        }
                    }
                }

                model: ListModel {}

                header: Rectangle {
                    color: "#333333";
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
                        color: "#ffffff";
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
                        enabledEffectsListView.currentIndex = index;
                    }

                    Rectangle {
                        id: enabledEffectBackground;
                        height: parent.height;
                        width: parent.width;
                        //anchors.fill: parent;
                        color: parent.checked ? "#E19854" : "#ffffff";

                        property string category: "enabledEffects";

                        Rectangle {
                            id: removeEnableEffectButton;
                            z: parent.z + 1;
                            width: 16;
                            height: width;
                            radius: width / 2;
                            color: "#222222";
                            anchors {
                                verticalCenter: parent.verticalCenter;
                                left: parent.left;
                                leftMargin: 12;
                            }

                            Text {
                                anchors { centerIn: parent; }
                                text: qsTr( "X" );
                                font { bold: true; }
                                color: "#ffffff";
                            }

                            MouseArea {
                                anchors.fill: parent;
                                onClicked: {
                                    console.log("click")
                                    enabledEffectsListView.model.remove( index, 1 );
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

                        Drag.active: enabledEffectBackgroundMouseArea.drag.active;
                        Drag.hotSpot {
                            x: width / 2;
                            y: height / 2;
                        }

                        MouseArea {
                            id: enabledEffectBackgroundMouseArea;
                            anchors.fill: parent;
                            drag.target: parent;
                            onClicked: {
                                console.log("Clicked 'Enabled' " + effectName + " button" );
                                currentModelKey = effectName;
                                enabledEffectItem.checked = true;


                            }
                            drag.onActiveChanged: {
                                if (drag.active) {
                                    effectsColumn.dragInProgress = true;
                                    enabledEffectsListView.dragItemIndex = index;
                                } else {
                                    var oldIndex = index;
                                    var oldEffectName = effectName;

                                    console.log( oldIndex, oldEffectName)
                                    //enabledEffectsListView.model.remove( oldIndex, 1 );
                                    //enabledEffectsListView.model.insert( oldIndex, { "effectName": oldEffectName } );
                                }

                                enabledEffectBackground.Drag.drop();
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
                        color: "#000000";
                    }
                }
            }
        }
        ListView {
            id: effectsListView;
            interactive: false;
            Layout.fillHeight: true;
            width: parent.width;
            spacing: 6;

            model: ListModel {
                ListElement { effectName: "Distortion"; }
                ListElement { effectName: "Delay"; }
                ListElement { effectName: "Reverb"; }
                ListElement { effectName: "Chorus"; }
                ListElement { effectName: "Frequency Shift"; }
                ListElement { effectName: "Harmonizer"; }
            }

            header: Rectangle {
                color: "#333333";
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
                    color: "#ffffff"
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
                    color: parent.checked ? "#E19854" : "#ffffff";

                    property alias text: effectButtonText.text;
                    property string category: "allEffects";

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
                                enabledEffectsListView.dragItemIndex = index;
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
                    color: "#000000";
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

            property bool checked: false;
            color: checked ? "#E19854" : "#777777";
            border.color: "#000000";
            border.width: 1;

            Text {
                anchors { centerIn: parent; }
                text: qsTr( "Settings" );
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
                    settingsArea.color = "#E19854"
                }
                onReleased: {
                    settingsArea.color = "#777777"
                }
            }
        }
    }
}
