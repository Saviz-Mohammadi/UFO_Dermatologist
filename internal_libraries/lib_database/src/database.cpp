#include "database.hpp"

#ifdef QT_DEBUG
    #include "logger.hpp"
#endif


Database *Database::m_Instance = Q_NULLPTR;

// Constructors, Initializers, Destructor
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

Database::Database(QObject *parent, const QString &name)
    : QObject{parent}
    , m_QSqlDatabase(QSqlDatabase{})
    , m_ConnectionStatus(false)
    , m_SearchResultList(QVariantList{})
    , m_TreatmentList(QVariantList{})
    , m_PatientDataMap(QVariantMap{})
{
    this->setObjectName(name);



#ifdef QT_DEBUG
    QString message("Call to Constructor\n");

    QTextStream stream(&message);

    stream << "List of SQL drivers: " << QSqlDatabase::drivers().join(", ");

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif
}

Database::~Database()
{
#ifdef QT_DEBUG
    QString message("Call to Destructor");

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    // Shutdown.
    this->disconnect();
}

Database *Database::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);

    if (!m_Instance)
    {
        m_Instance = new Database();
    }

    return (m_Instance);
}

Database *Database::cppInstance(QObject *parent)
{
    if (m_Instance)
    {
        return (qobject_cast<Database *>(Database::m_Instance));
    }

    auto instance = new Database(parent);
    m_Instance = instance;
    return (instance);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PUBLIC Methods
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

// CONNECTIONS
void Database::establishConnection(const QString &ipAddress, qint16 port, const QString &schema, const QString &username, const QString &password)
{
    // Connection already exists, abort operation.
    if (m_ConnectionStatus)
    {
        return;
    }



    m_QSqlDatabase = QSqlDatabase::addDatabase("QMYSQL");

    m_QSqlDatabase.setHostName(ipAddress);
    m_QSqlDatabase.setPort(port);
    m_QSqlDatabase.setDatabaseName(schema);
    m_QSqlDatabase.setUserName(username);
    m_QSqlDatabase.setPassword(password);



    bool connectionFailed = !m_QSqlDatabase.open();

    if (connectionFailed)
    {
#ifdef QT_DEBUG
        QString message("Connection failed!\n");

        QTextStream stream(&message);

        stream << "Error       : " << m_QSqlDatabase.lastError().text() << "\n"
               << "IpAddress   : " << ipAddress;

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif


        return;
    }



    // Notify QML:
    setConnectionStatus(true);



    // Populate lists:
    populateTreatmentList();
}

void Database::disconnect()
{
#ifdef QT_DEBUG
    QString message("Closing the database connection...\n");

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    m_QSqlDatabase.close();

    setConnectionStatus(false);
}



// SEARCH
bool Database::findPatient(const QString &first_name, const QString &last_name, quint8 age, const QString &phone_number, const QString &gender, const QString &marital_status)
{
    QString queryString = "SELECT * FROM patients WHERE 1=1";
    QSqlQuery query;



#ifdef QT_DEBUG
    QString message("Search initiated!\n");

    QTextStream stream(&message);
#endif



    // NOTE (SAVIZ): I like to use 'std::optional', but QML does not play nice.
    if (!first_name.isEmpty())
    {
        queryString += " AND first_name LIKE '%" + first_name + "%'";


#ifdef QT_DEBUG
        stream << "'first_name' : " << first_name << "\n";
#endif
    }

    if (!last_name.isEmpty())
    {
        queryString += " AND last_name LIKE '%" + last_name + "%'";


#ifdef QT_DEBUG
        stream << "'laste_name' : " << last_name << "\n";
#endif
    }

    // NOTE (SAVIZ): Using -1 as the sentinel value for age, which turns into 255 in unsigned format.
    if (age != 255)
    {
        queryString += " AND age = " + QString::number(age);


#ifdef QT_DEBUG
        stream << "'age' : " << age << "\n";
#endif
    }

    if (!phone_number.isEmpty())
    {
        queryString += " AND phone_number LIKE '%" + phone_number + "%'";


#ifdef QT_DEBUG
        stream << "'phone_number' : " << phone_number << "\n";
#endif
    }

    if (!gender.isEmpty() && gender != "Gender")
    {
        queryString += " AND gender = '" + gender + "'";


#ifdef QT_DEBUG
        stream << "'gender' : " << gender << "\n";
#endif
    }

    if (!marital_status.isEmpty() && marital_status != "Marital Status")
    {
        queryString += " AND marital_status = '" + marital_status + "'";


#ifdef QT_DEBUG
        stream << "'marital_status' : " << marital_status << "\n";
#endif
    }



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    query.prepare(queryString);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text());
#endif


        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Query returned no results.");
#endif


        return (false);
    }



    m_SearchResultList.clear();



    // NOTE (SAVIZ): Only obtain the bare minimum data on the patients for now:
    while (query.next())
    {
        QVariantMap patientMap;


        patientMap["patient_id"] = query.value("patient_id").toULongLong();
        patientMap["first_name"] = query.value("first_name").toString();
        patientMap["last_name"] = query.value("last_name").toString();
        patientMap["age"] = query.value("age").toString();
        patientMap["birth_date"] = query.value("birth_date").toString();
        patientMap["phone_number"] = query.value("phone_number").toString();
        patientMap["gender"] = query.value("gender").toString();
        patientMap["marital_status"] = query.value("marital_status").toString();


        m_SearchResultList.append(patientMap);
    }



    // Notify QML that the results have changed.
    emit searchResultListChanged();



    return (true);
}

bool Database::findFirstPatient()
{
    QString queryString = "SELECT * FROM patients ORDER BY patient_id ASC LIMIT 1";
    QSqlQuery query;



    query.prepare(queryString);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text());
#endif


        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Query returned no results.");
#endif


        return (false);
    }



    m_SearchResultList.clear();



    // NOTE (SAVIZ): Only obtain the bare minimum data on the patients for now:
    while (query.next())
    {
        QVariantMap patientMap;


        patientMap["patient_id"] = query.value("patient_id").toULongLong();
        patientMap["first_name"] = query.value("first_name").toString();
        patientMap["last_name"] = query.value("last_name").toString();
        patientMap["age"] = query.value("age").toString();
        patientMap["birth_date"] = query.value("birth_date").toString();
        patientMap["phone_number"] = query.value("phone_number").toString();
        patientMap["gender"] = query.value("gender").toString();
        patientMap["marital_status"] = query.value("marital_status").toString();


        m_SearchResultList.append(patientMap);
    }



    // Notify QML:
    emit searchResultListChanged();



    return (true);
}

bool Database::findLastPatient()
{
    QString queryString = "SELECT * FROM patients ORDER BY patient_id DESC LIMIT 1";
    QSqlQuery query;



    query.prepare(queryString);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text());
#endif


        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Query returned no results.");
#endif


        return (false);
    }



    m_SearchResultList.clear();



    // NOTE (SAVIZ): Only obtain the bare minimum data on the patients for now:
    while (query.next())
    {
        QVariantMap patientMap;


        patientMap["patient_id"] = query.value("patient_id").toULongLong();
        patientMap["first_name"] = query.value("first_name").toString();
        patientMap["last_name"] = query.value("last_name").toString();
        patientMap["age"] = query.value("age").toString();
        patientMap["birth_date"] = query.value("birth_date").toString();
        patientMap["phone_number"] = query.value("phone_number").toString();
        patientMap["gender"] = query.value("gender").toString();
        patientMap["marital_status"] = query.value("marital_status").toString();


        m_SearchResultList.append(patientMap);
    }



    // Notify QML:
    emit searchResultListChanged();



    return (true);
}



// UPDATE
bool Database::updatePersonalInformation(const QString &newFirstName, const QString &newLastName, quint8 newAge, const QString &newPhoneNumber, const QString &newGender, const QString &newMaritalStatus)
{
    QString queryString = "UPDATE patients SET ";
    QSqlQuery query;



#ifdef QT_DEBUG
    QString message("Update personal information\n");

    QTextStream stream(&message);
#endif



    // NOTE (SAVIZ): I like to use 'std::optional', but QML does not play nice.
    if (!newFirstName.isEmpty())
    {
        queryString += "first_name = '" + newFirstName + "'";


#ifdef QT_DEBUG
        stream << "New 'first_name' : " << newFirstName << "\n";
#endif
    }

    if (!newLastName.isEmpty())
    {
        queryString += ", last_name = '" + newLastName + "'";


#ifdef QT_DEBUG
        stream << "New 'last_name' : " << newLastName << "\n";
#endif
    }

    // NOTE (SAVIZ): Using -1 as the sentinel value for age, which turns into 255 in unsigned format.
    if (newAge != 255)
    {
        queryString += ", age = " + QString::number(newAge);


#ifdef QT_DEBUG
        stream << "New 'age' : " << newAge << "\n";
#endif
    }

    if (!newPhoneNumber.isEmpty())
    {
        queryString += ", phone_number = '" + newPhoneNumber + "'";


#ifdef QT_DEBUG
        stream << "New 'phone_number' : " << newPhoneNumber << "\n";
#endif
    }

    if (!newGender.isEmpty() && newGender != "Gender")
    {
        queryString += ", gender = '" + newGender + "'";


#ifdef QT_DEBUG
        stream << "New 'gender' : " << newGender << "\n";
#endif
    }

    if (!newMaritalStatus.isEmpty() && newMaritalStatus != "Marital Status")
    {
        queryString += ", marital_status = '" + newMaritalStatus + "'";


#ifdef QT_DEBUG
        stream << "New 'marital_status' : " << newMaritalStatus << "\n";
#endif
    }



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    queryString += " WHERE patient_id = " + m_PatientDataMap["patient_id"].toString();
    query.prepare(queryString);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text());
#endif


        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Query returned no results.");
#endif


        return (false);
    }



    return (true);
}

bool Database::updateTreatments(const QVariantList &newTreatments)
{
    QSqlQuery queryDelete;
    queryDelete.prepare("DELETE FROM patient_treatments WHERE patient_id = " + m_PatientDataMap["patient_id"].toString());

    if (!queryDelete.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, queryDelete.lastError().text());
#endif


        return (false);
    }



    if (newTreatments.isEmpty())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Treatment list received is empty!");
#endif


        return (true); // Technically, nothing went wrong...
    }



    QString queryString = "INSERT INTO patient_treatments (patient_id, treatment_id) VALUES (%1, %2)";
    QSqlQuery queryInsert;



    if(newTreatments.empty())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Treatment ids were empty!");
#endif


        return (false);
    }



    bool executionSuccessful = true;

    for (std::size_t index = 0; index < newTreatments.length(); ++index)
    {
        queryInsert.prepare(queryString.arg(m_PatientDataMap["patient_id"].toString(), newTreatments[index].toString()));

        if(!queryInsert.exec())
        {
            executionSuccessful = false;

            break;
        }
    }


    if(!executionSuccessful)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, queryInsert.lastError().text());
#endif


        return (false);
    }



    return (true);
}

bool Database::updatePatientData(const QString &newFirstName, const QString &newLastName, quint8 newAge, const QString &newPhoneNumber, const QString &newGender, const QString &newMaritalStatus, const QVariantList &newTreatments)
{
    if(!m_QSqlDatabase.transaction())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Failed to start transaction!");
#endif


        return (false);
    }



    bool personalUpdateSuccessful = updatePersonalInformation(newFirstName, newLastName, newAge, newPhoneNumber, newGender, newMaritalStatus);

    if(!personalUpdateSuccessful)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Personal update failed!");
#endif


        m_QSqlDatabase.rollback();

        return (false);
    }



    bool treatmentUpdateSuccessful = updateTreatments(newTreatments);

    if(!treatmentUpdateSuccessful)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Treatment update failed!");
#endif


        m_QSqlDatabase.rollback();

        return (false);
    }



    bool commitSuccessful = m_QSqlDatabase.commit();

    if(!commitSuccessful)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Commit failed!");
#endif


        return (false);
    }


    // Notify QML:
    emit updatesApplied();


    return (true);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// HELPER
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

bool Database::readyPatientData(const quint64 index)
{
#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "The patient_id is: " + QString::number(index));
#endif



    QString queryString = "SELECT * FROM patients ";
    QSqlQuery query;



    // Treatments:
    queryString += "LEFT JOIN patient_treatments ON patients.patient_id = patient_treatments.patient_id ";
    queryString += "LEFT JOIN treatments ON treatments.treatment_id = patient_treatments.treatment_id";



    // Id:
    queryString += " WHERE patients.patient_id = " + QString::number(index);



    query.prepare(queryString);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text());
#endif


        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Query returned no results.");
#endif


        return (false);
    }




    QVariantList treatments;



    while (query.next())
    {
        QVariantMap treatmentMap;

        // Personal Information:
        m_PatientDataMap["patient_id"] = query.value("patient_id").toULongLong();
        m_PatientDataMap["first_name"] = query.value("first_name").toString();
        m_PatientDataMap["last_name"] = query.value("last_name").toString();
        m_PatientDataMap["age"] = query.value("age").toString();
        m_PatientDataMap["birth_date"] = query.value("birth_date").toString();
        m_PatientDataMap["phone_number"] = query.value("phone_number").toString();
        m_PatientDataMap["gender"] = query.value("gender").toString();
        m_PatientDataMap["marital_status"] = query.value("marital_status").toString();

        // Treatments:
        treatmentMap["treatment_id"] = query.value("treatment_id").toULongLong();
        treatmentMap["treatment_name"] = query.value("treatments.name").toString();
        treatments.append(treatmentMap);
    }



    // Assign Treatments:
    m_PatientDataMap["treatments"] = treatments;



    // Notify QML:
    emit patientDataChanged();



    return (true);
}

bool Database::populateTreatmentList()
{
    QString queryString = "SELECT * FROM treatments";
    QSqlQuery query;



    query.prepare(queryString);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text());
#endif


        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Query returned no results.");
#endif


        return (false);
    }



    while (query.next())
    {
        QVariantMap treatmentMap;

        treatmentMap["treatment_id"] = query.value("treatment_id").toULongLong();
        treatmentMap["treatment_name"] = query.value("treatments.name").toString();

        m_TreatmentList.append(treatmentMap);
    }



    // Notify QML:
    emit treatmentsPopulated();



    return (true);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PUBLIC Getters
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

bool Database::getConnectionStatus() const
{
    return (m_ConnectionStatus);
}

QVariantList Database::getSearchResultList() const
{
    return (m_SearchResultList);
}

QVariantMap Database::getPatientDataMap() const
{
    return (m_PatientDataMap);
}

QVariantList Database::getTreatmentList() const
{
    return (m_TreatmentList);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PUBLIC Setters
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

void Database::setConnectionStatus(const bool newStatus)
{
    if (m_ConnectionStatus == newStatus)
    {
        return;
    }

    m_ConnectionStatus = newStatus;
    emit connectionStatusChanged();
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]
