#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QHostAddress>
#include <QThread>
#include <tcpclientwrapper.h>
#include <packetprocessorwrapper.h>
#include <user.h>
#include <tournament.h>

class BackEnd : public QObject
{
    Q_OBJECT

private:
    QThread * workerThread;
    TcpClientWrapper * clientWrapper;
    Client::PacketProcessorWrapper * packetProcessorWrapper;
    User * currentUser;

public:
    explicit BackEnd(QObject * parent = nullptr);
    ~BackEnd() {}

    Q_INVOKABLE void close();
    Q_INVOKABLE void connectToServer();
    Q_INVOKABLE void disconnectFromServer();
    Q_INVOKABLE void login(const QString & nickname, const QString & password);
    Q_INVOKABLE void registerAccount(const QString & nickname, const QString & password);
    Q_INVOKABLE void downloadUserProfile(const QString & nickname);
    Q_INVOKABLE void createTournament(Tournament * tournament, const QString & password);
    Q_INVOKABLE void pullTournamentsList(const QString & requesterName, int itemsLimit);
    Q_INVOKABLE void pullTournamentsList(const QString & requesterName,
                                         int itemsLimit, const QDateTime & minEntriesEndTime);

    TcpClientWrapper * getClientWrapper() const;
    Client::PacketProcessorWrapper * getPacketProcessorWrapper() const;
    User * getCurrentUser() const;
};

#endif // BACKEND_H
