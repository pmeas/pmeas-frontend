import QtQuick 2.7
import QtQuick.Controls 2.1

import Theme 1.0
import Models 1.0


ListView {
    id: effectsListView;
    interactive: false;

    spacing: 12;

    property ButtonGroup exclusiveGroup;


    model: EffectsModel {
        Effect { effectType: Effect.Distortion; }
        Effect { effectType: Effect.Delay; }
        Effect { effectType: Effect.Chorus; }
        Effect { effectType: Effect.Flanger; }
        Effect { effectType: Effect.FrequencyShift; }
        Effect { effectType: Effect.Harmonizer; }
        Effect { effectType: Effect.Phaser; }
        Effect { effectType: Effect.Reverb; }

    }

    header: Rectangle {
        color: "transparent";
        height: 24;
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

    delegate: EffectButton {
        exclusiveGroup: effectsExclusiveGroup;
        z: checked ? 100 : 0;
    }

    /*
    delegate: Item {
        id: allEffectItem;
        height: 24;
        width: parent.width;

        property bool checked: false;
        //property ExclusiveGroup exclusiveGroup: effectsExclusiveGroup;
        property bool mouseEntered: false;

//                onExclusiveGroupChanged: {
//                    if (exclusiveGroup) {
//                        exclusiveGroup.bindCheckable(allEffectItem);
//                    }
//                }

        onCheckedChanged: {
            effectsListView.currentIndex = index;
        }

        z: checked ? 100 : 0;

        property bool dragActive: effectButtonMouseArea.drag.active;

        Rectangle {
            id: effectButtonBackground;
            height: parent.height;
            width: parent.width - 24;
            color: parent.checked ? Theme.highlighterColor : "transparent";

            border {
                width: parent.checked ? 0 : 2;
                color: mouseEntered ? Theme.highlighterColor : "#5a5a5a";
            }

            anchors { horizontalCenter: effectButtonMouseArea.drag.active ? undefined : parent.horizontalCenter; }
            radius: 4;

            Behavior on color {
                PropertyAnimation {
                    duration: 350;
                    easing.type: Easing.OutCubic;
                }
            }

            Behavior on border.color {
                PropertyAnimation {
                    duration: 350;
                    easing.type: Easing.OutCubic;
                }
            }

            property alias text: effectButtonText.text;
            property string category: "allEffects";

            Text {
                id: effectButtonText;

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
                color: {
                    if ( allEffectItem.checked ) {
                        return "#346f66";
                    } else {
                        if ( mouseEntered ) {
                            return Theme.highlighterColor;
                        }
                        return "#5d6161";
                    }
                }

                Behavior on color {
                    PropertyAnimation {
                        duration: 1200;
                        easing.type: Easing.OutCubic;
                    }
                }
            }

            MouseArea {
                id: effectButtonMouseArea;
                anchors.fill: parent;
                hoverEnabled: true;

                onEntered: mouseEntered = true;
                onExited: mouseEntered = false;

                drag.target: parent;
                drag.onActiveChanged: {
                    if (drag.active) {
                        allEffectItem.checked = true;
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
            id: blackDropShadow;
            visible: parent.checked;
            source: effectButtonBackground;
            anchors.fill: source;
            horizontalOffset: 0;
            verticalOffset: 1;
            radius: 8.0
            samples: radius * 2;
            color: "black";
        }

    }
}*/

}
