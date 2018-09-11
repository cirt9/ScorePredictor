#include "dbconnection.h"

const QString DbConnection::DATABASE_NAME = QString("data/database.db");
const QString DbConnection::DRIVER_NAME = QString("QSQLITE");
const QString DbConnection::INITIAL_CONNECTION_NAME = QString("InitialConnection");
QStringList DbConnection::connectionsList = QStringList();

DbConnection::DbConnection(QObject * parent) : QObject(parent)
{
    name = INITIAL_CONNECTION_NAME;
}

bool DbConnection::connect(const QString & connectionName, const QString & databaseName, const QString & driver)
{
    if(isConnected() || connectionName == INITIAL_CONNECTION_NAME)
        return false;

    if(connectionsList.contains(connectionName))
        return false;

    connectionsList.append(connectionName);
    name = connectionName;

    connection = QSqlDatabase::addDatabase(driver, connectionName);
    connection.setDatabaseName(databaseName);

    if(connection.open())
        return true;

    clearConnection();
    return false;
}

void DbConnection::close()
{
    connection.close();
    clearConnection();
}

bool DbConnection::isConnected()
{
    if(connection.isOpen())
    {
        QSqlQuery query(connection);
        query.prepare("SELECT 1 FROM user");

        if(query.exec())
            return true;
    }

    return false;
}

void DbConnection::setConnectOptions(const QString & options)
{
    connection.setConnectOptions(options);
}

void DbConnection::clearConnection()
{
    connection = QSqlDatabase();

    QSqlDatabase::removeDatabase(name);

    if(connectionsList.contains(name))
        connectionsList.removeOne(name);

    name = INITIAL_CONNECTION_NAME;
}

int DbConnection::numberOfOpenedConnections()
{
    return connectionsList.count();
}

QSqlDatabase DbConnection::getConnection() const
{
    return connection;
}
