#ifndef TCPCONNECTIONS_H
#define TCPCONNECTIONS_H

#include <QObject>
#include <QRunnable>
#include <QEventLoop>
#include <QMutex>
#include <QMutexLocker>
#include <tcpconnection.h>

#include <QDebug>

class TcpConnections : public QObject, public QRunnable
{
    Q_OBJECT

private:
    QEventLoop * loop;
    QMutex mutex;
    QList<TcpConnection *> connections;

    TcpConnection * addConnection(qintptr descriptor);

public:
    explicit TcpConnections(QObject * parent = nullptr);
    ~TcpConnections() {}

    void run();
    int count();

public slots:
    void connectionPending(qintptr descriptor, TcpConnections * pool);
    void connectionStarted();
    void connectionFinished();
    void close();

signals:
    void quit();
    void finished();
    void updated();
};

#endif // TCPCONNECTIONS_H
