#include "clientpacketprocessorwrapper.h"

ClientPacketProcessorWrapper::ClientPacketProcessorWrapper(QObject * parent) : QObject(parent)
{
    packetProcessor = new ClientPacketProcessor();

    connect(packetProcessor, &ClientPacketProcessor::registrationReply,
            this, &ClientPacketProcessorWrapper::registrationReply);
    connect(packetProcessor, &ClientPacketProcessor::loggingReply,
            this, &ClientPacketProcessorWrapper::loggingReply);
}

ClientPacketProcessorWrapper::~ClientPacketProcessorWrapper()
{
    packetProcessor->deleteLater();
}

ClientPacketProcessor *ClientPacketProcessorWrapper::getPacketProcessor() const
{
    return packetProcessor;
}
