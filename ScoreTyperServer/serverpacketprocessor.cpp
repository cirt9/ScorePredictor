#include "serverpacketprocessor.h"

ServerPacketProcessor::ServerPacketProcessor(QSharedPointer<DbConnection> connection, QObject * parent) : QObject(parent)
{
    dbConnection = connection;
}

void ServerPacketProcessor::processPacket(const Packet & packet)
{
    if(!dbConnection->isConnected())
        return;

    QVariantList data = packet.getUnserializedData();
    int packetId = data[0].toInt();
    data.removeFirst();

    switch(packetId)
    {
    case Packet::PACKET_ID_REGISTER: registerUser(data); break;
    case Packet::PACKET_ID_LOGIN: loginUser(data); break;

    default: break;
    }
}

void ServerPacketProcessor::registerUser(const QVariantList & userData)
{
    Query query(dbConnection);
    QVariantList responseData;
    responseData << Packet::PACKET_ID_REGISTER;

    if(query.isUserRegistered(userData[0].toString()))
    {
        qDebug() << "User is registered";
        responseData << QVariant(false) << QVariant(QString("This nickname is already occupied."));
    }
    else
    {
        qDebug() << "User is not registered";
        if(query.registerUser(userData[0].toString(), userData[1].toString()))
        {
            qDebug() << "User registered";
            responseData << QVariant(true) << QVariant(QString("Your account has been successfully created."));
        }
        else
        {
            qDebug() << "User not registered";
            responseData << QVariant(false) << QVariant(QString("A problem occured. Account could not be created."));
        }
    }
    emit response(responseData);
}

void ServerPacketProcessor::loginUser(const QVariantList & userData)
{
    Query query(dbConnection);
    QVariantList responseData;
    responseData << Packet::PACKET_ID_LOGIN;

    if(query.isUserRegistered(userData[0].toString()))
    {
        qDebug() << "User exists";
        if(query.isPasswordCorrect(userData[0].toString(), userData[1].toString()))
        {
            qDebug() << "Password is correct";
            responseData << QVariant(true) << QVariant(userData[0].toString());
        }
        else
        {
            qDebug() << "Invalid password";
            responseData << QVariant(false) << QVariant(QString("Invalid password."));
        }
    }
    else
    {
        qDebug() << "User does not exists";
        responseData << QVariant(false) << QVariant(QString("Invalid nickname."));
    }
    emit response(responseData);
}
