#ifndef IMAGEPROVIDER_H
#define IMAGEPROVIDER_H

#include <QObject>
#include <QQmlEngine>
#include <QVariant>
#include <QVariantList>
#include <QFile>
#include <QBuffer>
#include <QImageReader>

class ImageProvider : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY_MOVE(ImageProvider) // Needed for Singleton

    // Q_PROPERTY

public:
    explicit ImageProvider(QObject *parent = Q_NULLPTR, const QString& name = "No name");
    ~ImageProvider();

    static ImageProvider *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);
    static ImageProvider *cppInstance(QObject *parent = Q_NULLPTR);

    static void Init();
    static void ShutDown();

    // PUBLIC Enums
public:

    // Fields
private:
    static ImageProvider *m_Instance;

    // Signals
signals:

    // PUBLIC Slots:
public slots:

    // PRIVATE Slots:
private slots:

    // PUBLIC Methods
public:
    Q_INVOKABLE QImage imageFromPath(const QString &path);
    Q_INVOKABLE QImage imageFromUrl(const QUrl &url);
    Q_INVOKABLE QByteArray dataFromPath(const QString &path);
    Q_INVOKABLE QByteArray dataFromUrl(const QUrl &url);
    Q_INVOKABLE QImage imageFromData(const QByteArray &data);
    Q_INVOKABLE QUrl urlFromData(const QByteArray &data);

    // PRIVATE Methods
private:
    QImage loadFromPath(const QString &path);

    // PUBLIC Getters
public:

    // PRIVATE Getters
public:

    // PUBLIC Setters
public:

    // PRIVATE Setters
private:
};

#endif // IMAGEPROVIDER_H
