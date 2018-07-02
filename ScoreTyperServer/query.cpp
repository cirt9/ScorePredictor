#include "query.h"

Query::Query(const QSqlDatabase & dbConnection) : QSqlQuery(dbConnection)
{
    setForwardOnly(true);
}

bool Query::findUserId(const QString & nickname)
{
    prepare("SELECT id FROM user WHERE nickname=:nickname");
    bindValue(":nickname", nickname);
    exec();

    if(first())
        return true;
    else
        return false;
}

bool Query::isUserRegistered(const QString & nickname)
{
    prepare("SELECT 1 FROM user WHERE nickname=:nickname");
    bindValue(":nickname", nickname);
    exec();

    if(first())
        return true;
    else
        return false;
}

bool Query::registerUser(const QString & nickname, const QString & password)
{
    prepare("INSERT INTO user(nickname, password) VALUES (:nickname, :password)");
    bindValue(":nickname", nickname);
    bindValue(":password", password);
    exec();

    if(numRowsAffected() > 0)
        return true;
    else
        return false;
}

bool Query::isPasswordCorrect(const QString & nickname, const QString & password)
{
    prepare("SELECT 1 FROM user WHERE nickname=:nickname AND password=:password");
    bindValue(":nickname", nickname);
    bindValue(":password", password);
    exec();

    if(first())
        return true;
    else
        return false;
}

bool Query::getUserProfile(const QString & nickname)
{
    prepare("SELECT description FROM user "
            "INNER JOIN user_profile on user.id = user_profile.user_id "
            "WHERE user.nickname=:nickname");
    bindValue(":nickname", nickname);
    exec();

    if(first())
        return true;
    else
        return false;
}

bool Query::tournamentExists(const QString & tournamentName, unsigned int hostId)
{
    prepare("SELECT 1 FROM tournament WHERE name=:tournamentName AND host_user_id=:hostId");
    bindValue(":tournamentName", tournamentName);
    bindValue(":hostId", hostId);
    exec();

    if(first())
        return true;
    else
        return false;
}

bool Query::createTournament(const Tournament & tournament, unsigned int hostId, const QString & password)
{
    prepare("INSERT INTO tournament (name, host_user_id, password, entries_end_time, typers_limit) "
                  "VALUES (:tournamentName, :hostId, :password, :entriesEndTime, :typersLimit)");
    bindValue(":tournamentName", tournament.getName());
    bindValue(":hostId", hostId);
    bindValue(":password", password);
    bindValue(":entriesEndTime", tournament.getEntriesEndTime());
    bindValue(":typersLimit", tournament.getTypersLimit());
    exec();

    if(numRowsAffected() > 0)
        return true;
    else
        return false;
}

void Query::findNewestTournamentsList(unsigned int hostId, const QDateTime & dateTime)
{
    prepare("SELECT name, nickname as host_name, "
            "(SELECT CASE WHEN length(tournament.password) == 0 THEN 0 ELSE 1 END) as password_required, "
            "entries_end_time, "
            "(SELECT count(tournament_participant.id) FROM tournament_participant "
            "INNER JOIN tournament AS t ON tournament_participant.tournament_id = tournament.id "
            "WHERE t.id = tournament.id) as 'typers', "
            "typers_limit FROM tournament "
            "INNER JOIN user ON host_user_id = user.id "
            "WHERE entries_end_time > :minDateTime AND tournament.id IN "
            "(SELECT tournament_id FROM tournament_participant WHERE tournament_id NOT IN "
            "(SELECT tournament_id FROM tournament_participant WHERE user_id = :hostId) "
            "GROUP BY tournament_id) "
            "ORDER BY entries_end_time "
            "LIMIT 20");
    bindValue(":hostId", hostId);
    bindValue(":minDateTime", dateTime);
    exec();
}
