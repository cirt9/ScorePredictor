#include "backend.h"

BackEnd::BackEnd(QObject * parent) : QObject(parent)
{
    currentUser = new User(this);
    workerThread = new QThread(this);
    clientWrapper = new TcpClientWrapper(this);
    connect(workerThread, &QThread::finished, clientWrapper->getClient(), &TcpClient::disconnectFromServer);

    packetProcessorWrapper = new Client::PacketProcessorWrapper(this);
    connect(clientWrapper->getClient(), &TcpClient::packetArrived, packetProcessorWrapper->getPacketProcessor(),
            &Client::PacketProcessor::processPacket, Qt::QueuedConnection);

    workerThread->start();
    clientWrapper->getClient()->moveToThread(workerThread);
    packetProcessorWrapper->getPacketProcessor()->moveToThread(workerThread);

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
    emit clientWrapper->connectToServer(QHostAddress("127.0.0.1"), 5000);
}

void BackEnd::disconnectFromServer()
{
    emit clientWrapper->disconnectFromServer();
}

void BackEnd::login(const QString & nickname, const QString & password)
{
    QVariantList data;
    data << Packet::ID_LOGIN << nickname << password;
    emit clientWrapper->sendData(data);
}

void BackEnd::registerAccount(const QString & nickname, const QString & password)
{
    QVariantList data;
    data << Packet::ID_REGISTER << nickname << password;
    emit clientWrapper->sendData(data);
}

void BackEnd::downloadUserProfile(const QString & nickname)
{
    QVariantList data;
    data << Packet::ID_DOWNLOAD_USER_PROFILE << nickname;
    emit clientWrapper->sendData(data);
}

void BackEnd::createTournament(Tournament * tournament)
{
    QVariantList data;
    data << Packet::ID_CREATE_TOURNAMENT << *tournament;
    emit clientWrapper->sendData(data);
}

TcpClientWrapper * BackEnd::getClientWrapper() const
{
    return clientWrapper;
}

Client::PacketProcessorWrapper * BackEnd::getPacketProcessorWrapper() const
{
    return packetProcessorWrapper;
}

User * BackEnd::getCurrentUser() const
{
    return currentUser;
}
