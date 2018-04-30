#include "clientpacketprocessorwrapper.h"

ClientPacketProcessorWrapper::ClientPacketProcessorWrapper(QObject * parent) : QObject(parent)
{
    packetProcessor = new ClientPacketProcessor();

    connect(packetProcessor, &ClientPacketProcessor::registrationReply,
            this, &ClientPacketProcessorWrapper::registrationReply);
    connect(packetProcessor, &ClientPacketProcessor::loggingReply,
            this, &ClientPacketProcessorWrapper::loggingReply);
    connect(packetProcessor, &ClientPacketProcessor::profileDownloadRedply,
            this, &ClientPacketProcessorWrapper::profileDownloadReply);
    connect(packetProcessor, &ClientPacketProcessor::requestError,
            this, &ClientPacketProcessorWrapper::requestError);
}

ClientPacketProcessorWrapper::~ClientPacketProcessorWrapper()
{
    packetProcessor->deleteLater();
}

ClientPacketProcessor * ClientPacketProcessorWrapper::getPacketProcessor() const
{
    return packetProcessor;
}
