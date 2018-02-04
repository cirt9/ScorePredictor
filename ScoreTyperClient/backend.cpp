#include "backend.h"

BackEnd::BackEnd(QObject *parent) : QObject(parent)
{

}

bool BackEnd::login(const QString & login, const QString & password)
{
    if(login == QString("1") && password == QString("2"))
        return true;
    else
        return false;
}
