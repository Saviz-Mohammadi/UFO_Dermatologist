#ifdef QT_DEBUG
    #include <QDebug>
#endif

#include "database.hpp"
#include "date.hpp"
#include <array>

Database *Database::m_Instance = Q_NULLPTR;

// Constructors, Init, ShutDown, Destructor
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

Database::Database(QObject *parent, const QString &name)
    : QObject{parent}
    , m_QSqlDatabase(QSqlDatabase{})
    , m_ConnectionStatus(false)
    , m_DiagnosisList(QVariantList{})
    , m_TreatmentList(QVariantList{})
    , m_MedicalDrugList(QVariantList{})
    , m_ProcedureList(QVariantList{})
    , m_ConsultantList(QVariantList{})
    , m_LabList(QVariantList{})
    , m_ImageList(QVariantList{})
    , m_SearchResultList(QVariantList{})
    , m_PatientDataMap(QVariantMap{})
{
    this->setObjectName(name);

#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
    qDebug() << "Log Output :" << "List of SQL drivers: " << QSqlDatabase::drivers().join(", ");
#endif
}

Database::~Database()
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
    qDebug() << "Log Output :" << "None";
#endif

    // Shutdown.
    this->disconnectFromDatabase();
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

// NOTE (SAVIZ): Not needed. However, provided just in case.
void Database::Init()
{
    // Init resources;
}

// NOTE (SAVIZ): In Qt, this isn't necessary due to its parent-child memory management system. However, in standard C++, it's a good practice to either explicitly call this when we're done with the object or ensure it gets invoked within the destructor.
void Database::ShutDown()
{
    delete (m_Instance);

    m_Instance = Q_NULLPTR;
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
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "IpAddress :" << ipAddress << ", " << "Port :" << port << ", " << "Schema :" << schema << ", " << "Username :" << username << ", " << "Password :" << password;
#endif

    // Connection exists, abort operation.
    if (m_ConnectionStatus == true)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Connection exists. Aborting operation.";
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
        qDebug() << "Log Output :" << "Connection failed!" << "\n" << m_QSqlDatabase.lastError().text();
#endif

        m_ConnectionStatus = false;

        // Notify QML:
        emit connectionStatusChanged("اتصال برقرار نشد: " + m_QSqlDatabase.lastError().text());

        return (false);
    }

    QPair<bool, QString> populateDiagnosisListResult = populateDiagnosisList();
    QPair<bool, QString> populateTreatmentListResult = populateTreatmentList();
    QPair<bool, QString> populateMedicalListDrugResult = populateMedicalDrugList();
    QPair<bool, QString> populateProcedureListResult = populateProcedureList();
    QPair<bool, QString> populateConsultantListResult = populateConsultantList();
    QPair<bool, QString> populateLabListResult = populateLabList();

    QStringList failedOperations;

    if (populateDiagnosisListResult.first == false)
    {
        failedOperations << populateDiagnosisListResult.second;
    }

    if (populateTreatmentListResult.first == false)
    {
        failedOperations << populateTreatmentListResult.second;
    }

    if (populateMedicalListDrugResult.first == false)
    {
        failedOperations << populateMedicalListDrugResult.second;
    }

    if (populateProcedureListResult.first == false)
    {
        failedOperations << populateProcedureListResult.second;
    }

    if (populateConsultantListResult.first == false)
    {
        failedOperations << populateConsultantListResult.second;
    }

    if (populateLabListResult.first == false)
    {
        failedOperations << populateLabListResult.second;
    }

    if(!failedOperations.isEmpty())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population failed!";
#endif

        m_ConnectionStatus = false;

        // Notify QML:
        emit connectionStatusChanged(QString("اتصال برقرار نشد. خطاهایی در بازیابی لیست‌های داده زیر وجود داشت: %1").arg(failedOperations.join(", ")));

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Connection established!";
#endif

    m_ConnectionStatus = true;

    // Notify QML:
    emit connectionStatusChanged("با موفقیت به پایگاه داده متصل شد.");

    return (true);
}

bool Database::disconnectFromDatabase()
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
#endif

    // Connection does not exist, abort operation.
    if (m_ConnectionStatus == false)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Connection does not exist. Aborting operation.";
#endif

        m_ConnectionStatus = false;

        // Notify QML:
        emit connectionStatusChanged("اتصال وجود ندارد. عملیات متوقف می‌شود.");

        return (true);
    }

    m_QSqlDatabase.close();


#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Closing the database connection...";
#endif

    m_ConnectionStatus = false;

    // Notify QML:
    emit connectionStatusChanged("از پایگاه داده قطع ارتباط شد.");

    return (true);
}

// INSERT
bool Database::createPatient(const QString &firstName, const QString &lastName, quint32 birthYear, const QString &phoneNumber, const QString &email, const QString &gender, const QString &maritalStatus)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "First name :" << firstName << ", " << "Last name :" << lastName << ", " << "Phone number :" << phoneNumber << ", " << "Email: " << email << ", " << "Birth year :" << birthYear << ", " << "Gender :" << gender << ", " << "Marital status :" << maritalStatus;
#endif

    QString queryString = R"(
        INSERT IGNORE INTO patients (first_name, last_name, birth_year, phone_number, email, gender, marital_status, first_visit_date, recent_visit_date)

        VALUES (:first_name, :last_name, :birth_year, :phone_number, :email, :gender, :marital_status, :first_visit_date, :recent_visit_date)
    )";

    QSqlQuery query(m_QSqlDatabase);

    query.prepare(queryString);

    query.bindValue(":first_name", firstName);
    query.bindValue(":last_name", lastName);
    query.bindValue(":birth_year", birthYear);
    query.bindValue(":phone_number", phoneNumber);
    query.bindValue(":email", email);
    query.bindValue(":gender", gender);
    query.bindValue(":marital_status", maritalStatus);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << query.lastError().text();
#endif

        emit queryExecuted(QueryType::CREATE, false, "در حین عملیات مشکلی پیش آمد: " + query.lastError().text());

        return (false);
    }

    if (query.numRowsAffected() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output           :" << "The record already exists and was not inserted!";
        qDebug() << "--------------------------------------------------------------------------------";
#endif

        // Notify QML:
        emit queryExecuted(QueryType::CREATE, false, "بیمار قبلاً وجود دارد و وارد نشد.");

        return(false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Record insertion succeeded!";
#endif

    // Notify QML:
    emit queryExecuted(QueryType::CREATE, true, "رکورد بیمار با موفقیت وارد شد.");

    return (true);
}

// SEARCH
bool Database::findPatient(const quint64 patientID)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Patient ID :" << patientID;
#endif

    QString queryString = "SELECT * FROM patients WHERE patient_id = :patient_id";
    QSqlQuery query(m_QSqlDatabase);

    query.prepare(queryString);

    query.bindValue(":patient_id", patientID);

    m_SearchResultList.clear();

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Search error occured :" << query.lastError().text();
#endif

        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, query.lastError().text());

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, true, "عملیات جستجو هیچ نتیجه‌ای برنگرداند.");

        return (true);
    }

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

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Search operation succeeded!";
#endif

    // Notify QML:
    emit queryExecuted(QueryType::SEARCH, true, "عملیات جستجو با موفقیت انجام شد!");

    return (true);
}

bool Database::findPatient(const QString &firstName, const QString &lastName, quint32 birthYearStart, quint32 birthYearEnd, const QString &phoneNumber, const QString &gender, const QString &maritalStatus)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "First name :" << firstName << ", " << "Last name :" << lastName << ", " << "Birth year start :" << birthYearStart << ", " << "Birth year end :" << birthYearEnd << ", " << "Phone number :" << phoneNumber << ", " << "Gender :" << gender << ", " << "Marital status :" << maritalStatus;
#endif

    QString queryString = "SELECT * FROM patients WHERE 1 = 1";
    QSqlQuery query(m_QSqlDatabase);

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
        qDebug() << "Log Output :" << "Search operation failed! :" << query.lastError().text();
#endif

        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, query.lastError().text());

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, true, "عملیات جستجو هیچ نتیجه‌ای برنگرداند.");

        return (true);
    }

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

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Search operation succeeded!";
#endif

    // Notify QML:
    emit queryExecuted(QueryType::SEARCH, true, "عملیات جستجو با موفقیت انجام شد!");

    return (true);
}

bool Database::findFirstXPatients(const quint64 count)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Count :" << count;
#endif

    QString queryString = "SELECT * FROM patients ORDER BY patient_id ASC LIMIT :count";
    QSqlQuery query(m_QSqlDatabase);

    query.prepare(queryString);

    query.bindValue(":count", count);

    m_SearchResultList.clear();

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Search operation failed! :" << query.lastError().text();
#endif

        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, query.lastError().text());

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, true, "عملیات جستجو هیچ نتیجه‌ای برنگرداند.");

        return (true);
    }

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

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Search operation succeeded!";
#endif

    // Notify QML:
    emit queryExecuted(QueryType::SEARCH, true, "عملیات جستجو با موفقیت انجام شد!");

    return (true);
}

bool Database::findLastXPatients(const quint64 count)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Count :" << count;
#endif

    QString queryString = "SELECT * FROM patients ORDER BY patient_id DESC LIMIT :count";
    QSqlQuery query(m_QSqlDatabase);

    query.prepare(queryString);

    query.bindValue(":count", count);

    m_SearchResultList.clear();

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Search operation failed! :" << query.lastError().text();
#endif

        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, false, query.lastError().text());

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        // Notify QML:
        emit queryExecuted(QueryType::SEARCH, true, "عملیات جستجو هیچ نتیجه‌ای برنگرداند.");

        return (true);
    }

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

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Search operation succeeded!";
#endif

    // Notify QML:
    emit queryExecuted(QueryType::SEARCH, true, "عملیات جستجو با موفقیت انجام شد!");

    return (true);
}

// SELECT
bool Database::pullPatientData(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
#endif

    // NOTE (SAVIZ): This check helps prevent problems when we delete a record and attempt to access it again:

    if(!recordExists(index))
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! " << "No such record to update.";
#endif

        emit queryExecuted(QueryType::SELECT, false, "این پرونده بیمار دیگر در پایگاه داده وجود ندارد.");

        return (false);
    }

    struct FunctionCall
    {
        std::function<bool()> function;

        QString errorMessage;
    };

    const std::array<FunctionCall, 12> calls =
    {{
        { [this, index] { return pullPatientBasicData(index); }, "خطا در دریافت اطلاعات اولیه بیمار" },
        { [this, index] { return pullPatientDiagnoses(index); }, "خطا در دریافت تشخیص‌ها" },
        { [this, index] { return pullPatientTreatments(index); }, "خطا در دریافت درمان‌ها" },
        { [this, index] { return pullPatientMedicalDrugs(index); }, "خطا در دریافت اطلاعات دارویی" },
        { [this, index] { return pullPatientProcedures(index); }, "خطا در دریافت اقدامات پزشکی" },
        { [this, index] { return pullDiagnosisNote(index); }, "خطا در دریافت یادداشت‌های تشخیصی" },
        { [this, index] { return pullTreatmentNote(index); }, "خطا در دریافت یادداشت‌های درمانی" },
        { [this, index] { return pullMedicalDrugNote(index); }, "خطا در دریافت یادداشت‌های دارویی" },
        { [this, index] { return pullProcedureNote(index); }, "خطا در دریافت یادداشت‌های مربوط به اقدامات پزشکی" },
        { [this, index] { return pullConsultations(index); }, "خطا در دریافت مشاوره‌ها" },
        { [this, index] { return pullLabTests(index); }, "خطا در دریافت آزمایش‌ها" },
        { [this, index] { return pullImages(index); }, "خطا در دریافت تصاویر" }
    }};

    const QString prefix = "خطاهایی هنگام دریافت اطلاعات بیمار رخ داد: ";
    const QString suffix = " لطفاً دوباره تلاش کنید.";

    for (const auto& call : calls)
    {
        if (call.function() == false)
        {
            QString fullMessage = prefix + call.errorMessage + suffix;

#ifdef QT_DEBUG
            qDebug() << "Log Output :" << "Select operation failed! : " << call.errorMessage;
#endif

            emit queryExecuted(QueryType::SELECT, false, fullMessage);

            return (false);
        }
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    emit queryExecuted(QueryType::SELECT, true, "اطلاعات بیمار با موفقیت از پایگاه داده دریافت شد.");

    return (true);
}

bool Database::pullPatientBasicData(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
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
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (true);
    }

    while (query.next())
    {
        m_PatientDataMap["patient_id"] = query.value("patient_id").toULongLong();
        m_PatientDataMap["first_name"] = query.value("first_name").toString();
        m_PatientDataMap["last_name"] = query.value("last_name").toString();
        m_PatientDataMap["birth_year"] = query.value("birth_year").toString();
        m_PatientDataMap["phone_number"] = query.value("phone_number").toString();
        m_PatientDataMap["email"] = query.value("email").toString();
        m_PatientDataMap["gender"] = query.value("gender").toString();
        m_PatientDataMap["marital_status"] = query.value("marital_status").toString();
        m_PatientDataMap["number_of_previous_visits"] = query.value("number_of_previous_visits").toUInt();
        m_PatientDataMap["first_visit_date"] = "";
        m_PatientDataMap["recent_visit_date"] = "";
        m_PatientDataMap["expected_visit_date"] = "";
        m_PatientDataMap["service_price"] = query.value("service_price").toReal();
        m_PatientDataMap["marked_for_deletion"] = query.value("marked_for_deletion").toBool();

        // NOTE (SAVIZ): If Gregorian dates are available for the 'first_visit_date' and 'recent_visit_date' fields in the database, they must be converted to the Jalali calendar format before caching:

        QDate firstVisitGregorianDate = query.value("first_visit_date").toDate();

        if(!firstVisitGregorianDate.isNull())
        {
            QString firstVisitJaliliDateString = Date::cppInstance()->gregorianToJalali(firstVisitGregorianDate);

            m_PatientDataMap["first_visit_date"] = firstVisitJaliliDateString;
        }

        QDate recentVisitGregorianDate = query.value("recent_visit_date").toDate();

        if(!recentVisitGregorianDate.isNull())
        {
            QString recentVisitJaliliDateString = Date::cppInstance()->gregorianToJalali(recentVisitGregorianDate);

            m_PatientDataMap["recent_visit_date"] = recentVisitJaliliDateString;
        }

        QDate expectedVisitGregorianDate = query.value("expected_visit_date").toDate();

        if(!expectedVisitGregorianDate.isNull())
        {
            QString expectedVisitJaliliDateString = Date::cppInstance()->gregorianToJalali(expectedVisitGregorianDate);

            m_PatientDataMap["expected_visit_date"] = expectedVisitJaliliDateString;
        }
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    return (true);
}

bool Database::pullPatientDiagnoses(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
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
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (true);
    }

    QVariantList diagnoses;

    while (query.next())
    {
        // WARNING (SAVIZ): 'LEFT JOIN' can produce 'Null' results. Therefore, we need to make sure to check against 'Null':

        if (!query.value("diagnosis_id").isNull() && !query.value("diagnoses.name").isNull())
        {
            QVariantMap diagnosisMap;

            diagnosisMap["diagnosis_id"] = query.value("diagnosis_id").toULongLong();
            diagnosisMap["diagnosis_name"] = query.value("diagnoses.name").toString().trimmed();

            diagnoses.append(diagnosisMap);
        }
    }

    m_PatientDataMap["diagnoses"] = diagnoses;

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    return (true);
}

bool Database::pullPatientTreatments(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
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
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (true);
    }

    QVariantList treatments;

    while (query.next())
    {
        // WARNING (SAVIZ): 'LEFT JOIN' can produce 'Null' results. Therefore, we need to make sure to check against 'Null':

        if (!query.value("treatment_id").isNull() && !query.value("treatments.name").isNull())
        {
            QVariantMap treatmentMap;

            treatmentMap["treatment_id"] = query.value("treatment_id").toULongLong();
            treatmentMap["treatment_name"] = query.value("treatments.name").toString().trimmed();

            treatments.append(treatmentMap);
        }
    }

    m_PatientDataMap["treatments"] = treatments;

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    return (true);
}

bool Database::pullPatientMedicalDrugs(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
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
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (true);
    }

    QVariantList medicalDrugs;

    while (query.next())
    {
        // WARNING (SAVIZ): 'LEFT JOIN' can produce 'Null' results. Therefore, we need to make sure to check against 'Null':

        if (!query.value("medical_drug_id").isNull() && !query.value("medical_drugs.name").isNull())
        {
            QVariantMap medicalDrugMap;

            medicalDrugMap["medical_drug_id"] = query.value("medical_drug_id").toULongLong();
            medicalDrugMap["medical_drug_name"] = query.value("medical_drugs.name").toString().trimmed();

            medicalDrugs.append(medicalDrugMap);
        }
    }

    m_PatientDataMap["medicalDrugs"] = medicalDrugs;

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    return (true);
}

bool Database::pullPatientProcedures(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
#endif

    QString queryString = R"(
        SELECT * FROM patients

        LEFT JOIN patient_procedures ON patients.patient_id = patient_procedures.patient_id
        LEFT JOIN procedures ON procedures.procedure_id = patient_procedures.procedure_id

        WHERE patients.patient_id = :patient_id
    )";

    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);

    query.bindValue(":patient_id", index);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (true);
    }

    QVariantList procedures;

    while (query.next())
    {
        // WARNING (SAVIZ): 'LEFT JOIN' can produce 'Null' results. Therefore, we need to make sure to check against 'Null':

        if (!query.value("procedure_id").isNull() && !query.value("procedures.name").isNull())
        {
            QVariantMap procedureMap;

            procedureMap["procedure_id"] = query.value("procedure_id").toULongLong();
            procedureMap["procedure_name"] = query.value("procedures.name").toString().trimmed();

            procedures.append(procedureMap);
        }
    }

    m_PatientDataMap["procedures"] = procedures;

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    return (true);
}

bool Database::pullDiagnosisNote(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
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
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (true);
    }

    while (query.next())
    {
        m_PatientDataMap["diagnosis_note"] = query.value("note").toString();
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    return (true);
}

bool Database::pullTreatmentNote(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
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
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (true);
    }

    while (query.next())
    {
        m_PatientDataMap["treatment_note"] = query.value("note").toString();
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    return (true);
}

bool Database::pullMedicalDrugNote(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
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
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (true);
    }

    while (query.next())
    {
        m_PatientDataMap["medical_drug_note"] = query.value("note").toString();
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    return (true);
}

bool Database::pullProcedureNote(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
#endif

    QString queryString = R"(
        SELECT note FROM procedure_notes

        WHERE patient_id = :patient_id;
    )";

    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);

    query.bindValue(":patient_id", index);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (true);
    }

    while (query.next())
    {
        m_PatientDataMap["procedure_note"] = query.value("note").toString();
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    return (true);
}

bool Database::pullConsultations(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
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
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (true);
    }

    QVariantList consultations;

    while (query.next())
    {
        // WARNING (SAVIZ): 'LEFT JOIN' can produce 'Null' results. Therefore, we need to make sure to check against 'Null':

        if (!query.value("consultant_id").isNull() && !query.value("consultants.name").isNull())
        {
            QVariantMap consultantMap;

            consultantMap["consultant_id"] = query.value("consultant_id").toULongLong();
            consultantMap["consultant_name"] = query.value("consultants.name").toString().trimmed();
            consultantMap["consultant_specialization"] = query.value("consultants.specialization").toString().trimmed();
            consultantMap["consultation_outcome"] = query.value("consultation_outcome").toString().trimmed();
            consultantMap["consultation_date"] = "";

            // NOTE (SAVIZ): If Gregorian dates are available for the 'first_visit_date' and 'recent_visit_date' fields in the database, they must be converted to the Jalali calendar format before caching:

            QDate outcomeGregorianDate = query.value("consultation_date").toDate();

            if(!outcomeGregorianDate.isNull())
            {
                QString outcomeJaliliDateString = Date::cppInstance()->gregorianToJalali(outcomeGregorianDate);

                consultantMap["consultation_date"] = outcomeJaliliDateString;
            }

            consultations.append(consultantMap);
        }
    }

    m_PatientDataMap["consultations"] = consultations;

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    return (true);
}

bool Database::pullLabTests(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
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
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (true);
    }

    QVariantList labTests;

    while (query.next())
    {
        // WARNING (SAVIZ): 'LEFT JOIN' can produce 'Null' results. Therefore, we need to make sure to check against 'Null':

        if (!query.value("lab_id").isNull() && !query.value("labs.name").isNull())
        {
            QVariantMap labTestMap;

            labTestMap["lab_id"] = query.value("lab_id").toULongLong();
            labTestMap["lab_name"] = query.value("labs.name").toString().trimmed();
            labTestMap["lab_specialization"] = query.value("labs.specialization").toString().trimmed();
            labTestMap["lab_test_outcome"] = query.value("lab_test_outcome").toString().trimmed();
            labTestMap["lab_test_date"] = "";

            // NOTE (SAVIZ): If Gregorian dates are available for the 'first_visit_date' and 'recent_visit_date' fields in the database, they must be converted to the Jalali calendar format before caching:

            QDate testOutcomeGregorianDate = query.value("lab_test_date").toDate();

            if(!testOutcomeGregorianDate.isNull())
            {
                QString testOutcomeJaliliDateString = Date::cppInstance()->gregorianToJalali(testOutcomeGregorianDate);

                labTestMap["lab_test_date"] = testOutcomeJaliliDateString;
            }

            labTests.append(labTestMap);
        }
    }

    m_PatientDataMap["labTests"] = labTests;

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    return (true);
}

bool Database::pullImages(const quint64 index)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "Index :" << index;
#endif

    QString queryString = R"(
        SELECT image_name, image_data FROM patient_images

        WHERE patient_id = :patient_id
    )";

    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);

    query.bindValue(":patient_id", index);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (true);
    }

    QVariantList images;

    while (query.next())
    {
        if (!query.value("image_id").isNull() && !query.value("image_name").isNull())
        {
            QVariantMap imageMap;

            imageMap["image_name"] = query.value("image_name").toString();
            imageMap["image_data"] = query.value("image_data").toByteArray();

            images.append(imageMap);
        }
    }

    m_PatientDataMap["images"] = images;

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Select operation succeeded!";
#endif

    return (true);
}

// UPDATE
bool Database::updatePatientData(const QString& newFirstName, const QString& newLastName, quint32 newBirthYear, const QString& newPhoneNumber, const QString &newEmail, const QString& newGender, const QString& newMaritalStatus, quint32 newNumberOfPreviousVisits, const QString& newFirstVisitDate, const QString& newRecentVisitDate, const QString &newExpectedVisitDate, qreal newServicePrice, const QVariantList& newDiagnoses, const QString& newDiagnosisNote, const QVariantList& newTreatments, const QString& newTreatmentNote, const QVariantList& newMedicalDrugs, const QString& newMedicalDrugNote, const QVariantList& newProcedures, const QString& newProcedureNote, const QVariantList& newConsultations, const QVariantList& newLabTests)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :";
    qDebug() << "    newFirstName          :" << newFirstName;
    qDebug() << "    newLastName           :" << newLastName;
    qDebug() << "    newBirthYear          :" << newBirthYear;
    qDebug() << "    newPhoneNumber        :" << newPhoneNumber;
    qDebug() << "    newEmail              :" << newEmail;
    qDebug() << "    newGender             :" << newGender;
    qDebug() << "    newMaritalStatus      :" << newMaritalStatus;
    qDebug() << "    newNumberOfVisits     :" << newNumberOfPreviousVisits;
    qDebug() << "    newFirstVisitDate     :" << newFirstVisitDate;
    qDebug() << "    newRecentVisitDate    :" << newRecentVisitDate;
    qDebug() << "    newExpectedVisitDate  :" << newExpectedVisitDate;
    qDebug() << "    newServicePrice       :" << newServicePrice;
    qDebug() << "    newDiagnoses          :" << newDiagnoses;
    qDebug() << "    newDiagnosisNote      :" << newDiagnosisNote;
    qDebug() << "    newTreatments         :" << newTreatments;
    qDebug() << "    newTreatmentNote      :" << newTreatmentNote;
    qDebug() << "    newMedicalDrugs       :" << newMedicalDrugs;
    qDebug() << "    newMedicalDrugNote    :" << newMedicalDrugNote;
    qDebug() << "    newProcedures         :" << newProcedures;
    qDebug() << "    newProcedureNote      :" << newProcedureNote;
    qDebug() << "    newConsultations      :" << newConsultations;
    qDebug() << "    newLabTests           :" << newLabTests;
#endif

    // NOTE (SAVIZ): This check helps prevent problems when we delete a record and attempt to access it again:

    if(!recordExists(m_PatientDataMap["patient_id"].toULongLong()))
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! " << "No such record to update.";
#endif

        emit queryExecuted(QueryType::UPDATE, false, "این پرونده بیمار دیگر در پایگاه داده وجود ندارد.");

        return (false);
    }

    const QString prefix = "خطاهایی هنگام به‌روزرسانی اطلاعات بیمار رخ داد: ";
    const QString suffix = " لطفاً دوباره تلاش کنید.";

    if (!m_QSqlDatabase.transaction())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << "Transaction could not be started.";
#endif
        emit queryExecuted(QueryType::UPDATE, false, prefix + "شروع تراکنش شکست خورد!" + suffix);

        return (false);
    }

    struct FunctionCall
    {
        std::function<bool()> function;

        QString errorMessage;
    };

    // Prepare the tasks array
    const std::array<FunctionCall, 12> calls =
    {{
        { std::bind(&Database::updateBasicData, this, newFirstName, newLastName, newBirthYear, newPhoneNumber, newEmail, newGender, newMaritalStatus, newNumberOfPreviousVisits, newFirstVisitDate, newRecentVisitDate, newExpectedVisitDate, newServicePrice), "خطا در به‌روزرسانی اطلاعات اولیه بیمار" },
        { std::bind(&Database::updateDiagnoses, this, newDiagnoses), "خطا در به‌روزرسانی تشخیص‌ها" },
        { std::bind(&Database::updateTreatments, this, newTreatments), "خطا در به‌روزرسانی درمان‌ها" },
        { std::bind(&Database::updateMedicalDrugs, this, newMedicalDrugs), "خطا در به‌روزرسانی داروهای بیمار" },
        { std::bind(&Database::updateProcedures, this, newProcedures), "خطا در به‌روزرسانی اقدامات پزشکی" },
        { std::bind(&Database::updateDiagnosisNote, this, newDiagnosisNote), "خطا در به‌روزرسانی یادداشت‌های تشخیصی" },
        { std::bind(&Database::updateTreatmentNote, this, newTreatmentNote), "خطا در به‌روزرسانی یادداشت‌های درمانی" },
        { std::bind(&Database::updateMedicalDrugNote, this, newMedicalDrugNote), "خطا در به‌روزرسانی یادداشت‌های دارویی" },
        { std::bind(&Database::updateProcedureNote, this, newProcedureNote), "خطا در به‌روزرسانی یادداشت‌های مربوط به اقدامات پزشکی" },
        { std::bind(&Database::updateConsultations, this, newConsultations), "خطا در به‌روزرسانی مشاوره‌ها" },
        { std::bind(&Database::updateLabTests, this, newLabTests), "خطا در به‌روزرسانی آزمایش‌ها" },
        { std::bind(&Database::updateImages, this), "خطا در به‌روزرسانی تصاویر" }
    }};

    for (const auto& call : calls)
    {
        if (!call.function())
        {
#ifdef QT_DEBUG
            qDebug() << "Log Output :" << "Update operation failed! :" << call.errorMessage;
#endif

            emit queryExecuted(QueryType::UPDATE, false, prefix + call.errorMessage + suffix);

            m_QSqlDatabase.rollback();

            return (false);
        }
    }

    if (!m_QSqlDatabase.commit())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << "Commit failed!";
#endif

        emit queryExecuted(QueryType::UPDATE, false, "تأیید تغییرات شکست خورد!");

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Update operation succeeded!";
#endif

    emit queryExecuted(QueryType::UPDATE, true, "اطلاعات با موفقیت به‌روزرسانی شد.");

    return (true);
}

bool Database::updateBasicData(const QString &newFirstName, const QString &newLastName, quint32 newBirthYear, const QString &newPhoneNumber, const QString &newEmail, const QString &newGender, const QString &newMaritalStatus, quint32 newNumberOfPreviousVisits, const QString &newFirstVisitDate, const QString &newRecentVisitDate, const QString &newExpectedVisitDate, qreal newServicePrice)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :";
    qDebug() << "    newFirstName          :" << newFirstName;
    qDebug() << "    newLastName           :" << newLastName;
    qDebug() << "    newBirthYear          :" << newBirthYear;
    qDebug() << "    newPhoneNumber        :" << newPhoneNumber;
    qDebug() << "    newEmail              :" << newEmail;
    qDebug() << "    newGender             :" << newGender;
    qDebug() << "    newMaritalStatus      :" << newMaritalStatus;
    qDebug() << "    newNumberOfVisits     :" << newNumberOfPreviousVisits;
    qDebug() << "    newFirstVisitDate     :" << newFirstVisitDate;
    qDebug() << "    newRecentVisitDate    :" << newRecentVisitDate;
    qDebug() << "    newExpectedVisitDate  :" << newExpectedVisitDate;
    qDebug() << "    newServicePrice       :" << newServicePrice;
#endif

    QString queryString = R"(
        UPDATE patients SET
        first_name = :first_name,
        last_name = :last_name,
        birth_year = :birth_year,
        phone_number = :phone_number,
        email = :email,
        gender = :gender,
        marital_status = :marital_status,
        number_of_previous_visits = :number_of_previous_visits,
        first_visit_date = :first_visit_date,
        recent_visit_date = :recent_visit_date,
        expected_visit_date = :expected_visit_date,
        service_price = :service_price

        WHERE patient_id = :patient_id
    )";

    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);

    query.bindValue(":first_name", newFirstName);
    query.bindValue(":last_name", newLastName);
    query.bindValue(":birth_year", newBirthYear);
    query.bindValue(":phone_number", newPhoneNumber);
    query.bindValue(":email", newEmail);
    query.bindValue(":gender", newGender);
    query.bindValue(":marital_status", newMaritalStatus);
    query.bindValue(":number_of_previous_visits", newNumberOfPreviousVisits);
    query.bindValue(":service_price", newServicePrice);
    query.bindValue(":patient_id", m_PatientDataMap["patient_id"]);

    // NOTE (SAVIZ): If Jalali dates are available for the 'first_visit_date' and 'recent_visit_date' arguments, they must be converted to the Gregorian calendar format before caching to the database:

    QCalendar calendarJalali(QCalendar::System::Jalali);

    QDate firstVisitGregorianDate;
    firstVisitGregorianDate = QDate::fromString(newFirstVisitDate, "yyyy-MM-dd", calendarJalali);

    QDate recentVisitGregorianDate;
    recentVisitGregorianDate = QDate::fromString(newRecentVisitDate, "yyyy-MM-dd", calendarJalali);

    QDate expectedVisitGregorianDate;
    expectedVisitGregorianDate = QDate::fromString(newExpectedVisitDate, "yyyy-MM-dd", calendarJalali);

    if(firstVisitGregorianDate.isNull() || !firstVisitGregorianDate.isValid())
    {
        query.bindValue(":first_visit_date", QVariant(QMetaType::fromType<QDate>()));
    }

    else
    {
        query.bindValue(":first_visit_date", firstVisitGregorianDate);
    }

    if(recentVisitGregorianDate.isNull() || !recentVisitGregorianDate.isValid())
    {
        query.bindValue(":recent_visit_date", QVariant(QMetaType::fromType<QDate>()));
    }

    else
    {
        query.bindValue(":recent_visit_date", recentVisitGregorianDate);
    }

    if(expectedVisitGregorianDate.isNull() || !expectedVisitGregorianDate.isValid())
    {
        query.bindValue(":expected_visit_date", QVariant(QMetaType::fromType<QDate>()));
    }

    else
    {
        query.bindValue(":expected_visit_date", expectedVisitGregorianDate);
    }

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "First visit date :" << recentVisitGregorianDate.toString() << ", " << "Recent visit date :" << recentVisitGregorianDate.toString() << ", " << "Update operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "First visit date :" << recentVisitGregorianDate.toString() << ", " << "Recent visit date :" << recentVisitGregorianDate.toString() << ", " << "Update operation succeeded!";
#endif

    return (true);
}

bool Database::updateDiagnoses(const QVariantList &newDiagnoses)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :";
    qDebug() << newDiagnoses;
#endif

    QSqlQuery queryDelete(m_QSqlDatabase);
    queryDelete.prepare("DELETE FROM patient_diagnoses WHERE patient_id = :patient_id");

    queryDelete.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());

    if (!queryDelete.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryDelete.lastError().text();
#endif

        return (false);
    }

    if (newDiagnoses.isEmpty())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Diagnoses list is empty!";
#endif

        return (true);
    }

    QString queryString = "INSERT INTO patient_diagnoses (patient_id, diagnosis_id) VALUES (?, ?)";
    QSqlQuery queryInsert(m_QSqlDatabase);

    queryInsert.prepare(queryString);

    QVariantList patientIDs;
    QVariantList diagnosisIDs;

    for (const QVariant &newDiagnosis : newDiagnoses)
    {
        patientIDs.append(m_PatientDataMap["patient_id"].toULongLong());
        diagnosisIDs.append(newDiagnosis.toULongLong());
    }

    queryInsert.addBindValue(patientIDs);
    queryInsert.addBindValue(diagnosisIDs);

    if (!queryInsert.execBatch())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryInsert.lastError().text();
#endif

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Update operation succeeded!";
#endif

    return (true);
}

bool Database::updateTreatments(const QVariantList &newTreatments)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :";
    qDebug() << newTreatments;
#endif

    QSqlQuery queryDelete(m_QSqlDatabase);
    queryDelete.prepare("DELETE FROM patient_treatments WHERE patient_id = :patient_id");

    queryDelete.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());

    if (!queryDelete.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryDelete.lastError().text();
#endif

        return (false);
    }

    if (newTreatments.isEmpty())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Treatment list is empty!";
#endif

        return (true);
    }

    QString queryString = "INSERT INTO patient_treatments (patient_id, treatment_id) VALUES (?, ?)";
    QSqlQuery queryInsert(m_QSqlDatabase);

    queryInsert.prepare(queryString);

    QVariantList patientIDs;
    QVariantList treatmentIDs;

    for (const QVariant &newTreatment : newTreatments)
    {
        patientIDs.append(m_PatientDataMap["patient_id"].toULongLong());
        treatmentIDs.append(newTreatment.toULongLong());
    }

    queryInsert.addBindValue(patientIDs);
    queryInsert.addBindValue(treatmentIDs);

    if (!queryInsert.execBatch())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryInsert.lastError().text();
#endif

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Update operation succeeded!";
#endif

    return (true);
}

bool Database::updateMedicalDrugs(const QVariantList &newMedicalDrugs)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :";
    qDebug() << newMedicalDrugs;
#endif

    QSqlQuery queryDelete(m_QSqlDatabase);
    queryDelete.prepare("DELETE FROM patient_medical_drugs WHERE patient_id = :patient_id");

    queryDelete.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());

    if (!queryDelete.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryDelete.lastError().text();
#endif

        return (false);
    }

    if (newMedicalDrugs.isEmpty())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Medical drug list is empty!";
#endif

        return (true);
    }

    QString queryString = "INSERT INTO patient_medical_drugs (patient_id, medical_drug_id) VALUES (?, ?)";
    QSqlQuery queryInsert(m_QSqlDatabase);

    queryInsert.prepare(queryString);

    QVariantList patientIDs;
    QVariantList medicalDrugIDs;

    for (const QVariant &newMedicalDrug : newMedicalDrugs)
    {
        patientIDs.append(m_PatientDataMap["patient_id"].toULongLong());
        medicalDrugIDs.append(newMedicalDrug.toULongLong());
    }

    queryInsert.addBindValue(patientIDs);
    queryInsert.addBindValue(medicalDrugIDs);

    if (!queryInsert.execBatch())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryInsert.lastError().text();
#endif

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Update operation succeeded!";
#endif

    return (true);
}

bool Database::updateProcedures(const QVariantList &newProcedures)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :";
    qDebug() << newProcedures;
#endif

    QSqlQuery queryDelete(m_QSqlDatabase);
    queryDelete.prepare("DELETE FROM patient_procedures WHERE patient_id = :patient_id");

    queryDelete.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());

    if (!queryDelete.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryDelete.lastError().text();
#endif

        return (false);
    }

    if (newProcedures.isEmpty())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Procedures list is empty!";
#endif

        return (true);
    }

    QString queryString = "INSERT INTO patient_procedures (patient_id, procedure_id) VALUES (?, ?)";
    QSqlQuery queryInsert(m_QSqlDatabase);

    queryInsert.prepare(queryString);

    QVariantList patientIDs;
    QVariantList procedureIDs;

    for (const QVariant &newProcedure : newProcedures)
    {
        patientIDs.append(m_PatientDataMap["patient_id"].toULongLong());
        procedureIDs.append(newProcedure.toULongLong());
    }

    queryInsert.addBindValue(patientIDs);
    queryInsert.addBindValue(procedureIDs);

    if (!queryInsert.execBatch())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryInsert.lastError().text();
#endif

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Update operation succeeded!";
#endif

    return (true);
}

bool Database::updateDiagnosisNote(const QString &newNote)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "newNote :" << newNote;
#endif

    QSqlQuery query(m_QSqlDatabase);
    query.prepare("UPDATE diagnosis_notes SET note = :note WHERE patient_id = :patient_id");

    query.bindValue(":note", newNote);
    query.bindValue(":patient_id", m_PatientDataMap["patient_id"]);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Update operation succeeded!";
#endif

    return (true);
}

bool Database::updateTreatmentNote(const QString &newNote)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "newNote :" << newNote;
#endif

    QSqlQuery query(m_QSqlDatabase);
    query.prepare("UPDATE treatment_notes SET note = :note WHERE patient_id = :patient_id");

    query.bindValue(":note", newNote);
    query.bindValue(":patient_id", m_PatientDataMap["patient_id"]);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Update operation succeeded!";
#endif

    return (true);
}

bool Database::updateMedicalDrugNote(const QString &newNote)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "newNote :" << newNote;
#endif

    QSqlQuery query(m_QSqlDatabase);
    query.prepare("UPDATE medical_drug_notes SET note = :note WHERE patient_id = :patient_id");

    query.bindValue(":note", newNote);
    query.bindValue(":patient_id", m_PatientDataMap["patient_id"]);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Update operation succeeded!";
#endif

    return (true);
}

bool Database::updateProcedureNote(const QString &newNote)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "newNote :" << newNote;
#endif

    QSqlQuery query(m_QSqlDatabase);
    query.prepare("UPDATE procedure_notes SET note = :note WHERE patient_id = :patient_id");

    query.bindValue(":note", newNote);
    query.bindValue(":patient_id", m_PatientDataMap["patient_id"]);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << query.lastError().text();
#endif

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Update operation succeeded!";
#endif

    return (true);
}

bool Database::updateConsultations(const QVariantList &newConsultations)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :";
    qDebug() << newConsultations;
#endif

    QSqlQuery queryDelete(m_QSqlDatabase);
    queryDelete.prepare("DELETE FROM patient_consultations WHERE patient_id = :patient_id");

    queryDelete.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());

    if (!queryDelete.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryDelete.lastError().text();
#endif

        return (false);
    }

    if (newConsultations.isEmpty())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Consultation list is empty!";
#endif

        return (true);
    }

    QString queryString = "INSERT INTO patient_consultations (patient_id, consultant_id, consultation_date, consultation_outcome) VALUES (?, ?, ?, ?)";
    QSqlQuery queryInsert(m_QSqlDatabase);

    queryInsert.prepare(queryString);

    QVariantList patientIDs;
    QVariantList consultationIDs;
    QVariantList consultationDates;
    QVariantList consultationOutcomes;

    for (const QVariant &newConsultation : newConsultations)
    {
        QVariantMap map = newConsultation.toMap();

        patientIDs.append(m_PatientDataMap["patient_id"].toULongLong());
        consultationIDs.append(map["consultant_id"].toULongLong());
        consultationOutcomes.append(map["consultation_outcome"].toString());

        // NOTE (SAVIZ): If Jalali date is available for the 'consultation_date', it must be converted to the Gregorian calendar format before caching to the database:

        QCalendar calendarJalali(QCalendar::System::Jalali);

        QDate consultationGregorianDate;
        consultationGregorianDate = QDate::fromString(map["consultation_date"].toString(), "yyyy-MM-dd", calendarJalali);

        if(consultationGregorianDate.isNull() || !consultationGregorianDate.isValid())
        {
            consultationDates.append(QVariant(QMetaType::fromType<QDate>()));
        }

        else
        {
            consultationDates.append(consultationGregorianDate);
        }
    }

    queryInsert.addBindValue(patientIDs);
    queryInsert.addBindValue(consultationIDs);
    queryInsert.addBindValue(consultationDates);
    queryInsert.addBindValue(consultationOutcomes);

    if (!queryInsert.execBatch())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryInsert.lastError().text();
#endif

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Update operation succeeded! :" << consultationDates;
#endif

    return (true);
}

bool Database::updateLabTests(const QVariantList &newLabTests)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :";
    qDebug() << newLabTests;
#endif

    QSqlQuery queryDelete(m_QSqlDatabase);
    queryDelete.prepare("DELETE FROM patient_lab_tests WHERE patient_id = :patient_id");

    queryDelete.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());

    if (!queryDelete.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryDelete.lastError().text();
#endif

        return (false);
    }

    if (newLabTests.isEmpty())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Lab test list is empty!";
#endif

        return (true);
    }

    QString queryString = "INSERT INTO patient_lab_tests (patient_id, lab_id, lab_test_date, lab_test_outcome) VALUES (?, ?, ?, ?)";
    QSqlQuery queryInsert(m_QSqlDatabase);

    queryInsert.prepare(queryString);

    QVariantList patientIDs;
    QVariantList labIDs;
    QVariantList labTestDates;
    QVariantList labTestOutcomes;

    for (const QVariant &newLabTest : newLabTests)
    {
        QVariantMap map = newLabTest.toMap();

        patientIDs.append(m_PatientDataMap["patient_id"].toULongLong());
        labIDs.append(map["lab_id"].toULongLong());
        labTestOutcomes.append(map["lab_test_outcome"].toString());

        // NOTE (SAVIZ): If Jalali date is available for the 'consultation_date', it must be converted to the Gregorian calendar format before caching to the database:

        QCalendar calendarJalali(QCalendar::System::Jalali);

        QDate labTestGregorianDate;
        labTestGregorianDate = QDate::fromString(map["lab_test_date"].toString(), "yyyy-MM-dd", calendarJalali);

        if(labTestGregorianDate.isNull() || !labTestGregorianDate.isValid())
        {
            labTestDates.append(QVariant(QMetaType::fromType<QDate>()));
        }

        else
        {
            labTestDates.append(labTestGregorianDate);
        }
    }

    queryInsert.addBindValue(patientIDs);
    queryInsert.addBindValue(labIDs);
    queryInsert.addBindValue(labTestDates);
    queryInsert.addBindValue(labTestOutcomes);

    if (!queryInsert.execBatch())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryInsert.lastError().text();
#endif

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Update operation succeeded! :" << labTestDates;
#endif

    return (true);
}

bool Database::updateImages()
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
#endif

    QSqlQuery queryDelete(m_QSqlDatabase);
    queryDelete.prepare("DELETE FROM patient_images WHERE patient_id = :patient_id");

    queryDelete.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());

    if (!queryDelete.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryDelete.lastError().text();
#endif

        return (false);
    }

    QVariantList imageList = m_PatientDataMap["images"].toList();

    if (imageList.isEmpty())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Image list is empty!";
#endif

        return (true);
    }

    QString queryString = "INSERT INTO patient_images (patient_id, image_name, image_data) VALUES (?, ?, ?)";
    QSqlQuery queryInsert(m_QSqlDatabase);

    queryInsert.prepare(queryString);

    QVariantList patientIDs;
    QVariantList imageNames;
    QVariantList imageDatas;

    for (const QVariant &image : imageList)
    {
        QVariantMap map = image.toMap();

        patientIDs.append(m_PatientDataMap["patient_id"].toULongLong());
        imageNames.append(map["image_name"].toString());
        imageDatas.append(map["image_data"].toByteArray());
    }

    queryInsert.addBindValue(patientIDs);
    queryInsert.addBindValue(imageNames);
    queryInsert.addBindValue(imageDatas);

    if (!queryInsert.execBatch())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Update operation failed! :" << queryInsert.lastError().text();
#endif

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Update operation succeeded!";
#endif

    return (true);
}

// DELETION
bool Database::changeDeletionStatus(bool newStatus)
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "newStatus :" << newStatus;
#endif

    QSqlQuery query(m_QSqlDatabase);
    QString queryString = "UPDATE patients SET marked_for_deletion = :newStatus WHERE patient_id = :patient_id;";

    query.prepare(queryString);

    query.bindValue(":newStatus", newStatus);
    query.bindValue(":patient_id", m_PatientDataMap["patient_id"].toULongLong());

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Delete operation failed! :" << query.lastError().text();
#endif

        emit queryExecuted(QueryType::DELETE, false, "عملیات حذف ناموفق بود!");

        return (false);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Delete operation succeeded!";
#endif

    emit queryExecuted(QueryType::DELETE, true, "عملیات حذف با موفقیت انجام شد!");

    return (true);
}

bool Database::addImage(const QUrl &path)
{
    QFile file(path.toLocalFile());

    if (!file.open(QIODevice::ReadOnly))
    {
#ifdef QT_DEBUG
        qDebug() << "Failed to read image file data: " << path;
#endif

        return (false);
    }

    QVariantMap map;
    map.insert(path.fileName(), file.readAll());

    m_ImageList.append(map);

    return (true);
}

bool Database::deleteImage(const QString &fileName)
{
    bool success = false;

    QVariantList images = m_PatientDataMap["images"].toList();

    for (const QVariant &image : images) {
        QVariantMap map = image.toMap();

        if (map.contains(fileName)) {

            map.remove(fileName);

            success = true;
        }
    }

    return success;
}

QByteArray Database::getImageData(const QString &fileName)
{
    QVariantList images = m_PatientDataMap["images"].toList();

    for (const QVariant &image : images) {
        QVariantMap map = image.toMap();

        if (map.contains(fileName)) {

            return (map["image_data"].toByteArray()) ;
        }
    }

    return QByteArray();
}

// Notifier
QList<QVariantMap> Database::getUpcomingVisits(int daysBefore) // TODO (SAVIZ): Maybe make this an unsigned int.
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
#endif

    QList<QVariantMap> patients;

    QSqlQuery query(m_QSqlDatabase);

    QString queryString = R"(
        SELECT email, expected_visit_date, DATEDIFF(expected_visit_date, CURDATE()) AS days_left
        FROM patients
        WHERE expected_visit_date IS NOT NULL AND DATEDIFF(expected_visit_date, CURDATE()) BETWEEN 1 AND ?
    )";

    query.prepare(queryString);
    query.addBindValue(daysBefore);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Select operation failed! :" << query.lastError().text();
#endif

        return (patients);
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Query returned no results.";
#endif

        return (patients);
    }

    while (query.next())
    {
        QVariantMap patient;

        patient["email"] = query.value("email").toString();
        patient["days_left"] = query.value("days_left").toInt();

        QDate expectedVisitGregorianDate = query.value("expected_visit_date").toDate();

        if(!expectedVisitGregorianDate.isNull())
        {
            QString expectedVisitJaliliDateString = Date::cppInstance()->gregorianToJalali(expectedVisitGregorianDate);

            patient["expected_visit_date"] = expectedVisitJaliliDateString;
        }

        patients.append(patient);
    }

    return (patients);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PRIVATE Methods
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

QPair<bool, QString> Database::populateDiagnosisList()
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
#endif

    QString queryString = "SELECT * FROM diagnoses WHERE is_active = TRUE";

    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population failed!" << "\n" << query.lastError().text();
#endif

        return QPair<bool, QString>(false, query.lastError().text());
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population succeeded!";
#endif

        // NOTE (SAVIZ): Technically, the specialist might have chosen not to provide a list of diagnoses yet.
        return QPair<bool, QString>(true, "The query did not return any results.");
    }

    m_DiagnosisList.clear();

    while (query.next())
    {
        QVariantMap diagnosisMap;

        diagnosisMap["diagnosis_id"] = query.value("diagnosis_id").toULongLong();
        diagnosisMap["diagnosis_name"] = query.value("name").toString();

        m_DiagnosisList.append(diagnosisMap);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Population succeeded!";
#endif

    return QPair<bool, QString>(true, "");
}

QPair<bool, QString> Database::populateTreatmentList()
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
#endif

    QString queryString = "SELECT * FROM treatments WHERE is_active = TRUE";

    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population failed!" << "\n" << query.lastError().text();
#endif

        return QPair<bool, QString>(false, query.lastError().text());
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population succeeded!";
#endif

        // NOTE (SAVIZ): Technically, the specialist might have chosen not to provide a list of treatments yet.
        return QPair<bool, QString>(true, "The query did not return any results.");
    }

    m_TreatmentList.clear();

    while (query.next())
    {
        QVariantMap treatmentMap;

        treatmentMap["treatment_id"] = query.value("treatment_id").toULongLong();
        treatmentMap["treatment_name"] = query.value("name").toString();

        m_TreatmentList.append(treatmentMap);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Population succeeded!";
#endif

    return QPair<bool, QString>(true, "");
}

QPair<bool, QString> Database::populateMedicalDrugList()
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
#endif

    QString queryString = "SELECT * FROM medical_drugs WHERE is_active = TRUE";

    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population failed!" << "\n" << query.lastError().text();
#endif

        return QPair<bool, QString>(false, query.lastError().text());
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population succeeded!";
#endif

        // NOTE (SAVIZ): Technically, the specialist might have chosen not to provide a list of medical drugs yet.
        return QPair<bool, QString>(true, "The query did not return any results.");
    }

    m_MedicalDrugList.clear();

    while (query.next())
    {
        QVariantMap medicalDrugMap;

        medicalDrugMap["medical_drug_id"] = query.value("medical_drug_id").toULongLong();
        medicalDrugMap["medical_drug_name"] = query.value("name").toString();

        m_MedicalDrugList.append(medicalDrugMap);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Population succeeded!";
#endif

    return QPair<bool, QString>(true, "");
}

QPair<bool, QString> Database::populateProcedureList()
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
#endif

    QString queryString = "SELECT * FROM procedures WHERE is_active = TRUE";

    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population failed!" << "\n" << query.lastError().text();
#endif

        return QPair<bool, QString>(false, query.lastError().text());
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population succeeded!";
#endif

        // NOTE (SAVIZ): Technically, the specialist might have chosen not to provide a list of procedures yet.
        return QPair<bool, QString>(true, "The query did not return any results.");
    }

    m_ProcedureList.clear();

    while (query.next())
    {
        QVariantMap procedureMap;

        procedureMap["procedure_id"] = query.value("procedure_id").toULongLong();
        procedureMap["procedure_name"] = query.value("name").toString();

        m_ProcedureList.append(procedureMap);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Population succeeded!";
#endif

    return QPair<bool, QString>(true, "");
}

QPair<bool, QString> Database::populateConsultantList()
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
#endif

    QString queryString = "SELECT * FROM consultants WHERE is_active = TRUE";

    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population failed!" << "\n" << query.lastError().text();
#endif

        return QPair<bool, QString>(false, query.lastError().text());
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population succeeded!";
#endif

        // NOTE (SAVIZ): Technically, the specialist might have chosen not to provide a list of consultants yet.
        return QPair<bool, QString>(true, "The query did not return any results.");
    }

    m_ConsultantList.clear();

    while (query.next())
    {
        QVariantMap consultantMap;

        consultantMap["consultant_id"] = query.value("consultant_id").toULongLong();
        consultantMap["consultant_name"] = query.value("name").toString();
        consultantMap["consultant_specialization"] = query.value("specialization").toString();

        m_ConsultantList.append(consultantMap);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Population succeeded!";
#endif

    return QPair<bool, QString>(true, "");
}

QPair<bool, QString> Database::populateLabList()
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
#endif

    QString queryString = "SELECT * FROM labs WHERE is_active = TRUE";

    QSqlQuery query(m_QSqlDatabase);
    query.prepare(queryString);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population failed!" << "\n" << query.lastError().text();
#endif

        return QPair<bool, QString>(false, query.lastError().text());
    }

    if (query.size() == 0)
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << "Population succeeded!";
#endif

        // NOTE (SAVIZ): Technically, the specialist might have chosen not to provide a list of labs yet.
        return QPair<bool, QString>(true, "The query did not return any results.");
    }

    m_LabList.clear();

    while (query.next())
    {
        QVariantMap labMap;

        labMap["lab_id"] = query.value("lab_id").toULongLong();
        labMap["lab_name"] = query.value("name").toString();
        labMap["lab_specialization"] = query.value("specialization").toString();

        m_LabList.append(labMap);
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Population succeeded!";
#endif

    return QPair<bool, QString>(true, "");
}

bool Database::recordExists(quint64 index)
{
    QSqlQuery query(m_QSqlDatabase);

    query.prepare("SELECT EXISTS(SELECT 1 FROM patients WHERE patient_id = :patient_id)");
    query.bindValue(":patient_id", index);

    if (!query.exec())
    {
#ifdef QT_DEBUG
        qDebug() << "Log Output :" << query.lastError().text();
#endif

        return (false);
    }

    bool exists = false;

    if (query.next())
    {
        exists = query.value(0).toBool();
    }

#ifdef QT_DEBUG
    qDebug() << "Log Output :" << "Record exists: " << exists;
#endif

    return (exists);
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

QVariantList Database::getProcedureList() const
{
    return (m_ProcedureList);
}

QVariantList Database::getConsultantList() const
{
    return (m_ConsultantList);
}

QVariantList Database::getLabList() const
{
    return (m_LabList);
}

QVariantList Database::getImageNames() const
{
    QVariantList list;

    for(const QVariant& item: m_ImageList)
    {
        QVariantMap map = item.toMap();
        list.append(map["image_name"]);
    }

    return (list);
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
