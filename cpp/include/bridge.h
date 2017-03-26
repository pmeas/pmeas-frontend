#pragma once

#include <QObject>
#include <QHostAddress>

// The SocketServer class will allow us to listen to and
// send messages to the backend server.
//
// This class is exposed to the QML environment so
// it can be used and tied into the GUI easily.

// Forward declares
class QUdpSocket;
class QTcpSocket;

class Bridge : public QObject
{
    // This Q_OBJECT macro is required by Qt, because we subclass the QObject class.
    Q_OBJECT
public:
    // Define a basic contructor for a QObject
    explicit Bridge( QObject *parent = nullptr );

signals:
    void tcpSocketConnected();

public slots:
    void broadcastDatagram();
    void broadcastJson(QByteArray);

private slots:
    void readDatagram();
    void readTCPResult();

private:
    QUdpSocket *m_udpSocket;
    QAbstractSocket *m_tcpSocket;
};
