#include "filestream.h"

FileStream::FileStream(QObject * parent) : QObject(parent)
{

}

QString FileStream::read()
{
    if(source.isEmpty())
    {
        emit readingError("The source string is empty.");
        return QString();
    }

    QFile file(source);

    if(!file.open(QIODevice::ReadOnly))
    {
        emit readingError("The file can't be opened or doesn't exist.");
        return QString();
    }

    QTextStream fileStream(&file);
    fileStream.setCodec("UTF-8");

    QString fileContent = fileStream.readAll();

    file.close();

    emit readingSuccess();
    return fileContent;
}

bool FileStream::write(const QString & data)
{
    if(source.isEmpty())
    {
        emit writingError("The source string is empty.");
        return false;
    }

    QFile file(source);

    if(!file.open(QIODevice::WriteOnly))
    {
        emit readingError("The file can't be opened or doesn't exist.");
        return false;
    }

    QTextStream fileStream(&file);
    fileStream.setCodec("UTF-8");

    fileStream << data;

    file.close();

    emit writingSuccess();
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
