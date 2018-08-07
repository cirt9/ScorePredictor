#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QHostAddress>
#include <QThread>
#include <tcpclientwrapper.h>
#include <packetprocessorwrapper.h>
#include <user.h>
#include <tournament.h>
#include <match.h>

class BackEnd : public QObject
{
    Q_OBJECT

private:
    QThread * workerThread;
    TcpClientWrapper * clientWrapper;
    Client::PacketProcessorWrapper * packetProcessorWrapper;
    User * currentUser;
    Tournament * currentTournament;

public:
    explicit BackEnd(QObject * parent = nullptr);
    ~BackEnd() {}

    Q_INVOKABLE void close();
    Q_INVOKABLE void connectToServer();
    Q_INVOKABLE void disconnectFromServer();

    Q_INVOKABLE void login(const QString & nickname, const QString & password);
    Q_INVOKABLE void registerAccount(const QString & nickname, const QString & password);

    Q_INVOKABLE void downloadUserInfo(const QString & nickname);
    Q_INVOKABLE void pullFinishedTournaments(const QString & nickname);
    Q_INVOKABLE void pullOngoingTournaments(const QString & nickname);

    Q_INVOKABLE void createTournament(Tournament * tournament, const QString & password);
    Q_INVOKABLE void pullTournaments(const QString & requesterName, int itemsLimit, const QString & tournamentName);
    Q_INVOKABLE void pullTournaments(const QString & requesterName, int itemsLimit, const QString & tournamentName,
                                     const QDateTime & minEntriesEndTime);
    Q_INVOKABLE void joinTournament(const QString & nickname, const QString & tournamentName, const QString & hostName);
    Q_INVOKABLE void joinTournament(const QString & nickname, const QString & tournamentName, const QString & hostName,
                                    const QString & password);

    Q_INVOKABLE void downloadTournamentInfo(const QString & tournamentName, const QString & hostName);
    Q_INVOKABLE void finishTournament(const QString & tournamentName, const QString & hostName);
    Q_INVOKABLE void addNewRound(const QString & tournamentName, const QString & hostName, const QString & roundName);
    Q_INVOKABLE void downloadTournamentLeaderboard(const QString & tournamentName, const QString & hostName);

    Q_INVOKABLE void pullMatches(const QString & tournamentName, const QString & hostName, const QString & roundName);
    Q_INVOKABLE void createNewMatch(Match * newMatch);
    Q_INVOKABLE void deleteMatch(Match * match);

    TcpClientWrapper * getClientWrapper() const;
    Client::PacketProcessorWrapper * getPacketProcessorWrapper() const;
    User * getCurrentUser() const;
    Tournament * getCurrentTournament() const;
};

#endif // BACKEND_H
