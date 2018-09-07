#include "backend.h"

BackEnd::BackEnd(QObject * parent) : QObject(parent)
{
    currentUser = new User(this);
    currentTournament = new Tournament(this);
    imageProvider = new ImageProvider();

    workerThread = new QThread(this);
    clientWrapper = new TcpClientWrapper(this);
    connect(workerThread, &QThread::finished, clientWrapper->getClient(), &TcpClient::disconnectFromServer);

    packetProcessorWrapper = new Client::PacketProcessorWrapper(this);
    connect(clientWrapper->getClient(), &TcpClient::packetArrived, packetProcessorWrapper->getPacketProcessor(),
            &Client::PacketProcessor::processPacket, Qt::QueuedConnection);
    connect(packetProcessorWrapper, &Client::PacketProcessorWrapper::avatarDataReceived,
            imageProvider, &ImageProvider::setImageData);

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

void BackEnd::downloadStartingMessage()
{
    QVariantList data;
    data << Packet::ID_DOWNLOAD_STARTING_MESSAGE;
    emit clientWrapper->sendData(data);
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

void BackEnd::downloadUserProfileInfo(const QString & nickname)
{
    QVariantList data;
    data << Packet::ID_DOWNLOAD_USER_PROFILE_INFO << nickname;
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

void BackEnd::updateUserProfileDescription(const QString & nickname, const QString & description)
{
    QVariantList data;
    data << Packet::ID_UPDATE_USER_PROFILE_DESCRIPTION << nickname << description;
    emit clientWrapper->sendData(data);
}

void BackEnd::updateUserProfileAvatar(const QString & nickname, const QUrl & avatarPath)
{
    QImage avatar;
    QByteArray avatarData;
    QBuffer avatarBuffer(&avatarData);
    QFileInfo avatarInfo(avatarPath.toLocalFile());

    if(!avatarInfo.exists())
        return;

    avatar.load(avatarPath.toLocalFile());
    avatar.save(&avatarBuffer, avatarInfo.suffix().toLocal8Bit().constData());

    QVariantList data;
    data << Packet::ID_UPDATE_USER_PROFILE_AVATAR << nickname << avatarData << avatarInfo.suffix();
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

void BackEnd::downloadRoundLeaderboard(const QString & tournamentName, const QString & hostName,
                                       const QString & roundName)
{
    QVariantList data;
    data << Packet::ID_DOWNLOAD_ROUND_LEADERBOARD << tournamentName << hostName << roundName;
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

void BackEnd::deleteMatch(Match * match)
{
    QVariantList data;
    QVariantList matchData;
    matchData << *match;
    data << Packet::ID_DELETE_MATCH << QVariant::fromValue(matchData);
    emit clientWrapper->sendData(data);
}

void BackEnd::updateMatchScore(Match * match)
{
    QVariantList data;
    QVariantList matchData;
    matchData << *match;
    data << Packet::ID_UPDATE_MATCH_SCORE << QVariant::fromValue(matchData);
    emit clientWrapper->sendData(data);
}

void BackEnd::pullMatchesPredictions(const QString & requesterName, const QString & tournamentName,
                                     const QString & hostName, const QString & roundName)
{
    QVariantList data;
    data << Packet::ID_PULL_MATCHES_PREDICTIONS << requesterName << tournamentName << hostName << roundName;
    emit clientWrapper->sendData(data);
}

void BackEnd::makePrediction(const QVariantMap & predictionData)
{
    QVariantList data;
    data << Packet::ID_MAKE_PREDICTION << predictionData.value("nickname") << predictionData.value("tournamentName")
         << predictionData.value("tournamentHostName") << predictionData.value("roundName")
         << predictionData.value("firstCompetitor") << predictionData.value("secondCompetitor")
         << predictionData.value("firstCompetitorPredictedScore")
         << predictionData.value("secondCompetitorPredictedScore");

    emit clientWrapper->sendData(data);
}

void BackEnd::updatePrediction(const QVariantMap & updatedPrediction)
{
    QVariantList data;
    data << Packet::ID_UPDATE_PREDICTION << updatedPrediction.value("nickname")
         << updatedPrediction.value("tournamentName")
         << updatedPrediction.value("tournamentHostName") << updatedPrediction.value("roundName")
         << updatedPrediction.value("firstCompetitor") << updatedPrediction.value("secondCompetitor")
         << updatedPrediction.value("firstCompetitorPredictedScore")
         << updatedPrediction.value("secondCompetitorPredictedScore");

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

ImageProvider * BackEnd::getImageProvider() const
{
    return imageProvider;
}
