#include "socketserver.h"

#include <QLocalServer>
#include <QLocalSocket>

// This is the name we give to the server to listen to.
// We just need to coordinate with Matt for the name.
const QString SERVER_NAME = "ListenHereBOI!";

SocketServer::SocketServer(QObject *parent) : QObject(parent),
    m_localServer( new QLocalServer( this ) )
{

    // Set up the server and listen to a connection name.
    if ( !m_localServer->listen( SERVER_NAME ) ) {

        // Qt's QLocalServer class creates a file on your operating system that
        // may not be properly deleted when the application quits.
        //
        // This is the only reason why the QLocalServer::listen() method would
        // fail to connect.
        //
        // We need to manually close the server, delete the server file and
        // then reconnect the server.
        //
        // That is what happens for the few lines below.s

        m_localServer->close();
        QLocalServer::removeServer( SERVER_NAME );
        m_localServer->listen( SERVER_NAME );
        Q_ASSERT( m_localServer->isListening() );
    }

    // Prints to the console, similar to 'std::cout', and automatically adds an 'std::endl';
    qDebug() << "The server is listening...";
    qDebug() << "check the cpp code to find this.";

    // Listen in for any new coming connections.
    // This is an async method and will be called for us automatically
    connect( m_localServer, &QLocalServer::newConnection, this, [this]() {
        QLocalSocket *newSocket = m_localServer->nextPendingConnection();

        // This is an async method and willb e called for us automatically.
        connect( newSocket, &QLocalSocket::readyRead, this, [this]() {
            qDebug() << "A socket is ready to be read, parse it now homie!";
        });
    });
}
