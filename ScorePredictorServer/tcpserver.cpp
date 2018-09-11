#include "tcpserver.h"

TcpServer::TcpServer(QObject * parent) : QTcpServer(parent)
{
    QThreadPool::globalInstance()->setMaxThreadCount(QThread::idealThreadCount());
}

bool TcpServer::startServer(quint16 port, const QHostAddress & address)
{
    if(!QTcpServer::listen(address, port))
        return false;

    for(int i=0; i<QThreadPool::globalInstance()->maxThreadCount(); i++)
        createConnectionPool();

    emit started();

    return true;
}

void TcpServer::closeServer()
{
    if(!isListening())
        return;

    emit quit();
    close();

    emit closed();
}

void TcpServer::createConnectionPool()
{
    TcpConnectionsWrapper * pool = new TcpConnectionsWrapper(this);
    connectionPools.append(pool);

    connect(this, &TcpServer::quit, pool, &TcpConnectionsWrapper::close);
    connect(pool, &TcpConnectionsWrapper::finished, this, &TcpServer::poolFinished);
    connect(this, &TcpServer::connectionPending, pool, &TcpConnectionsWrapper::connectionPending);
    connect(pool, &TcpConnectionsWrapper::clientsIncreased, this, &TcpServer::clientsIncreased);
    connect(pool, &TcpConnectionsWrapper::clientsDecreased, this, &TcpServer::clientsDecreased);
    connect(pool, &TcpConnectionsWrapper::clientsIncreased, this, &TcpServer::poolUpdated);
    connect(pool, &TcpConnectionsWrapper::clientsDecreased, this, &TcpServer::poolUpdated);
}

void TcpServer::incomingConnection(qintptr descriptor)
{
    if(connectionPools.count() == 0)
        return;

    TcpConnectionsWrapper * selectedPool = nullptr;

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

    emit connectionPending(descriptor, selectedPool);
}

void TcpServer::poolFinished()
{
    TcpConnectionsWrapper * pool = qobject_cast<TcpConnectionsWrapper *>(sender());

    if(!pool)
        return;

    connectionPools.removeAll(pool);
    pool->deleteLater();

    if(connectionPools.count() == 0)
        emit finished();
}

void TcpServer::poolUpdated()
{

}

bool TcpServer::isSafeToTerminate()
{
    if(numberOfClients() == 0 && connectionPools.count() == 0 && !isListening())
        return true;

    return false;
}

QString TcpServer::lastError() const
{
    return errorString();
}

int TcpServer::numberOfClients() const
{
    int totalNumberOfClients = 0;

    for(auto pool : connectionPools)
        totalNumberOfClients += pool->getNumberOfConnections();

    return totalNumberOfClients;
}
