#ifndef FILESTREAM_H
#define FILESTREAM_H

#include <QObject>
#include <QFile>
#include <QTextStream>

class FileStream : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString source READ getSource WRITE setSource NOTIFY sourceChanged)

private:
    QString source;

public:
    explicit FileStream(QObject * parent = nullptr);

    Q_INVOKABLE QString read();
    Q_INVOKABLE bool write(const QString & data);

    QString getSource() const;
    void setSource(const QString & value);

signals:
    void sourceChanged();
};

#endif // FILESTREAM_H
