#include "tcpserver.h"

//
#include <dbconnection.h>
//

TcpServer::TcpServer(QObject * parent) : QTcpServer(parent)
{
    QThreadPool::globalInstance()->setMaxThreadCount(QThread::idealThreadCount());

    qDebug() << "Server created";

    //
        DbConnection dbConnection;
        dbConnection.connect("testConnection");
    //
}

bool TcpServer::startServer(quint16 port, const QHostAddress & address)
{
    if(!QTcpServer::listen(address, port))
    {
        qDebug() << this << errorString();
        return false;
    }

    qDebug() << this << "Creating connection pools: " << QThreadPool::globalInstance()->maxThreadCount();

    for(int i=0; i<QThreadPool::globalInstance()->maxThreadCount(); i++)
        createConnectionsPool();

    return true;
}

void TcpServer::closeServer()
{
    if(!isListening())
        return;

    emit quit();
    qDebug() << "Terminating listening";
    close();
}

void TcpServer::createConnectionsPool()
{
    TcpConnections * pool = new TcpConnections();
    connectionsPools.append(pool);

    connect(this, &TcpServer::quit, pool, &TcpConnections::close, Qt::QueuedConnection);
    connect(pool, &TcpConnections::finished, this, &TcpServer::poolFinished, Qt::BlockingQueuedConnection);
    connect(this, &TcpServer::connectionPending, pool, &TcpConnections::connectionPending, Qt::QueuedConnection);
    connect(pool, &TcpConnections::updated, this, &TcpServer::poolUpdated, Qt::QueuedConnection);

    QThreadPool::globalInstance()->start(pool);
}

void TcpServer::incomingConnection(qintptr descriptor)
{
    qDebug() << "Incoming connection..." << descriptor;

    if(connectionsPools.count() == 0)
    {
        qDebug() << "No connection pools";
        return;
    }

    TcpConnections * selectedPool = nullptr;

    qDebug() << this << "Getting free pool";

    for(auto pool : connectionsPools)
    {
        if(!selectedPool)
        {
            selectedPool = pool;
            continue;
        }

        if(pool->count() < selectedPool->count())
            selectedPool = pool;
    }

    qDebug() << this << "Attempting to accept connection" << descriptor << "on" << selectedPool;
    emit connectionPending(descriptor, selectedPool);
}

void TcpServer::poolFinished()
{
    TcpConnections * pool = qobject_cast<TcpConnections *>(sender());

    qDebug() << "Finishing pool" << pool;

    if(!pool)
    {
        qDebug() << "Sender doesnt exist";
        return;
    }

    qDebug() << this << "Removing pool" << pool;

    connectionsPools.removeAll(pool);

    if(connectionsPools.count() == 0)
        emit finished();
}

void TcpServer::poolUpdated()
{
    info();
}

bool TcpServer::isSafeToTerminate()
{
    if(numberOfClients() == 0 && connectionsPools.count() == 0 && !isListening())
        return true;

    return false;
}

int TcpServer::numberOfClients() const
{
    int totalNumberOfClients = 0;

    for(auto connections : connectionsPools)
        totalNumberOfClients += connections->count();

    return totalNumberOfClients;
}

void TcpServer::info()
{
    int totalNumberOfClients = 0;

    qDebug() << "-------------------";

    for(auto pool : connectionsPools)
    {
        totalNumberOfClients += pool->count();
        qDebug() << "Connections(" << pool << "): " << pool->count() << "clients";
    }

    qDebug() << "Total number of clients: " << totalNumberOfClients;
    qDebug() << "-------------------";
}
