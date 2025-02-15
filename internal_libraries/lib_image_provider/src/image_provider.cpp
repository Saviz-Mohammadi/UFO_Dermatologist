#ifdef QT_DEBUG
    #include <QDebug>
#endif

#include "image_provider.hpp"

ImageProvider *ImageProvider::m_Instance = Q_NULLPTR;

// Constructors, Init, ShutDown, Destructor
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

ImageProvider::ImageProvider(QObject *parent, const QString &name)
    : QObject {parent}
{
    this->setObjectName(name);

#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
    qDebug() << "Log Output :" << "None";
#endif
}

ImageProvider::~ImageProvider()
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
    qDebug() << "Log Output :" << "None";
#endif
}

ImageProvider *ImageProvider::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);

    if (!m_Instance)
    {
        m_Instance = new ImageProvider();
    }

    return (m_Instance);
}

ImageProvider *ImageProvider::cppInstance(QObject *parent)
{
    if (m_Instance)
    {
        return (qobject_cast<ImageProvider *>(ImageProvider::m_Instance));
    }

    auto instance = new ImageProvider(parent);
    m_Instance = instance;

    return (instance);
}

// NOTE (SAVIZ): Not needed. However, provided just in case.
void ImageProvider::Init()
{
    // Init resources;
}

// NOTE (SAVIZ): In Qt, this isn't necessary due to its parent-child memory management system. However, in standard C++, it's a good practice to either explicitly call this when we're done with the object or ensure it gets invoked within the destructor.
void ImageProvider::ShutDown()
{
    delete (m_Instance);

    m_Instance = Q_NULLPTR;
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PUBLIC Methods
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

QImage ImageProvider::imageFromPath(const QString &path)
{
    return loadFromPath(path);
}

QImage ImageProvider::imageFromUrl(const QUrl &url)
{
    return loadFromPath(url.toLocalFile());
}

QByteArray ImageProvider::dataFromPath(const QString &path)
{
    QFile file(path);

    if (!file.open(QIODevice::ReadOnly))
    {
#ifdef QT_DEBUG
        qDebug() << "Failed to read image file data: " << path;
#endif

        return (QByteArray());
    }

    return (file.readAll());
}

QByteArray ImageProvider::dataFromUrl(const QUrl &url)
{
    return dataFromPath(url.toLocalFile());
}

QImage ImageProvider::imageFromData(const QByteArray &data)
{
    QImage image;

    if (!image.loadFromData(data))
    {
#ifdef QT_DEBUG
        qDebug() << "Failed to load image from QByteArray";
#endif

        return (QImage());
    }

    return (image);
}

QUrl ImageProvider::urlFromData(const QByteArray &data)
{
    QImage image;

    QDir dir("./cache/images");
    QString filePath = dir.absolutePath() + "temp_" + QDateTime::currentDateTime().toString("yyyyMMdd_HHmmss") + ".png";

    if (!image.loadFromData(data)) {
        qDebug() << "Failed to load";
        return QUrl();  // Failed to load image from QByteArray
    }

    // NOTE (SAVIZ): nullptr forces the QImage to decide for itself what the best format for the image file will be.
    if (!image.save(filePath, nullptr)) {
        qDebug() << "Failed to save to path: " << filePath;
        return QUrl();
    }

    return QUrl::fromLocalFile(filePath);  // Convert file path to QUrl
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PRIVATE Methods
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

QImage ImageProvider::loadFromPath(const QString &path)
{
    QImageReader reader(path);

    QImage image;

    if (!reader.read(&image))
    {
#ifdef QT_DEBUG
        qDebug() << "Failed to load image from path: " << path;
#endif

        return (QImage());
    }

    return (image);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]
