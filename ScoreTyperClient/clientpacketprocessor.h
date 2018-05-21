#ifndef CLIENTPACKETPROCESSOR_H
#define CLIENTPACKETPROCESSOR_H

#include <../ScoreTyperServer/packet.h>

#include <QDebug>

class ClientPacketProcessor : public QObject
{
    Q_OBJECT

private:
    void manageReplyError(const QVariantList & errorData);
    void manageRegistrationReply(const QVariantList & replyData);
    void manageLoggingReply(const QVariantList & replyData);
    void manageProfileRequestReply(const QVariantList & replyData);

public:
    explicit ClientPacketProcessor(QObject * parent = nullptr);
    ~ClientPacketProcessor() {}

public slots:
    void processPacket(const Packet & packet);

signals:
    void requestError(const QString & errorMessage);
    void registrationReply(bool replyState, const QString & message);
    void loggingReply(bool nicknameState, bool passwordState, const QString & message);
    void profileDownloadRedply(const QString & description);
};

#endif // CLIENTPACKETPROCESSOR_H
