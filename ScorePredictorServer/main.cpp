#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQMLContext>
//
#include <tcpserver.h>
//

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //

    QScopedPointer<TcpServer> server(new TcpServer);
    engine.rootContext()->setContextProperty("server", server.data());

    //

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

Q_DECLARE_METATYPE(QVariantList)
