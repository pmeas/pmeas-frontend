#include <QUdpSocket>
#include <QNetworkDatagram>
#include <QTcpSocket>

#include "socketserver.h"

SocketServer::SocketServer(QObject *parent) : QObject(parent)
{
    tcpSocket = new QTcpSocket(this);
    udpSocket = new QUdpSocket(this);

    connect(tcpSocket, &QTcpSocket::connected,this, [this] {
        qDebug() << "has connected";
    });

    connect(tcpSocket, &QTcpSocket::connected, this, &SocketServer::tcpConnected);
    connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(readTCPResult()));
    connect(udpSocket, SIGNAL(readyRead()),this, SLOT(readDatagram()));
}

void SocketServer::broadcastDatagram() {
    // TODO: Replace this sample JSON with live effect data + params.
    /* TODO: See if we _want_ to just broadcast the data or make a TCP
     * connection after like Younes suggests to send data over reliably. This can be done
     * of course but before we start work on it we gotta make sure its what we want to do.
     */
//    QByteArray datagram = "{\"delay\":{\"delay\": 1,\"feedback\": 0.5}}";
    QByteArray message = "1";
    udpSocket->writeDatagram(message.data(), message.size(),
                             QHostAddress::Broadcast, 10000);
}

void SocketServer::sendData(QByteArray message){

    int res = tcpSocket->write(message);
    if(res == -1) {
        qDebug() << "Connection severed.";
        emit(lostConnection());
    }

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
