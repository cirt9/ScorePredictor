#include "filestream.h"

FileStream::FileStream(QObject * parent) : QObject(parent)
{

}

QString FileStream::read()
{
    if(source.isEmpty())
        return QString();

    QFile file(source);

    if(!file.open(QIODevice::ReadOnly))
        return QString();

    QTextStream fileStream(&file);
    fileStream.setCodec("UTF-8");

    QString fileContent = fileStream.readAll();

    file.close();
    return fileContent;
}

bool FileStream::write(const QString & data)
{
    if(source.isEmpty())
        return false;

    QFile file(source);

    if(!file.open(QIODevice::WriteOnly))
        return false;

    QTextStream fileStream(&file);
    fileStream.setCodec("UTF-8");

    fileStream << data;

    file.close();

    return true;
}

QString FileStream::getSource() const
{
    return source;
}

void FileStream::setSource(const QString & value)
{
    source = value;
    emit sourceChanged();
}
