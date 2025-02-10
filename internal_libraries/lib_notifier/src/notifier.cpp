#ifdef QT_DEBUG
    #include <QDebug>
#endif

#include "database.hpp"
#include "notifier.hpp"

#include "cpp/opportunisticsecuresmtpclient.hpp"
#include "cpp/plaintextmessage.hpp"
#include "cpp/htmlmessage.hpp"
#include <iostream>
#include <stdexcept>

using namespace jed_utils::cpp;

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

bool Notifier::establishConnection(const QString &email, const QString &password)
{
    return true;
}

bool Notifier::disconnectFromEmail() { return true; }

bool Notifier::sendEmail()
{

    // QList<QVariantMap> patients = Database::cppInstance()->getUpcomingVisits();

    // for (const QVariantMap &p : patients) {
    //     QString email = p["email"].toString();
    //     int daysLeft = p["days_left"].toInt();

    //     QString subject = "Upcoming Visit Reminder";
    //     QString body = QString("Your next visit is expected in %1 days. Please confirm your appointment.")
    //                        .arg(daysLeft);

    //     sendEmail(email, subject, body);
    // }

    // return (true);

    submitEmail("", "", "");

    return true;
}

bool Notifier::getConnectionStatus() const {return true;}

void Notifier::submitEmail(const QString &recipientAddress, const QString &subject, const QString &body)
{
    // Here is a full working example: https://github.com/jeremydumais/CPP-SMTPClient-library/blob/master/src/cpp/example/send-mail.cpp

    // These 2 lines are used by the smpt engine to authenticate.
    OpportunisticSecureSMTPClient client("smtp.gmail.com", 587);  // Use 587 for STARTTLS
    client.setCredentials(Credential("savizdummymohammadidummy@gmail.com", "iilvalwxpwgggmuk")); // This is used for SMPT login.

    PlaintextMessage msg(MessageAddress("savizdummymohammadidummy@gmail.com", "Test Address Display"),
                         { MessageAddress("savizdummymohammadidummy@gmail.com", "Another Address display") },
                         "This is a test (Subject)",
                         "Hello\nHow are you?");

    int err_no = client.sendMail(msg);
    if (err_no != 0) {
        std::cerr << client.getCommunicationLog() << '\n';
        std::string errorMessage = client.getErrorMessage(err_no);
        std::stringstream err{};
        err << "An error occurred: " << errorMessage << " (error no: " << err_no << ")";
        throw std::invalid_argument{err.str()};
    }

    std::cout << client.getCommunicationLog() << '\n';
    std::cout << "Operation completed!" << std::endl;
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]
