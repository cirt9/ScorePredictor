#ifndef SERVERPACKETPROCESSOR_H
#define SERVERPACKETPROCESSOR_H

#include <packet.h>
#include <dbconnection.h>
#include <query.h>
#include <QSharedPointer>

class ServerPacketProcessor
{
private:
    QSharedPointer<DbConnection> dbConnection;

    void registerUser(const QVariantList & userData);

public:
    explicit ServerPacketProcessor(QSharedPointer<DbConnection> connection);
    ~ServerPacketProcessor() {}

    void processPacket(const Packet & packet);
};

#endif // SERVERPACKETPROCESSOR_H
