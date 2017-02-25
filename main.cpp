#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "socketserver.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<SocketServer>( "LocalServer", 1, 0, "SocketServer" );

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
