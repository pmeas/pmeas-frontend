#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "socketserver.h"

int main(int argc, char *argv[])
{

    // Sets up the GUI environment, this is required to a GUI application.
    QGuiApplication app(argc, argv);

    // Loads up the the QML javascript engine
    QQmlApplicationEngine engine;

    qmlRegisterType<SocketServer>( "LocalServer", 1, 0, "SocketServer" );

    // Loads the starting point file of the GUI.
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    // Activates the event loop.
    // It basically just is a big while loop and keeps the window alive.
    return app.exec();
}
