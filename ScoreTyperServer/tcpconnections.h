#ifndef TCPCONNECTIONS_H
#define TCPCONNECTIONS_H

#include <QObject>
#include <tcpconnection.h>
#include <dbconnection.h>
#include <QMutex>
#include <QMutexLocker>

#include <QDebug>

class TcpConnections : public QObject
{
    Q_OBJECT

private:
    QList<TcpConnection *> connections;
    DbConnection * dbConnection;
    static QMutex mutex;

    TcpConnection * createConnection(qintptr descriptor);

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
