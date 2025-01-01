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
    , m_TreatmentList(QVariantList{})
    , m_SearchResultList(QVariantList{})
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
#ifdef QT_DEBUG
    QString message("Connection request initiated!\n");

    QTextStream stream(&message);
#endif



    // Connection exists, abort operation.
    if (m_ConnectionStatus)
    {
#ifdef QT_DEBUG
        stream << "Connection exists. Aborting operation.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        // Notify QML:
        setConnectionStatus(true, "Connection exists. Aborting operation.");



        return;
    }



    m_QSqlDatabase = QSqlDatabase::addDatabase("QMYSQL", "MySQL database");

    m_QSqlDatabase.setHostName(ipAddress);
    m_QSqlDatabase.setPort(port);
    m_QSqlDatabase.setDatabaseName(schema);
    m_QSqlDatabase.setUserName(username);
    m_QSqlDatabase.setPassword(password);



    bool connectionFailed = !m_QSqlDatabase.open();

    if (connectionFailed)
    {
#ifdef QT_DEBUG
        stream  << "Connection failed!\n";

        stream  << "Error     : " << m_QSqlDatabase.lastError().text() << "\n"
                << "IpAddress : " << ipAddress << "\n"
                << "Port      : " << port << "\n"
                << "Schema    : " << schema << "\n"
                << "Username  : " << username << "\n"
                << "Password  : " << password << "\n";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        // Notify QML:
        setConnectionStatus(false, "Unable to establish a connection to the database.");



        return;
    }



#ifdef QT_DEBUG
    stream  << "Connection established!\n";

    stream  << "IpAddress : " << ipAddress << "\n"
            << "Port      : " << port << "\n"
            << "Schema    : " << schema << "\n"
            << "Username  : " << username << "\n"
            << "Password  : " << password << "\n";

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    // Populate lists:
    populateTreatmentList();



    // Notify QML:
    setConnectionStatus(true, "Successfully connected to the database.");
}

void Database::disconnect()
{
#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Closing the database connection...\n");
#endif



    m_QSqlDatabase.close();



    // Notify QML:
    setConnectionStatus(false, "Disconnected from database.");
}

// INSERT
bool Database::createPatient(const QString &firstName, const QString &lastName, quint32 birthYear, const QString &phoneNumber, const QString &gender, const QString &maritalStatus)
{
    // NOTE (SAVIZ): The application assumes that 'Creating a patient for the first time' corresponds to their 'First visit.' As a result, certain fields, such as first_visit_date and recent_visit_date, are automatically populated.

#ifdef QT_DEBUG
    QString message("Insert initiated!\n");

    QTextStream stream(&message);

    stream << "first_name     : " << firstName     << "\n";
    stream << "last_name      : " << lastName      << "\n";
    stream << "phone_number   : " << phoneNumber   << "\n";
    stream << "birth_year     : " << birthYear     << "\n";
    stream << "gender         : " << gender        << "\n";
    stream << "marital_status : " << maritalStatus << "\n";
#endif



    QString queryString = "INSERT IGNORE INTO patients (first_name, last_name, birth_year, phone_number, gender, marital_status, first_visit_date, recent_visit_date) VALUES (:first_name, :last_name, :birth_year, :phone_number, :gender, :marital_status, :first_visit_date, :recent_visit_date);";
    QSqlQuery query(m_QSqlDatabase);



    query.prepare(queryString);



    // First bind required fields:
    query.bindValue(":first_name", firstName);
    query.bindValue(":last_name", lastName);
    query.bindValue(":birth_year", birthYear);
    query.bindValue(":phone_number", phoneNumber);
    query.bindValue(":gender", gender);
    query.bindValue(":marital_status", maritalStatus);

    // Now bind automatic fields:
    query.bindValue(":first_visit_date", QDate::currentDate());
    query.bindValue(":recent_visit_date", QDate::currentDate());



    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text() + "\n" + message);
#endif



        emit queryExecuted(QueryType::CREATE, false, query.lastError().text());



        return (false);
    }



    if (query.numRowsAffected() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "The record already exists and was not inserted.\n" + message);
#endif



        // Notify QML:
        emit queryExecuted(QueryType::CREATE, false, "The record already exists and was not inserted.");



        return(false);
    }



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    // Notify QML:
    emit queryExecuted(QueryType::CREATE, true, "The patient record was inserted successfully.");



    return (true);
}

// SEARCH
bool Database::findPatient(const quint64 patientID)
{
    QString queryString = "SELECT * FROM patients WHERE patient_id = :patient_id";
    QSqlQuery query(m_QSqlDatabase);



#ifdef QT_DEBUG
    QString message("Search initiated! (patient_id)\n");

    QTextStream stream(&message);
#endif



    query.prepare(queryString);



    query.bindValue(":patient_id", patientID);



    m_SearchResultList.clear();



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, query.lastError().text());



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, "Query returned no results.");



        return (false);
    }



#ifdef QT_DEBUG
    stream  << "patient_id : " << patientID;

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    // NOTE (SAVIZ): Only obtain minimum data:
    while (query.next())
    {
        QVariantMap patientMap;



        patientMap["patient_id"] = query.value("patient_id").toULongLong();
        patientMap["first_name"] = query.value("first_name").toString();
        patientMap["last_name"] = query.value("last_name").toString();
        patientMap["birth_year"] = query.value("birth_year").toString();
        patientMap["phone_number"] = query.value("phone_number").toString();
        patientMap["gender"] = query.value("gender").toString();
        patientMap["marital_status"] = query.value("marital_status").toString();
        patientMap["service_price"] = query.value("service_price").toString();



        m_SearchResultList.append(patientMap);
    }



    // Notify QML:
    emit queryExecuted(QueryType::SEARCH, true, "Search query executed successfully.");



    return (true);
}

bool Database::findPatient(const QString &firstName, const QString &lastName, quint32 birthYearStart, quint32 birthYearEnd, const QString &phoneNumber, const QString &gender, const QString &maritalStatus)
{
    if(firstName.isEmpty() && lastName.isEmpty() && birthYearStart <= 0 && birthYearEnd <= 0 && phoneNumber.isEmpty() && gender.isEmpty() && maritalStatus.isEmpty())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "All fields were denied.");
#endif



        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, "All fields were denied.");



        return (false);
    }



    QString queryString = "SELECT * FROM patients WHERE 1 = 1";
    QSqlQuery query(m_QSqlDatabase);



#ifdef QT_DEBUG
    QString message("Search initiated! (patient data)\n");

    QTextStream stream(&message);
#endif



    // NOTE (SAVIZ): I like to use 'std::optional', but QML does not play nice.
    if (!firstName.isEmpty())
    {
        queryString += " AND first_name LIKE :first_name";
    }

    if (!lastName.isEmpty())
    {
        queryString += " AND last_name LIKE :last_name";
    }

    if (birthYearStart > 0)
    {
        queryString += " AND birth_year >= :birth_year_start";
    }

    if (birthYearEnd > 0)
    {
        queryString += " AND birth_year <= :birth_year_end";
    }

    if (!phoneNumber.isEmpty())
    {
        queryString += " AND phone_number LIKE :phone_number";
    }

    if (!gender.isEmpty())
    {
        queryString += " AND gender = :gender";
    }

    if (!maritalStatus.isEmpty())
    {
        queryString += " AND marital_status = :marital_status";
    }



    query.prepare(queryString);



    if (!firstName.isEmpty())
    {
        query.bindValue(":first_name", firstName + "%");
    }

    if(!lastName.isEmpty())
    {
        query.bindValue(":last_name", lastName + "%");
    }

    if (!phoneNumber.isEmpty())
    {
        query.bindValue(":phone_number", phoneNumber + "%");
    }

    if (birthYearStart > 0)
    {
        query.bindValue(":birth_year_start", birthYearStart);
    }

    if (birthYearEnd > 0)
    {
        query.bindValue(":birth_year_end", birthYearEnd);
    }

    if (!gender.isEmpty())
    {
        query.bindValue(":gender", gender);
    }

    if (!maritalStatus.isEmpty())
    {
        query.bindValue(":marital_status", maritalStatus);
    }



    m_SearchResultList.clear();



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream  << query.lastError().text() << "\n";

        stream  << "first_name       : " << firstName      << "\n"
                << "last_name        : " << lastName       << "\n"
                << "birth_year_start : " << birthYearStart << "\n"
                << "birth_year_end   : " << birthYearEnd   << "\n"
                << "phone_number     : " << phoneNumber    << "\n"
                << "gender           : " << gender         << "\n"
                << "marital_status   : " << maritalStatus;

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, query.lastError().text());



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream  << "Query returned no results." << "\n";

        stream  << "first_name       : " << firstName      << "\n"
                << "last_name        : " << lastName       << "\n"
                << "birth_year_start : " << birthYearStart << "\n"
                << "birth_year_end   : " << birthYearEnd   << "\n"
                << "phone_number     : " << phoneNumber    << "\n"
                << "gender           : " << gender         << "\n"
                << "marital_status   : " << maritalStatus;

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, "Query returned no results.");



        return (false);
    }



#ifdef QT_DEBUG
    stream  << "first_name       : " << firstName      << "\n"
            << "last_name        : " << lastName       << "\n"
            << "birth_year_start : " << birthYearStart << "\n"
            << "birth_year_end   : " << birthYearEnd   << "\n"
            << "phone_number     : " << phoneNumber    << "\n"
            << "gender           : " << gender         << "\n"
            << "marital_status   : " << maritalStatus;

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    // NOTE (SAVIZ): Only obtain minimum data:
    while (query.next())
    {
        QVariantMap patientMap;



        patientMap["patient_id"] = query.value("patient_id").toULongLong();
        patientMap["first_name"] = query.value("first_name").toString();
        patientMap["last_name"] = query.value("last_name").toString();
        patientMap["birth_year"] = query.value("birth_year").toString();
        patientMap["phone_number"] = query.value("phone_number").toString();
        patientMap["gender"] = query.value("gender").toString();
        patientMap["marital_status"] = query.value("marital_status").toString();
        patientMap["service_price"] = query.value("service_price").toString();



        m_SearchResultList.append(patientMap);
    }



    // Notify QML:
    emit queryExecuted(QueryType::SEARCH, true, "Search query executed successfully.");



    return (true);
}

bool Database::findFirstXPatients(const quint64 count)
{
    QString queryString = "SELECT * FROM patients ORDER BY patient_id ASC LIMIT :count";
    QSqlQuery query(m_QSqlDatabase);



#ifdef QT_DEBUG
    QString message("Search initiated! (First X)\n");

    QTextStream stream(&message);
#endif



    query.prepare(queryString);



    query.bindValue(":count", count);



    m_SearchResultList.clear();



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, query.lastError().text());



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, "Query returned no results.");



        return (false);
    }



#ifdef QT_DEBUG
    stream  << "count : " << count;

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    // NOTE (SAVIZ): Only obtain minimum data:
    while (query.next())
    {
        QVariantMap patientMap;



        patientMap["patient_id"] = query.value("patient_id").toULongLong();
        patientMap["first_name"] = query.value("first_name").toString();
        patientMap["last_name"] = query.value("last_name").toString();
        patientMap["birth_year"] = query.value("birth_year").toString();
        patientMap["phone_number"] = query.value("phone_number").toString();
        patientMap["gender"] = query.value("gender").toString();
        patientMap["marital_status"] = query.value("marital_status").toString();
        patientMap["service_price"] = query.value("service_price").toString();



        m_SearchResultList.append(patientMap);
    }



    // Notify QML:
    emit queryExecuted(QueryType::SEARCH, true, "Search query executed successfully.");



    return (true);
}

bool Database::findLastXPatients(const quint64 count)
{
    QString queryString = "SELECT * FROM patients ORDER BY patient_id DESC LIMIT :count";
    QSqlQuery query(m_QSqlDatabase);



#ifdef QT_DEBUG
    QString message("Search initiated! (Last X)\n");

    QTextStream stream(&message);
#endif



    query.prepare(queryString);



    query.bindValue(":count", count);



    m_SearchResultList.clear();



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, query.lastError().text());



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, "Query returned no results.");



        return (false);
    }



#ifdef QT_DEBUG
    stream  << "count : " << count;

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    // NOTE (SAVIZ): Only obtain minimum data:
    while (query.next())
    {
        QVariantMap patientMap;



        patientMap["patient_id"] = query.value("patient_id").toULongLong();
        patientMap["first_name"] = query.value("first_name").toString();
        patientMap["last_name"] = query.value("last_name").toString();
        patientMap["birth_year"] = query.value("birth_year").toString();
        patientMap["phone_number"] = query.value("phone_number").toString();
        patientMap["gender"] = query.value("gender").toString();
        patientMap["marital_status"] = query.value("marital_status").toString();
        patientMap["service_price"] = query.value("service_price").toString();



        m_SearchResultList.append(patientMap);
    }



    // Notify QML:
    emit queryExecuted(QueryType::SEARCH, true, "Search query executed successfully.");



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


// DELETION
bool Database::changeDeletionStatus(bool newStatus)
{
    QString queryString = "UPDATE patients SET mark_for_deletion = :newStatus WHERE patient_id = :patient_id;";
    QSqlQuery query;



    query.prepare(queryString);



    query.bindValue(":newStatus", newStatus);
    query.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());



    if (!query.exec())
    {



        return (false);
    }



    return (true);
}


// HELPER
bool Database::pullPatientData(const quint64 index)
{
#ifdef QT_DEBUG
    QString message("Pull initiated!\n");

    QTextStream stream(&message);

    stream << "The patient_id is: " + QString::number(index) + "\n";
#endif



    QString queryString = "SELECT * FROM patients";



    // treatments:
    queryString += " LEFT JOIN patient_treatments ON patients.patient_id = patient_treatments.patient_id";
    queryString += " LEFT JOIN treatments ON treatments.treatment_id = patient_treatments.treatment_id";



    // treatment_notes:
    queryString += " LEFT JOIN treatment_notes ON patients.patient_id = treatment_notes.patient_id";



    // Id:
    queryString += " WHERE patients.patient_id = :patient_id";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    query.bindValue(":patient_id", index);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text() << "\n";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        // Notify QML:
        emit patientDataPulled(false, query.lastError().text());



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        // Notify QML:
        emit patientDataPulled(false, "Query returned no results.");



        return (false);
    }



    QVariantList treatments;



    while (query.next())
    {
        QVariantMap treatmentMap;



        // Basic Data:
        m_PatientDataMap["patient_id"] = query.value("patient_id").toULongLong();
        m_PatientDataMap["first_name"] = query.value("first_name").toString();
        m_PatientDataMap["last_name"] = query.value("last_name").toString();
        m_PatientDataMap["birth_year"] = query.value("birth_year").toString();
        m_PatientDataMap["phone_number"] = query.value("phone_number").toString();
        m_PatientDataMap["gender"] = query.value("gender").toString();
        m_PatientDataMap["marital_status"] = query.value("marital_status").toString();
        m_PatientDataMap["number_of_previous_visits"] = query.value("number_of_previous_visits").toUInt();
        m_PatientDataMap["first_visit_date"] = query.value("first_visit_date").toString();
        m_PatientDataMap["recent_visit_date"] = query.value("recent_visit_date").toString();
        m_PatientDataMap["service_price"] = query.value("service_price").toReal();
        m_PatientDataMap["marked_for_deletion"] = query.value("marked_for_deletion").toBool();



        // treatments:
        treatmentMap["treatment_id"] = query.value("treatment_id").toULongLong();
        treatmentMap["treatment_name"] = query.value("treatments.name").toString();
        treatments.append(treatmentMap);



        // treatment_notes:
        m_PatientDataMap["treatment_note"] = query.value("treatment_notes.note").toString();
    }



    // Assign treatments:
    m_PatientDataMap["treatments"] = treatments;



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    // Notify QML:
    emit patientDataPulled(true, "Pull operation successful");



    return (true);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PRIVATE Methods
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

bool Database::populateTreatmentList()
{
    QString queryString = "SELECT * FROM treatments WHERE is_active = TRUE";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text());
#endif



        // Notify QML:
        emit treatmentListPopulated(false, query.lastError().text());



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Query returned no results.");
#endif



        // Notify QML:
        emit treatmentListPopulated(false, "Query returned no results.");



        return (false);
    }



    while (query.next())
    {
        QVariantMap treatmentMap;



        treatmentMap["treatment_id"] = query.value("treatment_id").toULongLong();
        treatmentMap["treatment_name"] = query.value("name").toString();



        m_TreatmentList.append(treatmentMap);
    }



    // Notify QML:
    emit treatmentListPopulated(true, "Treatment list successfully acquired.");



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

QVariantList Database::getTreatmentList() const
{
    return (m_TreatmentList);
}

QVariantMap Database::getPatientDataMap() const
{
    return (m_PatientDataMap);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PRIVATE Setters
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

void Database::setConnectionStatus(const bool newStatus, const QString &newMessage)
{
    if (m_ConnectionStatus == newStatus)
    {
        return;
    }

    m_ConnectionStatus = newStatus;
    emit connectionStatusChanged(newMessage);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]
