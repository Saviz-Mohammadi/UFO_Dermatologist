#ifdef QT_DEBUG
    #include <QDebug>
#endif

#include "printer.hpp"
#include "database.hpp"

Printer *Printer::m_Instance = Q_NULLPTR;

// Constructors, Initializers, Destructor *
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

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PUBLIC Methods
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

void Printer::printPatientData()
{
    Database *database = Database::cppInstance();

    database->pullPatientData(m_PatientID);

    // Load the HTML template
    QFile file(m_TemplateFilePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning("Failed to open HTML template.");
        return;
    }

    QTextStream in(&file);
    QString htmlContent = in.readAll();
    file.close();

    QVariantMap map = database->getPatientDataMap();

    // Get the Documents folder path
    QString outputFolder = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);

    // Extract first and last names
    QString firstName = map["first_name"].toString().trimmed();
    QString lastName = map["last_name"].toString().trimmed();

    m_OutputFilePath = QString("%1/Report_%2_%3.pdf")
                           .arg(outputFolder, firstName, lastName);

    // Replace placeholders with data
    htmlContent.replace("{{id}}", QString::number(map["id"].toInt()));
    htmlContent.replace("{{first_name}}", map["first_name"].toString());
    htmlContent.replace("{{last_name}}", map["last_name"].toString());
    htmlContent.replace("{{service_price}}", QString::number(map["service_price"].toDouble(), 'f', 3));

    // Handle medical drugs list
    QStringList drugList;
    for (const QVariant &drug : map["medicalDrugs"].toList()) {
        QVariantMap drugMap = drug.toMap();

        drugList.append("<li>" + drugMap["medical_drug_name"].toString() + "</li>");
    }
    htmlContent.replace("{{medical_drugs}}", drugList.join(""));

    // Create a QTextDocument and set the modified HTML content
    QTextDocument document;
    document.setHtml(htmlContent);

    // Configure the PDF printer
    QPrinter printer(QPrinter::PrinterResolution);
    printer.setOutputFormat(QPrinter::PdfFormat);
    printer.setOutputFileName(m_OutputFilePath);

    // Render the document to the PDF
    document.print(&printer);

#ifdef QT_DEBUG
    qDebug() << "PDF saved to:" << m_OutputFilePath;
#endif

    emit printStateChanged(true, "File generated");
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
// PUBLIC Methods
