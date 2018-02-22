#ifndef TCPCONNECTION_H
#define TCPCONNECTION_H

#include <QTcpSocket>
#include <QThreadPool>

#include <QDebug>

class TcpConnection : public QObject
{
    Q_OBJECT

private:
    QTcpSocket * socket;

public:
    explicit TcpConnection(QObject * parent = nullptr);
    ~TcpConnection() {}

    void setSocket(qintptr descriptor);

public slots:
    void connected();
    void disconnected();
    void read();
};

#endif // TCPCONNECTION_H
