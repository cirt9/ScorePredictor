#ifndef SERVERPACKETPROCESSOR_H
#define SERVERPACKETPROCESSOR_H

#include <packet.h>
#include <dbconnection.h>

class ServerPacketProcessor
{
private:
    DbConnection * dbConnection;

public:
    explicit ServerPacketProcessor(DbConnection * connection);
    ~ServerPacketProcessor() {}

    void processPacket(const Packet & packet);
};

#endif // SERVERPACKETPROCESSOR_H
