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
    clientSocket->connectToHost(address, port);

    if(clientSocket->waitForConnected())
    {
        emit started();
        return true;
    }
    else
        return false;
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

void TcpClient::disconnectFromServer()
{
    qDebug() << "Disconnecting from server";
    clientSocket->disconnectFromHost();
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
}
