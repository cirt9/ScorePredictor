#ifndef DBCONNECTION_H
#define DBCONNECTION_H

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>

#include <QDebug>

class DbConnection : QObject
{
    Q_OBJECT

private:
    QSqlDatabase connection;
    QString name;

    static QStringList connectionsList;

    const static QString DATABASE_NAME;
    const static QString DRIVER_NAME;
    const static QString INITIAL_CONNECTION_NAME;

    bool isConnected();
    void clearConnection();

public:
    explicit DbConnection(QObject * parent = nullptr);
    ~DbConnection();

    bool connect(const QString & connectionName, const QString & databaseName = DATABASE_NAME,
                 const QString & driver = DRIVER_NAME);
    void close();

    static int numberOfOpenedConnections();
};

#endif // DBCONNECTION_H
