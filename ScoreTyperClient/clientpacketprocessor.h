#ifndef CLIENTPACKETPROCESSOR_H
#define CLIENTPACKETPROCESSOR_H

#include <../ScoreTyperServer/packet.h>

#include <QDebug>

class ClientPacketProcessor : public QObject
{
    Q_OBJECT

private:
    void manageRegistrationReply(const QVariantList & userData);

public:
    explicit ClientPacketProcessor(QObject * parent = nullptr);
    ~ClientPacketProcessor() {}

public slots:
    void processPacket(const Packet & packet);

signals:
    void registrationReply(bool reply, const QString & message);
};

#endif // CLIENTPACKETPROCESSOR_H
