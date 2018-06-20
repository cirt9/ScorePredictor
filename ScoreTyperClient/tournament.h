#ifndef TOURNAMENT_H
#define TOURNAMENT_H

#include <QObject>
#include <QDateTime>
#include <QVariantList>
#include <QDataStream>

class Tournament : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ getName WRITE setName)
    Q_PROPERTY(QString hostName READ getHostName WRITE setHostName)
    Q_PROPERTY(QString password READ getPassword WRITE setPassword)
    Q_PROPERTY(QDateTime entriesEndTime READ getEntriesEndTime WRITE setEntriesEndTime)
    Q_PROPERTY(unsigned int typersLimit READ getTypersLimit WRITE setTypersLimit)

private:
    QString name;
    QString hostName;
    QString password;
    QDateTime entriesEndTime;
    unsigned int typersLimit;

public:
    Tournament(QObject * parent = nullptr);
    Tournament(const QVariantList & tournamentData, QObject * parent = nullptr);
    ~Tournament() {}

    QString getName() const;
    QString getHostName() const;
    QString getPassword() const;
    QDateTime getEntriesEndTime() const;
    unsigned int getTypersLimit() const;
    void setName(const QString & value);
    void setHostName(const QString & value);
    void setPassword(const QString & value);
    void setEntriesEndTime(const QDateTime & value);
    void setTypersLimit(unsigned int value);

    friend QVariantList & operator<<(QVariantList & list, const Tournament & tournament);
};

#endif // TOURNAMENT_H
