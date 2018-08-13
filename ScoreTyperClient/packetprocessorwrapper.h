#ifndef PACKETPROCESSORWRAPPER_H
#define PACKETPROCESSORWRAPPER_H

#include <packetprocessor.h>

namespace Client
{
    class PacketProcessorWrapper : public QObject
    {
        Q_OBJECT

    private:
        Client::PacketProcessor * packetProcessor;

    public:
        explicit PacketProcessorWrapper(QObject * parent = nullptr);
        ~PacketProcessorWrapper();

        Client::PacketProcessor * getPacketProcessor() const;

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

        void matchPredictionItemArrived(const QVariantMap & prediction);
        void allMatchesPredictionsPulled();

        void predictionCreated(const QVariantMap & predictionData);
        void predictionCreatingError(const QString & message);
    };
}

#endif // PACKETPROCESSORWRAPPER_H
