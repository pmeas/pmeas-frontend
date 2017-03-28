#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "bridge.h"
#include "effectsmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    // Sets up the GUI environment, this is required to a GUI application.
    QGuiApplication app(argc, argv);

    // Loads up the the QML javascript engine
    QQmlApplicationEngine engine;

    EffectsModel::registerTypes();

    qmlRegisterType<Bridge>( "Networking", 1, 0, "Bridge" );

    qmlRegisterSingletonType( QUrl( "qrc:///Theme.qml" ), "Theme", 1, 0, "Theme" );

    // Loads the starting point file of the GUI.
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    // Activates the event loop.
    // It basically just is a big while loop and keeps the window alive.
    return app.exec();
}
