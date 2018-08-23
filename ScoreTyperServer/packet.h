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
    static const int PACKET_ID_MAX = 32;

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
    static const int ID_DOWNLOAD_USER_PROFILE_INFO = 3;
    static const int ID_PULL_FINISHED_TOURNAMENTS = 4;
    static const int ID_PULL_ONGOING_TOURNAMENTS = 5;
    static const int ID_UPDATE_USER_PROFILE_DESCRIPTION = 6;
    static const int ID_UPDATE_USER_PROFILE_DESCRIPTION_ERROR = 7;
    static const int ID_CREATE_TOURNAMENT = 8;
    static const int ID_PULL_TOURNAMENTS = 9;
    static const int ID_JOIN_TOURNAMENT = 10;
    static const int ID_JOIN_TOURNAMENT_PASSWORD = 11;
    static const int ID_DOWNLOAD_TOURNAMENT_INFO = 12;
    static const int ID_FINISH_TOURNAMENT = 13;
    static const int ID_ADD_NEW_ROUND = 14;
    static const int ID_DOWNLOAD_TOURNAMENT_LEADERBOARD = 15;
    static const int ID_DOWNLOAD_ROUND_LEADERBOARD = 16;
    static const int ID_PULL_MATCHES = 17;
    static const int ID_ZERO_MATCHES_TO_PULL = 18;
    static const int ID_ALL_MATCHES_PULLED = 19;
    static const int ID_CREATE_MATCH = 20;
    static const int ID_DELETE_MATCH = 21;
    static const int ID_MATCH_DELETED = 22;
    static const int ID_MATCH_DELETING_ERROR = 23;
    static const int ID_UPDATE_MATCH_SCORE = 24;
    static const int ID_MATCH_SCORE_UPDATED = 25;
    static const int ID_MATCH_SCORE_UPDATE_ERROR = 26;
    static const int ID_PULL_MATCHES_PREDICTIONS = 27;
    static const int ID_ALL_MATCHES_PREDICTIONS_PULLED = 28;
    static const int ID_MAKE_PREDICTION = 29;
    static const int ID_MAKE_PREDICTION_ERROR = 30;
    static const int ID_UPDATE_PREDICTION = 31;
    static const int ID_UPDATE_PREDICTION_ERROR = 32;
};

#endif // PACKET_H
