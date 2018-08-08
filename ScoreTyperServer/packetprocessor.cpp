#include "packetprocessor.h"

namespace Server
{
    PacketProcessor::PacketProcessor(QSharedPointer<DbConnection> connection, QObject * parent) : QObject(parent)
    {
        dbConnection = connection;
    }

    void PacketProcessor::processPacket(const Packet & packet)
    {
        if(!dbConnection->isConnected())
            return;

        QVariantList data = packet.getUnserializedData();
        int packetId = data[0].toInt();
        data.removeFirst();

        switch(packetId)
        {
        case Packet::ID_REGISTER: registerUser(data); break;
        case Packet::ID_LOGIN: loginUser(data); break;
        case Packet::ID_DOWNLOAD_USER_INFO: manageDownloadingUserInfo(data); break;
        case Packet::ID_PULL_FINISHED_TOURNAMENTS: managePullingUserTournaments(data, false); break;
        case Packet::ID_PULL_ONGOING_TOURNAMENTS: managePullingUserTournaments(data, true); break;
        case Packet::ID_CREATE_TOURNAMENT: manageTournamentCreationRequest(data); break;
        case Packet::ID_PULL_TOURNAMENTS: managePullingTournaments(data); break;
        case Packet::ID_JOIN_TOURNAMENT: manageJoiningTournament(data); break;
        case Packet::ID_JOIN_TOURNAMENT_PASSWORD: manageJoiningTournamentWithPassword(data); break;
        case Packet::ID_DOWNLOAD_TOURNAMENT_INFO: manageDownloadingTournamentInfo(data); break;
        case Packet::ID_FINISH_TOURNAMENT: manageTournamentFinishing(data); break;
        case Packet::ID_ADD_NEW_ROUND: manageAddingNewRound(data); break;
        case Packet::ID_DOWNLOAD_TOURNAMENT_LEADERBOARD: manageDownloadingTournamentLeaderboard(data); break;
        case Packet::ID_PULL_MATCHES: managePullingMatches(data); break;
        case Packet::ID_CREATE_MATCH: manageCreatingNewMatch(data); break;
        case Packet::ID_DELETE_MATCH: manageDeletingMatch(data); break;
        case Packet::ID_UPDATE_MATCH_SCORE: manageUpdatingMatchScore(data); break;

        default: break;
        }
    }

    void PacketProcessor::registerUser(const QVariantList & userData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;
        responseData << Packet::ID_REGISTER;

        if(query.isUserRegistered(userData[0].toString()))
        {
            qDebug() << "User is registered";
            responseData << false << QString("This nickname is already occupied");
        }
        else
        {
            qDebug() << "User is not registered";
            if(query.registerUser(userData[0].toString(), userData[1].toString()))
            {
                qDebug() << "User registered";
                responseData << true << QString("Your account has been successfully created");
            }
            else
            {
                qDebug() << "User not registered";
                responseData << false << QString("A problem occured. Account could not be created");
            }
        }
        emit response(responseData);
    }

    void PacketProcessor::loginUser(const QVariantList & userData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;
        responseData << Packet::ID_LOGIN;

        if(query.isUserRegistered(userData[0].toString()))
        {
            qDebug() << "User exists";
            responseData << true;

            if(query.isPasswordCorrect(userData[0].toString(), userData[1].toString()))
            {
                qDebug() << "Password is correct";
                responseData << true << userData[0].toString();
            }
            else
            {
                qDebug() << "Invalid password";
                responseData << false << QString("Invalid password");
            }
        }
        else
        {
            qDebug() << "User does not exists";
            responseData << false << false << QString("Invalid nickname");
        }
        emit response(responseData);
    }

    void PacketProcessor::manageDownloadingUserInfo(const QVariantList & userData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.getUserInfo(userData[0].toString()))
        {
            responseData << Packet::ID_DOWNLOAD_USER_INFO << query.value("description");

            qDebug() << "Description for user: " << userData[0].toString();
            qDebug() << query.value("description");
        }
        else
        {
            qDebug() << "Profile loading error";
            responseData << Packet::ID_ERROR << QString("Couldn't load user data");
        }
        emit response(responseData);
    }

    void PacketProcessor::managePullingUserTournaments(const QVariantList & userData, bool opened)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(userData[0].toString()))
        {
            if(opened)
            {
                qDebug() << "Request for ongoing tournaments";
                responseData << Packet::ID_PULL_ONGOING_TOURNAMENTS;
            }
            else
            {
                qDebug() << "Request for finished tournaments";
                responseData << Packet::ID_PULL_FINISHED_TOURNAMENTS;
            }
            query.findUserTournaments(query.value("id").toUInt(), opened);

            while(query.next())
            {
                QVariantList tournamentData;
                tournamentData << query.value("name") << query.value("host_name");
                responseData << QVariant::fromValue(tournamentData);
            }
        }
        else
            responseData << Packet::ID_ERROR << QString("User does not exist");

        emit response(responseData);
    }

    void PacketProcessor::manageTournamentCreationRequest(QVariantList & tournamentData)
    {
        Tournament tournament(tournamentData[0].value<QVariantList>());
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(tournament.getHostName()))
        {
            unsigned int hostId = query.value("id").toUInt();
            qDebug() << "Host ID: " << hostId;

            if(!query.tournamentExists(tournament.getName(), hostId))
            {
                if(tournament.getEntriesEndTime() < QDateTime::currentDateTime())
                {
                    qDebug() << "Entries end time must be greater than the current time";
                    responseData << Packet::ID_CREATE_TOURNAMENT << false
                                 << QString("Entries end time must be greater than the current time");
                }
                else if(query.createTournament(tournament, hostId, tournamentData[1].toString()))
                {
                    qDebug() << "New tournament created";
                    responseData << Packet::ID_CREATE_TOURNAMENT << true
                                 << QString("Tournament created successfully");
                }
                else
                {
                    qDebug() << "Tournament couldn't be created";
                    responseData << Packet::ID_CREATE_TOURNAMENT << false
                                 << QString("Tournament couldn't be created. Try again later.");
                }
            }
            else
            {
                qDebug() << "User already created tournament with the same name";
                responseData << Packet::ID_CREATE_TOURNAMENT << false <<
                                QString("You can't create two tournaments with the same name!");
            }
        }
        else
            responseData << Packet::ID_ERROR << QString("User does not exist");

        emit response(responseData);
    }

    void PacketProcessor::managePullingTournaments(const QVariantList & requestData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(requestData[0].toString()))
        {
            responseData << Packet::ID_PULL_TOURNAMENTS;
            QDateTime startFromTime;

            if(requestData.size() == 4)
            {
                qDebug() << "Pulling another found tournaments pages";
                startFromTime = requestData[3].toDateTime();
            }
            else
            {
                qDebug() << "Pulling found tournaments pages";
                startFromTime = QDateTime::currentDateTime();
            }

            query.findTournaments(query.value("id").toUInt(), startFromTime, requestData[1].toInt(),
                                  requestData[2].toString());

            while(query.next())
            {
                QVariantList tournamentData;
                tournamentData << query.value("name") << query.value("host_name")
                               << query.value("password_required") << query.value("entries_end_time")
                               << query.value("typers") << query.value("typers_limit");
                responseData << QVariant::fromValue(tournamentData);
            }
        }
        else
            responseData << Packet::ID_ERROR << QString("User does not exist");

        emit response(responseData);
    }

    void PacketProcessor::manageJoiningTournament(const QVariantList & requestData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(requestData[0].toString()))
        {
            unsigned int userId = query.value("id").toUInt();

            if(query.findUserId(requestData[2].toString()) &&
               query.findTournamentId(requestData[1].toString(), query.value("id").toUInt()))
            {
                unsigned int tournamentId = query.value("id").toUInt();
                QString validationReply = validateTournamentJoining(tournamentId, userId);

                if(validationReply.size() > 0)
                    responseData << Packet::ID_JOIN_TOURNAMENT << false << validationReply;

                else if(query.tournamentRequiresPassword(tournamentId))
                    responseData << Packet::ID_JOIN_TOURNAMENT << false <<
                                    QString("This tournament requires password");

                else if(query.addUserToTournament(tournamentId, userId))
                    responseData << Packet::ID_JOIN_TOURNAMENT << true << QString("You joined the tournament");

                else
                    responseData << Packet::ID_ERROR << false << QString("A problem occured. Try again later.");
            }
            else
                responseData << Packet::ID_JOIN_TOURNAMENT << false << QString("This tournament does not exist");
        }
        else
            responseData << Packet::ID_ERROR << QString("User does not exist");

        emit response(responseData);
    }

    void PacketProcessor::manageJoiningTournamentWithPassword(const QVariantList & requestData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(requestData[0].toString()))
        {
            unsigned int userId = query.value("id").toUInt();

            if(query.findUserId(requestData[2].toString()) &&
               query.findTournamentId(requestData[1].toString(), query.value("id").toUInt()))
            {
                unsigned int tournamentId = query.value("id").toUInt();
                QString validationReply = validateTournamentJoining(tournamentId, userId);

                if(validationReply.size() > 0)
                    responseData << Packet::ID_JOIN_TOURNAMENT << false << validationReply;

                else if(!query.tournamentPasswordIsCorrect(tournamentId, requestData[3].toString()))
                    responseData << Packet::ID_JOIN_TOURNAMENT << false << QString("Incorrect password");

                else if(query.addUserToTournament(tournamentId, userId))
                    responseData << Packet::ID_JOIN_TOURNAMENT << true << QString("You joined the tournament");

                else
                    responseData << Packet::ID_ERROR << false << QString("A problem occured. Try again later.");
            }
            else
                responseData << Packet::ID_JOIN_TOURNAMENT << false << QString("This tournament does not exist");
        }
        else
            responseData << Packet::ID_ERROR << QString("User does not exist");

        emit response(responseData);
    }

    QString PacketProcessor::validateTournamentJoining(unsigned int tournamentId, unsigned int userId)
    {
        Query query(dbConnection->getConnection());

        if(!query.tournamentIsOpened(tournamentId))
            return QString("This tournament is closed");

        if(query.tournamentEntriesExpired(tournamentId))
            return QString("Entries for this tournament have expired");

        if(query.userPatricipatesInTournament(tournamentId, userId))
            return QString("You are already participating in this tournament");

        if(query.tournamentIsFull(tournamentId))
            return QString("This tournament is full");

        return QString("");
    }

    void PacketProcessor::manageDownloadingTournamentInfo(const QVariantList & tournamentData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(tournamentData[1].toString()) &&
           query.findTournamentId(tournamentData[0].toString(), query.value("id").toUInt()) )
        {
            unsigned int tournamentId = query.value("id").toUInt();
            query.findTournamentInfo(tournamentId);
            query.next();

            QVariantList tournamentInfo;

            tournamentInfo << query.value("password_required").toBool() << query.value("entries_end_time")
                           << query.value("typers").toUInt() << query.value("typers_limit").toUInt();

            responseData << Packet::ID_DOWNLOAD_TOURNAMENT_INFO << QVariant::fromValue(tournamentInfo)
                         << query.value("opened").toBool();

            query.findTournamentRounds(tournamentId);
            QVariantList roundsData;

            while(query.next())
                roundsData << query.value("name");

            responseData << QVariant::fromValue(roundsData);
        }
        else
            responseData << Packet::ID_ERROR << QString("This tournament does not exist");

        emit response(responseData);
    }

    void PacketProcessor::manageTournamentFinishing(const QVariantList & tournamentData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(tournamentData[1].toString()) &&
           query.findTournamentId(tournamentData[0].toString(), query.value("id").toUInt()) )
        {
            responseData << Packet::ID_FINISH_TOURNAMENT;
            unsigned int tournamentId = query.value("id").toUInt();

            if(query.tournamentIsOpened(tournamentId))
            {
                if(!query.tournamentEntriesExpired(tournamentId))
                    responseData << false << QString("You cannot close this tournament because it did not start yet.");

                else if(query.finishTournament(tournamentId))
                    responseData << true << QString("Tournament finished");
                else
                    responseData << false << QString("Finishing this tournament is not possible now. Try again later.");
            }
            else
                responseData << Packet::ID_FINISH_TOURNAMENT << false << QString("This tournament is already closed.");
        }
        else
            responseData << Packet::ID_ERROR << QString("This tournament does not exist");

        emit response(responseData);
    }

    void PacketProcessor::manageAddingNewRound(const QVariantList & tournamentData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(tournamentData[1].toString()) &&
           query.findTournamentId(tournamentData[0].toString(), query.value("id").toUInt()) )
        {
            responseData << Packet::ID_ADD_NEW_ROUND;
            unsigned int tournamentId = query.value("id").toUInt();

            if(query.tournamentIsOpened(tournamentId))
            {
                if(query.duplicateNameOfRound(tournamentData[2].toString(), tournamentId))
                    responseData << false << QString("A round with the same name already exists.");

                else if(query.addNewRound(tournamentData[2].toString(), tournamentId))
                    responseData << true << tournamentData[2].toString();
                else
                    responseData << false << QString("Adding new round is not possible right now. Try again later.");
            }
            else
                responseData << Packet::ID_ADD_NEW_ROUND << false << QString("This tournament is closed.");
        }
        else
            responseData << Packet::ID_ERROR << QString("This tournament does not exist.");

        emit response(responseData);
    }

    void PacketProcessor::manageDownloadingTournamentLeaderboard(const QVariantList & tournamentData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(tournamentData[1].toString()) &&
           query.findTournamentId(tournamentData[0].toString(), query.value("id").toUInt()) )
        {
            responseData << Packet::ID_DOWNLOAD_TOURNAMENT_LEADERBOARD;
            unsigned int tournamentId = query.value("id").toUInt();

            query.findTournamentLeaderboard(tournamentId);
        }
        else
            responseData << Packet::ID_ERROR << QString("This tournament does not exist.");

        //emit response(responseData);
        //TO BE DONE
        qDebug() << "TO BE DONE";
    }

    void PacketProcessor::managePullingMatches(const QVariantList & requestData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(requestData[1].toString()) &&
           query.findTournamentId(requestData[0].toString(), query.value("id").toUInt()) &&
           query.findRoundId(requestData[2].toString(), query.value("id").toUInt()) )
        {
            unsigned int roundId = query.value("id").toUInt();
            query.findMatches(roundId);
            bool matchesFound = true;

            if(!query.next())
            {
                responseData << Packet::ID_ZERO_MATCHES_TO_PULL;
                emit response(responseData);
                matchesFound = false;
            }
            else
                sendMatches(query);

            if(matchesFound)
            {
                responseData.clear();
                responseData << Packet::ID_ALL_MATCHES_PULLED;
                emit response(responseData);
            }
        }
        else
        {
            responseData << Packet::ID_ERROR << QString("This round does not exist.");
            emit response(responseData);
        }
    }

    void PacketProcessor::sendMatches(QSqlQuery & matchesQuery)
    {
        QVariantList responseData;
        int chunkSize = 40;
        int i = 0;

        do
        {
            if(i == chunkSize)
            {
                emit response(responseData);
                responseData.clear();
                i = 0;
            }

            if(i == 0)
                responseData << Packet::ID_PULL_MATCHES;

            QStringList matchData;
            matchData << matchesQuery.value("competitor_1").toString()
                      << matchesQuery.value("competitor_2").toString()
                      << QString::number(matchesQuery.value("competitor_1_score").toUInt())
                      << QString::number(matchesQuery.value("competitor_2_score").toUInt())
                      << matchesQuery.value("predictions_end_time").toDateTime().toString("dd.MM.yyyy hh:mm");
            responseData << matchData;

            i++;
        } while(matchesQuery.next());

        emit response(responseData);
    }

    void PacketProcessor::manageCreatingNewMatch(const QVariantList & matchData)
    {
        Match match(matchData[0].value<QVariantList>());
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(match.getTournamentHostName()) &&
           query.findTournamentId(match.getTournamentName(), query.value("id").toUInt()))
        {
            responseData << Packet::ID_CREATE_MATCH;
            unsigned int tournamentId = query.value("id").toUInt();

            if(!query.tournamentIsOpened(tournamentId))
                responseData << false << QString("This tournament is closed.");

            else if(!query.findRoundId(match.getRoundName(), tournamentId))
                responseData << false << QString("This round does not exist.");
            else
            {
                unsigned int roundId = query.value("id").toUInt();

                if(query.duplicateMatch(match.getFirstCompetitor(), match.getSecondCompetitor(), roundId))
                    responseData << false << QString("The same match already exists.");

                else if(match.getPredictionsEndTime() < QDateTime::currentDateTime())
                    responseData << false << QString("Predictions end time must be greater than the current time.");

                else if(query.createMatch(roundId, match.getFirstCompetitor(), match.getSecondCompetitor(),
                                          match.getPredictionsEndTime()))
                    responseData << true << QString("The match was created successfully.");
                else
                    responseData << false << QString("The match couldn't be created. Try again later.");
            }
        }
        else
            responseData << Packet::ID_ERROR << QString("This tournament does not exist.");

        emit response(responseData);
    }

    void PacketProcessor::manageDeletingMatch(const QVariantList & matchData)
    {
        Match match(matchData[0].value<QVariantList>());
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(match.getTournamentHostName()) &&
           query.findTournamentId(match.getTournamentName(), query.value("id").toUInt()))
        {
            unsigned int tournamentId = query.value("id").toUInt();

            if(!query.tournamentIsOpened(tournamentId))
                responseData << Packet::ID_MATCH_DELETING_ERROR << QString("This tournament is closed.");

            else if(!query.findRoundId(match.getRoundName(), tournamentId))
                responseData << Packet::ID_MATCH_DELETING_ERROR << QString("This round does not exist.");
            else
            {
                unsigned int roundId = query.value("id").toUInt();

                if(query.deleteMatch(roundId, match.getFirstCompetitor(), match.getSecondCompetitor()))
                    responseData << Packet::ID_MATCH_DELETED << match.getFirstCompetitor() << match.getSecondCompetitor();
                else
                    responseData << Packet::ID_MATCH_DELETING_ERROR
                                 << QString("The match couldn't be deleted. Try again later.");
            }
        }
        else
            responseData << Packet::ID_ERROR << QString("This tournament does not exist.");

        emit response(responseData);
    }

    void PacketProcessor::manageUpdatingMatchScore(const QVariantList & matchData)
    {
        Match match(matchData[0].value<QVariantList>());
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(match.getTournamentHostName()) &&
           query.findTournamentId(match.getTournamentName(), query.value("id").toUInt()))
        {
            unsigned int tournamentId = query.value("id").toUInt();

            if(!query.tournamentIsOpened(tournamentId))
                responseData << Packet::ID_MATCH_SCORE_UPDATE_ERROR << QString("This tournament is closed.");

            else if(!query.findRoundId(match.getRoundName(), tournamentId))
                responseData << Packet::ID_MATCH_SCORE_UPDATE_ERROR << QString("This round does not exist.");
            else
            {
                unsigned int roundId = query.value("id").toUInt();

                if(query.findMatchId(match.getFirstCompetitor(), match.getSecondCompetitor(), roundId))
                {
                    unsigned int matchId = query.value("id").toUInt();

                    if(query.updateMatchScore(matchId, match.getFirstCompetitorScore(), match.getSecondCompetitorScore()))
                    {
                        QStringList updatedMatchData;
                        updatedMatchData << match.getFirstCompetitor() << match.getSecondCompetitor()
                                         << QString::number(match.getFirstCompetitorScore())
                                         << QString::number(match.getSecondCompetitorScore());

                        responseData << Packet::ID_MATCH_SCORE_UPDATED << updatedMatchData;
                    }
                    else
                        responseData << Packet::ID_MATCH_SCORE_UPDATE_ERROR
                                     << QString("The score couldn't be udpated. Try again later.");
                }
                else
                    responseData << Packet::ID_MATCH_SCORE_UPDATE_ERROR << QString("This match does not exist.");
            }
        }
        else
            responseData << Packet::ID_ERROR << QString("This tournament does not exist.");

        emit response(responseData);
    }
}
