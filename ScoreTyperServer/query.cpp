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

bool Query::createTournament(const Tournament & tournament, unsigned int hostId)
{
    prepare("INSERT INTO tournament (name, host_user_id, password, entries_end_time, typers_limit) "
                  "VALUES (:tournamentName, :hostId, :password, :entriesEndTime, :typersLimit)");
    bindValue(":tournamentName", tournament.getName());
    bindValue(":hostId", hostId);
    bindValue(":password", tournament.getPassword());
    bindValue(":entriesEndTime", tournament.getEntriesEndTime());
    bindValue(":typersLimit", tournament.getTypersLimit());
    exec();

    if(numRowsAffected() > 0)
        return true;
    else
        return false;
}
