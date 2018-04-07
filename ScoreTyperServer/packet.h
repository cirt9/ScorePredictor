#ifndef PACKET_H
#define PACKET_H

#include <QByteArray>
#include <QVariantList>
#include <QDataStream>

#include <QDebug>

class Packet
{
private:
    QVariantList data;
    QByteArray serializedData;
    bool corrupted;
    QString error;

    static const QVariant START_OF_PACKET;
    static const QVariant END_OF_PACKET;
    static const QVariant PACKET_ID_MIN;
    static const QVariant PACKET_ID_MAX;

    void serialize();
    void unserialize(QDataStream & in);
    void clean();
    void validatePacket();

public:
    Packet(const QVariantList & packetData);
    Packet(QDataStream & in);
    ~Packet() {}

    void setSerializedData(const QVariantList & packetData);
    void setUnserializedData(QDataStream & in);

    QVariantList getUnserializedData() const;
    QByteArray getSerializedData() const;

    bool isCorrupted() const;
    QString lastError() const;

    static const QVariant PACKET_ID_REGISTER;
};

#endif // PACKET_H
