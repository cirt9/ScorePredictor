#ifndef SERVERPACKETPROCESSOR_H
#define SERVERPACKETPROCESSOR_H

#include <packet.h>
#include <dbconnection.h>
#include <query.h>
#include <QSharedPointer>
#include <../ScoreTyperClient/tournament.h>

class ServerPacketProcessor: public QObject
{
    Q_OBJECT

private:
    QSharedPointer<DbConnection> dbConnection;

    void registerUser(const QVariantList & userData);
    void loginUser(const QVariantList & userData);
    void userProfileRequest(const QVariantList & userData);
    void tournamentCreationRequest(const QVariantList & tournamentData);

public:
    explicit ServerPacketProcessor(QSharedPointer<DbConnection> connection, QObject * parent = nullptr);
    ~ServerPacketProcessor() {}

public slots:
    void processPacket(const Packet & packet);

signals:
    void response(const QVariantList & data);
};

#endif // SERVERPACKETPROCESSOR_H
