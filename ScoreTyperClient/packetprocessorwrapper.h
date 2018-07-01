#ifndef PACKETPROCESSORWRAPPER_H
#define PACKETPROCESSORWRAPPER_H

#include <packetprocessor.h>

namespace Client
{
    class PacketProcessorWrapper : public QObject
    {
        Q_OBJECT

    private:
        Client::PacketProcessor * packetProcessor;

    public:
        explicit PacketProcessorWrapper(QObject * parent = nullptr);
        ~PacketProcessorWrapper();

        Client::PacketProcessor * getPacketProcessor() const;

    signals:
        void requestError(const QString & errorMessage);
        void registrationReply(bool replyState, const QString & message);
        void loggingReply(bool nicknameState, bool passwordState, const QString & message);
        void profileDownloadReply(const QString & description);
        void tournamentCreationReply(bool replyState, const QString & message);
        void tournamentsListElementArrived(const QStringList & tournamentData);
    };
}

#endif // PACKETPROCESSORWRAPPER_H
