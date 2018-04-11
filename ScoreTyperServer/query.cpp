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
