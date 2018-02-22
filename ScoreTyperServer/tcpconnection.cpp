#include "tcpconnection.h"

TcpConnection::TcpConnection(QObject * parent) : QObject(parent)
{
    qDebug() << "Connection created";
}

void TcpConnection::setSocket(qintptr descriptor)
{
    socket = new QTcpSocket(this);

    connect(socket, SIGNAL(connected()), this, SLOT(connected()));
    connect(socket, SIGNAL(disconnected()), this, SLOT(disconnected()));
    connect(socket, SIGNAL(readyRead()), this, SLOT(read()));

    socket->setSocketDescriptor(descriptor);
    qDebug() << "Client connected";
}

void TcpConnection::connected()
{
    qDebug() << "Client connected (slot)";
}

void TcpConnection::disconnected()
{
    qDebug() << "Client disconnected (slot)";
}

void TcpConnection::read()
{
    qDebug() << socket->readAll();
}
