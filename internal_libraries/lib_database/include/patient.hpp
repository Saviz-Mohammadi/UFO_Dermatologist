#ifndef PATIENT_H
#define PATIENT_H

#include <QDebug>
#include <QtTypes>
#include <QString>
#include <QVariantMap>

struct Patient
{
    // Fields
public:
    quint64 patient_id;
    QString first_name;
    QString last_name;
    quint8 age;
    QString birth_date;
    QString phone_number;
    QString gender;
    QString marital_status;
};

#endif // PATIENT_H
