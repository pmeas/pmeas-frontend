#include <QtNetwork>

#include "socketserver.h"

// This is the name we give to the server to listen to.
// We just need to coordinate with Matt for the name.
const QString SERVER_NAME = "ListenHereBOI!";

SocketServer::SocketServer(QObject *parent) : QObject(parent)
{
    server = new QTcpServer(this);
    udpSocket = new QUdpSocket(this);
    connect(server, SIGNAL(nextPendingConnection()),
            this,SLOT(nextPendingConnection()));
    connect(udpSocket, SIGNAL(readyRead()),
            this, SLOT(readDatagram()));

    if(!server->listen(QHostAddress::Any,10000)){
        qDebug() << "TCP Server could not start.";
    }
    else{
        qDebug() << "TCP Server started";
    }
}

void SocketServer::broadcastDatagram() {
    // TODO: Replace this sample JSON with live effect data + params.
    /* TODO: See if we _want_ to just broadcast the data or make a TCP
     * connection after like Younes suggests to send data over reliably. This can be done
     * of course but before we start work on it we gotta make sure its what we want to do.
     */
    QByteArray datagram = "{\"distortion\": {\"drive\": 1,\"slope\": 0.5},\"intent\": \"EFFECT\"}";
    udpSocket->writeDatagram(datagram.data(), datagram.size(),
                             QHostAddress::Broadcast, 10000);
}

void SocketServer::nextPendingConnection() {
    QTcpSocket *socket = server->nextPendingConnection();
    //address = QTcpSocket::peerAddress();
    //qDebug() << QString(address);
    //socket->write("Hello Client");
    //socket->flush();
    //socket->waitForBytesWritten(3000);
    //socket->close();
}

void SocketServer::readDatagram() {

    while(udpSocket->hasPendingDatagrams()) {
        SocketServer::nextPendingConnection();
        QNetworkDatagram networkDatagram = udpSocket->receiveDatagram(1024);
        QByteArray receivedData = networkDatagram.data();
        qDebug() << QString(receivedData);
    }
}
