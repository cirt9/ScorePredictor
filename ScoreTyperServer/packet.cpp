#include "packet.h"

const QVariant Packet::START_OF_PACKET = QString("<SoP>");
const QVariant Packet::END_OF_PACKET = QString("</EoP>");
const QVariant Packet::PACKET_ID_MIN = 0;
const QVariant Packet::PACKET_ID_MAX = 0;
const QVariant Packet::PACKET_ID_LOGIN = 0;

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
    if(corrupted)
    {
        qDebug() << "No data to serialize";
        clean();
        return;
    }

    if(data[0] < PACKET_ID_MIN || data[0] > PACKET_ID_MAX)
    {
        qDebug() << "Wrong packet id";
        corrupted = true;
        clean();
        return;
    }

    QDataStream out(&serializedData, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_5_10);

    out << quint16(0);
    out << START_OF_PACKET;

    for(auto dataElement : data)
        out << dataElement;

    out << END_OF_PACKET;

    out.device()->seek(0);
    out << quint16(serializedData.size() - sizeof(quint16));
    qDebug() << "Packet serialized";
}

void Packet::unserialize(QDataStream & in)
{
    QVariant sof;
    in >> sof;

    if(sof != START_OF_PACKET)
    {
        qDebug() << "Packet corrupted. Start of packet marker missing.";
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
            qDebug() << "End of packet reached";
            endOfPacketFound = true;
            break;
        }
        else
            data << var;
    }

    if(!endOfPacketFound)
    {
        qDebug() << "End of packet not found";
        corrupted = true;
        clean();
        return;
    }

    qDebug() << "Packet data: ";
    for(auto dataElement : data)
        qDebug() << dataElement;
}

void Packet::setSerializedData(const QVariantList &packetData)
{
    corrupted = false;
    data = packetData;
    serialize();
}

void Packet::setUnserializedData(QDataStream & in)
{
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
