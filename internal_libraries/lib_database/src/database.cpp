#include "database.hpp"

#ifdef QT_DEBUG
    #include "logger.hpp"
#endif


Database *Database::m_Instance = Q_NULLPTR;

// Constructors, Initializers, Destructor
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

Database::Database(QObject *parent, const QString& name)
    : QObject{parent}
    , m_QSqlDatabase(QSqlDatabase{})
    , m_ConnectionStatus(false)
    , m_SearchListModel(QVariantList {})
    , m_EditPatient(Patient())
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
               << "Path        : " << ipAddress;

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif

        return;
    }


//     QSqlQuery query;

//     bool query_success = query.exec(
//         "CREATE TABLE IF NOT EXISTS tasks (task_id INTEGER PRIMARY KEY AUTOINCREMENT, task_description TEXT);"
//     );

//     if (!query_success)
//     {
// #ifdef QT_DEBUG
//         QString message("Failed to run query!\n");

//         QTextStream stream(&message);

//         stream << "Reason: " << query.lastError().text();

//         logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
// #endif

//         return;
//     }


    setConnectionStatus(true);
}

void Database::disconnect()
{
    m_QSqlDatabase.close();

    setConnectionStatus(false);


#ifdef QT_DEBUG
    QString message("Closing the database connection...\n");

    logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif
}


// NOTE (SAVIZ): This method will only be used to search and populate the the visual model in search tab. For this reason we do not have to worry about converting between 'Patient' and 'QVariantMap' and can simply rely on passing the id of the record to create a new patient in the 'Edit Patient' tab.
// NOTE (SAVIZ): I would like to use 'std::optional', but QML does not play nice.
bool Database::search(const QString &first_name,
                      const QString &last_name,
                      quint8 age,
                      const QString &phone_number,
                      const QString &gender,
                      const QString &marital_status)
{
    QString queryString = "SELECT * FROM patients WHERE 1=1";
    QSqlQuery query;

    if (!first_name.isEmpty()) {
        queryString += " AND first_name LIKE '%" + first_name + "%'";
        qDebug() << "first_name: " << first_name;
    }

    if (!last_name.isEmpty()) {
        queryString += " AND last_name LIKE '%" + last_name + "%'";
        qDebug() << "last_name: " << last_name;
    }

    // NOTE (SAVIZ): Using -1 as the sentinel value for age, which turns into 255 in unsigned format.
    if (age != 255) {
        queryString += " AND age = " + QString::number(age);
        qDebug() << "age: " << age;
    }

    if (!phone_number.isEmpty()) {
        queryString += " AND phone_number LIKE '%" + phone_number + "%'";
        qDebug() << "phone_number: " << phone_number;
    }

    if (!gender.isEmpty()) {
        queryString += " AND gender = '" + gender + "'";
        qDebug() << "gender: " << gender;
    }

    if (!marital_status.isEmpty()) {
        queryString += " AND marital_status = '" + marital_status + "'";
        qDebug() << "marital_status: " << marital_status;
    }

    queryString += ";";

    qDebug() << query.prepare(queryString);

    qDebug() << "Query:" << query.lastQuery();
    qDebug() << "Bound Values:" << query.boundValues();

    if (!query.exec()) {
        qDebug() << query.lastError();

        return (false);

        // TODO (SAVIZ): React to the returned failure state in QML.
    }

    if (query.size() == 0) {
        qDebug() << "No results found.";
    }

    qDebug() << "Bound Values:" << query.boundValues();



    m_SearchListModel.clear();

    int index = 0;

    // Only obtain the absolute neccessary data for searching a patient:
    while (query.next()) {
        QVariantMap variantMap;

        variantMap["patient_id"] = query.value("patient_id").toULongLong();
        variantMap["first_name"] = query.value("first_name").toString();
        variantMap["last_name"] = query.value("last_name").toString();
        variantMap["age"] = query.value("age").toString();
        variantMap["birth_date"] = query.value("birth_date").toString();
        variantMap["phone_number"] = query.value("phone_number").toString();
        variantMap["gender"] = query.value("gender").toString();
        variantMap["marital_status"] = query.value("marital_status").toString();

        m_SearchListModel.append(variantMap);

        //qDebug() << variantMap["first_name"] << variantMap["last_name"];

        QString fieldName = query.record().fieldName(index);
        QVariant value = query.value(index);
        qDebug() << fieldName << ":" << value;

        index++;
    }

    // Calling signal to notify the QML front-end that the model has changed. (Observer-pattern)
    emit searchModelChanged();

    return (true);
}

void Database::readyPatientForEditing(const quint64 index)
{
    m_EditPatient = Patient();
    QVariantMap targetPatientMap;

    if (m_SearchListModel[index].canConvert<QVariantMap>()) {
        m_SearchListModel[index].toMap();
    }

    // Now that we know exactly what patient we are looking for, obtain everything you can about the patient:
    QString queryString = "SELECT * FROM patients WHERE patient_id = "
                          + targetPatientMap["patient_id"].toString();
    QSqlQuery query;

    query.prepare(queryString);

    if (!query.exec()) {
        qDebug() << query.lastError();

        // TODO (SAVIZ): React to the returned failure state in QML.
    }

    while (query.next()) {
        m_EditPatient.patient_id = query.value("patient_id").toULongLong();
        m_EditPatient.first_name = query.value("first_name").toString();
        m_EditPatient.last_name = query.value("last_name").toString();
        m_EditPatient.age = query.value("age").toUInt();
        m_EditPatient.birth_date = query.value("birth_date").toString();
        m_EditPatient.phone_number = query.value("phone_number").toString();
        m_EditPatient.gender = query.value("gender").toString();
        m_EditPatient.marital_status = query.value("marital_status").toString();
    }

    // We can emit a signal and allow visual elements to know that changes have been made to the 'Patient':
    emit editPatientReadied();
}

QVariant Database::addTask(const QString &text)
{
    QString command("INSERT INTO tasks(task_description) VALUES(:text)");

    QSqlQuery query;
    query.prepare(command);
    query.bindValue(":text", text);


    bool operation_success = (query.exec());

    if (!operation_success)
    {
#ifdef QT_DEBUG
        QString message("Operation failed!\n");

        QTextStream stream(&message);

        stream << "Reason: " << query.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif


        return (operation_success);
    }


    return (query.lastInsertId());
}

bool Database::removeTask(QVariant id)
{
    QString command("DELETE FROM tasks WHERE task_id = :id");

    QSqlQuery query;
    query.prepare(command);
    query.bindValue(":id", id.toULongLong());


    bool operation_success = (query.exec());

    if (!operation_success)
    {
#ifdef QT_DEBUG
        QString message("Operation failed!\n");

        QTextStream stream(&message);

        stream << "Reason: " << query.lastError().text();

        logger::log(logger::LOG_LEVEL::DEBUG, this->objectName(), Q_FUNC_INFO, message);
#endif


        return (operation_success);
    }


    return (operation_success);
}

QVariantList Database::obtainAllTasks()
{
    QString command("SELECT task_id, task_description FROM tasks WHERE task_description IS NOT NULL");

    QSqlQuery query;
    query.prepare(command);
    query.exec();


    QVariantList list;

    while (query.next())
    {
        QVariantMap recordMap;

        recordMap["id"] = query.value(0).toULongLong();
        recordMap["task"] = query.value(1).toString();

        list.append(recordMap);
    }


    return (list);
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

QVariantList Database::getSearchModel() const
{
    return (m_SearchListModel);
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
