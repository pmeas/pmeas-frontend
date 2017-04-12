#include "bridge.h"
#include "logging.h"

#include <QNetworkDatagram>
#include <QTcpSocket>
#include <QJsonDocument>
#include <QMetaMethod>
#include "bridge.h"

// Sets up the TCP and UDP sockets, connecting to every signal that is useful to us.
Bridge::Bridge(QObject *parent) : QObject(parent)
{

    // Connect UDP Socket signals.

    connect( &m_udpSocket, &QUdpSocket::connected, this, [] {
        qCDebug( bridge ) << "UDP socket has connected to backend.";
    });
    connect( &m_udpSocket, &QUdpSocket::disconnected,this, [] {
        qCDebug( bridge ) << "UDP socket has disconnected from backend.";
    });

    connect( &m_udpSocket, static_cast<void(QAbstractSocket::*)(QAbstractSocket::SocketError)>( &QUdpSocket::error ), this, &Bridge::handleUDPError);
    connect( &m_udpSocket, &QUdpSocket::readyRead, this, &Bridge::udpRecvBackendIpAndConnect);
    connect( &m_udpSocket, &QUdpSocket::stateChanged, this, &Bridge::handleUDPStateChanged );
    connect( &m_tcpSocket, &QTcpSocket::connected,this, [this] {
        qCDebug( bridge ) << "TCP socket has connected to backend.";
    });
    connect( &m_tcpSocket, &QTcpSocket::disconnected, this, [this] {
        qCDebug( bridge ) << "TCP socket has disconnected from backend.";
    });
    connect( &m_tcpSocket, &QTcpSocket::stateChanged, this, &Bridge::handleTcpStateChanged );
    connect( &m_tcpSocket, &QTcpSocket::readyRead, this, &Bridge::updatePorts);
}

bool Bridge::connected() const {
    return m_tcpSocket.state() == QTcpSocket::ConnectedState;
}

// Called like a constructor from QML. We don't need to actually fill this in though.
void Bridge::classBegin() {

}

// This is equivalent to called 'Component.onCompleted' from QML.
//
// We need to broadcast the datagram as soon as this QML component gets loaded.
void Bridge::componentComplete() {
    //emit connectedChanged();

    beginUDPBroadcast();
}

// Tell the listening backend device that we are hearing them!
void Bridge::beginUDPBroadcast() {
    QByteArray message = "1";
    m_udpSocket.writeDatagram( message, QHostAddress::Broadcast, 10000);
}

//
void Bridge::tcpSend(QByteArray message)
{
    if  ( m_tcpSocket.state() == QTcpSocket::ConnectedState ) {
        if ( m_tcpSocket.write(message) == -1 ) {
            qWarning( "There was an error sending the TCP message %s", qPrintable( message ) );
            qCDebug( bridge ) << "Connection with backend interrupted.";
        return;
        }
        m_tcpSocket.flush();
    }

}

void Bridge::updatePorts() {
    auto data = m_tcpSocket.readAll();
    qDebug() << "Received: " << data;
    QJsonObject jsobj (QJsonDocument::fromJson(data).object());
    if(jsobj.contains("input")) {
        auto ins = jsobj["input"].toArray();
        m_inports = ins.toVariantList();
        qDebug() << "in size: " << m_inports.size() << '\n';
        emit(inportsChanged());
    }
    if(jsobj.contains("output")) {
        auto outs = jsobj["output"].toArray();
        m_outports = outs.toVariantList();
        qDebug() << "out size: " << m_outports.size() << '\n';
        emit(outportsChanged());
    }
}

void Bridge::getPorts() {
    tcpSend("{\"intent\":\"REQPORT\"}");
}

void Bridge::sendPorts() {
    QString msg = "{\"intent\":\"UPDATEPORT\", \"in\":\"";
    msg += m_curIn +"\", \"out\":\"";
    msg += m_curOut +"\"}";
    tcpSend(msg.toUtf8());
}
void Bridge::handleUDPStateChanged(QAbstractSocket::SocketState t_state) {

    qCDebug( bridge ) << "UDP State changed" << t_state;
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

    qCDebug( bridge ) << "Got socket error" << t_error;
    switch( t_error ) {
        default:
            break;
    }
}

void Bridge::handleTcpStateChanged(QAbstractSocket::SocketState t_state) {

    qCDebug( bridge ) << "TCP State changed" << t_state;
    switch( t_state ) {
        case QAbstractSocket::UnconnectedState:
            emit connectedChanged();
            break;
        case QAbstractSocket::HostLookupState:
            break;
        case QAbstractSocket::ConnectingState:
            break;
        case QAbstractSocket::ConnectedState:
            emit connectedChanged();
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

void Bridge::udpRecvBackendIpAndConnect() {
    while(m_udpSocket.hasPendingDatagrams()) {
        QNetworkDatagram networkDatagram = m_udpSocket.receiveDatagram(1024);
        QByteArray receivedData = networkDatagram.data();

        QHostAddress address = networkDatagram.senderAddress();
        int port = receivedData.toInt();        

        qCDebug( bridge ) << "Host:" << address << "Port:" << port;

        m_tcpSocket.connectToHost(address, static_cast<quint16>( port ) );
    }
}
