#include "tournament.h"

Tournament::Tournament(QObject * parent) : QObject(parent)
{

}

QString Tournament::getName() const
{
    return name;
}

QString Tournament::getHostName() const
{
    return hostName;
}

QString Tournament::getPassword() const
{
    return password;
}

QDateTime Tournament::getEntriesEndTime() const
{
    return entriesEndTime;
}

unsigned int Tournament::getTypersLimit() const
{
    return typersLimit;
}

unsigned int Tournament::getNumberOfRounds() const
{
    return numberOfRounds;
}

void Tournament::setName(const QString & value)
{
    name = value;
}

void Tournament::setHostName(const QString & value)
{
    hostName = value;
}

void Tournament::setPassword(const QString & value)
{
    password = value;
}

void Tournament::setEntriesEndTime(const QDateTime & value)
{
    entriesEndTime = value;
}

void Tournament::setTypersLimit(unsigned int value)
{
    typersLimit = value;
}

void Tournament::setNumberOfRounds(unsigned int value)
{
    numberOfRounds = value;
}
