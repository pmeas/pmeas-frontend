import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

Window {
    // Responsible for the splash screen upon loading of application.

    id: splashScreen;
    title: "PMEAS Splash Screen";
    modality: Qt.ApplicationModal;
    flags: Qt.SplashScreen;
    property int durationOfSplash: 5000;
    signal timeout;
    x: (Screen.width - splashImage.width) / 2;
    y: (Screen.height - splashImage.height) / 2;
    width: splashImage.width;
    height: splashImage.height;

    Image {
        id: splashImage;
        source: "images/logo.png";

    }

    Text {
        id: errorMessage
        visible: false
        text: "Could not establish connection :( make sure it's all good"
    }

    Timer {
        id: timer;
        interval: durationOfSplash;
        running: true;
        repeat: false;
        onTriggered: {
            errorMessage.visible = true;
        }
    }

    Component.onCompleted: {
        bridge.beginUDPBroadcast();
        bridge.tcpSocketConnected.connect(function () {
            visible = false;
            splashScreen.timeout();
        });
        visible = true;
//        visible = false;
//        splashScreen.timeout();

    }


}
