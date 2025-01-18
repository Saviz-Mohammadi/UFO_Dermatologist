#include "database.hpp"

#ifdef QT_DEBUG
    #include "logger.hpp"
#endif


// WARNING (SAVIZ): 'LEFT JOIN' can produce 'Null' results. Therefore, we need to make sure to check against null valuse when dealing with things such as 'diagnoses', 'treatments', and 'medical drugs'.


Database *Database::m_Instance = Q_NULLPTR;

// Constructors, Initializers, Destructor
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

Database::Database(QObject *parent, const QString &name)
    : QObject{parent}
    , m_QSqlDatabase(QSqlDatabase{})
    , m_ConnectionStatus(false)
    , m_DiagnosisList(QVariantList{})
    , m_TreatmentList(QVariantList{})
    , m_MedicalDrugList(QVariantList{})
    , m_ConsultantList(QVariantList{})
    , m_LabList(QVariantList{})
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
bool Database::establishConnection(const QString &ipAddress, qint16 port, const QString &schema, const QString &username, const QString &password)
{
#ifdef QT_DEBUG
    QString message("Connection request initiated!\n");

    QTextStream stream(&message);
#endif



    // Connection exists, abort operation.
    if (m_ConnectionStatus == true)
    {
#ifdef QT_DEBUG
        stream << "Connection exists. Aborting operation.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        m_ConnectionStatus = true;



        // Notify QML:
        emit connectionStatusChanged("Connection exists. Aborting operation.");



        return (true);
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

        stream  << m_QSqlDatabase.lastError().text() << "\n\n";

        stream  << "IpAddress : " << ipAddress << "\n"
                << "Port      : " << port << "\n"
                << "Schema    : " << schema << "\n"
                << "Username  : " << username << "\n"
                << "Password  : " << password << "\n";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        m_ConnectionStatus = false;



        // Notify QML:
        emit connectionStatusChanged("اتصال برقرار نشد: " + m_QSqlDatabase.lastError().text());



        return (false);
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
    populateDiagnosisList();
    populateTreatmentList();
    populateMedicalDrugList();
    populateConsultantList();
    populateLabList();



    m_ConnectionStatus = true;



    // Notify QML:
    emit connectionStatusChanged("با موفقیت به پایگاه داده متصل شد.");



    return (true);
}

bool Database::disconnect()
{
#ifdef QT_DEBUG
    QString message("Disconnect request initiated!\n");

    QTextStream stream(&message);
#endif



    // Connection does not exist, abort operation.
    if (m_ConnectionStatus == false)
    {
#ifdef QT_DEBUG
        stream << "Connection does not exist. Aborting operation.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        m_ConnectionStatus = false;



        // Notify QML:
        emit connectionStatusChanged("اتصال وجود ندارد. عملیات متوقف می‌شود.");



        return (true);
    }



    m_QSqlDatabase.close();



#ifdef QT_DEBUG
    stream << "Closing the database connection...\n";

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    m_ConnectionStatus = false;



    // Notify QML:
    emit connectionStatusChanged("از پایگاه داده قطع ارتباط شد.");



    return (true);
}

// INSERT
bool Database::createPatient(const QString &firstName, const QString &lastName, quint32 birthYear, const QString &phoneNumber, const QString &gender, const QString &maritalStatus)
{
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



    query.bindValue(":first_name", firstName);
    query.bindValue(":last_name", lastName);
    query.bindValue(":birth_year", birthYear);
    query.bindValue(":phone_number", phoneNumber);
    query.bindValue(":gender", gender);
    query.bindValue(":marital_status", maritalStatus);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text() + "\n" + message);
#endif



        emit queryExecuted(QueryType::CREATE, false, "در حین عملیات مشکلی پیش آمد: " + query.lastError().text());



        return (false);
    }



    if (query.numRowsAffected() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "The record already exists and was not inserted.\n" + message);
#endif



        // Notify QML:
        emit queryExecuted(QueryType::CREATE, false, "بیمار قبلاً وجود دارد و وارد نشد.");



        return(false);
    }



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    // Notify QML:
    emit queryExecuted(QueryType::CREATE, true, "رکورد بیمار با موفقیت وارد شد.");



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
        patientMap["service_price"] = query.value("service_price").toDouble();



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
        patientMap["service_price"] = query.value("service_price").toDouble();



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
        patientMap["service_price"] = query.value("service_price").toDouble();



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
        patientMap["service_price"] = query.value("service_price").toDouble();



        m_SearchResultList.append(patientMap);
    }



    // Notify QML:
    emit queryExecuted(QueryType::SEARCH, true, "Search query executed successfully.");



    return (true);
}

// SELECT
bool Database::pullPatientData(const quint64 index)
{
    bool basicDataPullOutcome = pullPatientBasicData(index);

    bool diagnosesPullOutcome = pullPatientDiagnoses(index);

    bool treatmentsPullOutcome = pullPatientTreatments(index);

    bool medicalDrugsPullOutcome = pullPatientMedicalDrugs(index);

    bool diagnosisNotePullOutcome = pullDiagnosisNote(index);

    bool treatmentNotePullOutcome = pullTreatmentNote(index);

    bool medicalDrugNotePullOutcome = pullMedicalDrugNote(index);

    bool consultationsPullOutcome = pullConsultations(index);

    bool labTestsPullOutcome = pullLabTests(index);



    if(basicDataPullOutcome == false || diagnosesPullOutcome == false || treatmentsPullOutcome == false || medicalDrugsPullOutcome == false || diagnosisNotePullOutcome == false || treatmentNotePullOutcome == false || medicalDrugNotePullOutcome == false || consultationsPullOutcome == false || labTestsPullOutcome == false)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Errors occured while pulling patient data!");
#endif



        // Notify QML:
        emit patientDataPushed(false, "خطاهایی هنگام دریافت اطلاعات بیمار رخ داد. لطفاً دوباره تلاش کنید.");



        return (false);
    }



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Patient data successfully pulled from database!");
#endif



    // Notify QML:
    emit patientDataPulled(true, "اطلاعات بیمار با موفقیت از پایگاه داده دریافت شد.");



    return (true);
}

bool Database::pullPatientBasicData(const quint64 index)
{
#ifdef QT_DEBUG
    QString message("Basic Data pull initiated!\n");

    QTextStream stream(&message);

    stream << "The patient_id is: " + QString::number(index) + "\n";
#endif



    QString queryString = R"(
        SELECT * FROM patients

        WHERE patients.patient_id = :patient_id
    )";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    query.bindValue(":patient_id", index);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text() << "\n";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    while (query.next())
    {
        // Basic patient data
        m_PatientDataMap["patient_id"] = query.value("patient_id").toULongLong();
        m_PatientDataMap["first_name"] = query.value("first_name").toString();
        m_PatientDataMap["last_name"] = query.value("last_name").toString();
        m_PatientDataMap["birth_year"] = query.value("birth_year").toString();
        m_PatientDataMap["phone_number"] = query.value("phone_number").toString();
        m_PatientDataMap["gender"] = query.value("gender").toString();
        m_PatientDataMap["marital_status"] = query.value("marital_status").toString();
        m_PatientDataMap["number_of_previous_visits"] = query.value("number_of_previous_visits").toUInt();
        m_PatientDataMap["service_price"] = query.value("service_price").toReal();
        m_PatientDataMap["marked_for_deletion"] = query.value("marked_for_deletion").toBool();

        // Dates need to be converted to Jalali:
        QDate firstVisitDate = query.value("first_visit_date").toDate();
        QDate recentVisitDate = query.value("recent_visit_date").toDate();


        if(!firstVisitDate.isNull())
        {
            QCalendar::YearMonthDay fvdgregorianYMD(firstVisitDate.year(), firstVisitDate.month(), firstVisitDate.day());

            QCalendar::YearMonthDay firstVisitDateJalili = Date::cppInstance()->gregorianToJalali(fvdgregorianYMD);

            QString firstVisitDateString = QString("%1-%2-%3")
                                               .arg(firstVisitDateJalili.year, 4, 10, QChar('0'))
                                               .arg(firstVisitDateJalili.month, 2, 10, QChar('0'))
                                               .arg(firstVisitDateJalili.day, 2, 10, QChar('0'));

            m_PatientDataMap["first_visit_date"] = firstVisitDateString;
        }

        else
        {
            m_PatientDataMap["first_visit_date"] = "";
        }

        if(!recentVisitDate.isNull())
        {
            QCalendar::YearMonthDay rvdgregorianYMD(recentVisitDate.year(), recentVisitDate.month(), recentVisitDate.day());

            QCalendar::YearMonthDay recentVisitDateJalili = Date::cppInstance()->gregorianToJalali(rvdgregorianYMD);

            QString recentVisitDateString = QString("%1-%2-%3")
                                                .arg(recentVisitDateJalili.year, 4, 10, QChar('0'))
                                                .arg(recentVisitDateJalili.month, 2, 10, QChar('0'))
                                                .arg(recentVisitDateJalili.day, 2, 10, QChar('0'));

            m_PatientDataMap["recent_visit_date"] = recentVisitDateString;
        }

        else
        {
            m_PatientDataMap["recent_visit_date"] = "";
        }
    }



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::pullPatientDiagnoses(const quint64 index)
{
#ifdef QT_DEBUG
    QString message("Diagnoses pull initiated!\n");

    QTextStream stream(&message);

    stream << "The patient_id is: " + QString::number(index) + "\n";
#endif



    QString queryString = R"(
        SELECT * FROM patients

        LEFT JOIN patient_diagnoses ON patients.patient_id = patient_diagnoses.patient_id
        LEFT JOIN diagnoses ON diagnoses.diagnosis_id = patient_diagnoses.diagnosis_id

        WHERE patients.patient_id = :patient_id
    )";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    query.bindValue(":patient_id", index);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text() << "\n";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    QVariantList diagnoses;



    while (query.next())
    {
        if (!query.value("diagnosis_id").isNull() && !query.value("diagnoses.name").isNull())
        {
            QVariantMap diagnosisMap;

            diagnosisMap["diagnosis_id"] = query.value("diagnosis_id").toULongLong();
            diagnosisMap["name"] = query.value("diagnoses.name").toString().trimmed();

            diagnoses.append(diagnosisMap);
        }
    }



    m_PatientDataMap["diagnoses"] = diagnoses;



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::pullPatientTreatments(const quint64 index)
{
#ifdef QT_DEBUG
    QString message("Treatments pull initiated!\n");

    QTextStream stream(&message);

    stream << "The patient_id is: " + QString::number(index) + "\n";
#endif



    QString queryString = R"(
        SELECT * FROM patients

        LEFT JOIN patient_treatments ON patients.patient_id = patient_treatments.patient_id
        LEFT JOIN treatments ON treatments.treatment_id = patient_treatments.treatment_id

        WHERE patients.patient_id = :patient_id
    )";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    query.bindValue(":patient_id", index);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text() << "\n";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    QVariantList treatments;



    while (query.next())
    {
        if (!query.value("treatment_id").isNull() && !query.value("treatments.name").isNull())
        {
            QVariantMap treatmentMap;

            treatmentMap["treatment_id"] = query.value("treatment_id").toULongLong();
            treatmentMap["name"] = query.value("treatments.name").toString().trimmed();

            treatments.append(treatmentMap);
        }
    }



    m_PatientDataMap["treatments"] = treatments;



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::pullPatientMedicalDrugs(const quint64 index)
{
#ifdef QT_DEBUG
    QString message("Medical Drugs pull initiated!\n");

    QTextStream stream(&message);

    stream << "The patient_id is: " + QString::number(index) + "\n";
#endif



    QString queryString = R"(
        SELECT * FROM patients

        LEFT JOIN patient_medical_drugs ON patients.patient_id = patient_medical_drugs.patient_id
        LEFT JOIN medical_drugs ON medical_drugs.medical_drug_id = patient_medical_drugs.medical_drug_id

        WHERE patients.patient_id = :patient_id
    )";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    query.bindValue(":patient_id", index);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text() << "\n";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    QVariantList medicalDrugs;



    while (query.next())
    {
        if (!query.value("medical_drug_id").isNull() && !query.value("medical_drugs.name").isNull())
        {
            QVariantMap medicalDrugMap;

            medicalDrugMap["medical_drug_id"] = query.value("medical_drug_id").toULongLong();
            medicalDrugMap["name"] = query.value("medical_drugs.name").toString().trimmed();

            medicalDrugs.append(medicalDrugMap);
        }
    }



    m_PatientDataMap["medicalDrugs"] = medicalDrugs;



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::pullDiagnosisNote(const quint64 index)
{
#ifdef QT_DEBUG
    QString message("Diagnosis Note pull initiated!\n");

    QTextStream stream(&message);

    stream << "The patient_id is: " + QString::number(index) + "\n";
#endif



    QString queryString = R"(
        SELECT note FROM diagnosis_notes

        WHERE patient_id = :patient_id;
    )";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    query.bindValue(":patient_id", index);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text() << "\n";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    while (query.next())
    {
        m_PatientDataMap["diagnosis_note"] = query.value("note").toString();
    }



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::pullTreatmentNote(const quint64 index)
{
#ifdef QT_DEBUG
    QString message("Treatment Note pull initiated!\n");

    QTextStream stream(&message);

    stream << "The patient_id is: " + QString::number(index) + "\n";
#endif



    QString queryString = R"(
        SELECT note FROM treatment_notes

        WHERE patient_id = :patient_id;
    )";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    query.bindValue(":patient_id", index);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text() << "\n";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    while (query.next())
    {
        m_PatientDataMap["treatment_note"] = query.value("note").toString();
    }



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::pullMedicalDrugNote(const quint64 index)
{
#ifdef QT_DEBUG
    QString message("Medical Drug Note pull initiated!\n");

    QTextStream stream(&message);

    stream << "The patient_id is: " + QString::number(index) + "\n";
#endif



    QString queryString = R"(
        SELECT note FROM medical_drug_notes

        WHERE patient_id = :patient_id;
    )";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    query.bindValue(":patient_id", index);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text() << "\n";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    while (query.next())
    {
        m_PatientDataMap["medical_drug_note"] = query.value("note").toString();
    }



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::pullConsultations(const quint64 index)
{
#ifdef QT_DEBUG
    QString message("Consultations pull initiated!\n");

    QTextStream stream(&message);

    stream << "The patient_id is: " + QString::number(index) + "\n";
#endif



    QString queryString = R"(
        SELECT * FROM patients

        LEFT JOIN patient_consultations ON patients.patient_id = patient_consultations.patient_id
        LEFT JOIN consultants ON consultants.consultant_id = patient_consultations.consultant_id

        WHERE patients.patient_id = :patient_id
    )";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    query.bindValue(":patient_id", index);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text() << "\n";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    QVariantList consultations;



    while (query.next())
    {
        if (!query.value("consultant_id").isNull() && !query.value("consultants.name").isNull())
        {
            QVariantMap consultantMap;

            consultantMap["consultant_id"] = query.value("consultant_id").toULongLong();
            consultantMap["consultant_name"] = query.value("consultants.name").toString().trimmed();
            consultantMap["consultant_specialization"] = query.value("consultants.specialization").toString().trimmed();
            consultantMap["consultation_outcome"] = query.value("consultation_outcome").toString().trimmed();

            // Converting date to jalali:
            QDate outcomeDate = query.value("consultation_date").toDate();

            if(!outcomeDate.isNull())
            {
                QCalendar::YearMonthDay fvdgregorianYMD(outcomeDate.year(), outcomeDate.month(), outcomeDate.day());

                QCalendar::YearMonthDay firstVisitDateJalili = Date::cppInstance()->gregorianToJalali(fvdgregorianYMD);

                QString firstVisitDateString = QString("%1-%2-%3")
                                                   .arg(firstVisitDateJalili.year, 4, 10, QChar('0'))
                                                   .arg(firstVisitDateJalili.month, 2, 10, QChar('0'))
                                                   .arg(firstVisitDateJalili.day, 2, 10, QChar('0'));

                consultantMap["consultation_date"] = firstVisitDateString;
            }

            else
            {
                consultantMap["consultation_date"] = "";
            }


            consultations.append(consultantMap);
        }
    }



    m_PatientDataMap["consultations"] = consultations;



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::pullLabTests(const quint64 index)
{
#ifdef QT_DEBUG
    QString message("Lab Tests pull initiated!\n");

    QTextStream stream(&message);

    stream << "The patient_id is: " + QString::number(index) + "\n";
#endif



    QString queryString = R"(
        SELECT * FROM patients

        LEFT JOIN patient_lab_tests ON patients.patient_id = patient_lab_tests.patient_id
        LEFT JOIN labs ON labs.lab_id = patient_lab_tests.lab_id

        WHERE patients.patient_id = :patient_id
    )";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    query.bindValue(":patient_id", index);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text() << "\n";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    QVariantList labTests;



    while (query.next())
    {
        if (!query.value("lab_id").isNull() && !query.value("labs.name").isNull())
        {
            QVariantMap labTestMap;

            labTestMap["lab_id"] = query.value("lab_id").toULongLong();
            labTestMap["lab_name"] = query.value("labs.name").toString().trimmed();
            labTestMap["lab_specialization"] = query.value("labs.specialization").toString().trimmed();
            labTestMap["lab_test_outcome"] = query.value("lab_test_outcome").toString().trimmed();

            // Converting date to jalali:
            QDate outcomeDate = query.value("lab_test_date").toDate();

            if(!outcomeDate.isNull())
            {
                QCalendar::YearMonthDay fvdgregorianYMD(outcomeDate.year(), outcomeDate.month(), outcomeDate.day());

                QCalendar::YearMonthDay firstVisitDateJalili = Date::cppInstance()->gregorianToJalali(fvdgregorianYMD);

                QString firstVisitDateString = QString("%1-%2-%3")
                                                   .arg(firstVisitDateJalili.year, 4, 10, QChar('0'))
                                                   .arg(firstVisitDateJalili.month, 2, 10, QChar('0'))
                                                   .arg(firstVisitDateJalili.day, 2, 10, QChar('0'));

                labTestMap["lab_test_date"] = firstVisitDateString;
            }

            else
            {
                labTestMap["lab_test_date"] = "";
            }


            labTests.append(labTestMap);
        }
    }



    m_PatientDataMap["labTests"] = labTests;



#ifdef QT_DEBUG
    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

// UPDATE
bool Database::updatePatientData(const QString &newFirstName, const QString &newLastName, quint32 newBirthYear, const QString &newPhoneNumber, const QString &newGender, const QString &newMaritalStatus, quint32 newNumberOfPreviousVisits, const QString &newFirstVisitDate, const QString &newRecentVisitDate, qreal newServicePrice, const QVariantList &newDiagnoses, const QString &newDiagnosisNote, const QVariantList &newTreatments, const QString &newTreatmentNote, const QVariantList &newMedicalDrugs, const QString &newMedicalDrugNote, const QVariantList &newConsultations)
{
    if(!m_QSqlDatabase.transaction())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Failed to start transaction!");
#endif



        // Notify QML:
        emit patientDataPushed(false, "Failed to start transaction!");



        return (false);
    }



    bool basicDataUpdateOutcome = updateBasicData(newFirstName, newLastName, newBirthYear, newPhoneNumber, newGender, newMaritalStatus, newNumberOfPreviousVisits, newFirstVisitDate, newRecentVisitDate, newServicePrice);

    bool diagnosesUpdateOutcome = updateDiagnoses(newDiagnoses);

    bool treatmentsUpdateOutcome = updateTreatments(newTreatments);

    bool medicalDrugsUpdateOutcome = updateMedicalDrugs(newMedicalDrugs);

    bool diagnosisNoteUpdateOutcome = updateDiagnosisNote(newDiagnosisNote);

    bool treatmentNoteUpdateOutcome = updateTreatmentNote(newTreatmentNote);

    bool medicalDrugNoteUpdateOutcome = updateMedicalDrugNote(newMedicalDrugNote);

    bool consultationsUpdateOutcome = updateConsultations(newConsultations);


    if(basicDataUpdateOutcome == false)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Basic Data update failed!");
#endif



        emit patientDataPushed(false, "Basic Data update failed!");



        m_QSqlDatabase.rollback();



        return (false);
    }

    if(diagnosesUpdateOutcome == false)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Diagnoses update failed!");
#endif



        emit patientDataPushed(false, "Diagnoses update failed!");



        m_QSqlDatabase.rollback();



        return (false);
    }

    if(treatmentsUpdateOutcome == false)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Treatment update failed!");
#endif



        emit patientDataPushed(false, "Treatment update failed!");



        m_QSqlDatabase.rollback();



        return (false);
    }

    if(medicalDrugsUpdateOutcome == false)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Medical Drug update failed!");
#endif



        emit patientDataPushed(false, "Medical Drug update failed!");



        m_QSqlDatabase.rollback();



        return (false);
    }

    if(diagnosisNoteUpdateOutcome == false)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Diagnosis note update failed!");
#endif



        emit patientDataPushed(false, "Diagnosis note update failed!");



        m_QSqlDatabase.rollback();



        return (false);
    }

    if(treatmentNoteUpdateOutcome == false)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Treatment note update failed!");
#endif



        emit patientDataPushed(false, "Treatment note update failed!");



        m_QSqlDatabase.rollback();



        return (false);
    }

    if(medicalDrugNoteUpdateOutcome == false)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Medical Drug note update failed!");
#endif



        emit patientDataPushed(false, "Medical Drug note update failed!");



        m_QSqlDatabase.rollback();



        return (false);
    }

    if(consultationsUpdateOutcome == false)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Consultations update failed!");
#endif



        emit patientDataPushed(false, "Consultations update failed!");



        m_QSqlDatabase.rollback();



        return (false);
    }



    bool commitSuccessful = m_QSqlDatabase.commit();

    if(!commitSuccessful)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Commit failed!");
#endif



        // Notify QML:
        emit patientDataPushed(true, "Commit failed!");



        return (false);
    }



    // Notify QML:
    emit patientDataPushed(true, "Data successfully pushed to database.");



    return (true);
}

bool Database::updateBasicData(const QString &newFirstName, const QString &newLastName, quint32 newBirthYear, const QString &newPhoneNumber, const QString &newGender, const QString &newMaritalStatus, quint32 newNumberOfPreviousVisits, const QString &newFirstVisitDate, const QString &newRecentVisitDate, qreal newServicePrice)
{
#ifdef QT_DEBUG
    QString message("Basic Data update requested!\n");

    QTextStream stream(&message);

    stream << "first_name                : " << newFirstName              << "\n";
    stream << "last_name                 : " << newLastName               << "\n";
    stream << "phone_number              : " << newPhoneNumber            << "\n";
    stream << "birth_year                : " << newBirthYear              << "\n";
    stream << "gender                    : " << newGender                 << "\n";
    stream << "marital_status            : " << newMaritalStatus          << "\n";
    stream << "number_of_previous_visits : " << newNumberOfPreviousVisits << "\n";
    stream << "first_visit_date          : " << newFirstVisitDate         << "\n";
    stream << "recent_visit_date         : " << newRecentVisitDate        << "\n";
    stream << "service_price             : " << newServicePrice           << "\n";
#endif



    QString queryString = "UPDATE patients SET first_name = :first_name, last_name = :last_name, birth_year = :birth_year, phone_number = :phone_number, gender = :gender, marital_status = :marital_status, number_of_previous_visits = :number_of_previous_visits, first_visit_date = :first_visit_date, recent_visit_date = :recent_visit_date, service_price = :service_price WHERE patient_id = :patient_id";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    query.bindValue(":first_name", newFirstName);
    query.bindValue(":last_name", newLastName);
    query.bindValue(":birth_year", newBirthYear);
    query.bindValue(":phone_number", newPhoneNumber);
    query.bindValue(":gender", newGender);
    query.bindValue(":marital_status", newMaritalStatus);
    query.bindValue(":number_of_previous_visits", newNumberOfPreviousVisits);
    query.bindValue(":first_visit_date", QDate::fromString(newFirstVisitDate, "yyyy-mm-dd"));
    query.bindValue(":recent_visit_date", QDate::fromString(newRecentVisitDate, "yyyy-mm-dd"));
    query.bindValue(":service_price", newServicePrice);
    query.bindValue(":patient_id", m_PatientDataMap["patient_id"]);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        stream << "Query returned no results.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



#ifdef QT_DEBUG
    stream << "Basic Data update successful";

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::updateDiagnoses(const QVariantList &newDiagnoses)
{
#ifdef QT_DEBUG
    QString message("Diagnoses List update requested!\n");

    QTextStream stream(&message);

    for (const QVariant &item : newDiagnoses)
    {
        stream << "diagnosis_id: " << item.toString() << "\n";
    }
#endif



    QSqlQuery queryDelete(m_QSqlDatabase);
    queryDelete.prepare("DELETE FROM patient_diagnoses WHERE patient_id = :patient_id");



    queryDelete.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());



    if (!queryDelete.exec())
    {
#ifdef QT_DEBUG
        stream << queryDelete.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (newDiagnoses.isEmpty())
    {
#ifdef QT_DEBUG
        stream << "Diagnoses list received is empty! Patient requires no diagnoses.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (true); // If the list is empty, then the doctor decided to assign no diagnoses to the current patient. Technically, the operation is not a failure.
    }



    QString queryString = "INSERT INTO patient_diagnoses (patient_id, diagnosis_id) VALUES (?, ?)";
    QSqlQuery queryInsert(m_QSqlDatabase);


    queryInsert.prepare(queryString);



    QVariantList patientIDs;
    QVariantList diagnosisIDs;

    for (const QVariant &item : newDiagnoses)
    {
        patientIDs.append(m_PatientDataMap["patient_id"].toULongLong());
        diagnosisIDs.append(item.toULongLong());
    }



    queryInsert.addBindValue(patientIDs);
    queryInsert.addBindValue(diagnosisIDs);



    if (!queryInsert.execBatch())
    {
#ifdef QT_DEBUG
        stream << queryInsert.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return false;
    }



#ifdef QT_DEBUG
    stream << "Diagnoses List updated successfully!";

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::updateTreatments(const QVariantList &newTreatments)
{
#ifdef QT_DEBUG
    QString message("Treatment List update requested!\n");

    QTextStream stream(&message);

    for (const QVariant &item : newTreatments)
    {
        stream << "treatment_id: " << item.toString() << "\n";
    }
#endif



    QSqlQuery queryDelete(m_QSqlDatabase);
    queryDelete.prepare("DELETE FROM patient_treatments WHERE patient_id = :patient_id");



    queryDelete.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());



    if (!queryDelete.exec())
    {
#ifdef QT_DEBUG
        stream << queryDelete.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (newTreatments.isEmpty())
    {
#ifdef QT_DEBUG
        stream << "Treatment list received is empty! Patient requires no treatments.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (true); // If the list is empty, then the doctor decided to assign no treatments to the current patient. Technically, the operation is not a failure.
    }



    QString queryString = "INSERT INTO patient_treatments (patient_id, treatment_id) VALUES (?, ?)";
    QSqlQuery queryInsert(m_QSqlDatabase);


    queryInsert.prepare(queryString);



    QVariantList patientIDs;
    QVariantList treatmentIDs;

    for (const QVariant &item : newTreatments)
    {
        patientIDs.append(m_PatientDataMap["patient_id"].toULongLong());
        treatmentIDs.append(item.toULongLong());
    }



    queryInsert.addBindValue(patientIDs);
    queryInsert.addBindValue(treatmentIDs);



    if (!queryInsert.execBatch())
    {
#ifdef QT_DEBUG
        stream << queryInsert.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return false;
    }



#ifdef QT_DEBUG
    stream << "Treatment List updated successfully!";

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::updateMedicalDrugs(const QVariantList &newMedicalDrugs)
{
#ifdef QT_DEBUG
    QString message("Medical Drugs List update requested!\n");

    QTextStream stream(&message);

    for (const QVariant &item : newMedicalDrugs)
    {
        stream << "medical_drug_id: " << item.toString() << "\n";
    }
#endif



    QSqlQuery queryDelete(m_QSqlDatabase);
    queryDelete.prepare("DELETE FROM patient_medical_drugs WHERE patient_id = :patient_id");



    queryDelete.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());



    if (!queryDelete.exec())
    {
#ifdef QT_DEBUG
        stream << queryDelete.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (newMedicalDrugs.isEmpty())
    {
#ifdef QT_DEBUG
        stream << "Medical Drug list received is empty! Patient requires no medical drugs.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (true); // If the list is empty, then the doctor decided to assign no medical drugs to the current patient. Technically, the operation is not a failure.
    }



    QString queryString = "INSERT INTO patient_medical_drugs (patient_id, medical_drug_id) VALUES (?, ?)";
    QSqlQuery queryInsert(m_QSqlDatabase);


    queryInsert.prepare(queryString);



    QVariantList patientIDs;
    QVariantList medicalDrugIDs;

    for (const QVariant &item : newMedicalDrugs)
    {
        patientIDs.append(m_PatientDataMap["patient_id"].toULongLong());
        medicalDrugIDs.append(item.toULongLong());
    }



    queryInsert.addBindValue(patientIDs);
    queryInsert.addBindValue(medicalDrugIDs);



    if (!queryInsert.execBatch())
    {
#ifdef QT_DEBUG
        stream << queryInsert.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return false;
    }



#ifdef QT_DEBUG
    stream << "Medical Drug List updated successfully!";

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::updateDiagnosisNote(const QString &newNote)
{
#ifdef QT_DEBUG
    QString message("Diagnosis Note update requested!\n");

    QTextStream stream(&message);
#endif



    QSqlQuery query(m_QSqlDatabase);
    query.prepare("UPDATE diagnosis_notes SET note = :note WHERE patient_id = :patient_id");



    query.bindValue(":note", newNote);
    query.bindValue(":patient_id", m_PatientDataMap["patient_id"]);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



#ifdef QT_DEBUG
    stream << "Diagnosis note updated successfully!";

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::updateTreatmentNote(const QString &newNote)
{
#ifdef QT_DEBUG
    QString message("Treatment Note update requested!\n");

    QTextStream stream(&message);
#endif



    QSqlQuery query(m_QSqlDatabase);
    query.prepare("UPDATE treatment_notes SET note = :note WHERE patient_id = :patient_id");



    query.bindValue(":note", newNote);
    query.bindValue(":patient_id", m_PatientDataMap["patient_id"]);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



#ifdef QT_DEBUG
    stream << "Treatment note updated successfully!";

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::updateMedicalDrugNote(const QString &newNote)
{
#ifdef QT_DEBUG
    QString message("Medical Drug Note update requested!\n");

    QTextStream stream(&message);
#endif



    QSqlQuery query(m_QSqlDatabase);
    query.prepare("UPDATE medical_drug_notes SET note = :note WHERE patient_id = :patient_id");



    query.bindValue(":note", newNote);
    query.bindValue(":patient_id", m_PatientDataMap["patient_id"]);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



#ifdef QT_DEBUG
    stream << "Medical Drug note updated successfully!";

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

bool Database::updateConsultations(const QVariantList &newConsultations)
{
#ifdef QT_DEBUG
    QString message("Consultations List update requested!\n");

    QTextStream stream(&message);

    for (const QVariant &item : newConsultations)
    {
        QVariantMap map = item.toMap();

        stream << "consultant_id: " << map["consultant_id"].toString() << "\n";
        stream << "consultation_date: " << map["consultation_date"].toString() << "\n";
        stream << "consultation_outcome: " << map["consultation_outcome"].toString() << "\n";
    }
#endif



    QSqlQuery queryDelete(m_QSqlDatabase);
    queryDelete.prepare("DELETE FROM patient_consultations WHERE patient_id = :patient_id");



    queryDelete.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());



    if (!queryDelete.exec())
    {
#ifdef QT_DEBUG
        stream << queryDelete.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (false);
    }



    if (newConsultations.isEmpty())
    {
#ifdef QT_DEBUG
        stream << "Consultation list received is empty! Patient requires no treatments.";

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return (true); // If the list is empty, then the doctor decided to assign no treatments to the current patient. Technically, the operation is not a failure.
    }



    QString queryString = "INSERT INTO patient_consultations (patient_id, consultant_id, consultation_date, consultation_outcome) VALUES (?, ?, ?, ?)";
    QSqlQuery queryInsert(m_QSqlDatabase);


    queryInsert.prepare(queryString);



    QVariantList patientIDs;
    QVariantList consultationIDs;
    QVariantList consultationDates;
    QVariantList consultationOutcomes;

    for (const QVariant &item : newConsultations)
    {
        QVariantMap map = item.toMap();

        patientIDs.append(m_PatientDataMap["patient_id"].toULongLong());
        consultationIDs.append(map["consultant_id"].toULongLong());
        consultationDates.append(map["consultation_date"].toDate());
        consultationOutcomes.append(map["consultation_outcome"].toString());
    }



    queryInsert.addBindValue(patientIDs);
    queryInsert.addBindValue(consultationIDs);
    queryInsert.addBindValue(consultationDates);
    queryInsert.addBindValue(consultationOutcomes);



    if (!queryInsert.execBatch())
    {
#ifdef QT_DEBUG
        stream << queryInsert.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        return false;
    }



#ifdef QT_DEBUG
    stream << "Consultation List updated successfully!";

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    return (true);
}

// DELETION
bool Database::changeDeletionStatus(bool newStatus)
{
#ifdef QT_DEBUG
    QString message("Deletion status change requested!\n");

    QTextStream stream(&message);
#endif



    QSqlQuery query(m_QSqlDatabase);
    QString queryString = "UPDATE patients SET mark_for_deletion = :newStatus WHERE patient_id = :patient_id;";



    query.prepare(queryString);



    query.bindValue(":newStatus", newStatus);
    query.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());



    if (!query.exec())
    {
#ifdef QT_DEBUG
        stream << query.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



        emit queryExecuted(QueryType::DELETE, false, query.lastError().text());



        return (false);
    }



#ifdef QT_DEBUG
    stream << "Deletion status changed successfully.";

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif



    emit queryExecuted(QueryType::DELETE, true, "Deletion status changed successfully.");



    return (true);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PRIVATE Methods
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

bool Database::populateDiagnosisList()
{
    QString queryString = "SELECT * FROM diagnoses WHERE is_active = TRUE";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text());
#endif



        // Notify QML:
        emit diagnosisListPopulated(false, query.lastError().text());



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Query returned no results.");
#endif



        // Notify QML:
        emit diagnosisListPopulated(false, "Query returned no results.");



        return (false);
    }



    m_DiagnosisList.clear();



    while (query.next())
    {
        QVariantMap diagnosisMap;



        diagnosisMap["diagnosis_id"] = query.value("diagnosis_id").toULongLong();
        diagnosisMap["name"] = query.value("name").toString();



        m_DiagnosisList.append(diagnosisMap);
    }



    // Notify QML:
    emit diagnosisListPopulated(true, "Diagnosis list successfully acquired.");



    return (true);
}

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



    m_TreatmentList.clear();



    while (query.next())
    {
        QVariantMap treatmentMap;



        treatmentMap["treatment_id"] = query.value("treatment_id").toULongLong();
        treatmentMap["name"] = query.value("name").toString();



        m_TreatmentList.append(treatmentMap);
    }



    // Notify QML:
    emit treatmentListPopulated(true, "Treatment list successfully acquired.");



    return (true);
}

bool Database::populateMedicalDrugList()
{
    QString queryString = "SELECT * FROM medical_drugs WHERE is_active = TRUE";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text());
#endif



        // Notify QML:
        emit medicalDrugListPopulated(false, query.lastError().text());



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Query returned no results.");
#endif



        // Notify QML:
        emit medicalDrugListPopulated(false, "Query returned no results.");



        return (false);
    }



    m_MedicalDrugList.clear();



    while (query.next())
    {
        QVariantMap medicalDrugMap;



        medicalDrugMap["medical_drug_id"] = query.value("medical_drug_id").toULongLong();
        medicalDrugMap["name"] = query.value("name").toString();



        m_MedicalDrugList.append(medicalDrugMap);
    }



    // Notify QML:
    emit medicalDrugListPopulated(true, "Medical-Drug list successfully acquired.");



    return (true);
}

bool Database::populateConsultantList()
{
    QString queryString = "SELECT * FROM consultants WHERE is_active = TRUE";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text());
#endif



        // Notify QML:
        emit consultantListPopulated(false, query.lastError().text());



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Query returned no results.");
#endif



        // Notify QML:
        emit consultantListPopulated(false, "Query returned no results.");



        return (false);
    }



    m_ConsultantList.clear();



    while (query.next())
    {
        QVariantMap consultantMap;



        consultantMap["consultant_id"] = query.value("consultant_id").toULongLong();
        consultantMap["name"] = query.value("name").toString();
        consultantMap["specialization"] = query.value("specialization").toString();



        m_ConsultantList.append(consultantMap);
    }



    // Notify QML:
    emit consultantListPopulated(true, "Consultant list successfully acquired.");



    return (true);
}

bool Database::populateLabList()
{
    QString queryString = "SELECT * FROM labs WHERE is_active = TRUE";



    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);



    if (!query.exec())
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, query.lastError().text());
#endif



        // Notify QML:
        emit labListPopulated(false, query.lastError().text());



        return (false);
    }



    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, "Query returned no results.");
#endif



        // Notify QML:
        emit labListPopulated(false, "Query returned no results.");



        return (false);
    }



    m_LabList.clear();



    while (query.next())
    {
        QVariantMap labMap;



        labMap["lab_id"] = query.value("lab_id").toULongLong();
        labMap["name"] = query.value("name").toString();
        labMap["specialization"] = query.value("specialization").toString();



        m_LabList.append(labMap);
    }



    // Notify QML:
    emit labListPopulated(true, "Lab list successfully acquired.");



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

QVariantList Database::getDiagnosisList() const
{
    return (m_DiagnosisList);
}

QVariantList Database::getTreatmentList() const
{
    return (m_TreatmentList);
}

QVariantList Database::getMedicalDrugList() const
{
    return (m_MedicalDrugList);
}

QVariantList Database::getConsultantList() const
{
    return (m_ConsultantList);
}

QVariantList Database::getLabList() const
{
    return (m_LabList);
}

QVariantList Database::getSearchResultList() const
{
    return (m_SearchResultList);
}

QVariantMap Database::getPatientDataMap() const
{
    return (m_PatientDataMap);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]
