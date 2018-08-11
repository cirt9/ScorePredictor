#include "tournament.h"

Tournament::Tournament(QObject * parent) : QObject(parent)
{
    name = QString("Tournament");
    hostName = QString("Host");
    passwordRequired = false;
    entriesEndTime = QDateTime::currentDateTime();
    typersNumber = 0;
    typersLimit = 0;
}

Tournament::Tournament(const QVariantList & tournamentData, QObject * parent) : QObject(parent)
{
    if(tournamentData.size() == Tournament::NUMBER_OF_FIELDS)
    {
        name = tournamentData[0].toString();
        hostName = tournamentData[1].toString();
        passwordRequired = tournamentData[2].toBool();
        entriesEndTime = tournamentData[3].toDateTime();
        typersNumber = tournamentData[4].toUInt();
        typersLimit = tournamentData[5].toUInt();
    }
}

void Tournament::reset()
{
    setName(QString("Tournament"));
    setHostName(QString("Host"));
    setPasswordRequired(false);
    setEntriesEndTime(QDateTime::currentDateTime());
    setTypersNumber(0);
    setTypersLimit(0);
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
    emit nameChanged();
}

void Tournament::setHostName(const QString & value)
{
    hostName = value;
    emit hostNameChanged();
}

void Tournament::setPasswordRequired(bool required)
{
    passwordRequired = required;
    emit passwordRequiredChanged();
}

void Tournament::setEntriesEndTime(const QDateTime & value)
{
    entriesEndTime = value;
    emit entriesEndTimeChanged();
}

void Tournament::setTypersNumber(unsigned int value)
{
    typersNumber = value;
    emit typersNumberChanged();
}

void Tournament::setTypersLimit(unsigned int value)
{
    typersLimit = value;
    emit typersLimitChanged();
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
