#include "match.h"

Match::Match(QObject * parent) : QObject(parent)
{
    firstCompetitorScore = 0;
    secondCompetitorScore = 0;
}

Match::Match(const QVariantList & matchData, QObject * parent) : QObject(parent)
{
    if(matchData.size() == Match::NUMBER_OF_FIELDS)
    {
        firstCompetitor = matchData[0].toString();
        secondCompetitor = matchData[1].toString();
        firstCompetitorScore = matchData[2].toUInt();
        secondCompetitorScore = matchData[3].toUInt();
        predictionsEndTime = matchData[4].toDateTime();
        tournamentName = matchData[5].toString();
        tournamentHostName = matchData[6].toString();
        roundName = matchData[7].toString();
    }
}

void Match::setFirstCompetitor(const QString & value)
{
    firstCompetitor = value;
    emit firstCompetitorChanged();
}

void Match::setSecondCompetitor(const QString & value)
{
    secondCompetitor = value;
    emit secondCompetitorChanged();
}

void Match::setFirstCompetitorScore(unsigned int value)
{
    firstCompetitorScore = value;
    emit firstCompetitorScoreChanged();
}

void Match::setSecondCompetitorScore(unsigned int value)
{
    secondCompetitorScore = value;
    emit secondCompetitorScoreChanged();
}

void Match::setPredictionsEndTime(const QDateTime & value)
{
    predictionsEndTime = value;
    emit predictionsEndTimeChanged();
}

void Match::setTournamentName(const QString & value)
{
    tournamentName = value;
    emit tournamentNameChanged();
}

void Match::setTournamentHostName(const QString & value)
{
    tournamentHostName = value;
    emit tournamentHostNameChanged();
}

void Match::setRoundName(const QString & value)
{
    roundName = value;
    emit roundNameChanged();
}

QString Match::getFirstCompetitor() const
{
    return firstCompetitor;
}

QString Match::getSecondCompetitor() const
{
    return secondCompetitor;
}

unsigned int Match::getFirstCompetitorScore() const
{
    return firstCompetitorScore;
}

unsigned int Match::getSecondCompetitorScore() const
{
    return secondCompetitorScore;
}

QDateTime Match::getPredictionsEndTime() const
{
    return predictionsEndTime;
}

QString Match::getTournamentName() const
{
    return tournamentName;
}

QString Match::getTournamentHostName() const
{
    return tournamentHostName;
}

QString Match::getRoundName() const
{
    return roundName;
}

QVariantList & operator<<(QVariantList & list, const Match & match)
{
    list << match.firstCompetitor;
    list << match.secondCompetitor;
    list << match.firstCompetitorScore;
    list << match.secondCompetitorScore;
    list << match.predictionsEndTime;
    list << match.tournamentName;
    list << match.tournamentHostName;
    list << match.roundName;

    return list;
}
