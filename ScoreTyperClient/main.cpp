#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQMLContext>
#include <backend.h>
#include <filestream.h>

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qRegisterMetaType<QHostAddress>("QHostAddress");
    qRegisterMetaType<Packet>("Packet");
    qmlRegisterType<Tournament>("DataStorage", 1, 0, "Tournament");
    qmlRegisterType<Match>("DataStorage", 1, 0, "Match");
    qmlRegisterType<FileStream>("FileStream", 1, 0, "FileStream");

    QScopedPointer<BackEnd> backend(new BackEnd);
    engine.rootContext()->setContextProperty("backend", backend.data());
    engine.rootContext()->setContextProperty("serverConnection", backend->getClientWrapper());
    engine.rootContext()->setContextProperty("packetProcessor", backend->getPacketProcessorWrapper());
    engine.rootContext()->setContextProperty("currentUser", backend->getCurrentUser());
    engine.rootContext()->setContextProperty("currentTournament", backend->getCurrentTournament());
    engine.addImageProvider("images", backend->getImageProvider());

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

Q_DECLARE_METATYPE(QVariantList)
