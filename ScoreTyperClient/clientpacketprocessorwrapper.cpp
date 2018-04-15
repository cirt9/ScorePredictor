#include "clientpacketprocessorwrapper.h"

ClientPacketProcessorWrapper::ClientPacketProcessorWrapper(QObject * parent) : QObject(parent)
{
    packetProcessor = new ClientPacketProcessor();

    connect(packetProcessor, &ClientPacketProcessor::registrationReply,
            this, &ClientPacketProcessorWrapper::registrationReply);
}

ClientPacketProcessorWrapper::~ClientPacketProcessorWrapper()
{
    packetProcessor->deleteLater();
}

ClientPacketProcessor *ClientPacketProcessorWrapper::getPacketProcessor() const
{
    return packetProcessor;
}
