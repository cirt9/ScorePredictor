#include "tcpclient.h"

TcpClient::TcpClient(QObject * parent) : QObject(parent)
{
    clientSocket = new QTcpSocket(this);

    connect(clientSocket, &QTcpSocket::connected, this, &TcpClient::connected);
    connect(clientSocket, &QTcpSocket::disconnected, this, &TcpClient::disconnected);
    connect(clientSocket, &QTcpSocket::readyRead, this, &TcpClient::read);
    connect(clientSocket, &QTcpSocket::stateChanged, this, &TcpClient::stateChanged);
    connect(clientSocket, static_cast<void (QTcpSocket::*) (QAbstractSocket::SocketError)>(&QTcpSocket::error),
            this, &TcpClient::error);
}

bool TcpClient::connectToServer(const QHostAddress & address, quint16 port)
{
    if(clientSocket->state() == QTcpSocket::ConnectedState)
        return false;

    clientSocket->connectToHost(address, port);

    if(clientSocket->waitForConnected())
    {
        emit started();
        return true;
    }
    else
        return false;
}

void TcpClient::disconnectFromServer()
{
    if(!(clientSocket->state() == QTcpSocket::ConnectedState))
        return;

    qDebug() << "Disconnecting from server";
    clientSocket->disconnectFromHost();
}

void TcpClient::connected()
{
    qDebug() << "Connected";
}

void TcpClient::disconnected()
{
    qDebug() << "Disconnected";
    emit finished();
}

void TcpClient::read()
{
    qDebug() << clientSocket->readAll();
}

void TcpClient::stateChanged(QAbstractSocket::SocketState state)
{
    qDebug() << "State changed" << state;
}

void TcpClient::error(QAbstractSocket::SocketError error)
{
    qDebug() << "Error:" << error;

    if(error == QAbstractSocket::RemoteHostClosedError)
        emit remoteHostClosed();

    else if(error == QAbstractSocket::HostNotFoundError)
        emit hostNotFound();

    else if(error == QAbstractSocket::ConnectionRefusedError)
        emit connectionRefused();

    else if(error == QAbstractSocket::NetworkError)
        emit networkError();
    else
        emit unidentifiedError();
}
