#ifdef QT_DEBUG
    #include <QDebug>
#endif

#include "database.hpp"
#include "notifier.hpp"

// NOTE (SAVIZ): I don't know why, but for whatever reason I cannot access these files in 'hpp' files. Therefore, I have to change my method of coding.
#include "cpp/opportunisticsecuresmtpclient.hpp"
#include "cpp/plaintextmessage.hpp"

template<typename T>
class ClientWrapper {
public:
    ClientWrapper(T client,
                  jed_utils::cpp::Credential&& credentials) : mClient{std::move(client)} {
        mClient.setCredentials(credentials);
    }

    auto client() -> T& { return mClient; }

private:
    jed_utils::cpp::OpportunisticSecureSMTPClient mClient;
};

auto buildClient(const QString &username, const QString &password) -> jed_utils::cpp::OpportunisticSecureSMTPClient& {

    // WARNING (SAVIZ): The instance must be created as 'static' and live through the application life time. Otherwise, we will get a crash.
    static ClientWrapper clientWrapper {
        jed_utils::cpp::OpportunisticSecureSMTPClient{"smtp.gmail.com", 587},
        jed_utils::cpp::Credential(username.toStdString(), password.toStdString())
    };

    return clientWrapper.client();
}

Notifier *Notifier::m_Instance = Q_NULLPTR;

// Constructors, Init, ShutDown, Destructor
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

Notifier::Notifier(QObject *parent, const QString &name)
    : QObject{parent}
{
    this->setObjectName(name);

#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
#endif
}

Notifier::~Notifier()
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
    qDebug() << "Log Output :" << "None";
#endif
}

Notifier *Notifier::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);

    if (!m_Instance)
    {
        m_Instance = new Notifier();
    }

    return (m_Instance);
}

Notifier *Notifier::cppInstance(QObject *parent)
{
    if (m_Instance)
    {
        return (qobject_cast<Notifier *>(Notifier::m_Instance));
    }

    auto instance = new Notifier(parent);
    m_Instance = instance;

    return (instance);
}

// NOTE (SAVIZ): Not needed. However, provided just in case.
void Notifier::Init()
{
    // Init resources;
}

// NOTE (SAVIZ): In Qt, this isn't necessary due to its parent-child memory management system. However, in standard C++, it's a good practice to either explicitly call this when we're done with the object or ensure it gets invoked within the destructor.
void Notifier::ShutDown()
{
    delete (m_Instance);

    m_Instance = Q_NULLPTR;
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PUBLIC Methods
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

//client.setCredentials(Credential("savizdummymohammadidummy@gmail.com", "iilvalwxpwgggmuk"));

bool Notifier::sendEmail(int daysBefore, const QString &username, const QString &password)
{
    // NOTE (SAVIZ): In this context, username is the same as sender email address.
    // NOTE (SAVIZ): In this context, password is the same as app password.
    auto &client = buildClient(username, password);

    jed_utils::cpp::MessageAddress sender = jed_utils::cpp::MessageAddress(username.toStdString(), "Doctor Name");

    QList<QVariantMap> patients = Database::cppInstance()->getUpcomingVisits(daysBefore);

    for (const QVariantMap &patient : patients)
    {
        QString recipientEmail = patient["email"].toString();
        int daysLeft = patient["days_left"].toInt();
        QString expected_visit_date = patient["expected_visit_date"].toString();
        QString subject = "Upcoming Visit Reminder";

        // Correct grammar: "1 day" vs. "X days"
        QString daysText = (daysLeft == 1) ? "day" : "days";

        QString message = QString("Your next visit is scheduled in %1 %2, on %3. Please ensure you arrive on time for your appointment.")
                              .arg(daysLeft)
                              .arg(daysText)
                              .arg(expected_visit_date);

        jed_utils::cpp::MessageAddress recipient = jed_utils::cpp::MessageAddress(recipientEmail.toStdString(), "Recipient Name");

        jed_utils::cpp::PlaintextMessage email(sender, { recipient }, subject.toStdString(), message.toStdString());

        int err_no = client.sendMail(email);

        if (err_no != 0)
        {
#ifdef QT_DEBUG
            std::string errorMessage = client.getErrorMessage(err_no);
            qDebug() << "An error occurred: " << QString::fromStdString(errorMessage) << " (error no: " << err_no << ")";
            qDebug() << QString::fromStdString(client.getCommunicationLog()) << '\n';
#endif
        }

#ifdef QT_DEBUG
        qDebug() << client.getCommunicationLog() << '\n';
#endif
    }

    // Notify QML:
    emit emailSent(true, "پیام‌ها با موفقیت برای بیماران ارسال شدند.");

    return (true);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]
