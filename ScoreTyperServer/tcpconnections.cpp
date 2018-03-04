#include "tcpconnections.h"

TcpConnections::TcpConnections(QObject * parent) : QObject(parent)
{
    qDebug() << "Connections created";
}

void TcpConnections::run()
{
    qDebug() << this << "Connections starting";

    loop = new QEventLoop();
    connect(this, &TcpConnections::quit, loop, &QEventLoop::quit);
    loop->exec();

    qDebug() << this << "Connections finished";

    emit finished();
}

int TcpConnections::count()
{
    QMutexLocker locker(&mutex);
    int numberOfConnections = connections.count();

    return numberOfConnections;
}

void TcpConnections::connectionStarted()
{
    TcpConnection * connection = qobject_cast<TcpConnection *>(sender());

    if(!connection)
        return;

    qDebug() << this << "Connection started";
}

void TcpConnections::connectionFinished()
{
    TcpConnection * connection = qobject_cast<TcpConnection *>(sender());

    if(!connection)
        return;

    qDebug() << this << "Connection finished" << connection;

    QMutexLocker locker(&mutex);
    connections.removeAll(connection);
    connection->deleteLater();

    qDebug() << this << "Connection was removed";

    emit updated();
}

void TcpConnections::connectionPending(qintptr descriptor, TcpConnections * pool)
{
    if(pool != this)
        return;

    qDebug() << this << "Accepting connection" << descriptor;

    TcpConnection * connection = addConnection(descriptor);

    if(!connection)
    {
        qDebug() << "Could not add connection";
        return;
    }
    emit updated();
}

void TcpConnections::close()
{
    qDebug() << this << "Closing connections";

    emit quit();
}

TcpConnection * TcpConnections::addConnection(qintptr descriptor)
{
    TcpConnection * connection = new TcpConnection(this);

    connect(connection, &TcpConnection::started, this, &TcpConnections::connectionStarted, Qt::QueuedConnection);
    connect(connection, &TcpConnection::finished, this, &TcpConnections::connectionFinished, Qt::QueuedConnection);
    connect(this, &TcpConnections::quit, connection, &TcpConnection::quit, Qt::QueuedConnection);

    connections.append(connection);
    connection->accept(descriptor);

    return connection;
}
