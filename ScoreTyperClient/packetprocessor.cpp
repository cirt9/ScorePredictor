#include "packetprocessor.h"

namespace Client
{
    PacketProcessor::PacketProcessor(QObject * parent) : QObject(parent)
    {

    }

    void PacketProcessor::processPacket(const Packet & packet)
    {
        QVariantList data = packet.getUnserializedData();
        int packetId = data[0].toInt();
        data.removeFirst();

        switch(packetId)
        {
        case Packet::ID_ERROR: manageReplyError(data); break;
        case Packet::ID_REGISTER: manageRegistrationReply(data); break;
        case Packet::ID_LOGIN: manageLoggingReply(data); break;
        case Packet::ID_DOWNLOAD_USER_PROFILE: manageProfileRequestReply(data); break;
        case Packet::ID_CREATE_TOURNAMENT: manageTournamentCreationReply(data); break;
        case Packet::ID_PULL_TOURNAMENTS: manageTournamentsPullReply(data); break;

        default: break;
        }
    }

    void PacketProcessor::manageReplyError(const QVariantList & errorData)
    {
        emit requestError(errorData[0].toString());
    }

    void PacketProcessor::manageRegistrationReply(const QVariantList & replyData)
    {
        emit registrationReply(replyData[0].toBool(), replyData[1].toString());
    }

    void PacketProcessor::manageLoggingReply(const QVariantList & replyData)
    {
        emit loggingReply(replyData[0].toBool(), replyData[1].toBool(), replyData[2].toString());
    }

    void PacketProcessor::manageProfileRequestReply(const QVariantList & replyData)
    {
        emit profileDownloadRedply(replyData[0].toString());
    }

    void PacketProcessor::manageTournamentCreationReply(const QVariantList & replyData)
    {
        emit tournamentCreationReply(replyData[0].toBool(), replyData[1].toString());
    }

    void PacketProcessor::manageTournamentsPullReply(const QVariantList & replyData)
    {
        emit tournamentsListArrived();

        for(int i=0; i<replyData.size(); i++)
        {
            Tournament tournament(replyData[i].value<QVariantList>());
            QStringList tournamentData;

            tournamentData << tournament.getName() << tournament.getHostName()
                           << tournament.getEntriesEndTime().toString("dd.MM.yyyy hh:mm")
                           << QString::number(tournament.getTypersNumber()) + "/"
                              + QString::number(tournament.getTypersLimit());
            if(tournament.getPasswordRequired())
                tournamentData << QString("Yes");
            else
                tournamentData << QString("No");

            tournamentsListItemArrived(tournamentData);
        }
    }
}
