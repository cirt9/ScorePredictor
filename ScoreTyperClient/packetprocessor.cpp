#include "packetprocessor.h"

namespace Client
{
    PacketProcessor::PacketProcessor(QObject * parent) : QObject(parent)
    {

    }

    void PacketProcessor::processPacket(const Packet & packet)
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

    void PacketProcessor::manageReplyError(const QVariantList & errorData)
    {
        emit requestError(errorData[0].toString());
    }

    void PacketProcessor::manageRegistrationReply(const QVariantList & replyData)
    {
        emit registrationReply(replyData[0].toBool(), replyData[1].toString());
    }

    void PacketProcessor::manageLoggingReply(const QVariantList & replyData)
    {
        emit loggingReply(replyData[0].toBool(), replyData[1].toBool(), replyData[2].toString());
    }

    void PacketProcessor::manageProfileRequestReply(const QVariantList & replyData)
    {
        emit profileDownloadRedply(replyData[0].toString());
    }
}
