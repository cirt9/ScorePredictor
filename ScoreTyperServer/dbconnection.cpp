#include "dbconnection.h"

const QString DbConnection::DATABASE_NAME = QString("data/database.db");
const QString DbConnection::DRIVER_NAME = QString("QSQLITE");
const QString DbConnection::INITIAL_CONNECTION_NAME = QString("InitialConnection");
QStringList DbConnection::connectionsList = QStringList();

DbConnection::DbConnection(QObject * parent) : QObject(parent)
{
    name = INITIAL_CONNECTION_NAME;

    qDebug() << "Creating db connection" << this;
}

bool DbConnection::connect(const QString & connectionName, const QString & databaseName, const QString & driver)
{
    if(isConnected() || connectionName == INITIAL_CONNECTION_NAME)
    {
        qDebug() << "There is already established connection to database or the name is forbidden" << this;
        return false;
    }

    if(connectionsList.contains(connectionName))
    {
        qDebug() << "There is already connection with name: " << connectionName;
        return false;
    }

    qDebug() << this << connectionName;
    connectionsList.append(connectionName);
    name = connectionName;

    connection = QSqlDatabase::addDatabase(driver, connectionName);
    connection.setDatabaseName(databaseName);

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
        return true;
    }
    qDebug() << "Database is not connected" << this;
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
