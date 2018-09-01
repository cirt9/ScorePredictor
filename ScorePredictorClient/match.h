#ifndef MATCH_H
#define MATCH_H

#include <QObject>
#include <QDateTime>
#include <QVariantList>

class Match : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString firstCompetitor READ getFirstCompetitor WRITE setFirstCompetitor
               NOTIFY firstCompetitorChanged)
    Q_PROPERTY(QString secondCompetitor READ getSecondCompetitor WRITE setSecondCompetitor
               NOTIFY secondCompetitorChanged)
    Q_PROPERTY(unsigned int firstCompetitorScore READ getFirstCompetitorScore WRITE setFirstCompetitorScore
               NOTIFY firstCompetitorScoreChanged)
    Q_PROPERTY(unsigned int secondCompetitorScore READ getSecondCompetitorScore WRITE setSecondCompetitorScore
               NOTIFY secondCompetitorScoreChanged)
    Q_PROPERTY(QDateTime predictionsEndTime READ getPredictionsEndTime WRITE setPredictionsEndTime
               NOTIFY predictionsEndTimeChanged)
    Q_PROPERTY(QString tournamentName READ getTournamentName WRITE setTournamentName
               NOTIFY tournamentNameChanged)
    Q_PROPERTY(QString tournamentHostName READ getTournamentHostName WRITE setTournamentHostName
               NOTIFY tournamentHostNameChanged)
    Q_PROPERTY(QString roundName READ getRoundName WRITE setRoundName NOTIFY roundNameChanged)

private:
    QString firstCompetitor;
    QString secondCompetitor;
    unsigned int firstCompetitorScore;
    unsigned int secondCompetitorScore;
    QDateTime predictionsEndTime;
    QString tournamentName;
    QString tournamentHostName;
    QString roundName;

public:
    explicit Match(QObject * parent = nullptr);
    explicit Match(const QVariantList & matchData, QObject * parent = nullptr);
    ~Match() {}

    void setRoundName(const QString & value);
    void setFirstCompetitor(const QString & value);
    void setSecondCompetitor(const QString & value);
    void setFirstCompetitorScore(unsigned int value);
    void setSecondCompetitorScore(unsigned int value);
    void setPredictionsEndTime(const QDateTime & value);
    void setTournamentName(const QString & value);
    void setTournamentHostName(const QString & value);

    QString getFirstCompetitor() const;
    QString getSecondCompetitor() const;
    unsigned int getFirstCompetitorScore() const;
    unsigned int getSecondCompetitorScore() const;
    QDateTime getPredictionsEndTime() const;
    QString getTournamentName() const;
    QString getTournamentHostName() const;
    QString getRoundName() const;

    static const int NUMBER_OF_FIELDS = 8;

    friend QVariantList & operator<<(QVariantList & list, const Match & match);

signals:
    void firstCompetitorChanged();
    void secondCompetitorChanged();
    void firstCompetitorScoreChanged();
    void secondCompetitorScoreChanged();
    void predictionsEndTimeChanged();
    void tournamentNameChanged();
    void tournamentHostNameChanged();
    void roundNameChanged();
};

#endif // MATCH_H
