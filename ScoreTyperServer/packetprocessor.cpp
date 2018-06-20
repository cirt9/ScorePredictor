#include "packetprocessor.h"


namespace Server
{
    PacketProcessor::PacketProcessor(QSharedPointer<DbConnection> connection, QObject * parent) : QObject(parent)
    {
        dbConnection = connection;
    }

    void PacketProcessor::processPacket(const Packet & packet)
    {
        if(!dbConnection->isConnected())
            return;

        QVariantList data = packet.getUnserializedData();
        int packetId = data[0].toInt();
        data.removeFirst();

        switch(packetId)
        {
        case Packet::ID_REGISTER: registerUser(data); break;
        case Packet::ID_LOGIN: loginUser(data); break;
        case Packet::ID_DOWNLOAD_USER_PROFILE: userProfileRequest(data); break;
        case Packet::ID_CREATE_TOURNAMENT: tournamentCreationRequest(data); break;

        default: break;
        }
    }

    void PacketProcessor::registerUser(const QVariantList & userData)
    {
        Query query(dbConnection);
        QVariantList responseData;
        responseData << Packet::ID_REGISTER;

        if(query.isUserRegistered(userData[0].toString()))
        {
            qDebug() << "User is registered";
            responseData << false << QString("This nickname is already occupied");
        }
        else
        {
            qDebug() << "User is not registered";
            if(query.registerUser(userData[0].toString(), userData[1].toString()))
            {
                qDebug() << "User registered";
                responseData << true << QString("Your account has been successfully created");
            }
            else
            {
                qDebug() << "User not registered";
                responseData << false << QString("A problem occured. Account could not be created");
            }
        }
        emit response(responseData);
    }

    void PacketProcessor::loginUser(const QVariantList & userData)
    {
        Query query(dbConnection);
        QVariantList responseData;
        responseData << Packet::ID_LOGIN;

        if(query.isUserRegistered(userData[0].toString()))
        {
            qDebug() << "User exists";
            responseData << true;

            if(query.isPasswordCorrect(userData[0].toString(), userData[1].toString()))
            {
                qDebug() << "Password is correct";
                responseData << true << userData[0].toString();
            }
            else
            {
                qDebug() << "Invalid password";
                responseData << false << QString("Invalid password");
            }
        }
        else
        {
            qDebug() << "User does not exists";
            responseData << false << false << QString("Invalid nickname");
        }
        emit response(responseData);
    }

    void PacketProcessor::userProfileRequest(const QVariantList & userData)
    {
        Query query(dbConnection);
        QVariantList responseData;

        if(query.getUserProfile(userData[0].toString()))
        {
            responseData << Packet::ID_DOWNLOAD_USER_PROFILE << query.value("description");

            qDebug() << "Description for user: " << userData[0].toString();
            qDebug() << query.value("description");
        }
        else
        {
            qDebug() << "Profile loading error";
            responseData << Packet::ID_ERROR << QString("Couldn't load your profile");
        }
        emit response(responseData);
    }

    void PacketProcessor::tournamentCreationRequest(const QVariantList & tournamentData)
    {
        Tournament tournament(tournamentData);

        qDebug() << tournament.getName()
                 << tournament.getHostName()
                 << tournament.getPassword()
                 << tournament.getEntriesEndTime()
                 << tournament.getTypersLimit();

        Query query(dbConnection);
        QVariantList responseData;

        if(query.isUserRegistered(tournament.getHostName()))
        {
            if(!query.tournamentExists(tournament.getHostName(), tournament.getName()))
            {
                qDebug() << "createTournament";
            }
            else
            {
                qDebug() << "You have already created tournament with the same name";
            }
        }
        else
        {
            qDebug() << "User that wants to create tournament doesn't exist";
            responseData << Packet::ID_ERROR << QString("User does not exist");
        }
        emit response(responseData);
    }
}