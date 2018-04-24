#include "query.h"

Query::Query(QSharedPointer<DbConnection> connection)
{
    dbConnection = connection;
}

bool Query::isUserRegistered(const QString & nickname)
{
    QString queryString = "SELECT 1 FROM user WHERE nickname = '" + nickname + "';";
    QSqlQuery query = dbConnection->exec(queryString);

    if(query.first())
        return true;
    else
        return false;
}

bool Query::registerUser(const QString & nickname, const QString & password)
{
    QString queryString = "INSERT INTO user (nickname, password) VALUES "
                          "('" + nickname + "', '" + password + "');";
    QSqlQuery query = dbConnection->exec(queryString);

    if(query.numRowsAffected() > 0)
        return true;
    else
        return false;
}

bool Query::isPasswordCorrect(const QString & nickname, const QString & password)
{
    QString queryString = "SELECT 1 FROM user WHERE nickname = '" + nickname +
            "' AND password = '" + password + "';";
    QSqlQuery query = dbConnection->exec(queryString);

    if(query.first())
        return true;
    else
        return false;
}
