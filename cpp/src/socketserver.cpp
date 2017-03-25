#include <QtNetwork>
#include "socketserver.h"

// This is the name we give to the server to listen to.
// We just need to coordinate with Matt for the name.
const QString SERVER_NAME = "ListenHereBOI!";

SocketServer::SocketServer(QObject *parent) : QObject(parent)
{
    tcpSocket = new QTcpSocket(this);
    udpSocket = new QUdpSocket(this);

    connect(tcpSocket, &QTcpSocket::connected,this, [this] {
        qDebug() << "has connected";
    });

    connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(readTCPResult()));
    connect(udpSocket, SIGNAL(readyRead()),this, SLOT(readDatagram()));
}

void SocketServer::broadcastDatagram() {
    // datagram loaded with one byte of data to broadcast to backend
    QByteArray datagram = "1";
    udpSocket->writeDatagram(datagram.data(), datagram.size(),
                             QHostAddress::Broadcast, 10000);
}

void SocketServer::sendData(){

    int res = tcpSocket->write("{\"distortion\": {\"drive\": 1,\"slope\": 0.25},\"intent\": \"EFFECT\"}");
    qDebug() << res;

    tcpSocket->flush();
}

void SocketServer::readTCPResult() {

    QByteArray tcpResult = tcpSocket->readAll();

    qDebug() << tcpResult;
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
        qDebug() << "Got IP: " << address << " on Port: " << port;
        tcpConnection(address,port);
    }
}
