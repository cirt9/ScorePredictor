#include "tcpconnections.h"

QMutex TcpConnections::mutex;

TcpConnections::TcpConnections(QObject * parent) : QObject(parent)
{

}

void TcpConnections::init()
{
    if(dbConnection)
        return;

    QMutexLocker locker(&mutex);

    dbConnection = QSharedPointer<DbConnection>(new DbConnection(this));
    dbConnection->setConnectOptions("QSQLITE_ENABLE_SHARED_CACHE=1;QSQLITE_BUSY_TIMEOUT=10000;");
    dbConnection->connect(QString::number(dbConnection->numberOfOpenedConnections()));
}

void TcpConnections::connectionStarted()
{
    QPointer<TcpConnection> connection = qobject_cast<TcpConnection *>(sender());

    if(!connection)
        return;
}

void TcpConnections::connectionFinished()
{
    QPointer<TcpConnection> connection = qobject_cast<TcpConnection *>(sender());

    if(!connection)
        return;

    connections.removeAll(connection);
    connection->deleteLater();

    emit connectionsDecreased();
}

void TcpConnections::connectionPending(qintptr descriptor)
{
    QPointer<TcpConnection> connection = createConnection(descriptor);

    if(!connection)
        return;

    emit connectionsIncreased();
}

void TcpConnections::close()
{
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
    QPointer<TcpConnection> connection = qobject_cast<TcpConnection *>(sender());
    Server::PacketProcessor * packetProcessor = new Server::PacketProcessor(dbConnection, this);
    connect(packetProcessor, &Server::PacketProcessor::response, connection, &TcpConnection::send);

    packetProcessor->processPacket(packet);
    packetProcessor->deleteLater();
}
