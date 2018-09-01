#ifndef IMAGEPROVIDER_H
#define IMAGEPROVIDER_H

#include <QObject>
#include <QQuickImageProvider>

class ImageProvider : public QObject, public QQuickImageProvider
{
    Q_OBJECT

private:
    QByteArray imageData;

public:
    explicit ImageProvider();
    ~ImageProvider() {}

    QImage requestImage(const QString & id, QSize * size, const QSize & requestedSize) override;

public slots:
    void setImageData(const QByteArray & data);
};

#endif // IMAGEPROVIDER_H
