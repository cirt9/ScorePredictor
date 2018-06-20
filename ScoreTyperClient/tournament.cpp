#include "tournament.h"

Tournament::Tournament(QObject * parent) : QObject(parent)
{

}

Tournament::Tournament(const QVariantList & tournamentData, QObject * parent) : QObject(parent)
{
    if(tournamentData.size() == 5)
    {
        name = tournamentData[0].toString();
        hostName = tournamentData[1].toString();
        password = tournamentData[2].toString();
        entriesEndTime = tournamentData[3].toDateTime();
        typersLimit = tournamentData[4].toUInt();
    }
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

QVariantList & operator<<(QVariantList & list, const Tournament & tournament)
{
    list << tournament.name;
    list << tournament.hostName;
    list << tournament.password;
    list << tournament.entriesEndTime;
    list << tournament.typersLimit;

    return list;
}
