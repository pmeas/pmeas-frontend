#include <QtNetwork>
#include "socketserver.h"

// This is the name we give to the server to listen to.
// We just need to coordinate with Matt for the name.
const QString SERVER_NAME = "ListenHereBOI!";

SocketServer::SocketServer(QObject *parent) : QObject(parent)
{
    tcpSocket = new QTcpSocket(this);
    udpSocket = new QUdpSocket(this);

    connect(tcpSocket,SIGNAL(readyRead()),this, SLOT(readDatagram()));
    connect(udpSocket, SIGNAL(readyRead()),this, SLOT(readDatagram()));
}

void SocketServer::broadcastDatagram() {
    // TODO: Replace this sample JSON with live effect data + params.
    /* TODO: See if we _want_ to just broadcast the data or make a TCP
     * connection after like Younes suggests to send data over reliably. This can be done
     * of course but before we start work on it we gotta make sure its what we want to do.
     */
    QByteArray datagram = "{\"distortion\": {\"drive\": 0,\"slope\": 0.5},\"intent\": \"EFFECT\"}";
    udpSocket->writeDatagram(datagram.data(), datagram.size(),
                             QHostAddress::Broadcast, 10000);
}

void SocketServer::tcpConnection(QHostAddress address,int port){
    tcpSocket->connectToHost(address,port);
    qDebug() << "Host Address:" << (address);
    qDebug() << "Port:" << (port);
}

void SocketServer::readDatagram() {

    while(udpSocket->hasPendingDatagrams()) {
        QNetworkDatagram networkDatagram = udpSocket->receiveDatagram(1024);
        QByteArray receivedData = networkDatagram.data();
        qDebug() << QString(receivedData);
        QHostAddress address = networkDatagram.destinationAddress();
        int port = networkDatagram.destinationPort();
        tcpConnection(address,port);
    }
}
