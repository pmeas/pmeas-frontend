#include "socketserver.h"

#include <QLocalServer>
#include <QLocalSocket>

const QString SERVER_NAME = "ListenHereBOI!";

SocketServer::SocketServer(QObject *parent) : QObject(parent),
    m_localServer( new QLocalServer( this ) )
{

    if ( !m_localServer->listen( SERVER_NAME ) ) {
        m_localServer->close();
        QLocalServer::removeServer( SERVER_NAME );
        m_localServer->listen( SERVER_NAME );
        Q_ASSERT( m_localServer->isListening() );
    }

    qDebug() << "The server is listening...";
    qDebug() << "check the cpp code to find this.";

    connect( m_localServer, &QLocalServer::newConnection, this, [this]() {
        QLocalSocket *newSocket = m_localServer->nextPendingConnection();

        connect( newSocket, &QLocalSocket::readyRead, this, [this]() {
            qDebug() << "A socket is ready to be read, parse it now homie!";
        });
    });
}
