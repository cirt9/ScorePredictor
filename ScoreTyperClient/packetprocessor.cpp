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
        case Packet::ID_DOWNLOAD_TOURNAMENT_LEADERBOARD: manageDownloadingTournamentLeaderboardReply(data); break;
        case Packet::ID_DOWNLOAD_ROUND_LEADERBOARD: manageDownloadingRoundLeaderboardReply(data); break;
        case Packet::ID_PULL_MATCHES: managePullingMatchesReply(data); break;
        case Packet::ID_ZERO_MATCHES_TO_PULL: managePullingZeroMatchesReply(); break;
        case Packet::ID_ALL_MATCHES_PULLED: manageAllMatchesPulledReply(); break;
        case Packet::ID_CREATE_MATCH: manageMatchCreatingReply(data); break;
        case Packet::ID_MATCH_DELETED: manageMatchDeletedReply(data); break;
        case Packet::ID_MATCH_DELETING_ERROR: manageMatchDeletingErrorReply(data); break;
        case Packet::ID_MATCH_SCORE_UPDATED: manageMatchScoreUpdatedReply(data); break;
        case Packet::ID_MATCH_SCORE_UPDATE_ERROR: manageMatchScoreUpdatingErrorReply(data); break;
        case Packet::ID_PULL_MATCHES_PREDICTIONS: managePullingMatchesPredictionsReply(data); break;
        case Packet::ID_ALL_MATCHES_PREDICTIONS_PULLED: manageAllMatchesPredictionsPulledReply(); break;
        case Packet::ID_MAKE_PREDICTION: managePredictionMakingReply(data); break;
        case Packet::ID_MAKE_PREDICTION_ERROR: managePredictionMakingErrorReply(data); break;
        case Packet::ID_UPDATE_PREDICTION: managePredictionUpdatingReply(data); break;
        case Packet::ID_UPDATE_PREDICTION_ERROR: managePredictionUpdatingErrorReply(data); break;

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

    void PacketProcessor::manageDownloadingTournamentLeaderboardReply(const QVariantList & replyData)
    {
        for(int i=0; i<replyData.size(); i++)
        {
            QVariantList tournamentParticipantData = replyData[i].value<QVariantList>();
            QVariantMap tournamentParticipant;
            tournamentParticipant.insert("nickname", tournamentParticipantData[0]);
            tournamentParticipant.insert("exactScore", tournamentParticipantData[1]);
            tournamentParticipant.insert("predictedResult", tournamentParticipantData[2]);
            tournamentParticipant.insert("points", tournamentParticipantData[3]);

            tournamentParticipantArrived(tournamentParticipant);
        }
    }

    void PacketProcessor::manageDownloadingRoundLeaderboardReply(const QVariantList & replyData)
    {
        for(int i=0; i<replyData.size(); i++)
        {
            QVariantList roundParticipantData = replyData[i].value<QVariantList>();
            QVariantMap roundParticipant;
            roundParticipant.insert("nickname", roundParticipantData[0]);
            roundParticipant.insert("exactScore", roundParticipantData[1]);
            roundParticipant.insert("predictedResult", roundParticipantData[2]);
            roundParticipant.insert("points", roundParticipantData[3]);

            roundParticipantArrived(roundParticipant);
        }
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

    void PacketProcessor::manageAllMatchesPulledReply()
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

    void PacketProcessor::managePullingMatchesPredictionsReply(const QVariantList & replyData)
    {
        for(int i=0; i<replyData.size(); i++)
        {
            QVariantList predictionData = replyData[i].value<QVariantList>();
            QVariantMap prediction;
            prediction.insert("nickname", predictionData[0]);
            prediction.insert("firstCompetitorPredictedScore", predictionData[1]);
            prediction.insert("secondCompetitorPredictedScore", predictionData[2]);
            prediction.insert("firstCompetitor", predictionData[3]);
            prediction.insert("secondCompetitor", predictionData[4]);

            emit matchPredictionItemArrived(prediction);
        }
    }

    void PacketProcessor::manageAllMatchesPredictionsPulledReply()
    {
        emit allMatchesPredictionsPulled();
    }

    void PacketProcessor::managePredictionMakingReply(const QVariantList & replyData)
    {
        QVariantMap predictionData;
        predictionData.insert("nickname", replyData[0]);
        predictionData.insert("firstCompetitor", replyData[1]);
        predictionData.insert("secondCompetitor", replyData[2]);
        predictionData.insert("firstCompetitorPredictedScore", replyData[3]);
        predictionData.insert("secondCompetitorPredictedScore", replyData[4]);

        emit predictionCreated(predictionData);
    }

    void PacketProcessor::managePredictionMakingErrorReply(const QVariantList & replyData)
    {
        emit predictionCreatingError(replyData[0].toString());
    }

    void PacketProcessor::managePredictionUpdatingReply(const QVariantList & replyData)
    {
        QVariantMap updatedPrediction;
        updatedPrediction.insert("nickname", replyData[0]);
        updatedPrediction.insert("firstCompetitor", replyData[1]);
        updatedPrediction.insert("secondCompetitor", replyData[2]);
        updatedPrediction.insert("firstCompetitorPredictedScore", replyData[3]);
        updatedPrediction.insert("secondCompetitorPredictedScore", replyData[4]);

        emit predictionUpdated(updatedPrediction);
    }

    void PacketProcessor::managePredictionUpdatingErrorReply(const QVariantList & replyData)
    {
        emit predictionUpdatingError(replyData[0].toString());
    }
}
