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
    QSqlQuery query;

public:
    Query(QSharedPointer<DbConnection> connection);
    ~Query() {}

    bool next();
    QVariant value(int index) const;
    QVariant value(const QString & name) const;
    QString	lastQuery() const;
    QString lastError() const;
    bool isValid() const;

    bool isUserRegistered(const QString & nickname);
    bool registerUser(const QString & nickname, const QString & password);
    bool isPasswordCorrect(const QString & nickname, const QString & password);
    bool getUserProfile(const QString & nickname);
    bool tournamentExists(const QString & tournamentName, const QString & hostName);
};

#endif // QUERY_H
