#include "tournament.h"

Tournament::Tournament(QObject * parent) : QObject(parent)
{
    name = QString("Tournament");
    hostName = QString("Host");
    passwordRequired = false;
    entriesEndTime = QDateTime::currentDateTime();
    predictorsNumber = 0;
    predictorsLimit = 0;
}

Tournament::Tournament(const QVariantList & tournamentData, QObject * parent) : QObject(parent)
{
    if(tournamentData.size() == Tournament::NUMBER_OF_FIELDS)
    {
        name = tournamentData[0].toString();
        hostName = tournamentData[1].toString();
        passwordRequired = tournamentData[2].toBool();
        entriesEndTime = tournamentData[3].toDateTime();
        predictorsNumber = tournamentData[4].toUInt();
        predictorsLimit = tournamentData[5].toUInt();
    }
}

void Tournament::reset()
{
    setName(QString("Tournament"));
    setHostName(QString(""));
    setPasswordRequired(false);
    setEntriesEndTime(QDateTime::currentDateTime());
    setPredictorsNumber(0);
    setPredictorsLimit(0);
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

unsigned int Tournament::getPredictorsNumber() const
{
    return predictorsNumber;
}

unsigned int Tournament::getPredictorsLimit() const
{
    return predictorsLimit;
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

void Tournament::setPredictorsNumber(unsigned int value)
{
    predictorsNumber = value;
    emit predictorsNumberChanged();
}

void Tournament::setPredictorsLimit(unsigned int value)
{
    predictorsLimit = value;
    emit predictorsLimitChanged();
}

QVariantList & operator<<(QVariantList & list, const Tournament & tournament)
{
    list << tournament.name;
    list << tournament.hostName;
    list << tournament.passwordRequired;
    list << tournament.entriesEndTime;
    list << tournament.predictorsNumber;
    list << tournament.predictorsLimit;

    return list;
}
