#ifndef NOTIFIER_H
#define NOTIFIER_H

#include <QObject>
#include <QQmlEngine>
#include <QVariant>
#include <QVariantList>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrlQuery>
#include <QTextStream>

class Notifier : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY_MOVE(Notifier) // Needed for Singleton

    // Q_PROPERTY

public:
    explicit Notifier(QObject *parent = Q_NULLPTR, const QString& name = "No name");
    ~Notifier();

    static Notifier *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);
    static Notifier *cppInstance(QObject *parent = Q_NULLPTR);

    static void Init();
    static void ShutDown();

    // PUBLIC Enum

    // Fields
private:
    static Notifier *m_Instance;


    // Signals
signals:
    void emailSent(bool status, const QString &message);

    // PUBLIC Slots:
public slots:

    // PRIVATE Slots:
private slots:

    // PUBLIC Methods
public:
    // SEARCH
    Q_INVOKABLE bool sendEmail(int daysBefore, const QString &username, const QString &password);

    // PRIVATE Methods
private:

    // PUBLIC Getters
public:

    // PRIVATE Getters
public:

    // PUBLIC Setters
public:

    // PRIVATE Setters
private:
};

#endif // NOTIFIER_H
