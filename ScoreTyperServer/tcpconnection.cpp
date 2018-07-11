#include "tcpconnection.h"

TcpConnection::TcpConnection(QObject * parent) : QObject(parent)
{
    nextPacketSize = 0;
    qDebug() << "Connection created" << this;
}

void TcpConnection::accept(qintptr descriptor)
{
    qDebug() << "Accepting connection " << descriptor;

    socket = new QTcpSocket(this);
    connect(socket, &QTcpSocket::connected, this, &TcpConnection::connected);
    connect(socket, &QTcpSocket::disconnected, this, &TcpConnection::disconnected);
    connect(socket, &QTcpSocket::readyRead, this, &TcpConnection::read);
    connect(socket, &QTcpSocket::stateChanged, this, &TcpConnection::stateChanged);
    connect(socket, static_cast<void (QTcpSocket::*) (QAbstractSocket::SocketError)>(&QTcpSocket::error),
            this, &TcpConnection::error);

    if(!socket->setSocketDescriptor(descriptor))
    {
        qDebug() << "Could not accept connection" << descriptor;
        return;
    }

    qDebug() << "Connection " << descriptor << "accepted";
    emit started();
}

void TcpConnection::quit()
{
    qDebug() << "Connection quitting..." << this;
    socket->disconnectFromHost();
}

void TcpConnection::connected()
{
    qDebug() << "Client connected" << this;
}

void TcpConnection::disconnected()
{
    qDebug() << "Client disconnected" << this;

    emit finished();
}

void TcpConnection::read()
{
    QDataStream in(socket);
    in.setVersion(QDataStream::Qt_5_10);

    if(nextPacketSize == 0)
    {
        if(socket->bytesAvailable() < sizeof(quint16))
        {
            qDebug() << "Not enough bytes to read packet size";
            return;
        }
        in >> nextPacketSize;
        qDebug() << "Packet size: " << nextPacketSize;
    }

    if(socket->bytesAvailable() < nextPacketSize)
    {
        qDebug() << "Not enough bytes to read packet. Bytes: " << socket->bytesAvailable() << "Packet size: " << nextPacketSize;
        return;
    }

    Packet packet(in);
    if(packet.isCorrupted())
    {
        flushSocket();
        qDebug() << packet.lastError();
    }
    else
        emit packetArrived(packet);
    nextPacketSize = 0;

    if(socket->bytesAvailable() >= sizeof(quint16))
        read();
}

void TcpConnection::send(const QVariantList & data)
{
    qDebug() << "Sending data:" << data;

    if(socket->state() != QTcpSocket::ConnectedState)
        return;

    Packet packet(data);

    if(!packet.isCorrupted())
        socket->write(packet.getSerializedData());
    else
        qDebug() << packet.lastError();
}

void TcpConnection::flushSocket()
{
    if(socket->bytesAvailable())
        socket->readAll();
}

void TcpConnection::stateChanged(QAbstractSocket::SocketState state)
{
    qDebug() << "State changed" << state << "in" << this;
}

void TcpConnection::error(QAbstractSocket::SocketError error)
{
    qDebug() << "Error:" << error << "in" << this;
}
