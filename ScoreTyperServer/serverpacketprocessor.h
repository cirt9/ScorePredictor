#ifndef SERVERPACKETPROCESSOR_H
#define SERVERPACKETPROCESSOR_H

#include <packet.h>
#include <dbconnection.h>
#include <query.h>
#include <QSharedPointer>

class ServerPacketProcessor: public QObject
{
    Q_OBJECT

private:
    QSharedPointer<DbConnection> dbConnection;

    void registerUser(const QVariantList & userData);
    void loginUser(const QVariantList & userData);

public:
    explicit ServerPacketProcessor(QSharedPointer<DbConnection> connection, QObject * parent = nullptr);
    ~ServerPacketProcessor() {}

public slots:
    void processPacket(const Packet & packet);

signals:
    void response(const QVariantList & data);
};

#endif // SERVERPACKETPROCESSOR_H
