#pragma once

#include <QObject>

// The SocketServer class will allow us to listen to and
// send messages to the backend server.
//
// This class is exposed to the QML environment so
// it can be used and tied into the GUI easily.

// Forward declares
class QTimer;
class QUdpSocket;

class SocketServer : public QObject
{
    // This Q_OBJECT macro is required by Qt, because we subclass the QObject class.
    Q_OBJECT
public:
    // Define a basic contructor for a QObject
    explicit SocketServer( QObject *parent = nullptr );

signals:

public slots:
    void broadcastDatagram();

private:
    QUdpSocket *udpSocket;
};
