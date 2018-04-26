#include "user.h"

User::User(QObject * parent) : QObject(parent)
{

}

User::User(const QString & name, QObject * parent) : QObject(parent)
{
    nickname = name;
}

void User::setNickname(const QString & name)
{
    if(nickname != name)
    {
        nickname = name;
        emit nicknameChanged();
    }
}

QString User::getNickname() const
{
    return nickname;
}
