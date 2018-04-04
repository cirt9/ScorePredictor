#ifndef TCPCLIENTWRAPPER_H
#define TCPCLIENTWRAPPER_H

#include <tcpclient.h>
#include <QHostAddress>

class TcpClientWrapper : public QObject
{
    Q_OBJECT

private:
    TcpClient * client;

public:
    explicit TcpClientWrapper(QObject * parent = nullptr);
    ~TcpClientWrapper();

    void connectToServer(const QHostAddress & address, quint16 port);
    TcpClient * getClient() const;

signals:
    void connectingToServer(const QHostAddress & address, quint16 port);
    void connected();
    void serverClosed();
    void serverNotFound();
    void connectionRefused();
    void networkError();
    void unidentifiedError();
    void sendData(const QVariantList & data);
};

#endif // TCPCLIENTWRAPPER_H
