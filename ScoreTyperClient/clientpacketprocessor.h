#ifndef CLIENTPACKETPROCESSOR_H
#define CLIENTPACKETPROCESSOR_H

#include <../ScoreTyperServer/packet.h>

#include <QDebug>

class ClientPacketProcessor : public QObject
{
    Q_OBJECT

private:
    void manageRegistrationReply(const QVariantList & replyData);
    void manageLoggingReply(const QVariantList & replyData);
    void manageProfileDownloadReply(const QVariantList & replyData);

public:
    explicit ClientPacketProcessor(QObject * parent = nullptr);
    ~ClientPacketProcessor() {}

public slots:
    void processPacket(const Packet & packet);

signals:
    void registrationReply(bool replyState, const QString & message);
    void loggingReply(bool replyState, const QString & message);
    void profileDownloadRedply(const QString & description);
};

#endif // CLIENTPACKETPROCESSOR_H
