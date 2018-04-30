#ifndef CLIENTPACKETPROCESSORWRAPPER_H
#define CLIENTPACKETPROCESSORWRAPPER_H

#include <clientpacketprocessor.h>

class ClientPacketProcessorWrapper : public QObject
{
    Q_OBJECT

private:
    ClientPacketProcessor * packetProcessor;

public:
    explicit ClientPacketProcessorWrapper(QObject * parent = nullptr);
    ~ClientPacketProcessorWrapper();

    ClientPacketProcessor * getPacketProcessor() const;

signals:
    void requestError(const QString & errorMessage);
    void registrationReply(bool replyState, const QString & message);
    void loggingReply(bool replyState, const QString & message);
    void profileDownloadReply(const QString & description);
};

#endif // CLIENTPACKETPROCESSORWRAPPER_H
