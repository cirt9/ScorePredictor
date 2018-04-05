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
    /*
    QVariantList data;
    data << nickname << password;
    emit clientWrapper->sendData(data);
    */
    qDebug() << "to do" << nickname << password;
}

void BackEnd::registerAccount(const QString & nickname, const QString & password)
{
    QVariantList data;
    data << Packet::PACKET_ID_REGISTER << nickname << password;
    emit clientWrapper->sendData(data);
}

TcpClientWrapper * BackEnd::getClientWrapper() const
{
    return clientWrapper;
}
