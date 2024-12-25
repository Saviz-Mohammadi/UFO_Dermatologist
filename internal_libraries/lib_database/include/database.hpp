#ifndef DATABASE_H
#define DATABASE_H

#include <QDebug>
#include <QObject>
#include <QQmlEngine>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QVariant>
#include <QVariantList>
#include <QFileInfo>
#include <QTextStream>
#include <optional>

#include "patient.hpp"

// NOTE (SAVIZ): The combination of 'QVariantMap' and 'QVariantList' enbales us to replicate any type of data structure and exposed it easilly to QML. For this reason I don't use any intermidiate objects or strcuts for data transfer.

class Database : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY_MOVE(Database) // Needed for Singleton

    // Q_PROPERTY
    Q_PROPERTY(bool connectionStatus READ getConnectionStatus NOTIFY connectionStatusChanged FINAL)
    //Q_PROPERTY(QVariantMap editPatientMap READ getEditPatientMap NOTIFY editPatientMapChanged FINAL)

public:
    explicit Database(QObject *parent = Q_NULLPTR, const QString& name = "No name");
    ~Database();

    static Database *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);
    static Database *cppInstance(QObject *parent = Q_NULLPTR);

private:
    static Database *m_Instance;

    // Fields
private:
    QSqlDatabase m_QSqlDatabase;
    bool m_ConnectionStatus;
    QVariantList m_SearchResultList;
    QVariantMap m_PatientDataMap;
    QVariantMap m_TreatmentMap;

    // Signals
signals:
    void connectionStatusChanged();
    void searchResultListChanged();
    void patientDataChanged();
    void updatesApplied();
    void treatmentsPopulated();

    // PUBLIC Methods
public:
    // CONNECTIONS
    Q_INVOKABLE void establishConnection(const QString &ipAddress, qint16 port, const QString &schema, const QString &username, const QString &password);
    Q_INVOKABLE void disconnect();

    // SEARCH
    Q_INVOKABLE bool findPatient(const QString &first_name, const QString &last_name, quint8 age, const QString &phone_number, const QString &gender, const QString &marital_status);
    Q_INVOKABLE bool findFirstPatient();
    Q_INVOKABLE bool findLastPatient();

    // UPDATE
    bool updatePersonalInformation(const QString &newFirstName, const QString &newLastName, quint8 newAge, const QString &newPhoneNumber, const QString &newGender, const QString &newMaritalStatus);
    bool updateTreatments(const QVariantList &newTreatments);
    Q_INVOKABLE bool updatePatientData(const QString &newFirstName, const QString &newLastName, quint8 newAge, const QString &newPhoneNumber, const QString &newGender, const QString &newMaritalStatus, const QVariantList &newTreatments);

    // HELPER
    Q_INVOKABLE bool readyPatientDataForEditing(const quint64 index);
    bool populateTreatmentList();

    // PUBLIC Getters
public:
    bool getConnectionStatus() const;
    Q_INVOKABLE QVariantList getSearchResultList() const;
    QVariantMap getPatientData() const;

    // PRIVATE Setters
private:
    void setConnectionStatus(const bool newStatus);
};

#endif // DATABASE_H
