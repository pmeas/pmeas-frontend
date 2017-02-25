#pragma once

#include <QObject>

#include <QLocalServer>

class SocketServer : public QObject
{
    Q_OBJECT
public:
    explicit SocketServer( QObject *parent = nullptr );

signals:

public slots:

private:
    QLocalServer *m_localServer;
};
