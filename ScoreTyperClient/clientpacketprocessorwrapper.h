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
    void registrationReply(bool reply, const QString & message);
};

#endif // CLIENTPACKETPROCESSORWRAPPER_H
