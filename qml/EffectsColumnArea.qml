import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {

    property alias effectsListView: enabledEffectsListView;

    property var currentParameterModel: effectsExclusiveGroup.current === null ? undefined : effectsExclusiveGroup.current.model;

    ColumnLayout {
        id: effectsColumn;
        anchors {
            fill: parent;
        }

        spacing: 0;

        ExclusiveGroup {
            id: effectsExclusiveGroup;
        }

        property bool dragInProgress: false;


        EnabledEffectsList {
            id: enabledEffectsListView;

            anchors {
                top: parent.top;
                bottom: separator.top;
                bottomMargin: 12;
            }

            //Layout.fillHeight: true;

            Layout.fillWidth: true;
        }

        Rectangle {
            id: separator;
            anchors {
                left: parent.left;
                right: parent.right;
                bottom: effectsListView.top;
                leftMargin: 12;
                rightMargin: 12;
                bottomMargin: 6;
            }

            radius: 3;
            height: 2;
            opacity: 0.25;
            color: "black";
        }

        AllEffectsList {
            id: effectsListView;

            height: ( count * ( currentItem.height + spacing ) ) + currentItem.height;
            width: parent.width;

            anchors {
                bottom: settingsArea.top;
            }
        }

        Rectangle {
            id: settingsArea;
            height: 24;
            anchors {
                bottom: parent.bottom;
                left: parent.left;
                right: parent.right;
                leftMargin: 12;
                rightMargin: 12;
            }

            color: "#3e3a3a";
            radius: 3;

            RowLayout {
                anchors.centerIn: parent;

                spacing: 12;

                Image {
                    id: settingsIcon;
                    source: "./icons/cog-2x.png";
                    height: 14;
                    width: height;
                    sourceSize {
                        width: 14;
                        height: 14;
                    }
                }

                Text {

                    text: qsTr( "Settings" );
                    font {
                        bold: true;
                        pixelSize: 12;
                    }
                    color: "#f1f1f1";
                }
            }

            SettingsWindow {
                id: settingsWindow;
            }

            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    settingsWindow.show();
                }

            }
        }

        DropShadow {
            anchors.fill: source;
            horizontalOffset: 0;
            verticalOffset: 1;
            radius: 4.0
            samples: radius * 2;
            color: "black"
            source: settingsArea;
        }
    }
}
