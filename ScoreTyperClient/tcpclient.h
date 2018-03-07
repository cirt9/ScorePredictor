#ifndef TCPCLIENT_H
#define TCPCLIENT_H

#include <QTcpSocket>

class TcpClient : public QObject
{
    Q_OBJECT

private:
    QTcpSocket * clientSocket;

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
    Q_INVOKABLE bool connectToServer(const QHostAddress & address, quint16 port);
    Q_INVOKABLE void disconnectFromServer();

signals:
    void started();
    void finished();
};

#endif // TCPCLIENT_H
