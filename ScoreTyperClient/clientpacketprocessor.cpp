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

    default: break;
    }
}

void ClientPacketProcessor::manageRegistrationReply(const QVariantList & userData)
{
    emit registrationReply(userData[0].toBool(), userData[1].toString());
}
