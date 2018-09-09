#ifndef TCPCLIENT_H
#define TCPCLIENT_H

#include <QTcpSocket>
#include <../ScorePredictorServer/packet.h>

class TcpClient : public QObject
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
    explicit TcpClient(QObject * parent = nullptr);
    ~TcpClient() {}

public slots:
    bool connectToServer(const QHostAddress & address, quint16 port);
    void disconnectFromServer();
    void send(const QVariantList & data);

signals:
    void started();
    void finished();
    void remoteHostClosed();
    void hostNotFound();
    void connectionRefused();
    void networkError();
    void socketTimeoutError();
    void unidentifiedError();
    void packetArrived(const Packet & packet);
};

#endif // TCPCLIENT_H
