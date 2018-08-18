#ifndef QUERY_H
#define QUERY_H

#include <dbconnection.h>
#include <QSqlQuery>
#include <QSharedPointer>
#include <../ScoreTyperClient/tournament.h>
#include <../ScoreTyperClient/match.h>

#include <QDebug>

class Query : public QSqlQuery
{
public:
    Query(const QSqlDatabase & dbConnection);
    ~Query() {}

    bool findUserId(const QString & nickname);
    bool isUserRegistered(const QString & nickname);
    bool registerUser(const QString & nickname, const QString & password);
    bool isPasswordCorrect(const QString & nickname, const QString & password);

    bool getUserInfo(const QString & nickname);
    void findUserTournaments(unsigned int userId, bool opened);

    bool tournamentExists(const QString & tournamentName, unsigned int hostId);
    bool createTournament(const Tournament & tournament, unsigned int hostId, const QString & password);
    void findTournaments(unsigned int hostId, const QDateTime & dateTime, int itemsLimit, const QString & tournamentName);
    bool findTournamentId(const QString & tournamentName, unsigned int hostId);

    bool tournamentIsOpened(unsigned int tournamentId);
    bool tournamentEntriesExpired(unsigned int tournamentId);
    bool userPatricipatesInTournament(unsigned int tournamentId, unsigned int userId);
    bool tournamentRequiresPassword(unsigned int tournamentId);
    bool tournamentPasswordIsCorrect(unsigned int tournamentId, const QString & password);
    bool tournamentIsFull(unsigned int tournamentId);
    bool addUserToTournament(unsigned int tournamentId, unsigned int userId);

    void findTournamentInfo(unsigned int tournamentId);
    void findTournamentRounds(unsigned int tournamentId);
    bool allMatchesFinished(unsigned int tournamentId);
    bool finishTournament(unsigned int tournamentId);
    bool duplicateNameOfRound(const QString & roundName, unsigned int tournamentId);
    bool addNewRound(const QString & roundName, unsigned int tournamentId);
    void findTournamentLeaderboard(unsigned int tournamentId);
    bool findRoundId(const QString & roundName, unsigned int tournamentId);
    void findRoundLeaderboard(unsigned int tournamentId, unsigned int roundId);

    bool matchStartsAfterEntriesEndTime(unsigned int tournamentId, const QDateTime & predictionsEndTime);
    void findMatches(unsigned int roundId);
    bool duplicateMatch(const QString & firstCompetitor, const QString & secondCompetitor, unsigned int roundId);
    bool findMatchId(const QString & firstCompetitor, const QString & secondCompetitor, unsigned int roundId);
    bool createMatch(unsigned int roundId, const QString & firstCompetitor, const QString & secondCompetitor,
                     const QDateTime & predictionsEndTime);
    bool deleteMatch(unsigned int roundId, const QString & firstCompetitor, const QString & secondCompetitor);
    bool updateMatchScore(unsigned int matchId, unsigned int firstCompetitorScore, unsigned int secondCompetitorScore);

    void findMatchesPredictions(unsigned int tournamentId, unsigned int roundId, unsigned int requesterId);

    bool findTournamentParticipantId(unsigned int userId, unsigned int tournamentId);
    bool matchPredictionAlreadyExists(unsigned int matchId, unsigned int participantId);
    bool matchAcceptsPredictions(unsigned int matchId);
    bool createMatchPrediction(unsigned int matchId, unsigned int participantId, unsigned int firstCompetitorScore,
                               unsigned int secondCompetitorScore);
    bool updateMatchPrediction(unsigned int matchId, unsigned int participantId, unsigned int firstCompetitorScore,
                               unsigned int secondCompetitorScore);
};

#endif // QUERY_H
