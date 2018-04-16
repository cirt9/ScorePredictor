#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QHostAddress>
#include <QThread>
#include <tcpclientwrapper.h>
#include <clientpacketprocessorwrapper.h>

class BackEnd : public QObject
{
    Q_OBJECT

private:
    QThread * workerThread;
    TcpClientWrapper * clientWrapper;
    ClientPacketProcessorWrapper * packetProcessorWrapper;

public:
    explicit BackEnd(QObject * parent = nullptr);
    ~BackEnd() {}

    Q_INVOKABLE void close();
    Q_INVOKABLE void connectToServer();
    Q_INVOKABLE void login(const QString & nickname, const QString & password);
    Q_INVOKABLE void registerAccount(const QString & nickname, const QString & password);

    TcpClientWrapper * getClientWrapper() const;
    ClientPacketProcessorWrapper * getPacketProcessorWrapper() const;
};

#endif // BACKEND_H
