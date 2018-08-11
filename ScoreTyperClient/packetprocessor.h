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

        void manageTournamentCreationReply(const QVariantList & replyData);
        void manageTournamentsPullReply(const QVariantList & replyData);

        void manageTournamentJoiningReply(const QVariantList & replyData);

        void manageTournamentInfoReply(const QVariantList & replyData);
        void manageFinishingTournamentReply(const QVariantList & replyData);
        void manageAddingNewRoundReply(const QVariantList & replyData);

        void managePullingMatchesReply(const QVariantList & replyData);
        void managePullingZeroMatchesReply();
        void managePullingAllMatchesReply();

        void manageMatchCreatingReply(const QVariantList & replyData);
        void manageMatchDeletedReply(const QVariantList & replyData);
        void manageMatchDeletingErrorReply(const QVariantList & replyData);
        void manageMatchScoreUpdatedReply(const QVariantList & replyData);
        void manageMatchScoreUpdatingErrorReply(const QVariantList & replyData);

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
        void finishedTournamentsListArrived(int numberOfItems);
        void finishedTournamentsListItemArrived(const QString & tournamentName, const QString & hostName);
        void ongoingTournamentsListArrived(int numberOfItems);
        void ongoingTournamentsListItemArrived(const QString & tournamentName, const QString & hostName);

        void tournamentCreationReply(bool replyState, const QString & message);
        void tournamentsListArrived();
        void tournamentsListItemArrived(const QStringList & tournamentData);

        void tournamentJoiningReply(bool replyState, const QString & message);

        void tournamentInfoDownloadReply(const QStringList & tournamentInfo, bool opened);
        void tournamentRoundNameArrived(const QString & name);
        void finishingTournamentReply(bool replyState, const QString & message);
        void addingNewRoundReply(bool replyState, const QString & message);

        void matchItemArrived(const QVariantMap & match);
        void zeroMatchesToPull();
        void allMatchesPulled();

        void creatingNewMatchReply(bool replyState, const QString & message);
        void matchDeleted(const QString & firstCompetitor, const QString & secondCompetitor);
        void matchDeletingError(const QString & message);
        void matchScoreUpdated(const QVariantMap & updatedMatch);
        void matchScoreUpdatingError(const QString & message);
    };
}

#endif // PACKETPROCESSOR_H
