import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import Theme 1.0

Rectangle {

    id: parameterColumnArea;

    Rectangle  {
        color: "transparent";

        anchors {
            top: parent.top;
            bottom: parent.bottom;
            left: parent.left;
            right: parent.right;
        }

//        ScrollBar {
//            flickable: parameterListView;
//            width: 8;
//            anchors {
//                top: parent.top;
//                right: parent.right;
//                bottom: parent.bottom;
//                rightMargin: 18 ;
//                topMargin: 32;
//                bottomMargin: 18;

//            }
//        }

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

            add: Transition {
                NumberAnimation {
                    //properties: "x";
                    //to: -enabledEffectsListView.width;
                    duration: 3000;
                    easing.type: Easing.Linear;
                }
             }

            model: effectsColumnArea.currentParameterModel;

            spacing: 12;

            ScrollBar.vertical: ScrollBar {
                width: 12;
                opacity: 0.3;
            }


            delegate: ParameterBlock {
                height: 112;

                width: parent.width;

                anchors {
                    horizontalCenter: parent.horizontalCenter;
                }

                maxWidth: 500;
            }
        }

    }
}
