#include "tcpconnections.h"

QMutex TcpConnections::mutex;

TcpConnections::TcpConnections(QObject * parent) : QObject(parent)
{
    qDebug() << "Connections created" << this;
}

void TcpConnections::init()
{
    if(dbConnection)
        return;

    QMutexLocker locker(&mutex);

    dbConnection = QSharedPointer<DbConnection>(new DbConnection(this));
    dbConnection->connect(QString::number(dbConnection->numberOfOpenedConnections()));
}

void TcpConnections::connectionStarted()
{
    QPointer<TcpConnection> connection = qobject_cast<TcpConnection *>(sender());

    if(!connection)
        return;

    qDebug() << "Connection started" << this;
}

void TcpConnections::connectionFinished()
{
    QPointer<TcpConnection> connection = qobject_cast<TcpConnection *>(sender());

    if(!connection)
        return;

    qDebug() << this << "Connection finished" << connection;

    connections.removeAll(connection);
    connection->deleteLater();

    qDebug() << this << "Connection was removed";

    emit connectionsDecreased();
}

void TcpConnections::connectionPending(qintptr descriptor)
{
    qDebug() << this << "Accepting connection" << descriptor;

    QPointer<TcpConnection> connection = createConnection(descriptor);

    if(!connection)
    {
        qDebug() << "Could not add connection in " << this;
        return;
    }
    emit connectionsIncreased();
}

void TcpConnections::close()
{
    qDebug() << this << "Closing connections";
    QMutexLocker locker(&mutex);
    dbConnection->close();

    for(auto connection : connections)
        connection->quit();

    emit finished();
}

QPointer<TcpConnection> TcpConnections::createConnection(qintptr descriptor)
{
    QPointer<TcpConnection> connection = new TcpConnection(this);

    connect(connection, &TcpConnection::started, this, &TcpConnections::connectionStarted);
    connect(connection, &TcpConnection::finished, this, &TcpConnections::connectionFinished);
    connect(connection, &TcpConnection::packetArrived, this, &TcpConnections::processPacket);

    connections.append(connection);
    connection->accept(descriptor);

    return connection;
}

void TcpConnections::processPacket(const Packet & packet)
{
    qDebug() << packet.getUnserializedData();

    QPointer<TcpConnection> connection = qobject_cast<TcpConnection *>(sender());
    ServerPacketProcessor * packetProcessor = new ServerPacketProcessor(dbConnection, this);
    connect(packetProcessor, &ServerPacketProcessor::response, connection, &TcpConnection::send);

    packetProcessor->processPacket(packet);
    packetProcessor->deleteLater();
}
