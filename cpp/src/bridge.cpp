#include "bridge.h"

#include <QNetworkDatagram>
#include <QHostAddress>

// Sets up the TCP and UDP sockets, connecting to every signal that is useful to us.
Bridge::Bridge(QObject *parent) : QObject(parent)
{

    // Connect UDP Socket signals.

    connect( &m_udpSocket, &QUdpSocket::connected, this, [] {
        qDebug() << "UDP socket has connected to backend.";
    });
    connect( &m_udpSocket, &QUdpSocket::disconnected,this, [] {
        qDebug() << "UDP socket has disconnected from backend.";
    });

    connect( &m_udpSocket, &QUdpSocket::readyRead, this, &Bridge::readDatagram );
    connect( &m_udpSocket, static_cast<void(QAbstractSocket::*)(QAbstractSocket::SocketError)>( &QUdpSocket::error ), this, &Bridge::handleUDPError);

    connect( &m_udpSocket, &QUdpSocket::stateChanged, this, &Bridge::handleUDPStateChanged );

    // Connect TCP socket signals

    connect( &m_tcpSocket, &QTcpSocket::connected,this, [this] {
        qDebug() << "TCP socket has connected to backend.";
    });

    connect( &m_tcpSocket, &QTcpSocket::connected, this, &Bridge::tcpSocketConnected);
    connect( &m_tcpSocket, &QTcpSocket::disconnected, this, [this] {
        qDebug() << "TCP socket has disconnected from backend.";
    });

    connect( &m_tcpSocket, &QTcpSocket::readyRead, this, &Bridge::readTCPResult );
}

// Tell the listening backend device that we are hearing them!
void Bridge::broadcastDatagram() {

    // TODO: Replace this sample JSON with live effect data + params.
    // TODO: See if we _want_ to just broadcast the data or make a TCP
    // connection after like Younes suggests to send data over reliably. This can be done
    // of course but before we start work on it we gotta make sure its what we want to do.

    // QByteArray datagram = "{\"delay\":{\"delay\": 1,\"feedback\": 0.5}}";
    QByteArray message = "1";
    m_udpSocket.writeDatagram( message, QHostAddress::Broadcast, 10000);
}

//
void Bridge::sendData(QByteArray message){

    if  ( m_tcpSocket.state() == QTcpSocket::ConnectedState ) {

        if ( m_tcpSocket.write(message) == -1 ) {
            qWarning( "There was an error sending the TCP message %s", qPrintable( message ) );
            qDebug() << "Connection with backend interrupted.";
            emit lostConnection();
            return;
        }

        m_tcpSocket.flush();

    } else {
        emit lostConnection();
    }

}

void Bridge::readTCPResult() {

    QByteArray result = m_tcpSocket.readAll();
    qDebug() << result;
}

void Bridge::handleUDPStateChanged(QAbstractSocket::SocketState t_state) {

    qDebug() << "State changed" << t_state;
    switch( t_state ) {
        case QAbstractSocket::UnconnectedState:
            break;
        case QAbstractSocket::HostLookupState:
            break;
        case QAbstractSocket::ConnectingState:
            break;
        case QAbstractSocket::ConnectedState:
            break;
        case QAbstractSocket::BoundState:
            break;
        case QAbstractSocket::ListeningState:
            break;
        case QAbstractSocket::ClosingState:
            break;
        default:
            break;
    }
}

void Bridge::handleUDPError(QAbstractSocket::SocketError t_error) {

    qDebug() << "Got socket error" << t_error;
    switch( t_error ) {
        default:
            break;
    }
}

void Bridge::readDatagram() {

    while ( m_udpSocket.hasPendingDatagrams() ) {

        QNetworkDatagram networkDatagram = m_udpSocket.receiveDatagram(1024);
        QByteArray receivedData = networkDatagram.data();

        QHostAddress address = networkDatagram.senderAddress();
        int port = receivedData.toInt();        

        qDebug() << "Host:" << address << "Port:" << port;

        m_tcpSocket.connectToHost(address, static_cast<quint16>( port ) );

    }

}
