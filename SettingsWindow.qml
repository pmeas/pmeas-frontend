import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

Window {
    id: settingsWindow
    title: qsTr( "Settings" );
    visible: false;
    x: root.x + ( ( root.width / 2 ) - ( width / 2 ) );
    y: root.y + ( ( root.height / 2 ) - ( height / 2 ) );
    width: 300;
    height: 200;

    modality: Qt.WindowModal;
    flags: Qt.WindowStaysOnTopHint;

    color: "#E3E3E5";
}
