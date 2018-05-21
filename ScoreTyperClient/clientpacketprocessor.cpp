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
    case Packet::ID_ERROR: manageReplyError(data); break;
    case Packet::ID_REGISTER: manageRegistrationReply(data); break;
    case Packet::ID_LOGIN: manageLoggingReply(data); break;
    case Packet::ID_DOWNLOAD_USER_PROFILE: manageProfileRequestReply(data); break;

    default: break;
    }
}

void ClientPacketProcessor::manageReplyError(const QVariantList & errorData)
{
    emit requestError(errorData[0].toString());
}

void ClientPacketProcessor::manageRegistrationReply(const QVariantList & replyData)
{
    emit registrationReply(replyData[0].toBool(), replyData[1].toString());
}

void ClientPacketProcessor::manageLoggingReply(const QVariantList & replyData)
{
    emit loggingReply(replyData[0].toBool(), replyData[1].toBool(), replyData[2].toString());
}

void ClientPacketProcessor::manageProfileRequestReply(const QVariantList & replyData)
{
    emit profileDownloadRedply(replyData[0].toString());
}
