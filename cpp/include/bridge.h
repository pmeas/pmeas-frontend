#pragma once

#include <QObject>

// The Bridge class will allow us to listen to and
// send messages to the backend server.
//
// This class is exposed to the QML environment so
// it can be used and tied into the GUI easily.

#include <QUdpSocket>
#include <QTcpSocket>
#include <QQmlParserStatus>

class Bridge : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)

    Q_PROPERTY( bool connected READ connected NOTIFY connectedChanged )

public:
    // Define a basic contructor for a QObject
    explicit Bridge( QObject *parent = nullptr );

    bool connected() const;

    // Virtual methods from the QQmlParserStatus class.
    void classBegin() override;

    // Is called by the QML 'Component.onCompleted' signal.
    void componentComplete() override;

signals:
    void connectedChanged();

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
