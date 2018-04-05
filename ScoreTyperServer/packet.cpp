#include "packet.h"

const QVariant Packet::START_OF_PACKET = QString("<SoP>");
const QVariant Packet::END_OF_PACKET = QString("</EoP>");
const QVariant Packet::PACKET_ID_MIN = 0;
const QVariant Packet::PACKET_ID_MAX = 0;
const QVariant Packet::PACKET_ID_REGISTER = 0;

Packet::Packet(const QVariantList & packetData)
{
    corrupted = false;
    data = packetData;
    serialize();
}

Packet::Packet(QDataStream & in)
{
    corrupted = false;
    unserialize(in);
    serialize();
}

void Packet::serialize()
{
    validatePacket();

    QDataStream out(&serializedData, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_5_10);
    out << quint16(0);
    out << START_OF_PACKET;

    for(auto dataElement : data)
    {
        if(dataElement == START_OF_PACKET || dataElement == END_OF_PACKET)
        {
            error = "Too much start/end markers.";
            corrupted = true;
            clean();
            return;
        }
        out << dataElement;
    }

    out << END_OF_PACKET;
    out.device()->seek(0);
    out << quint16(serializedData.size() - sizeof(quint16));
}

void Packet::unserialize(QDataStream & in)
{
    QVariant sop;
    in >> sop;

    if(sop != START_OF_PACKET)
    {
        error = "Start of packet marker not found.";
        corrupted = true;
        clean();
        return;
    }
    bool endOfPacketFound = false;

    while(!in.atEnd())
    {
        QVariant var;
        in >> var;

        if(var == END_OF_PACKET)
        {
            endOfPacketFound = true;
            break;
        }
        else
            data << var;
    }

    if(!endOfPacketFound)
    {
        error = "End of packet marker not found.";
        corrupted = true;
        clean();
        return;
    }

    qDebug() << "Packet data: ";
    for(auto dataElement : data)
        qDebug() << dataElement;
}

void Packet::validatePacket()
{
    if(corrupted)
        return;

    else if(data.count() == 0)
    {
        error = "No data.";
        corrupted = true;
        clean();
    }

    else if(data[0] < PACKET_ID_MIN || data[0] > PACKET_ID_MAX)
    {
        error = "Wrong packet id.";
        corrupted = true;
        clean();
    }
}

void Packet::setSerializedData(const QVariantList & packetData)
{
    clean();
    error.clear();
    corrupted = false;
    data = packetData;
    serialize();
}

void Packet::setUnserializedData(QDataStream & in)
{
    clean();
    error.clear();
    corrupted = false;
    unserialize(in);
    serialize();
}

void Packet::clean()
{
    data.clear();
    serializedData = QByteArray();
}

QVariantList Packet::getUnserializedData() const
{
    return data;
}

QByteArray Packet::getSerializedData() const
{
    return serializedData;
}

bool Packet::isCorrupted() const
{
    return corrupted;
}

QString Packet::lastError() const
{
    return error;
}
