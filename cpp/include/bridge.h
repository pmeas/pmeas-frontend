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
public:
    Q_PROPERTY(QVariantList inports MEMBER m_inports NOTIFY inportsChanged)
    Q_PROPERTY(QVariantList outports MEMBER m_outports NOTIFY outportsChanged)
    Q_PROPERTY(QString currentIn MEMBER m_curIn NOTIFY curInChanged)
    Q_PROPERTY(QString currentOut MEMBER m_curOut NOTIFY curOutChanged)
    // Define a basic contructor for a QObject
    explicit Bridge( QObject *parent = nullptr );
signals:
    void tcpSocketConnected();
    void lostConnection();
    void inportsChanged();
    void outportsChanged();
    void curInChanged();

    void curOutChanged();
public slots:
    void beginUDPBroadcast();
    void tcpSend(QByteArray);
    void udpRecvBackendIpAndConnect();
    void getPorts();
    void sendPorts();
    void updatePorts();
private:
    QUdpSocket *m_udpSocket;
    QAbstractSocket *m_tcpSocket;
    QVariantList m_inports, m_outports;
    QString m_curIn, m_curOut;
};
