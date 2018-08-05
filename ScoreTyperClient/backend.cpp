#include "backend.h"

BackEnd::BackEnd(QObject * parent) : QObject(parent)
{
    currentUser = new User(this);
    currentTournament = new Tournament(this);
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

void BackEnd::downloadUserInfo(const QString & nickname)
{
    QVariantList data;
    data << Packet::ID_DOWNLOAD_USER_INFO << nickname;
    emit clientWrapper->sendData(data);
}

void BackEnd::pullFinishedTournaments(const QString & nickname)
{
    QVariantList data;
    data << Packet::ID_PULL_FINISHED_TOURNAMENTS << nickname;
    emit clientWrapper->sendData(data);
}

void BackEnd::pullOngoingTournaments(const QString & nickname)
{
    QVariantList data;
    data << Packet::ID_PULL_ONGOING_TOURNAMENTS << nickname;
    emit clientWrapper->sendData(data);
}

void BackEnd::createTournament(Tournament * tournament, const QString & password)
{
    QVariantList data;
    QVariantList tournamentData;
    tournamentData << *tournament;
    data << Packet::ID_CREATE_TOURNAMENT << QVariant::fromValue(tournamentData) << password;
    emit clientWrapper->sendData(data);
}

void BackEnd::pullTournaments(const QString & requesterName, int itemsLimit, const QString & tournamentName)
{
    QVariantList data;
    data << Packet::ID_PULL_TOURNAMENTS << requesterName << itemsLimit << tournamentName;
    emit clientWrapper->sendData(data);
}

void BackEnd::pullTournaments(const QString & requesterName, int itemsLimit, const QString & tournamentName,
                              const QDateTime & minEntriesEndTime)
{
    QVariantList data;
    data << Packet::ID_PULL_TOURNAMENTS << requesterName << itemsLimit << tournamentName << minEntriesEndTime;
    emit clientWrapper->sendData(data);
}

void BackEnd::joinTournament(const QString & nickname, const QString & tournamentName, const QString & hostName)
{
    QVariantList data;
    data << Packet::ID_JOIN_TOURNAMENT << nickname << tournamentName << hostName;
    emit clientWrapper->sendData(data);
}

void BackEnd::joinTournament(const QString & nickname, const QString & tournamentName, const QString & hostName,
                             const QString & password)
{
    QVariantList data;
    data << Packet::ID_JOIN_TOURNAMENT_PASSWORD << nickname << tournamentName << hostName << password;
    emit clientWrapper->sendData(data);
}

void BackEnd::downloadTournamentInfo(const QString & tournamentName, const QString & hostName)
{
    QVariantList data;
    data << Packet::ID_DOWNLOAD_TOURNAMENT_INFO << tournamentName << hostName;
    emit clientWrapper->sendData(data);
}

void BackEnd::finishTournament(const QString & tournamentName, const QString & hostName)
{
    QVariantList data;
    data << Packet::ID_FINISH_TOURNAMENT << tournamentName << hostName;
    emit clientWrapper->sendData(data);
}

void BackEnd::addNewRound(const QString & tournamentName, const QString & hostName, const QString & roundName)
{
    QVariantList data;
    data << Packet::ID_ADD_NEW_ROUND << tournamentName << hostName << roundName;
    emit clientWrapper->sendData(data);
}

void BackEnd::downloadTournamentLeaderboard(const QString & tournamentName, const QString & hostName)
{
    QVariantList data;
    data << Packet::ID_DOWNLOAD_TOURNAMENT_LEADERBOARD << tournamentName << hostName;
    emit clientWrapper->sendData(data);
}

void BackEnd::pullMatches(const QString & tournamentName, const QString & hostName, const QString & roundName)
{
    QVariantList data;
    data << Packet::ID_PULL_MATCHES << tournamentName << hostName << roundName;
    emit clientWrapper->sendData(data);
}

void BackEnd::createNewMatch(Match * newMatch)
{
    QVariantList data;
    QVariantList matchData;
    matchData << *newMatch;
    data << Packet::ID_CREATE_MATCH << QVariant::fromValue(matchData);
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

Tournament * BackEnd::getCurrentTournament() const
{
    return currentTournament;
}
