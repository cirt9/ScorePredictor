#include "clientpacketprocessor.h"

ClientPacketProcessor::ClientPacketProcessor(QObject * parent) : QObject(parent)
{

}

void ClientPacketProcessor::processPacket(const Packet & packet)
{
    QVariantList data = packet.getUnserializedData();
    int packetId = data[0].toInt();
    data.removeFirst();

    switch(packetId)
    {
    case Packet::PACKET_ID_REGISTER: manageRegistrationReply(data); break;
    case Packet::PACKET_ID_LOGIN: manageLoggingReply(data); break;

    default: break;
    }
}

void ClientPacketProcessor::manageRegistrationReply(const QVariantList & replyData)
{
    emit registrationReply(replyData[0].toBool(), replyData[1].toString());
}

void ClientPacketProcessor::manageLoggingReply(const QVariantList & replyData)
{
    emit loggingReply(replyData[0].toBool(), replyData[1].toString());
}
