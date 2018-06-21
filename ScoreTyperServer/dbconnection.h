#ifndef DBCONNECTION_H
#define DBCONNECTION_H

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>

#include <QDebug>

class DbConnection : public QObject
{
    Q_OBJECT

private:
    QSqlDatabase connection;
    QString name;

    static QStringList connectionsList;

    const static QString DATABASE_NAME;
    const static QString DRIVER_NAME;
    const static QString INITIAL_CONNECTION_NAME;

    void clearConnection();

public:
    explicit DbConnection(QObject * parent = nullptr);
    ~DbConnection() {}

    bool connect(const QString & connesctionName, const QString & databaseName = DATABASE_NAME,
                 const QString & driver = DRIVER_NAME);
    void close();
    void setConnectOptions(const QString & options = QString());

    static int numberOfOpenedConnections();
    bool isConnected();
    QSqlDatabase getConnection() const;
};

#endif // DBCONNECTION_H
