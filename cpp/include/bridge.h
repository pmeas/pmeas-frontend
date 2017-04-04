#pragma once

#include <QObject>

// The Bridge class will allow us to listen to and
// send messages to the backend server.
//
// This class is exposed to the QML environment so
// it can be used and tied into the GUI easily.

#include <QUdpSocket>
#include <QTcpSocket>

class Bridge : public QObject
{
    // This Q_OBJECT macro is required by Qt, because we subclass the QObject class.
    Q_OBJECT
    Q_PROPERTY( bool isConnected READ isConnected NOTIFY isConnectedChanged )

public:
    // Define a basic contructor for a QObject
    explicit  Bridge( QObject *parent = nullptr );

    bool isConnected() const;

signals:
    void tcpSocketConnected();
    void lostConnection();
    void isConnectedChanged();

public slots:
    void broadcastDatagram();
    void sendData(QByteArray);

private slots:
    void readDatagram();
    void readTCPResult();

    void handleUDPStateChanged( QAbstractSocket::SocketState t_state );
    void handleUDPError( QAbstractSocket::SocketError t_error );

    void handleTcpStateChanged( QAbstractSocket::SocketState t_state );

private:
    QUdpSocket m_udpSocket;
    QTcpSocket m_tcpSocket;

};
