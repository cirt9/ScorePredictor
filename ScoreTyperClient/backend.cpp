#include "backend.h"

BackEnd::BackEnd(QObject * parent) : QObject(parent)
{
    client = nullptr;
    workerThread = new QThread(this);
    workerThread->start();

    connectToServer(QHostAddress("127.0.0.1"), 5000);
}

bool BackEnd::login(const QString & login, const QString & password)
{
    if(login == QString("") && password == QString(""))
        return true;
    else
        return false;
}

void BackEnd::connectToServer(const QHostAddress & address, quint16 port)
{
    if(!client)
    {
        client = new TcpClient();
        connect(workerThread, &QThread::finished, client, &TcpClient::disconnectFromServer);
        connect(workerThread, &QThread::finished, client, &TcpClient::deleteLater);
        connect(this, &BackEnd::connectingToServer, client, &TcpClient::connectToServer, Qt::QueuedConnection);

        client->moveToThread(workerThread);
        emit connectingToServer(address, port);
    }
}

void BackEnd::close()
{
    qDebug() << "Quitting thread";

    workerThread->quit();
    workerThread->wait();

    qDebug() << "Closing";
}
