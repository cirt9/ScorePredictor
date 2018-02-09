#include "backend.h"

BackEnd::BackEnd(QObject *parent) : QObject(parent)
{

}

bool BackEnd::login(const QString & login, const QString & password)
{
    if(login == QString("") && password == QString(""))
        return true;
    else
        return false;
}
