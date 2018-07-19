#ifndef QUERY_H
#define QUERY_H

#include <dbconnection.h>
#include <QSqlQuery>
#include <QSharedPointer>
#include <../ScoreTyperClient/tournament.h>

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
};

#endif // QUERY_H
