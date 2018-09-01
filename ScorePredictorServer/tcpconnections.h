#ifndef TCPCONNECTIONS_H
#define TCPCONNECTIONS_H

#include <QObject>
#include <tcpconnection.h>
#include <dbconnection.h>
#include <QMutex>
#include <QMutexLocker>
#include <QPointer>
#include <packet.h>
#include <packetprocessor.h>
#include <QSharedPointer>

#include <QDebug>

class TcpConnections : public QObject
{
    Q_OBJECT

private:
    QList<QPointer<TcpConnection> > connections;
    QSharedPointer<DbConnection> dbConnection;
    static QMutex mutex;

    QPointer<TcpConnection> createConnection(qintptr descriptor);

private slots:
    void processPacket(const Packet & packet);

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
