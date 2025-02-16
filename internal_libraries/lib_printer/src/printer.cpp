#ifdef QT_DEBUG
    #include <QDebug>
#endif

#include "printer.hpp"
#include "database.hpp"

Printer *Printer::m_Instance = Q_NULLPTR;

// Constructors, Init, ShutDown, Destructor
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

Printer::Printer(QObject *parent, const QString &name)
    : QObject{parent}
    , m_PatientID(0)
    , m_TemplateFilePath("./resources/html/template.html")
    , m_OutputFilePath("")
{
    this->setObjectName(name);

#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";

    QList<QPrinterInfo> printers = QPrinterInfo::availablePrinters();
    qDebug() << "Log Output :";

    for (const QPrinterInfo &printer : printers) {
        qDebug() << printer.printerName();
    }
#endif
}

Printer::~Printer()
{
#ifdef QT_DEBUG
    qDebug() << "objectName :" << this->objectName();
    qDebug() << "Arguments  :" << "None";
    qDebug() << "Log Output :" << "None";
#endif
}

Printer *Printer::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);

    if (!m_Instance)
    {
        m_Instance = new Printer();
    }

    return (m_Instance);
}

Printer *Printer::cppInstance(QObject *parent)
{
    if (m_Instance)
    {
        return (qobject_cast<Printer *>(Printer::m_Instance));
    }

    auto instance = new Printer(parent);
    m_Instance = instance;

    return (instance);
}

// NOTE (SAVIZ): Not needed. However, provided just in case.
void Printer::Init()
{
    // Init resources;
}

// NOTE (SAVIZ): In Qt, this isn't necessary due to its parent-child memory management system. However, in standard C++, it's a good practice to either explicitly call this when we're done with the object or ensure it gets invoked within the destructor.
void Printer::ShutDown()
{
    delete (m_Instance);

    m_Instance = Q_NULLPTR;
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PUBLIC Methods
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

bool Printer::printPatientData()
{
    Database *database = Database::cppInstance();

    // NOTE (SAVIZ): This check is unnecessary because the database is guaranteed to be connected when this function is called. However, I included it as a precaution:
    if(database->getConnectionStatus() == false)
    {
#ifdef QT_DEBUG
        qDebug() << "Connection to database is not established!";
#endif

        emit printStateChanged(false, "اتصالی به پایگاه داده شناسایی نشد");

        return (false);
    }

    QPair<bool, QVariantMap> patientBasicData = database->pullPatientBasicData(m_PatientID);
    QPair<bool, QVariantList> medicalDrugs = database->pullPatientMedicalDrugs(m_PatientID);

    QFile file(m_TemplateFilePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
#ifdef QT_DEBUG
        qDebug() << "Failed to open HTML template.";
#endif

        emit printStateChanged(false, "امکان خواندن فایل الگو وجود ندارد");

        return (false);
    }

    QTextStream in(&file);
    QString htmlContent = in.readAll();
    file.close();

    QString outputFolder = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);

    QString firstName = patientBasicData.second["first_name"].toString().trimmed();
    QString lastName = patientBasicData.second["last_name"].toString().trimmed();

    m_OutputFilePath = QString("%1/Report_%2_%3.pdf")
                           .arg(outputFolder, firstName, lastName);

    htmlContent.replace("{{id}}", QString::number(patientBasicData.second["patient_id"].toInt()));
    htmlContent.replace("{{first_name}}", patientBasicData.second["first_name"].toString());
    htmlContent.replace("{{last_name}}", patientBasicData.second["last_name"].toString());
    htmlContent.replace("{{service_price}}", QString::number(patientBasicData.second["service_price"].toDouble(), 'f', 3));

    QStringList drugList;
    for (const QVariant &drug : medicalDrugs.second)
    {
        QVariantMap drugMap = drug.toMap();

        drugList.append("<li>" + drugMap["medical_drug_name"].toString() + "</li>");
    }

    htmlContent.replace("{{medical_drugs}}", drugList.join(""));

    QTextDocument document;
    document.setHtml(htmlContent);

    // TODO (SAVIZ): Make this available and changabel in QML and have it be set via properties.
    QPrinter printer(QPrinter::PrinterResolution);
    printer.setOutputFormat(QPrinter::PdfFormat);
    printer.setOutputFileName(m_OutputFilePath);

    document.print(&printer);

#ifdef QT_DEBUG
    qDebug() << "PDF saved to:" << m_OutputFilePath;
#endif

    emit printStateChanged(true, "فایل ایجاد شد و در مسیر قرار گرفت: " + m_OutputFilePath);

    return (true);
}

void Printer::setPatientID(unsigned int newPatientID)
{
    if(m_PatientID == newPatientID)
    {
        return;
    }

    m_PatientID = newPatientID;
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]
