#ifndef TCPSERVER_H
#define TCPSERVER_H

#include <QTcpServer>
#include <QThreadPool>
#include <QTimer>
#include <tcpconnectionswrapper.h>

#include <QDebug>

class TcpServer : public QTcpServer
{
    Q_OBJECT

private:
    QList<TcpConnectionsWrapper *> connectionPools;
    void info();

protected:
    void incomingConnection(qintptr descriptor);
    void createConnectionPool();

public:
    explicit TcpServer(QObject * parent = nullptr);
    ~TcpServer() {}

    Q_INVOKABLE bool startServer(quint16 port, const QHostAddress & address = QHostAddress::Any);
    Q_INVOKABLE void closeServer();
    Q_INVOKABLE bool isSafeToTerminate();
    Q_INVOKABLE QString lastError() const;

    int numberOfClients() const;
    qint64 port() const;

public slots:
    void poolFinished();
    void poolUpdated();

signals:
    void connectionPending(qintptr descriptor, TcpConnectionsWrapper * connectionPool);
    void quit();
    void finished();
    void started();
    void closed();
    void clientsIncreased();
    void clientsDecreased();
};

#endif // TCPSERVER_H
