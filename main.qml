import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

import LocalServer 1.0


/*
 * This is the main entry point for the GUI.
 *
 * QML is a css-like environment where you can also add in javascript functions and code.
 * All of the widgets are actually rendered with OpenGL, and so can be themed and styled
 * in a dynamic way.
 *
 * Tips:
 *      1. Property assignment is done with the colon ':'
 *      2. The lefthand side property values like 'width' and 'height' are predefined inside of the widget.
 *      3. The righthand side of property values, which is the value, is a javascript expression. So
           you can do things like 'width: {
                                       var w = 300;
                                       return w;
                                   }
                                  '
 *      4. Do not use a 'this' variable insided of javascript functions, it's just a big no-no and
 *         QML will complain if you do, it really messes things up.
 */

// This is the root level of the GUI, hence why the 'id: root' exists.
ApplicationWindow {
    id: root;
    visible: true;
    width: 640;
    height: 480;

    minimumWidth: 640;
    minimumHeight: 480;

    title: qsTr("Portable Multi-Effects Software");

    // This is defined in the cpp code and is then exposed to this QML enviroment
    SocketServer {
        id: socketServer;
    }

    RowLayout {

        anchors {
            fill: parent;
            margins: 12;
        }

        // This is defined in the QML file of the same name.
        EffectsColumnArea {
            id: effectsColumnArea;
            Layout.fillHeight: true;
            width: 150;

            color: "orange";
        }

        // This is defined in the QML file of the same name.
        ParameterColumnArea {
            id: parameterColumnArea;
            Layout.fillHeight: true;
            Layout.fillWidth: true;

            color: "green";
        }

    }
}
