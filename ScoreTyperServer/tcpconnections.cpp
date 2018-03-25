#include "tcpconnections.h"

TcpConnections::TcpConnections(QObject * parent) : QObject(parent)
{
    //dbConnection = nullptr;
    qDebug() << "Connections created";
}

void TcpConnections::init()
{
    /*
    if(dbConnection)
        return;

    dbConnection = new DbConnection(this);
    dbConnection->connect(QString::number(DbConnection::numberOfOpenedConnections()));
    */
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

    emit connectionsDecreased();
}

void TcpConnections::connectionPending(qintptr descriptor)
{
    qDebug() << this << "Accepting connection" << descriptor;

    TcpConnection * connection = addConnection(descriptor);

    if(!connection)
    {
        qDebug() << "Could not add connection";
        return;
    }
    emit connectionsIncreased();
}

void TcpConnections::close()
{
    qDebug() << this << "Closing connections";

    //dbConnection->close();

    for(auto connection : connections)
        connection->quit();

    emit finished();
}

TcpConnection * TcpConnections::addConnection(qintptr descriptor)
{
    TcpConnection * connection = new TcpConnection(this);

    connect(connection, &TcpConnection::started, this, &TcpConnections::connectionStarted);
    connect(connection, &TcpConnection::finished, this, &TcpConnections::connectionFinished);

    connections.append(connection);
    connection->accept(descriptor);

    return connection;
}
