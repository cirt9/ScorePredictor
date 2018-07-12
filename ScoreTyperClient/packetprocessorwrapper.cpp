#include "packetprocessorwrapper.h"

namespace Client
{
    PacketProcessorWrapper::PacketProcessorWrapper(QObject * parent) : QObject(parent)
    {
        packetProcessor = new Client::PacketProcessor();

        connect(packetProcessor, &Client::PacketProcessor::requestError,
                this, &PacketProcessorWrapper::requestError);
        connect(packetProcessor, &Client::PacketProcessor::registrationReply,
                this, &PacketProcessorWrapper::registrationReply);
        connect(packetProcessor, &Client::PacketProcessor::loggingReply,
                this, &PacketProcessorWrapper::loggingReply);

        connect(packetProcessor, &Client::PacketProcessor::userInfoDownloadReply,
                this, &PacketProcessorWrapper::userInfoDownloadReply);
        connect(packetProcessor, &Client::PacketProcessor::finishedTournamentsListArrived,
                this, &PacketProcessorWrapper::finishedTournamentsListArrived);
        connect(packetProcessor, &Client::PacketProcessor::finishedTournamentsListItemArrived,
                this, &PacketProcessorWrapper::finishedTournamentsListItemArrived);
        connect(packetProcessor, &Client::PacketProcessor::ongoingTournamentsListArrived,
                this, &PacketProcessorWrapper::ongoingTournamentsListArrived);
        connect(packetProcessor, &Client::PacketProcessor::ongoingTournamentsListItemArrived,
                this, &PacketProcessorWrapper::ongoingTournamentsListItemArrived);

        connect(packetProcessor, &Client::PacketProcessor::tournamentCreationReply,
                this, &PacketProcessorWrapper::tournamentCreationReply);
        connect(packetProcessor, &Client::PacketProcessor::tournamentsListArrived,
                this, &PacketProcessorWrapper::tournamentsListArrived);
        connect(packetProcessor, &Client::PacketProcessor::tournamentsListItemArrived,
                this, &PacketProcessorWrapper::tournamentsListItemArrived);
    }

    PacketProcessorWrapper::~PacketProcessorWrapper()
    {
        packetProcessor->deleteLater();
    }

    Client::PacketProcessor * PacketProcessorWrapper::getPacketProcessor() const
    {
        return packetProcessor;
    }
}
