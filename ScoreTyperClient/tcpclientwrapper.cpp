#include "tcpclientwrapper.h"

TcpClientWrapper::TcpClientWrapper(QObject * parent) : QObject(parent)
{
    client = new TcpClient();

    connect(client, &TcpClient::started, this, &TcpClientWrapper::connected);
    connect(client, &TcpClient::remoteHostClosed, this, &TcpClientWrapper::serverClosed);
    connect(client, &TcpClient::hostNotFound, this, &TcpClientWrapper::serverNotFound);
    connect(client, &TcpClient::connectionRefused, this, &TcpClientWrapper::connectionRefused);
    connect(client, &TcpClient::networkError, this, &TcpClientWrapper::networkError);
    connect(client, &TcpClient::unidentifiedError, this, &TcpClientWrapper::unidentifiedError);
    connect(this, &TcpClientWrapper::connectingToServer, client, &TcpClient::connectToServer, Qt::QueuedConnection);
    connect(this, &TcpClientWrapper::sendData, client, &TcpClient::send, Qt::QueuedConnection);
}

TcpClientWrapper::~TcpClientWrapper()
{
    client->deleteLater();
}

void TcpClientWrapper::connectToServer(const QHostAddress & address, quint16 port)
{
    emit connectingToServer(address, port);
}

TcpClient * TcpClientWrapper::getClient() const
{
    return client;
}
