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
    Q_PROPERTY(bool connectionStatus READ getConnectionStatus NOTIFY connectionStatusChanged FINAL)

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
    //SmtpClient m_Smtp;

    // Signals
signals:
    void connectionStatusChanged(const QString &message);
    void emailSent(bool status, const QString &message);

    // PUBLIC Slots:
public slots:

    // PRIVATE Slots:
private slots:

    // PUBLIC Methods
public:
    Q_INVOKABLE bool establishConnection(const QString &email, const QString &password);
    Q_INVOKABLE bool disconnectFromEmail();

    // SEARCH
    Q_INVOKABLE bool sendEmail();

    // PRIVATE Methods
private:
    void submitEmail(const QString &recipientAddress, const QString &subject, const QString &body);

    // PUBLIC Getters
public:
    bool getConnectionStatus() const;

    // PRIVATE Getters
public:

    // PUBLIC Setters
public:

    // PRIVATE Setters
private:
};

#endif // NOTIFIER_H
