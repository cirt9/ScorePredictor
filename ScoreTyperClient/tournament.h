#ifndef TOURNAMENT_H
#define TOURNAMENT_H

#include <QObject>
#include <QDateTime>
#include <QVariantList>

class Tournament : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString hostName READ getHostName WRITE setHostName NOTIFY hostNameChanged)
    Q_PROPERTY(bool passwordRequired READ getPasswordRequired WRITE setPasswordRequired NOTIFY passwordRequiredChanged)
    Q_PROPERTY(QDateTime entriesEndTime READ getEntriesEndTime WRITE setEntriesEndTime NOTIFY entriesEndTimeChanged)
    Q_PROPERTY(unsigned int predictorsNumber READ getPredictorsNumber WRITE setPredictorsNumber NOTIFY predictorsNumberChanged)
    Q_PROPERTY(unsigned int predictorsLimit READ getPredictorsLimit WRITE setPredictorsLimit NOTIFY predictorsLimitChanged)

private:
    QString name;
    QString hostName;
    bool passwordRequired;
    QDateTime entriesEndTime;
    unsigned int predictorsNumber;
    unsigned int predictorsLimit;

public:
    explicit Tournament(QObject * parent = nullptr);
    explicit Tournament(const QVariantList & tournamentData, QObject * parent = nullptr);
    ~Tournament() {}

    Q_INVOKABLE void reset();

    QString getName() const;
    QString getHostName() const;
    bool getPasswordRequired() const;
    QDateTime getEntriesEndTime() const;
    unsigned int getPredictorsNumber() const;
    unsigned int getPredictorsLimit() const;
    void setName(const QString & value);
    void setHostName(const QString & value);
    void setPasswordRequired(bool required);
    void setEntriesEndTime(const QDateTime & value);
    void setPredictorsNumber(unsigned int value);
    void setPredictorsLimit(unsigned int value);

    static const int NUMBER_OF_FIELDS = 6;

    friend QVariantList & operator<<(QVariantList & list, const Tournament & tournament);

signals:
    void nameChanged();
    void hostNameChanged();
    void passwordRequiredChanged();
    void entriesEndTimeChanged();
    void predictorsNumberChanged();
    void predictorsLimitChanged();
};

#endif // TOURNAMENT_H
