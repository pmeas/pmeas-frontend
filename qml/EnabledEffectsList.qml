import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

ListView {

    id: enabledEffectsListView;
    interactive: true;

    Layout.fillHeight: true;
    Layout.fillWidth: true;

    ScrollBar.vertical: ScrollBar {
        width: 8;
        opacity: 0.3;
    }

    remove: Transition {
        NumberAnimation {
            properties: "x";
            to: -enabledEffectsListView.width;
            duration: 1200;
            easing.type: Easing.InOutElastic;
        }
     }

    spacing: 12;

    property int dragItemIndex: -1

    property int indexToMoveTo: -1;

    property bool draggedItemEntered: false;

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

            enabledEffectsListView.draggedItemEntered = false;
        }

        //onEntered: enabledEffectsListView.draggedItemEntered = true
        //onExited: enabledEffectsListView.draggedItemEntered = false;

        Rectangle {
            id: enabledEffectsDropHighlighter;
            anchors.fill: parent;
            opacity: enabledEffectsListView.draggedItemEntered ? 1.0 : 0.0;
            color: "transparent";
            radius: 6;
            border {
                width: 3;
                color: "#6ff7c9";
            }

            Behavior on opacity {
                PropertyAnimation {
                    duration: 600;
                    easing.type: enabledEffectsListView.draggedItemEntered ? Easing.InCubic : Easing.Linear;
                }
            }
        }

        DropShadow {
            opacity: enabledEffectsListView.draggedItemEntered ? 1.0 : 0;
            source: enabledEffectsDropHighlighter;
            anchors.fill: source;
            horizontalOffset: 0;
            verticalOffset: 0;
            radius: 32.0
            samples: radius * 2;
            color: "#6ff7c9";
        }
    }

    model: ListModel {}

    header: Rectangle {
        color: "transparent";
        height: 40;
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
            color: enabledEffectsListView.draggedItemEntered ? "#6ff7c9" : "#ffffff";
            Behavior on color {
                PropertyAnimation {
                    duration: 600;
                    easing.type: enabledEffectsListView.draggedItemEntered ? Easing.InCubic : Easing.Linear;
                }
            }
        }
    }

    delegate: Item {
        id: enabledEffectItem;
        height: 24;
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
            width: parent.width - 24;
            color: parent.checked ? "#6ff7c9" : "transparent";

            border {
                width: parent.checked ? 0 : 2;
                color: "#5a5a5a";
            }

            anchors { horizontalCenter: parent.horizontalCenter; }
            radius: 4;

            property string category: "enabledEffects";

            Rectangle {
                id: removeEnableEffectButton;
                z: parent.z + 1;
                width: 14;
                height: width;
                radius: width / 2;
                color: enabledEffectItem.checked ? "#396f5b" : "transparent";
                opacity: 0.0;
                border {
                    width: enabledEffectItem.checked ? 0 : 2;
                    color: "#8a8a8a";
                }

                Behavior on opacity {
                    PropertyAnimation {
                        duration: 300;
                        easing.type: Easing.InCubic;
                    }
                }

                anchors {
                    verticalCenter: parent.verticalCenter;
                    right : parent.right;
                    rightMargin: 7;
                }

                Text {
                    anchors { centerIn: parent; }
                    text: qsTr( "X" );
                    font { bold: true; pixelSize: 9; }
                    color: enabledEffectItem.checked ? "#cacaca" : "#8a8a8a";

                }

                MouseArea {
                    id: enabledEffectMouseArea;
                    anchors.fill: parent;
                    onClicked: {
                        enabledEffectsListView.model.remove( index, 1 );
                    }
                }
            }

            Text {

                anchors {
                    verticalCenter: parent.verticalCenter;
                    left: parent.left;
                    leftMargin: 12;
                }
                font {
                    bold: true;
                    pixelSize: 12;
                }

                text: effectName;
                color: enabledEffectItem.checked ? "black" : "#8a8a8a";
                opacity: 0.55;

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
                hoverEnabled: true;

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

                onEntered: removeEnableEffectButton.opacity = 1.0;
                onExited: removeEnableEffectButton.opacity = 0.0;
            }


        }

        DropShadow {
            id: dropShadow;
            visible: parent.checked;
            source: enabledEffectBackground;
            anchors.fill: source;
            horizontalOffset: 0;
            verticalOffset: 1;
            radius: 8.0
            samples: radius * 2;
            color: "#000000";
            cached: true;
        }
    }
}
