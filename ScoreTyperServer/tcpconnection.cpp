#include "tcpconnection.h"

TcpConnection::TcpConnection(QObject * parent) : QObject(parent)
{
    qDebug() << "Connection created";
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
        qDebug() << "Could not accept connection";
        return;
    }

    qDebug() << "Connection " << descriptor << "accepted";

    emit started();
}

void TcpConnection::quit()
{
    qDebug() << "Connection quitting...";
    socket->disconnectFromHost();
}

void TcpConnection::connected()
{
    if(!sender())
        return;

    qDebug() << "Client connected";
}

void TcpConnection::disconnected()
{
    if(!sender())
        return;

    qDebug() << "Client disconnected";

    emit finished();
}

void TcpConnection::read()
{
    if(!sender())
        return;

    qDebug() << socket->readAll();
}

void TcpConnection::stateChanged(QAbstractSocket::SocketState state)
{
    if(!sender())
        return;

    qDebug() << "State changed" << state;
}

void TcpConnection::error(QAbstractSocket::SocketError error)
{
    if(!sender())
        return;

    qDebug() << "Error:" << error;
}
