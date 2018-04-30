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
