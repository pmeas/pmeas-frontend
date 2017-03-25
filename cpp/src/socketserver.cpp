#include <QtNetwork>
#include "socketserver.h"

// This is the name we give to the server to listen to.
// We just need to coordinate with Matt for the name.
const QString SERVER_NAME = "ListenHereBOI!";

SocketServer::SocketServer(QObject *parent) : QObject(parent)
{
    tcpSocket = new QTcpSocket(this);
    udpSocket = new QUdpSocket(this);

    connect(tcpSocket,SIGNAL(connected()),this, SLOT(handleTcpConnection()));
    connect(udpSocket, SIGNAL(readyRead()),this, SLOT(readDatagram()));
}

void SocketServer::broadcastDatagram() {
    // datagram loaded with one byte of data to broadcast to backend
    QByteArray datagram = "1";
    udpSocket->writeDatagram(datagram.data(), datagram.size(),
                             QHostAddress::Broadcast, 10000);
}

void SocketServer::handleTcpConnection(){
    qDebug() << "Connected!";

    tcpSocket->write("{\"distortion\": {\"drive\": 0,\"slope\": 0.5},\"intent\": \"EFFECT\"}");

    tcpSocket->waitForBytesWritten(1000);
    tcpSocket->waitForReadyRead(1000);

    qDebug() << "Reading: " << tcpSocket->bytesAvailable(); //HOW MANY BYTES COMMING FROM SERVER
    qDebug() << tcpSocket->readAll(); //READ ENTIRE BUFFER
}

void SocketServer::tcpConnection(QHostAddress address,int port){
    qDebug() << "Host:" << address << "Port:" << port;
    tcpSocket->connectToHost(address, quint16(port));
    qDebug() << "Connected to Host:" << address << "Port:" << port;
}

void SocketServer::readDatagram() {
    while(udpSocket->hasPendingDatagrams()) {
        QNetworkDatagram networkDatagram = udpSocket->receiveDatagram(1024);
        QByteArray receivedData = networkDatagram.data();
        QHostAddress address = networkDatagram.senderAddress();
        int port = receivedData.toInt();
        tcpConnection(address,port);
    }
}
