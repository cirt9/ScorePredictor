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
    static const int PACKET_ID_MIN = 0;
    static const int PACKET_ID_MAX = 7;

    void serialize();
    void unserialize(QDataStream & in);
    void clean();
    void validatePacket();

public:
    Packet();
    Packet(const QVariantList & packetData);
    Packet(QDataStream & in);
    ~Packet() {}

    void setSerializedData(const QVariantList & packetData);
    void setUnserializedData(QDataStream & in);

    QVariantList getUnserializedData() const;
    QByteArray getSerializedData() const;

    bool isCorrupted() const;
    QString lastError() const;

    static const int ID_ERROR = 0;
    static const int ID_REGISTER = 1;
    static const int ID_LOGIN = 2;
    static const int ID_DOWNLOAD_USER_INFO = 3;
    static const int ID_PULL_FINISHED_TOURNAMENTS = 4;
    static const int ID_PULL_ONGOING_TOURNAMENTS = 5;
    static const int ID_CREATE_TOURNAMENT = 6;
    static const int ID_PULL_TOURNAMENTS = 7;
};

#endif // PACKET_H
