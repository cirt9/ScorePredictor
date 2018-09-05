#include "tcpconnectionswrapper.h"

TcpConnectionsWrapper::TcpConnectionsWrapper(QObject * parent) : QObject(parent)
{
    workerThread = new QThread(this);
    numberOfConnections = 0;
    connectionPool = new TcpConnections();

    connect(this, &TcpConnectionsWrapper::pendingConnection, connectionPool,
            &TcpConnections::connectionPending, Qt::QueuedConnection);
    connect(connectionPool, &TcpConnections::connectionsIncreased, this,
            &TcpConnectionsWrapper::connectionsIncreased, Qt::QueuedConnection);
    connect(connectionPool, &TcpConnections::connectionsDecreased, this,
            &TcpConnectionsWrapper::connectionsDecreased, Qt::QueuedConnection);
    connect(this, &TcpConnectionsWrapper::quit, connectionPool,
            &TcpConnections::close, Qt::QueuedConnection);
    connect(connectionPool, &TcpConnections::finished, this,
            &TcpConnectionsWrapper::terminate, Qt::QueuedConnection);
    connect(workerThread, &QThread::started, connectionPool, &TcpConnections::init);

    workerThread->start();
    connectionPool->moveToThread(workerThread);

    qDebug() << "Connections starting in wrapper " << this;
}

TcpConnectionsWrapper::~TcpConnectionsWrapper()
{
    connectionPool->deleteLater();
}

void TcpConnectionsWrapper::close()
{
    qDebug() << "Closing connection pool in wrapper" << this;

    emit quit();
}

void TcpConnectionsWrapper::connectionPending(qintptr descriptor, TcpConnectionsWrapper * pool)
{
    if(this != pool)
        return;

    emit pendingConnection(descriptor);
}

void TcpConnectionsWrapper::terminate()
{
    workerThread->quit();
    workerThread->wait();

    qDebug() << "Connection pool in" << this << "finished";

    emit finished();
}

void TcpConnectionsWrapper::connectionsIncreased()
{
    numberOfConnections++;
    emit clientsIncreased();
}

void TcpConnectionsWrapper::connectionsDecreased()
{
    numberOfConnections--;
    emit clientsDecreased();
}

int TcpConnectionsWrapper::getNumberOfConnections() const
{
    return numberOfConnections;
}
