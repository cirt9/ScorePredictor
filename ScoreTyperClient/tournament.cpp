#include "tournament.h"

Tournament::Tournament(QObject * parent) : QObject(parent)
{
    passwordRequired = false;
    typersNumber = 0;
    typersLimit = 0;
}

Tournament::Tournament(const QVariantList & tournamentData, QObject * parent) : QObject(parent)
{
    if(tournamentData.size() == 6)
    {
        name = tournamentData[0].toString();
        hostName = tournamentData[1].toString();
        passwordRequired = tournamentData[2].toBool();
        entriesEndTime = tournamentData[3].toDateTime();
        typersNumber = tournamentData[4].toUInt();
        typersLimit = tournamentData[5].toUInt();
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

bool Tournament::getPasswordRequired() const
{
    return passwordRequired;
}

QDateTime Tournament::getEntriesEndTime() const
{
    return entriesEndTime;
}

unsigned int Tournament::getTypersNumber() const
{
    return typersNumber;
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

void Tournament::setPasswordRequired(bool required)
{
    passwordRequired = required;
}

void Tournament::setEntriesEndTime(const QDateTime & value)
{
    entriesEndTime = value;
}

void Tournament::setTypersNumber(unsigned int value)
{
    typersNumber = value;
}

void Tournament::setTypersLimit(unsigned int value)
{
    typersLimit = value;
}

QVariantList & operator<<(QVariantList & list, const Tournament & tournament)
{
    list << tournament.name;
    list << tournament.hostName;
    list << tournament.passwordRequired;
    list << tournament.entriesEndTime;
    list << tournament.typersNumber;
    list << tournament.typersLimit;

    return list;
}
