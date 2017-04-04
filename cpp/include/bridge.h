#pragma once

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
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
    Q_OBJECT
    Q_PROPERTY(QVariantList inports MEMBER m_inports NOTIFY portsChanged)
    Q_PROPERTY(QVariantList outports MEMBER m_outports NOTIFY portsChanged)
public:
    // Define a basic contructor for a QObject
    explicit Bridge( QObject *parent = nullptr );

signals:
    void tcpSocketConnected();
    void lostConnection();
    void portsChanged();

public slots:
    void beginUDPBroadcast();
    void tcpSend(QByteArray);
    void udpRecvBackendIpAndConnect();
    void getPorts();
    void sendPorts();

private:
    QUdpSocket *m_udpSocket;
    QAbstractSocket *m_tcpSocket;
    QVariantList m_inports, m_outports;
    QString inport, outport;
};
