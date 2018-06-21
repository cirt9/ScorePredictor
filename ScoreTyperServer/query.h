#ifndef QUERY_H
#define QUERY_H

#include <dbconnection.h>
#include <QSqlQuery>
#include <QSharedPointer>
#include <../ScoreTyperClient/tournament.h>

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

    bool findUserId(const QString & nickname);
    bool isUserRegistered(const QString & nickname);
    bool registerUser(const QString & nickname, const QString & password);
    bool isPasswordCorrect(const QString & nickname, const QString & password);
    bool getUserProfile(const QString & nickname);
    bool tournamentExists(const QString & tournamentName, unsigned int hostId);
    bool createTournament(const Tournament & tournament, unsigned int hostId);
};

#endif // QUERY_H
