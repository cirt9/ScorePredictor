#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QHostAddress>
#include <QThread>
#include <tcpclientwrapper.h>

class BackEnd : public QObject
{
    Q_OBJECT

private:
    QThread * workerThread;
    TcpClientWrapper * clientWrapper;

public:
    explicit BackEnd(QObject * parent = nullptr);
    ~BackEnd() {}

    Q_INVOKABLE void close();
    Q_INVOKABLE void connectToServer();
    Q_INVOKABLE void login(const QString & nickname, const QString & password);

    TcpClientWrapper * getClientWrapper() const;
};

#endif // BACKEND_H
