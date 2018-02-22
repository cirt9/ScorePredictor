#include <QGuiApplication>
#include <QQmlApplicationEngine>
//
#include <tcpserver.h>
//

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    //

    TcpServer server;
    server.startServer(QHostAddress::Any, 5000);

    //

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
