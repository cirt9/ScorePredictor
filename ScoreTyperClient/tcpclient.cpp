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

    qDebug() << "Disconnecting from server";
    socket->disconnectFromHost();
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
    QDataStream in(socket);
    in.setVersion(QDataStream::Qt_5_10);

    if(nextPacketSize == 0)
    {
        if(socket->bytesAvailable() < sizeof(quint16))
        {
            qDebug() << "No bytes to read.";
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
        qDebug() << "Packet processed successfully";
    nextPacketSize = 0;
    //read();
}

void TcpClient::send(const QVariantList & data)
{
    qDebug() << "Sending data:" << data;

    Packet packet(data);

    if(!packet.isCorrupted())
        socket->write(packet.getSerializedData());
    else
        qDebug() << packet.lastError();
}

void TcpClient::flushSocket()
{
    if(socket->bytesAvailable())
        socket->readAll();
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
