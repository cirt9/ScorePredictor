#ifndef TCPSERVER_H
#define TCPSERVER_H

#include <QTcpServer>
#include <QThreadPool>
#include <tcpconnection.h>

#include <QDebug>

class TcpServer : public QTcpServer
{
    Q_OBJECT

private:

protected:
    void incomingConnection(qintptr descriptor);

public:
    explicit TcpServer(QObject * parent = nullptr);
    ~TcpServer() {}

    bool startServer(const QHostAddress & address, quint16 port);
    void closeServer();

public slots:

signals:
};

#endif // TCPSERVER_H
