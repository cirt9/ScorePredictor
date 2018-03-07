#include "backend.h"

BackEnd::BackEnd(QObject * parent) : QObject(parent)
{
    client = new TcpClient(this);
    client->connectToServer(QHostAddress("127.0.0.1"), 5000);
}

bool BackEnd::login(const QString & login, const QString & password)
{
    if(login == QString("") && password == QString(""))
        return true;
    else
        return false;
}

TcpClient * BackEnd::getClient() const
{
    return client;
}
