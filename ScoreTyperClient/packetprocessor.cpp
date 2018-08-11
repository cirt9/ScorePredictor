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
        case Packet::ID_DOWNLOAD_USER_INFO: manageUserInfoReply(data); break;
        case Packet::ID_PULL_FINISHED_TOURNAMENTS: manageFinishedTournamentsPullReply(data); break;
        case Packet::ID_PULL_ONGOING_TOURNAMENTS: manageOngoingTournamentsPullReply(data); break;
        case Packet::ID_CREATE_TOURNAMENT: manageTournamentCreationReply(data); break;
        case Packet::ID_PULL_TOURNAMENTS: manageTournamentsPullReply(data); break;
        case Packet::ID_JOIN_TOURNAMENT: manageTournamentJoiningReply(data); break;
        case Packet::ID_DOWNLOAD_TOURNAMENT_INFO: manageTournamentInfoReply(data); break;
        case Packet::ID_FINISH_TOURNAMENT: manageFinishingTournamentReply(data); break;
        case Packet::ID_ADD_NEW_ROUND: manageAddingNewRoundReply(data); break;
        case Packet::ID_PULL_MATCHES: managePullingMatchesReply(data); break;
        case Packet::ID_ZERO_MATCHES_TO_PULL: managePullingZeroMatchesReply(); break;
        case Packet::ID_ALL_MATCHES_PULLED: managePullingAllMatchesReply(); break;
        case Packet::ID_CREATE_MATCH: manageMatchCreatingReply(data); break;
        case Packet::ID_MATCH_DELETED: manageMatchDeletedReply(data); break;
        case Packet::ID_MATCH_DELETING_ERROR: manageMatchDeletingErrorReply(data); break;
        case Packet::ID_MATCH_SCORE_UPDATED: manageMatchScoreUpdatedReply(data); break;
        case Packet::ID_MATCH_SCORE_UPDATE_ERROR: manageMatchScoreUpdatingErrorReply(data); break;

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

    void PacketProcessor::manageUserInfoReply(const QVariantList & replyData)
    {
        emit userInfoDownloadReply(replyData[0].toString());
    }

    void PacketProcessor::manageFinishedTournamentsPullReply(const QVariantList & replyData)
    {
        emit finishedTournamentsListArrived(replyData.size());

        for(int i=0; i<replyData.size(); i++)
        {
            QVariantList finishedTournamentData = replyData[i].value<QVariantList>();
            QString tournamentName = finishedTournamentData[0].toString();
            QString hostName = finishedTournamentData[1].toString();

            emit finishedTournamentsListItemArrived(tournamentName, hostName);
        }
    }

    void PacketProcessor::manageOngoingTournamentsPullReply(const QVariantList & replyData)
    {
        emit ongoingTournamentsListArrived(replyData.size());

        for(int i=0; i<replyData.size(); i++)
        {
            QVariantList ongoingTournamentData = replyData[i].value<QVariantList>();
            QString tournamentName = ongoingTournamentData[0].toString();
            QString hostName = ongoingTournamentData[1].toString();

            emit ongoingTournamentsListItemArrived(tournamentName, hostName);
        }
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
                           << QString::number(tournament.getTypersNumber()) + "/" +
                              QString::number(tournament.getTypersLimit())
                           << (tournament.getPasswordRequired() ? QString("Yes") : QString("No"));

            emit tournamentsListItemArrived(tournamentData);
        }
    }

    void PacketProcessor::manageTournamentJoiningReply(const QVariantList & replyData)
    {
        emit tournamentJoiningReply(replyData[0].toBool(), replyData[1].toString());
    }

    void PacketProcessor::manageTournamentInfoReply(const QVariantList & replyData)
    {
        QVariantList tournamentData = replyData[0].value<QVariantList>();
        QStringList tournamentInfo;
        QVariantList roundsData = replyData[2].value<QVariantList>();

        tournamentInfo << (tournamentData[0].toBool() ? QString("Yes") : QString("No"))
                       << tournamentData[1].toDateTime().toString("dd.MM.yyyy hh:mm")
                       << QString::number(tournamentData[2].toUInt())
                       << QString::number(tournamentData[3].toUInt());

        emit tournamentInfoDownloadReply(tournamentInfo, replyData[1].toBool());

        for(int i=0; i<roundsData.size(); i++)
            emit tournamentRoundNameArrived(roundsData[i].toString());
    }

    void PacketProcessor::manageFinishingTournamentReply(const QVariantList & replyData)
    {
        emit finishingTournamentReply(replyData[0].toBool(), replyData[1].toString());
    }

    void PacketProcessor::manageAddingNewRoundReply(const QVariantList & replyData)
    {
        emit addingNewRoundReply(replyData[0].toBool(), replyData[1].toString());
    }

    void PacketProcessor::managePullingMatchesReply(const QVariantList & replyData)
    {
        for(int i=0; i<replyData.size(); i++)
        {
            QVariantList matchData = replyData[i].value<QVariantList>();
            QVariantMap match;
            match.insert("firstCompetitor", matchData[0]);
            match.insert("secondCompetitor", matchData[1]);
            match.insert("firstCompetitorScore", matchData[2]);
            match.insert("secondCompetitorScore", matchData[3]);
            match.insert("predictionsEndTime", matchData[4]);

            emit matchItemArrived(match);
        }
    }

    void PacketProcessor::managePullingZeroMatchesReply()
    {
        emit zeroMatchesToPull();
    }

    void PacketProcessor::managePullingAllMatchesReply()
    {
        emit allMatchesPulled();
    }

    void PacketProcessor::manageMatchCreatingReply(const QVariantList & replyData)
    {
        emit creatingNewMatchReply(replyData[0].toBool(), replyData[1].toString());
    }

    void PacketProcessor::manageMatchDeletedReply(const QVariantList & replyData)
    {
        emit matchDeleted(replyData[0].toString(), replyData[1].toString());
    }

    void PacketProcessor::manageMatchDeletingErrorReply(const QVariantList & replyData)
    {
        emit matchDeletingError(replyData[0].toString());
    }

    void PacketProcessor::manageMatchScoreUpdatedReply(const QVariantList & replyData)
    {
        QVariantList updatedMatchData = replyData[0].value<QVariantList>();
        QVariantMap updatedMatch;
        updatedMatch.insert("firstCompetitor", updatedMatchData[0]);
        updatedMatch.insert("secondCompetitor", updatedMatchData[1]);
        updatedMatch.insert("firstCompetitorScore", updatedMatchData[2]);
        updatedMatch.insert("secondCompetitorScore", updatedMatchData[3]);

        emit matchScoreUpdated(updatedMatch);
    }

    void PacketProcessor::manageMatchScoreUpdatingErrorReply(const QVariantList & replyData)
    {
        emit matchScoreUpdatingError(replyData[0].toString());
    }
}
