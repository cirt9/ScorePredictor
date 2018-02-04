#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQMLContext>
#include "backend.h"

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QScopedPointer<BackEnd> backend(new BackEnd);
    engine.rootContext()->setContextProperty("backend", backend.data());

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
