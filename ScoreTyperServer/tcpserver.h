#ifndef TCPSERVER_H
#define TCPSERVER_H

#include <QTcpServer>
#include <QThreadPool>
#include <tcpconnections.h>

#include <QDebug>

class TcpServer : public QTcpServer
{
    Q_OBJECT

private:
    QList<TcpConnections *> connectionsPools;
    void info();

protected:
    void incomingConnection(qintptr descriptor);
    void createConnectionsPool();

public:
    explicit TcpServer(QObject * parent = nullptr);
    ~TcpServer() {}

    Q_INVOKABLE bool startServer(quint16 port, const QHostAddress & address = QHostAddress::Any);
    Q_INVOKABLE void closeServer();
    Q_INVOKABLE bool isSafeToTerminate();

    int numberOfClients() const;
    qint64 port() const;

public slots:
    void poolFinished();
    void poolUpdated();

signals:
    void connectionPending(qintptr descriptor, TcpConnections * connectionsPool);
    void quit();
    void finished();

};

#endif // TCPSERVER_H
