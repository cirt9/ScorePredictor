#include "tcpconnection.h"

TcpConnection::TcpConnection(QObject * parent) : QObject(parent)
{
    nextPacketSize = 0;
}

void TcpConnection::accept(qintptr descriptor)
{
    socket = new QTcpSocket(this);
    connect(socket, &QTcpSocket::connected, this, &TcpConnection::connected);
    connect(socket, &QTcpSocket::disconnected, this, &TcpConnection::disconnected);
    connect(socket, &QTcpSocket::readyRead, this, &TcpConnection::read);
    connect(socket, &QTcpSocket::stateChanged, this, &TcpConnection::stateChanged);
    connect(socket, static_cast<void (QTcpSocket::*) (QAbstractSocket::SocketError)>(&QTcpSocket::error),
            this, &TcpConnection::error);

    if(!socket->setSocketDescriptor(descriptor))
        return;

    emit started();
}

void TcpConnection::quit()
{
    socket->disconnectFromHost();
}

void TcpConnection::connected()
{

}

void TcpConnection::disconnected()
{
    emit finished();
}

void TcpConnection::read()
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

void TcpConnection::send(const QVariantList & data)
{
    if(socket->state() != QTcpSocket::ConnectedState)
        return;

    Packet packet(data);

    if(!packet.isCorrupted())
        socket->write(packet.getSerializedData());
}

void TcpConnection::flushSocket()
{
    if(socket->bytesAvailable())
        socket->readAll();
}

void TcpConnection::stateChanged(QAbstractSocket::SocketState state)
{
    Q_UNUSED(state)
}

void TcpConnection::error(QAbstractSocket::SocketError error)
{
    Q_UNUSED(error)
}
