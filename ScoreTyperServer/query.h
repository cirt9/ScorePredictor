#ifndef QUERY_H
#define QUERY_H

#include <dbconnection.h>
#include <QSqlQuery>
#include <QSharedPointer>

#include <QDebug>

class Query
{
private:
    QSharedPointer<DbConnection> dbConnection;

public:
    Query(QSharedPointer<DbConnection> connection);
    ~Query() {}

    bool isUserRegistered(const QString & nickname);
    bool registerUser(const QString & nickname, const QString & password);
    bool isPasswordCorrect(const QString & nickname, const QString & password);
    QSqlQuery getUserProfile(const QString & nickname);
};

#endif // QUERY_H
