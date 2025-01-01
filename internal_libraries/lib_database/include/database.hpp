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
#include <QDateTime>
#include <QFileInfo>
#include <QTextStream>

// NOTE (SAVIZ): The combination of 'QVariantMap' and 'QVariantList' enbales us to replicate any type of data structure and exposed it easilly to QML. For this reason I don't use any intermidiate objects or strcuts for data transfer.

class Database : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY_MOVE(Database) // Needed for Singleton

    // Q_PROPERTY
    Q_PROPERTY(bool connectionStatus READ getConnectionStatus NOTIFY connectionStatusChanged FINAL)

public:
    explicit Database(QObject *parent = Q_NULLPTR, const QString& name = "No name");
    ~Database();

    static Database *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);
    static Database *cppInstance(QObject *parent = Q_NULLPTR);

    // Enum
public:
    enum class QueryType
    {
        CREATE,
        SEARCH,
        UPDATE,
        DELETE,
    };

    Q_ENUM(QueryType)

private:
    static Database *m_Instance;

    // Fields
private:
    QSqlDatabase m_QSqlDatabase;
    bool m_ConnectionStatus;
    QVariantList m_TreatmentList;
    QVariantList m_SearchResultList;
    QVariantMap m_PatientDataMap;

    // Signals
signals:
    void connectionStatusChanged(const QString &message);
    void treatmentListPopulated(bool success, const QString &message);
    void queryExecuted(QueryType type, bool success, const QString &message);
    void patientDataPulled(bool success, const QString &message);
    void updatesApplied();

    // PUBLIC Methods
public:
    // CONNECTIONS
    Q_INVOKABLE void establishConnection(const QString &ipAddress, qint16 port, const QString &schema, const QString &username, const QString &password);
    Q_INVOKABLE void disconnect();

    // INSERT
    Q_INVOKABLE bool createPatient(const QString &firstName, const QString &lastName, quint32 birthYear, const QString &phoneNumber, const QString &gender, const QString &maritalStatus);

    // SEARCH
    Q_INVOKABLE bool findPatient(const quint64 patientID);
    Q_INVOKABLE bool findPatient(const QString &firstName, const QString &lastName, quint32 birthYearStart, quint32 birthYearEnd, const QString &phoneNumber, const QString &gender, const QString &maritalStatus);
    Q_INVOKABLE bool findFirstXPatients(const quint64 count);
    Q_INVOKABLE bool findLastXPatients(const quint64 count);

    // UPDATE
    bool updatePersonalInformation(const QString &newFirstName, const QString &newLastName, quint8 newAge, const QString &newPhoneNumber, const QString &newGender, const QString &newMaritalStatus);
    bool updateTreatments(const QVariantList &newTreatments);
    Q_INVOKABLE bool updatePatientData(const QString &newFirstName, const QString &newLastName, quint8 newAge, const QString &newPhoneNumber, const QString &newGender, const QString &newMaritalStatus, const QVariantList &newTreatments);

    // DELETION
    Q_INVOKABLE bool changeDeletionStatus(bool newStatus);

    // HELPER
    Q_INVOKABLE bool pullPatientData(const quint64 index);

    // PRIVATE Methods
private:
    bool populateTreatmentList();

    // PUBLIC Getters
public:
    bool getConnectionStatus() const;
    Q_INVOKABLE QVariantList getSearchResultList() const;
    Q_INVOKABLE QVariantList getTreatmentList() const;
    Q_INVOKABLE QVariantMap getPatientDataMap() const;

    // PRIVATE Setters
private:
    void setConnectionStatus(const bool newStatus, const QString &newMessage);
};

#endif // DATABASE_H
