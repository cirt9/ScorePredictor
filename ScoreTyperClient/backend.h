#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>

class BackEnd : public QObject
{
    Q_OBJECT
public:
    explicit BackEnd(QObject * parent = nullptr);

    Q_INVOKABLE bool login(const QString & login, const QString & password);
};

#endif // BACKEND_H
