#include "serverpacketprocessor.h"

ServerPacketProcessor::ServerPacketProcessor(DbConnection * connection)
{
    dbConnection = connection;
}

void ServerPacketProcessor::processPacket(const Packet & packet)
{
    QVariantList data = packet.getUnserializedData();
    int packetId = data[0].toInt();

    switch(packetId)
    {
    case Packet::PACKET_ID_REGISTER: break;

    default: break;
    }
}
