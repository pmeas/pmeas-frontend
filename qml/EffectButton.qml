import QtQuick 2.3
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0

import Theme 1.0

Item {
    id: allEffectItem;
    height: 24;
    width: parent.width;

    property var model: parameterModel;

    property bool checked: false;
    property ExclusiveGroup exclusiveGroup;
    property bool mouseEntered: false;

    onExclusiveGroupChanged: {
        if (exclusiveGroup) {
            exclusiveGroup.bindCheckable(allEffectItem);
        }
    }

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
        property int type: effectType;


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
                        return "#6ff7c9";
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
                enabledEffectsListView.draggedItemEntered = true;
                if (drag.active) {
                    allEffectItem.checked = true;
                    effectsColumn.dragInProgress = true;
                    enabledEffectsListView.dragItemIndex = index;
                } else {
                    var oldIndex = index;
                    var oldEffectType = effectType;

                    effectsListView.model.remove( oldIndex );
                    effectsListView.model.insert( oldIndex, oldEffectType );
                    enabledEffectsListView.draggedItemEntered = false;
                }

                effectButtonBackground.Drag.drop();
            }

            onClicked: {
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
