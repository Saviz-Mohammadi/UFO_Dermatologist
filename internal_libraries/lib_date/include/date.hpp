#ifndef DATE_H
#define DATE_H

#include <QObject>
#include <QQmlEngine>
#include <QVariant>
#include <QVariantList>
#include <QDateTime>
#include <QTextStream>

// NOTE (SAVIZ): The combination of 'QVariantMap' and 'QVariantList' enbales us to replicate any type of data structure and exposed it easilly to QML. For this reason I don't use any intermidiate objects or strcuts for data transfer.

class Date : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY_MOVE(Date) // Needed for Singleton

public:
    explicit Date(QObject *parent = Q_NULLPTR, const QString& name = "No name");
    ~Date();

    static Date *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);
    static Date *cppInstance(QObject *parent = Q_NULLPTR);

private:
    static Date *m_Instance;

    // PUBLIC Methods
public:
    QCalendar::YearMonthDay gregorianToJalali(QCalendar::YearMonthDay gregorianDate);
    QCalendar::YearMonthDay jalaliToGregorian(QCalendar::YearMonthDay jalaliDate);
    Q_INVOKABLE QString calculateJalaliAge(quint32 birthYear);
    Q_INVOKABLE QString differenceToDateJalali(int year, int month, int day);
};

#endif // DATE_H
