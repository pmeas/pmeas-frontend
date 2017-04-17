import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1

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
    BusyIndicator {
        id: networkSpinner
        running: timer.running
        anchors {
            verticalCenter: splashImage.bottom;
            verticalCenterOffset: -128;
            horizontalCenter: splashImage.horizontalCenter;
        }
    }

    Image {
        id: splashImage;
        source: "images/splash.png";
        anchors.centerIn: parent;
    }

    MessageDialog {
        id: errorMessage
        visible: false
        title: "Could not establish network connection"
        icon: StandardIcon.Critical
        informativeText: "The backend failed to respond within "+durationOfSplash+" ms.\n"+
                         "Please make sure that the backend has power and a network connection.\n"+
                         "If the problem persists, try ethernet\n"
        width: 2000
        standardButtons: StandardButton.Retry | StandardButton.Close
        onAccepted: tryConnect()
        onRejected: Qt.quit()
    }

    function tryConnect(){
        timer.start()
        networkSpinner.running = true;
        bridge.beginUDPBroadcast();
        bridge.tcpSocketConnected.connect(stop);
        visible = true;
    }

    function stop()
    {
        timer.running = false;
        timer.stop();
        visible = false;
        splashScreen.timeout();
    }

    Timer {
        id: timer;
        interval: durationOfSplash;
        repeat: false;
        onTriggered: {
            networkSpinner.running = false;
            errorMessage.setWidth(400)
            errorMessage.open()
        }
    }

    Component.onCompleted: tryConnect()

}
