#ifndef PACKETPROCESSOR_H
#define PACKETPROCESSOR_H

#include <packet.h>
#include <dbconnection.h>
#include <query.h>
#include <QSharedPointer>
#include <../ScorePredictorClient/tournament.h>
#include <../ScorePredictorClient/match.h>
#include <QBuffer>
#include <QImage>
#include <QFile>
#include <QFileInfo>

namespace Server
{
    class PacketProcessor: public QObject
    {
        Q_OBJECT

    private:
        QSharedPointer<DbConnection> dbConnection;

        void registerUser(const QVariantList & userData);
        void loginUser(const QVariantList & userData);

        void manageDownloadingUserInfo(const QVariantList & userData);
        void managePullingUserTournaments(const QVariantList & userData, bool opened);

        void manageUpdatingUserProfileDescription(const QVariantList & requestData);
        void manageUpdatingUserProfileAvatar(const QVariantList & requestData);

        void manageTournamentCreationRequest(QVariantList & tournamentData);
        void managePullingTournaments(const QVariantList & requestData);
        void manageJoiningTournament(const QVariantList & requestData);
        void manageJoiningTournamentWithPassword(const QVariantList & requestData);

        void manageDownloadingTournamentInfo(const QVariantList & tournamentData);
        void manageTournamentFinishing(const QVariantList & tournamentData);
        void manageAddingNewRound(const QVariantList & tournamentData);

        void manageDownloadingTournamentLeaderboard(const QVariantList & tournamentData);
        void manageDownloadingRoundLeaderboard(const QVariantList & roundData);

        void managePullingMatches(const QVariantList & requestData);
        void manageCreatingNewMatch(const QVariantList & matchData);
        void manageDeletingMatch(const QVariantList & matchData);
        void manageUpdatingMatchScore(const QVariantList & matchData);

        void managePullingMatchesPredictions(const QVariantList & requestData);
        void manageMakingPrediction(const QVariantList & predictionData);
        void manageUpdatingPrediction(const QVariantList & predictionData);

        QString validateTournamentJoining(unsigned int tournamentId, unsigned int userId);
        void sendParticipantsInChunks(QSqlQuery & query, const int packetId);
        void sendMatchesInChunks(QSqlQuery & query);
        void sendMatchesPredictionsInChunks(QSqlQuery & query);

    public:
        explicit PacketProcessor(QSharedPointer<DbConnection> connection, QObject * parent = nullptr);
        ~PacketProcessor() {}

    public slots:
        void processPacket(const Packet & packet);

    signals:
        void response(const QVariantList & data);
    };
}

#endif // PACKETPROCESSOR_H
