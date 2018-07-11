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
        case Packet::ID_DOWNLOAD_USER_INFO: manageUserInfoRequest(data); break;
        case Packet::ID_CREATE_TOURNAMENT: manageTournamentCreationRequest(data); break;
        case Packet::ID_PULL_TOURNAMENTS: managePullingTournamentsRequest(data); break;

        default: break;
        }
    }

    void PacketProcessor::registerUser(const QVariantList & userData)
    {
        Query query(dbConnection->getConnection());
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
        Query query(dbConnection->getConnection());
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

    void PacketProcessor::manageUserInfoRequest(const QVariantList & userData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.getUserInfo(userData[0].toString()))
        {
            responseData << Packet::ID_DOWNLOAD_USER_INFO << query.value("description");

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

    void PacketProcessor::manageTournamentCreationRequest(QVariantList & tournamentData)
    {
        Tournament tournament(tournamentData[0].value<QVariantList>());
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(tournament.getHostName()))
        {
            unsigned int hostId = query.value("id").toUInt();
            qDebug() << "Host ID: " << hostId;

            if(!query.tournamentExists(tournament.getName(), hostId))
            {
                if(query.createTournament(tournament, hostId, tournamentData[1].toString()))
                {
                    qDebug() << "New tournament created";
                    responseData << Packet::ID_CREATE_TOURNAMENT << true
                                 << QString("Tournament created successfully");
                }
                else
                {
                    qDebug() << "Tournament couldn't be created";
                    responseData << Packet::ID_CREATE_TOURNAMENT << false
                                 << QString("Tournament couldn't be created, try again later");
                }
            }
            else
            {
                qDebug() << "User already created tournament with the same name";
                responseData << Packet::ID_CREATE_TOURNAMENT << false <<
                                QString("You can't create two tournaments with the same name!");
            }
        }
        else
            responseData << Packet::ID_ERROR << QString("User does not exist");

        emit response(responseData);
    }

    void PacketProcessor::managePullingTournamentsRequest(const QVariantList & requestData)
    {
        Query query(dbConnection->getConnection());
        QVariantList responseData;

        if(query.findUserId(requestData[0].toString()))
        {
            responseData << Packet::ID_PULL_TOURNAMENTS;
            QDateTime startFromTime;

            if(requestData.size() == 4)
            {
                qDebug() << "Pulling another found tournaments pages";
                startFromTime = requestData[3].toDateTime();
            }
            else
            {
                qDebug() << "Pulling found tournaments pages";
                startFromTime = QDateTime::currentDateTime();
            }

            query.findTournaments(query.value("id").toUInt(), startFromTime, requestData[1].toInt(),
                                  requestData[2].toString());

            while(query.next())
            {
                QVariantList tournamentData;
                tournamentData << query.value("name") << query.value("host_name")
                               << query.value("password_required") << query.value("entries_end_time")
                               << query.value("typers") << query.value("typers_limit");
                responseData << QVariant::fromValue(tournamentData);
            }
        }
        else
            responseData << Packet::ID_ERROR << QString("User does not exist");

        emit response(responseData);
    }
}
