#pragma once

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QHostAddress>

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
    Q_PROPERTY(QVariantList inports MEMBER m_inports NOTIFY inportsChanged)
    Q_PROPERTY(QVariantList outports MEMBER m_outports NOTIFY outportsChanged)
    Q_PROPERTY(QString currentIn MEMBER m_curIn NOTIFY curInChanged)
    Q_PROPERTY(QString currentOut MEMBER m_curOut NOTIFY curOutChanged)
    // Define a basic contructor for a QObject
    explicit Bridge( QObject *parent = nullptr );

    bool connected() const;

    // Virtual methods from the QQmlParserStatus class.
    void classBegin() override;

    // Is called by the QML 'Component.onCompleted' signal.
    void componentComplete() override;

signals:
    void tcpSocketConnected();
    void lostConnection();
    void inportsChanged();
    void outportsChanged();
    void curInChanged();
    void connectedChanged();
    void curOutChanged();
public slots:
    void beginUDPBroadcast();
    void tcpSend(QByteArray);
    void udpRecvBackendIpAndConnect();
    void getPorts();
    void sendPorts();
    void updatePorts();
    void handleUDPStateChanged( QAbstractSocket::SocketState t_state );
    void handleUDPError( QAbstractSocket::SocketError t_error );
    void handleTcpStateChanged( QAbstractSocket::SocketState t_state );
private:
    QVariantList m_inports, m_outports;
    QString m_curIn, m_curOut;
    QTcpSocket m_tcpSocket;
    QUdpSocket m_udpSocket;
};
