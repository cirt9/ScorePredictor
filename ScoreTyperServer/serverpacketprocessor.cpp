#include "serverpacketprocessor.h"

ServerPacketProcessor::ServerPacketProcessor(QSharedPointer<DbConnection> connection)
{
    dbConnection = connection;
}

void ServerPacketProcessor::processPacket(const Packet & packet)
{
    if(!dbConnection->isConnected())
        return;

    QVariantList data = packet.getUnserializedData();
    int packetId = data[0].toInt();
    data.removeFirst();

    switch(packetId)
    {
    case Packet::PACKET_ID_REGISTER: registerUser(data); break;

    default: break;
    }
}

void ServerPacketProcessor::registerUser(const QVariantList & userData)
{
    Query query(dbConnection);

    if(query.isUserRegistered(userData[0].toString()))
        qDebug() << "User is registered";
    else
        qDebug() << "User is not registered";
}
