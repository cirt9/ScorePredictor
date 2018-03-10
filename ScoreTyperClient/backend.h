#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QHostAddress>
#include <QThread>
#include <tcpclient.h>

class BackEnd : public QObject
{
    Q_OBJECT

private:
    TcpClient * client;
    QThread * workerThread;

    void connectToServer(const QHostAddress & address, quint16 port);

public:
    explicit BackEnd(QObject * parent = nullptr);
    ~BackEnd() {}

    Q_INVOKABLE void close();

    Q_INVOKABLE bool login(const QString & login, const QString & password);

signals:
    void connectingToServer(const QHostAddress & address, quint16 port);
};

#endif // BACKEND_H
