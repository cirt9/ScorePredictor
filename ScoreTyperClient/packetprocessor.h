#ifndef PACKETPROCESSOR_H
#define PACKETPROCESSOR_H

#include <../ScoreTyperServer/packet.h>
#include <tournament.h>
#include <match.h>

#include <QDebug>

namespace Client
{
    class PacketProcessor : public QObject
    {
        Q_OBJECT

    private:
        void manageReplyError(const QVariantList & errorData);
        void manageRegistrationReply(const QVariantList & replyData);
        void manageLoggingReply(const QVariantList & replyData);

        void manageUserInfoReply(const QVariantList & replyData);
        void manageFinishedTournamentsPullReply(const QVariantList & replyData);
        void manageOngoingTournamentsPullReply(const QVariantList & replyData);

        void manageUpdatingProfileDescriptionReply(const QVariantList & replyData);
        void manageUpdatingProfileDescriptionErrorReply(const QVariantList & replyData);
        void manageUpdatingProfileAvatarReply(const QVariantList & replyData);
        void manageUpdatingProfileAvatarErrorReply(const QVariantList & replyData);

        void manageTournamentCreationReply(const QVariantList & replyData);
        void manageTournamentsPullReply(const QVariantList & replyData);

        void manageTournamentJoiningReply(const QVariantList & replyData);

        void manageTournamentInfoReply(const QVariantList & replyData);
        void manageFinishingTournamentReply(const QVariantList & replyData);
        void manageAddingNewRoundReply(const QVariantList & replyData);

        void manageDownloadingTournamentLeaderboardReply(const QVariantList & replyData);
        void manageDownloadingRoundLeaderboardReply(const QVariantList & replyData);

        void managePullingMatchesReply(const QVariantList & replyData);
        void managePullingZeroMatchesReply();
        void manageAllMatchesPulledReply();

        void manageMatchCreatingReply(const QVariantList & replyData);
        void manageMatchDeletedReply(const QVariantList & replyData);
        void manageMatchDeletingErrorReply(const QVariantList & replyData);
        void manageMatchScoreUpdatedReply(const QVariantList & replyData);
        void manageMatchScoreUpdatingErrorReply(const QVariantList & replyData);

        void managePullingMatchesPredictionsReply(const QVariantList & replyData);
        void manageAllMatchesPredictionsPulledReply();

        void managePredictionMakingReply(const QVariantList & replyData);
        void managePredictionMakingErrorReply(const QVariantList & replyData);
        void managePredictionUpdatingReply(const QVariantList & replyData);
        void managePredictionUpdatingErrorReply(const QVariantList & replyData);

    public:
        explicit PacketProcessor(QObject * parent = nullptr);
        ~PacketProcessor() {}

    public slots:
        void processPacket(const Packet & packet);

    signals:
        void requestError(const QString & errorMessage);
        void registrationReply(bool replyState, const QString & message);
        void loggingReply(bool nicknameState, bool passwordState, const QString & message);

        void userInfoDownloadReply(const QString & description);
        void avatarDataReceived(const QByteArray & avatarData);
        void finishedTournamentsListArrived(int numberOfItems);
        void finishedTournamentsListItemArrived(const QString & tournamentName, const QString & hostName);
        void ongoingTournamentsListArrived(int numberOfItems);
        void ongoingTournamentsListItemArrived(const QString & tournamentName, const QString & hostName);

        void userProfileDescriptionUpdated(const QString & message);
        void userProfileDescriptionUpdatingError(const QString & message);
        void userProfileAvatarUpdated(const QString & message);
        void userProfileAvatarUpdatingError(const QString & message);

        void tournamentCreationReply(bool replyState, const QString & message);
        void tournamentsListArrived();
        void tournamentsListItemArrived(const QStringList & tournamentData);

        void tournamentJoiningReply(bool replyState, const QString & message);

        void tournamentInfoDownloadReply(const QStringList & tournamentInfo, bool opened);
        void tournamentRoundNameArrived(const QString & name);
        void finishingTournamentReply(bool replyState, const QString & message);
        void addingNewRoundReply(bool replyState, const QString & message);

        void tournamentParticipantArrived(const QVariantMap & tournamentParticipant);
        void roundParticipantArrived(const QVariantMap & roundParticipant);

        void matchItemArrived(const QVariantMap & match);
        void zeroMatchesToPull();
        void allMatchesPulled();

        void creatingNewMatchReply(bool replyState, const QString & message);
        void matchDeleted(const QString & firstCompetitor, const QString & secondCompetitor);
        void matchDeletingError(const QString & message);
        void matchScoreUpdated(const QVariantMap & updatedMatch);
        void matchScoreUpdatingError(const QString & message);

        void matchPredictionItemArrived(const QVariantMap & prediction);
        void allMatchesPredictionsPulled();

        void predictionCreated(const QVariantMap & predictionData);
        void predictionCreatingError(const QString & message);
        void predictionUpdated(const QVariantMap & updatedPrediction);
        void predictionUpdatingError(const QString & message);
    };
}

#endif // PACKETPROCESSOR_H
