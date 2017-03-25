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
    // datagram loaded with one byte of data to broadcast to backend
    QByteArray datagram = "1";
    udpSocket->writeDatagram(datagram.data(), datagram.size(),
                             QHostAddress::Broadcast, 10000);
}

void SocketServer::tcpConnection(QHostAddress address,int port){
    // TODO: Replace this sample JSON with live effect data + params.
    // ISSUE CONNECTING TO HOST

    qDebug() << "Host:" << address << "Port:" << port;
    tcpSocket->connectToHost(address, port);
    if(tcpSocket->waitForConnected(3000)){
        qDebug() << "Connected to Host:" << address << "Port:" << port;

        tcpSocket->write("{\"distortion\": {\"drive\": 1,\"slope\": 0.5},\"intent\": \"EFFECT\"}");

        tcpSocket->waitForBytesWritten(1000);
        tcpSocket->waitForReadyRead(1000);

        qDebug() << "Reading: " << tcpSocket->bytesAvailable(); //HOW MANY BYTES COMMING FROM SERVER
        qDebug() << tcpSocket->readAll(); //READ ENTIRE BUFFER

        tcpSocket->close(); //CLOSE SOCKET
    }
    else{
        qDebug() << "Not Connected";
    }
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
