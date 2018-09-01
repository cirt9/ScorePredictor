#ifndef USER_H
#define USER_H

#include <QObject>

class User : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString username READ getNickname WRITE setNickname NOTIFY nicknameChanged)

private:
    QString nickname;

public:
    User(QObject * parent = nullptr);
    User(const QString & name, QObject * parent = nullptr);
    ~User() {}

    Q_INVOKABLE void reset();
    void setNickname(const QString & name);
    QString getNickname() const;

signals:
    void nicknameChanged();
};

#endif // USER_H
