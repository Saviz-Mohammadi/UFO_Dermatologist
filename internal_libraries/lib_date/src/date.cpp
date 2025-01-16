#include "date.hpp"

#ifdef QT_DEBUG
    #include "logger.hpp"
#endif


Date *Date::m_Instance = Q_NULLPTR;

// Constructors, Initializers, Destructor
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

Date::Date(QObject *parent, const QString &name)
    : QObject{parent}
{
    this->setObjectName(name);



#ifdef QT_DEBUG
    QString message("Call to Constructor\n");

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif
}

Date::~Date()
{
#ifdef QT_DEBUG
    QString message("Call to Destructor");

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    // Shutdown.
    this->disconnect();
}

Date *Date::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);

    if (!m_Instance)
    {
        m_Instance = new Date();
    }

    return (m_Instance);
}

Date *Date::cppInstance(QObject *parent)
{
    if (m_Instance)
    {
        return (qobject_cast<Date *>(Date::m_Instance));
    }

    auto instance = new Date(parent);
    m_Instance = instance;
    return (instance);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PUBLIC Methods
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

QCalendar::YearMonthDay Date::gregorianToJalali(QCalendar::YearMonthDay gregorianYMD)
{
    QCalendar calendarGregorian(QCalendar::System::Gregorian);
    QCalendar calendarJalali(QCalendar::System::Jalali);

    QDate gregorianDate(gregorianYMD.year, gregorianYMD.month, gregorianYMD.day);

    QCalendar::YearMonthDay ymd = calendarJalali.partsFromDate(gregorianDate);

    return (ymd);
}

QCalendar::YearMonthDay Date::jalaliToGregorian(QCalendar::YearMonthDay jalaliYMD)
{
    QCalendar calendarJalali(QCalendar::System::Jalali);
    QCalendar calendarGregorian(QCalendar::System::Gregorian);

    QDate gregorianDate = calendarJalali.dateFromParts(jalaliYMD.year, jalaliYMD.month, jalaliYMD.day);

    QCalendar::YearMonthDay ymd = calendarGregorian.partsFromDate(gregorianDate);

    return (ymd);
}

QString Date::calculateJalaliAge(quint32 birthYear)
{
    QCalendar::YearMonthDay gregorianYMD(QDate::currentDate().year(), QDate::currentDate().month(), QDate::currentDate().day());
    QCalendar::YearMonthDay newJalili = gregorianToJalali(gregorianYMD);

    QString result = QString::number(newJalili.year - birthYear);

    return (result);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]
