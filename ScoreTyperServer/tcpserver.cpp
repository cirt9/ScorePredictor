#include "tcpserver.h"

TcpServer::TcpServer(QObject * parent) : QTcpServer(parent)
{

}

void TcpServer::incomingConnection(qintptr descriptor)
{
    TcpConnection * connection = new TcpConnection(this);
    connection->setSocket(descriptor);
}

bool TcpServer::startServer(const QHostAddress & address, quint16 port)
{
    qDebug() << "Server starting...";
    if(listen(address, port))
    {
        qDebug() << "Server started";
        return true;
    }
    else
    {
        qDebug() << "Server not started";
        return false;
    }
}

void TcpServer::closeServer()
{
    qDebug() << "Server closed";
    close();
}
