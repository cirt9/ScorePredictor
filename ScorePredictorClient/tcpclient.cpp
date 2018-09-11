#include "tcpclient.h"

TcpClient::TcpClient(QObject * parent) : QObject(parent)
{
    socket = new QTcpSocket(this);
    nextPacketSize = 0;

    connect(socket, &QTcpSocket::connected, this, &TcpClient::connected);
    connect(socket, &QTcpSocket::disconnected, this, &TcpClient::disconnected);
    connect(socket, &QTcpSocket::readyRead, this, &TcpClient::read);
    connect(socket, &QTcpSocket::stateChanged, this, &TcpClient::stateChanged);
    connect(socket, static_cast<void (QTcpSocket::*) (QAbstractSocket::SocketError)>(&QTcpSocket::error),
            this, &TcpClient::error);
}

bool TcpClient::connectToServer(const QHostAddress & address, quint16 port)
{
    if(socket->state() == QTcpSocket::ConnectedState)
        return false;

    socket->connectToHost(address, port);

    if(socket->waitForConnected())
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
    if(!(socket->state() == QTcpSocket::ConnectedState))
        return;

    socket->disconnectFromHost();
}

void TcpClient::connected()
{

}

void TcpClient::disconnected()
{
    emit finished();
}

void TcpClient::read()
{
    QDataStream in(socket);
    in.setVersion(QDataStream::Qt_5_10);

    if(nextPacketSize == 0)
    {
        if(socket->bytesAvailable() < sizeof(quint16))
            return;

        in >> nextPacketSize;
    }

    if(socket->bytesAvailable() < nextPacketSize)
        return;

    Packet packet(in);

    if(packet.isCorrupted())
        flushSocket();
    else
        emit packetArrived(packet);

    nextPacketSize = 0;

    if(socket->bytesAvailable() >= sizeof(quint16))
        read();
}

void TcpClient::send(const QVariantList & data)
{
    if(socket->state() != QTcpSocket::ConnectedState)
        return;

    Packet packet(data);

    if(!packet.isCorrupted())
        socket->write(packet.getSerializedData());
}

void TcpClient::flushSocket()
{
    if(socket->bytesAvailable())
        socket->readAll();
}

void TcpClient::stateChanged(QAbstractSocket::SocketState state)
{
    Q_UNUSED(state)
}

void TcpClient::error(QAbstractSocket::SocketError error)
{
    if(error == QAbstractSocket::RemoteHostClosedError)
        emit remoteHostClosed();

    else if(error == QAbstractSocket::HostNotFoundError)
        emit hostNotFound();

    else if(error == QAbstractSocket::ConnectionRefusedError)
        emit connectionRefused();

    else if(error == QAbstractSocket::NetworkError)
        emit networkError();

    else if(error == QAbstractSocket::SocketTimeoutError)
        emit socketTimeoutError();
    else
        emit unidentifiedError();
}
