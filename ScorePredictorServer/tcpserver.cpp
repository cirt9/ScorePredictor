#include "tcpserver.h"

TcpServer::TcpServer(QObject * parent) : QTcpServer(parent)
{
    QThreadPool::globalInstance()->setMaxThreadCount(QThread::idealThreadCount());

    qDebug() << "Server created";
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
        createConnectionPool();

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

void TcpServer::createConnectionPool()
{
    TcpConnectionsWrapper * pool = new TcpConnectionsWrapper(this);
    connectionPools.append(pool);

    connect(this, &TcpServer::quit, pool, &TcpConnectionsWrapper::close);
    connect(pool, &TcpConnectionsWrapper::finished, this, &TcpServer::poolFinished);
    connect(this, &TcpServer::connectionPending, pool, &TcpConnectionsWrapper::connectionPending);
    connect(pool, &TcpConnectionsWrapper::updated, this, &TcpServer::poolUpdated);
}

void TcpServer::incomingConnection(qintptr descriptor)
{
    qDebug() << "Incoming connection..." << descriptor;

    if(connectionPools.count() == 0)
    {
        qDebug() << "No connection pools";
        return;
    }

    TcpConnectionsWrapper * selectedPool = nullptr;

    qDebug() << this << "Getting free pool";

    for(auto pool : connectionPools)
    {
        if(!selectedPool)
        {
            selectedPool = pool;
            continue;
        }

        if(pool->getNumberOfConnections() < selectedPool->getNumberOfConnections())
            selectedPool = pool;
    }

    qDebug() << this << "Attempting to accept connection" << descriptor << "on" << selectedPool;
    emit connectionPending(descriptor, selectedPool);
}

void TcpServer::poolFinished()
{
    TcpConnectionsWrapper * pool = qobject_cast<TcpConnectionsWrapper *>(sender());

    qDebug() << "Finishing pool in wrapper" << pool;

    if(!pool)
    {
        qDebug() << "Sender doesnt exist";
        return;
    }

    qDebug() << this << "Removing pool in wrapper" << pool;

    connectionPools.removeAll(pool);
    pool->deleteLater();

    if(connectionPools.count() == 0)
        emit finished();
}

void TcpServer::poolUpdated()
{
    info();
}

bool TcpServer::isSafeToTerminate()
{
    if(numberOfClients() == 0 && connectionPools.count() == 0 && !isListening())
        return true;

    return false;
}

int TcpServer::numberOfClients() const
{
    int totalNumberOfClients = 0;

    for(auto pool : connectionPools)
        totalNumberOfClients += pool->getNumberOfConnections();

    return totalNumberOfClients;
}

void TcpServer::info()
{
    int totalNumberOfClients = 0;

    qDebug() << "-------------------";

    for(auto pool : connectionPools)
    {
        totalNumberOfClients += pool->getNumberOfConnections();
        qDebug() << "Connections in wrapper(" << pool << "): " << pool->getNumberOfConnections() << "clients";
    }

    qDebug() << "Total number of clients: " << totalNumberOfClients;
    qDebug() << "-------------------";
}
