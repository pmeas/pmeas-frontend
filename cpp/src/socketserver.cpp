#include <QUdpSocket>
#include <QNetworkDatagram>

#include "socketserver.h"

// This is the name we give to the server to listen to.
// We just need to coordinate with Matt for the name.
const QString SERVER_NAME = "ListenHereBOI!";

SocketServer::SocketServer(QObject *parent) : QObject(parent)
{
    udpSocket = new QUdpSocket(this);

    connect(udpSocket, SIGNAL(readyRead()),
            this, SLOT(readDatagram()));
}

void SocketServer::broadcastDatagram(QByteArray message) {
    // TODO: Replace this sample JSON with live effect data + params.
    /* TODO: See if we _want_ to just broadcast the data or make a TCP
     * connection after like Younes suggests to send data over reliably. This can be done
     * of course but before we start work on it we gotta make sure its what we want to do.
     */
//    QByteArray datagram = "{\"delay\":{\"delay\": 1,\"feedback\": 0.5}}";
    udpSocket->writeDatagram(message.data(), message.size(),
                             QHostAddress::Broadcast, 10000);
}

void SocketServer::readDatagram() {

    while(udpSocket->hasPendingDatagrams()) {
        QNetworkDatagram networkDatagram = udpSocket->receiveDatagram(1024);
        QByteArray receivedData = networkDatagram.data();
        qInfo() << QString(receivedData);
    }
}
