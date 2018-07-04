#ifndef PACKETPROCESSOR_H
#define PACKETPROCESSOR_H

#include <../ScoreTyperServer/packet.h>
#include <tournament.h>

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
        void manageProfileRequestReply(const QVariantList & replyData);
        void manageTournamentCreationReply(const QVariantList & replyData);
        void manageTournamentsListReply(const QVariantList & replyData);

    public:
        explicit PacketProcessor(QObject * parent = nullptr);
        ~PacketProcessor() {}

    public slots:
        void processPacket(const Packet & packet);

    signals:
        void requestError(const QString & errorMessage);
        void registrationReply(bool replyState, const QString & message);
        void loggingReply(bool nicknameState, bool passwordState, const QString & message);
        void profileDownloadRedply(const QString & description);
        void tournamentCreationReply(bool replyState, const QString & message);
        void tournamentsListItemArrived(const QStringList & tournamentData);
    };
}

#endif // PACKETPROCESSOR_H
