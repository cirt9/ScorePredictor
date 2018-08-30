#include "imageprovider.h"

ImageProvider::ImageProvider() : QObject(nullptr), QQuickImageProvider(QQuickImageProvider::Image)
{

}

QImage ImageProvider::requestImage(const QString & id, QSize * size, const QSize & requestedSize)
{
    Q_UNUSED(id)
    QImage image;

    if(!imageData.isEmpty() && !imageData.isNull())
    {
        image.loadFromData(imageData);
        imageData.clear();
        *size = image.size();

        if(requestedSize.isValid())
            image = image.scaled(requestedSize, Qt::KeepAspectRatio);
    }

    return image;
}

void ImageProvider::setImageData(const QByteArray & data)
{
    imageData = data;
}
