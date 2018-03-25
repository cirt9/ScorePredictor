#ifndef TCPCONNECTIONS_H
#define TCPCONNECTIONS_H

#include <QObject>
#include <QMutex>
#include <QMutexLocker>
#include <tcpconnection.h>
#include <dbconnection.h>

#include <QDebug>

class TcpConnections : public QObject
{
    Q_OBJECT

private:
    QMutex mutex;
    QList<TcpConnection *> connections;
    //DbConnection * dbConnection;

    TcpConnection * addConnection(qintptr descriptor);

public:
    explicit TcpConnections(QObject * parent = nullptr);
    ~TcpConnections() {}

public slots:
    void connectionPending(qintptr descriptor);
    void connectionStarted();
    void connectionFinished();
    void close();

    void init();

signals:
    void finished();
    void connectionsIncreased();
    void connectionsDecreased();
};

#endif // TCPCONNECTIONS_H
