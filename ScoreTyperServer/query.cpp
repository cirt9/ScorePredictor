#include "query.h"

Query::Query(QSharedPointer<DbConnection> connection)
{
    dbConnection = connection;
}

bool Query::next()
{
    if(query.next())
        return true;
    else
        return false;
}

QVariant Query::value(int index) const
{
    return query.value(index);
}

QVariant Query::value(const QString & name) const
{
    return query.value(name);
}

QString Query::lastQuery() const
{
    return query.lastQuery();
}

QString Query::lastError() const
{
    return query.lastError().text();
}

bool Query::isValid() const
{
    return query.isValid();
}

bool Query::findUserId(const QString & nickname)
{
    QString queryString = "SELECT id FROM user WHERE nickname='" + nickname + "';";
    query = dbConnection->exec(queryString);

    if(query.first())
        return true;
    else
        return false;
}

bool Query::isUserRegistered(const QString & nickname)
{
    QString queryString = "SELECT 1 FROM user WHERE nickname = '" + nickname + "';";
    query = dbConnection->exec(queryString);

    if(query.first())
        return true;
    else
        return false;
}

bool Query::registerUser(const QString & nickname, const QString & password)
{
    QString queryString = "INSERT INTO user (nickname, password) VALUES "
                          "('" + nickname + "', '" + password + "');";
    query = dbConnection->exec(queryString);

    if(query.numRowsAffected() > 0)
        return true;
    else
        return false;
}

bool Query::isPasswordCorrect(const QString & nickname, const QString & password)
{
    QString queryString = "SELECT 1 FROM user WHERE nickname = '" + nickname +
            "' AND password = '" + password + "';";
    query = dbConnection->exec(queryString);

    if(query.first())
        return true;
    else
        return false;
}

bool Query::getUserProfile(const QString & nickname)
{
    QString queryString = "SELECT description FROM user "
            "INNER JOIN user_profile on user.id = user_profile.user_id "
            "WHERE user.nickname='" + nickname + "';";
    query = dbConnection->exec(queryString);

    if(query.first())
        return true;
    else
        return false;
}

bool Query::tournamentExists(const QString & tournamentName, unsigned int hostId)
{
    QString queryString = "SELECT 1 FROM tournament WHERE name='" + tournamentName + "'"
                          " AND host_user_id='" + QString::number(hostId) + "';";
    query = dbConnection->exec(queryString);

    if(query.first())
        return true;
    else
        return false;
}

bool Query::createTournament(const Tournament & tournament, unsigned int hostId)
{
    QString queryString = "INSERT INTO tournament (name, host_user_id, password, entries_end_time, "
                          "typers_limit) VALUES ('" + tournament.getName() + "', " +
                          QString::number(hostId) + ", '" + tournament.getPassword() + "', '" +
                          tournament.getEntriesEndTime().toString("dd-MM-yyyy hh:mm:ss") + "', " +
                          QString::number(tournament.getTypersLimit()) + ");";
    query = dbConnection->exec(queryString);

    if(query.numRowsAffected() > 0)
        return true;
    else
        return false;
}
