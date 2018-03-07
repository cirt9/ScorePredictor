#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QHostAddress>
#include <tcpclient.h>

class BackEnd : public QObject
{
    Q_OBJECT

private:
    TcpClient * client;

public:
    explicit BackEnd(QObject * parent = nullptr);
    ~BackEnd() {}

    Q_INVOKABLE bool login(const QString & login, const QString & password);
    TcpClient * getClient() const;
};

#endif // BACKEND_H
