#ifndef TCPCONNECTION_H
#define TCPCONNECTION_H

#include <QTcpSocket>
#include <packet.h>

#include <QDebug>

class TcpConnection : public QObject
{
    Q_OBJECT

private:
    QTcpSocket * socket;
    quint16 nextPacketSize;

    void flushSocket();

private slots:
    void read();
    void stateChanged(QAbstractSocket::SocketState state);
    void error(QAbstractSocket::SocketError error);
    void connected();
    void disconnected();

public:
    explicit TcpConnection(QObject * parent = nullptr);
    ~TcpConnection() {}

public slots:
    void accept(qintptr descriptor);
    void quit();
    void send(const QVariantList & data);

signals:
    void started();
    void finished();
    void packetArrived(const Packet & packet);
};

#endif // TCPCONNECTION_H
