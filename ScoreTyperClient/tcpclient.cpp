#include "tcpclient.h"

TcpClient::TcpClient(QObject * parent) : QObject(parent)
{
    clientSocket = new QTcpSocket(this);
    nextPacketSize = 0;

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
        nextPacketSize = 0;
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
    QDataStream in(clientSocket);
    in.setVersion(QDataStream::Qt_5_10);

    if(nextPacketSize == 0)
    {
        if(clientSocket->bytesAvailable() < sizeof(quint16))
        {
            qDebug() << "No bytes to read.";
            return;
        }
        in >> nextPacketSize;
        qDebug() << "Packet size: " << nextPacketSize;
    }

    if(clientSocket->bytesAvailable() < nextPacketSize)
    {
        qDebug() << "Not enough bytes to read packet. Bytes: " << clientSocket->bytesAvailable() << "Packet size: " << nextPacketSize;
        return;
    }

    Packet packet(in);
    if(packet.isCorrupted())
        qDebug() << packet.lastError();
    else
        qDebug() << "Packet processed successfully";
    nextPacketSize = 0;
    //read();
}

void TcpClient::send(const QVariantList & data)
{
    qDebug() << "Sending data:" << data;

    Packet packet(data);

    if(!packet.isCorrupted())
        clientSocket->write(packet.getSerializedData());
    else
        qDebug() << packet.lastError();
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
