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
#include <QTextStream>
#include "date.hpp"

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
    QVariantList m_DiagnosisList;
    QVariantList m_TreatmentList;
    QVariantList m_MedicalDrugList;
    QVariantList m_ProcedureList;
    QVariantList m_ConsultantList;
    QVariantList m_LabList;
    QVariantList m_SearchResultList;
    QVariantMap m_PatientDataMap;

    // Signals
signals:
    void connectionStatusChanged(const QString &message);
    void diagnosisListPopulated(bool success, const QString &message);
    void treatmentListPopulated(bool success, const QString &message);
    void consultantListPopulated(bool success, const QString &message);
    void labListPopulated(bool success, const QString &message);
    void medicalDrugListPopulated(bool success, const QString &message);
    void procedureListPopulated(bool success, const QString &message);
    void queryExecuted(QueryType type, bool success, const QString &message);
    void patientDataPulled(bool success, const QString &message);
    void patientDataPushed(bool success, const QString &message);

    // PUBLIC Methods
public:
    // CONNECTIONS
    Q_INVOKABLE bool establishConnection(const QString &ipAddress, qint16 port, const QString &schema, const QString &username, const QString &password);
    Q_INVOKABLE bool disconnect();

    // INSERT
    Q_INVOKABLE bool createPatient(const QString &firstName, const QString &lastName, quint32 birthYear, const QString &phoneNumber, const QString &gender, const QString &maritalStatus);

    // SEARCH
    Q_INVOKABLE bool findPatient(const quint64 patientID);
    Q_INVOKABLE bool findPatient(const QString &firstName, const QString &lastName, quint32 birthYearStart, quint32 birthYearEnd, const QString &phoneNumber, const QString &gender, const QString &maritalStatus);
    Q_INVOKABLE bool findFirstXPatients(const quint64 count);
    Q_INVOKABLE bool findLastXPatients(const quint64 count);

    // SELECT
    Q_INVOKABLE bool pullPatientData(const quint64 index);
    bool pullPatientBasicData(const quint64 index);
    bool pullPatientDiagnoses(const quint64 index);
    bool pullPatientTreatments(const quint64 index);
    bool pullPatientMedicalDrugs(const quint64 index);
    bool pullPatientProcedures(const quint64 index);
    bool pullDiagnosisNote(const quint64 index);
    bool pullTreatmentNote(const quint64 index);
    bool pullMedicalDrugNote(const quint64 index);
    bool pullProcedureNote(const quint64 index);
    bool pullConsultations(const quint64 index);
    bool pullLabTests(const quint64 index);

    // UPDATE
    Q_INVOKABLE bool updatePatientData(const QString &newFirstName, const QString &newLastName, quint32 newBirthYear, const QString &newPhoneNumber, const QString &newGender, const QString &newMaritalStatus, quint32 newNumberOfPreviousVisits, const QString &newFirstVisitDate, const QString &newRecentVisitDate, qreal newServicePrice, const QVariantList &newDiagnoses, const QString &newDiagnosisNote, const QVariantList &newTreatments, const QString &newTreatmentNote, const QVariantList &newMedicalDrugs, const QString &newMedicalDrugNote, const QVariantList &newProcedures, const QString &newProcedureNote, const QVariantList &newConsultations, const QVariantList &newLabTests);
    bool updateBasicData(const QString &newFirstName, const QString &newLastName, quint32 newBirthYear, const QString &newPhoneNumber, const QString &newGender, const QString &newMaritalStatus, quint32 newNumberOfPreviousVisits, const QString &newFirstVisitDate, const QString &newRecentVisitDate, qreal newServicePrice);
    bool updateDiagnoses(const QVariantList &newDiagnoses);
    bool updateDiagnosisNote(const QString &newNote);
    bool updateTreatments(const QVariantList &newTreatments);
    bool updateTreatmentNote(const QString &newNote);
    bool updateMedicalDrugs(const QVariantList &newMedicalDrugs);
    bool updateMedicalDrugNote(const QString &newNote);
    bool updateProcedures(const QVariantList &newProcedures);
    bool updateProcedureNote(const QString &newNote);
    bool updateConsultations(const QVariantList &newConsultations);
    bool updateLabTests(const QVariantList &newLabTests);

    // DELETION
    Q_INVOKABLE bool changeDeletionStatus(bool newStatus);

    // PRIVATE Methods
private:
    bool populateDiagnosisList();
    bool populateTreatmentList();
    bool populateMedicalDrugList();
    bool populateProcedureList();
    bool populateConsultantList();
    bool populateLabList();

    // PUBLIC Getters
public:
    bool getConnectionStatus() const;
    Q_INVOKABLE QVariantList getDiagnosisList() const;
    Q_INVOKABLE QVariantList getTreatmentList() const;
    Q_INVOKABLE QVariantList getMedicalDrugList() const;
    Q_INVOKABLE QVariantList getProcedureList() const;
    Q_INVOKABLE QVariantList getConsultantList() const;
    Q_INVOKABLE QVariantList getLabList() const;
    Q_INVOKABLE QVariantList getSearchResultList() const;
    Q_INVOKABLE QVariantMap getPatientDataMap() const;
};

#endif // DATABASE_H
