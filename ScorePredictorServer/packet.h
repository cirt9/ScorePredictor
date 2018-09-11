#ifndef PACKET_H
#define PACKET_H

#include <QByteArray>
#include <QVariantList>
#include <QDataStream>

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
    static const int PACKET_ID_MAX = 35;

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
    static const int ID_DOWNLOAD_STARTING_MESSAGE = 1;
    static const int ID_REGISTER = 2;
    static const int ID_LOGIN = 3;
    static const int ID_DOWNLOAD_USER_PROFILE_INFO = 4;
    static const int ID_PULL_FINISHED_TOURNAMENTS = 5;
    static const int ID_PULL_ONGOING_TOURNAMENTS = 6;
    static const int ID_UPDATE_USER_PROFILE_DESCRIPTION = 7;
    static const int ID_UPDATE_USER_PROFILE_DESCRIPTION_ERROR = 8;
    static const int ID_UPDATE_USER_PROFILE_AVATAR = 9;
    static const int ID_UPDATE_USER_PROFILE_AVATAR_ERROR = 10;
    static const int ID_CREATE_TOURNAMENT = 11;
    static const int ID_PULL_TOURNAMENTS = 12;
    static const int ID_JOIN_TOURNAMENT = 13;
    static const int ID_JOIN_TOURNAMENT_PASSWORD = 14;
    static const int ID_DOWNLOAD_TOURNAMENT_INFO = 15;
    static const int ID_FINISH_TOURNAMENT = 16;
    static const int ID_ADD_NEW_ROUND = 17;
    static const int ID_DOWNLOAD_TOURNAMENT_LEADERBOARD = 18;
    static const int ID_DOWNLOAD_ROUND_LEADERBOARD = 19;
    static const int ID_PULL_MATCHES = 20;
    static const int ID_ZERO_MATCHES_TO_PULL = 21;
    static const int ID_ALL_MATCHES_PULLED = 22;
    static const int ID_CREATE_MATCH = 23;
    static const int ID_DELETE_MATCH = 24;
    static const int ID_MATCH_DELETED = 25;
    static const int ID_MATCH_DELETING_ERROR = 26;
    static const int ID_UPDATE_MATCH_SCORE = 27;
    static const int ID_MATCH_SCORE_UPDATED = 28;
    static const int ID_MATCH_SCORE_UPDATE_ERROR = 29;
    static const int ID_PULL_MATCHES_PREDICTIONS = 30;
    static const int ID_ALL_MATCHES_PREDICTIONS_PULLED = 31;
    static const int ID_MAKE_PREDICTION = 32;
    static const int ID_MAKE_PREDICTION_ERROR = 33;
    static const int ID_UPDATE_PREDICTION = 34;
    static const int ID_UPDATE_PREDICTION_ERROR = 35;
};

#endif // PACKET_H
