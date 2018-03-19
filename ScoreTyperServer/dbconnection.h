#ifndef DBCONNECTION_H
#define DBCONNECTION_H

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>

#include <QDebug>

class DbConnection
{
private:
    QSqlDatabase connection;
    QString name;

    const static QString DATABASE_NAME;
    const static QString DRIVER_NAME;
    const static QString INITIAL_CONNECTION_NAME;

    bool isConnected();
    void clearConnection();

public:
    explicit DbConnection();
    ~DbConnection();

    bool connect(const QString & connectionName, const QString & databaseName = DATABASE_NAME,
                 const QString & driver = DRIVER_NAME);
    void close();
};

#endif // DBCONNECTION_H
