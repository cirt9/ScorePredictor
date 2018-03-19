#include "dbconnection.h"

const QString DbConnection::DATABASE_NAME = QString("data/database.db");
const QString DbConnection::DRIVER_NAME = QString("QSQLITE");
const QString DbConnection::INITIAL_CONNECTION_NAME = QString("InitialConnection");

DbConnection::DbConnection()
{
    name = INITIAL_CONNECTION_NAME;

    qDebug() << "Creating db connection" << this;
}

DbConnection::~DbConnection()
{
    close();
}

bool DbConnection::connect(const QString & connectionName, const QString & databaseName, const QString & driver)
{
    if(isConnected() || connectionName == INITIAL_CONNECTION_NAME)
    {
        qDebug() << "There is already established connection to database or the name is forbidden" << this;
        return false;
    }

    if(QSqlDatabase::connectionNames().contains(connectionName))
    {
        qDebug() << "There is already connection with name: " << connectionName;
        return false;
    }

    connection.setConnectOptions("QSQLITE_ENABLE_SHARED_CACHE");
    connection = QSqlDatabase::addDatabase(driver, connectionName);
    connection.setDatabaseName(databaseName);
    name = connectionName;

    if(connection.open())
    {
        qDebug() << "Database connection opened" << this;
        return true;
    }
    qDebug() << "Couldn't open database connection" << connection.lastError() << this;
    clearConnection();

    return false;
}

void DbConnection::close()
{
    connection.close();
    clearConnection();
    qDebug() << "Database connection closed" << this;
}

bool DbConnection::isConnected()
{
    if(connection.isOpen())
    {
        QSqlQuery query(connection);
        query.prepare("SELECT 1 FROM user");

        if(query.exec())
        {
            qDebug() << "Database is connected" << this;
            return true;
        }
    }
    qDebug() << "Database is not connected" << this;
    return false;
}

void DbConnection::clearConnection()
{
    connection = QSqlDatabase();
    QSqlDatabase::removeDatabase(name);
    name = INITIAL_CONNECTION_NAME;
}
