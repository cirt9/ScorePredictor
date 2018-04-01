#include "backend.h"

BackEnd::BackEnd(QObject * parent) : QObject(parent)
{
    workerThread = new QThread(this);
    clientWrapper = new TcpClientWrapper(this);
    connect(workerThread, &QThread::finished, clientWrapper->getClient(), &TcpClient::disconnectFromServer);

    workerThread->start();
    clientWrapper->getClient()->moveToThread(workerThread);

    connectToServer();
}

void BackEnd::close()
{
    qDebug() << "Quitting thread";

    workerThread->quit();
    workerThread->wait();

    qDebug() << "Closing";
}

void BackEnd::connectToServer()
{
    clientWrapper->connectToServer(QHostAddress("127.0.0.1"), 5000);
}

void BackEnd::login(const QString & nickname, const QString & password)
{
    emit clientWrapper->sendData(nickname+password);
}

TcpClientWrapper * BackEnd::getClientWrapper() const
{
    return clientWrapper;
}
