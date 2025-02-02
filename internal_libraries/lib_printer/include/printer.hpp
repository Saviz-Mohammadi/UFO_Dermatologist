#ifndef PRINTER_H
#define PRINTER_H

#include <QObject>
#include <QQmlEngine>
#include <QVariant>
#include <QVariantList>
#include <QPrinterInfo>
#include <QFile>
#include <QTextStream>
#include <QTextDocument>
#include <QStringList>
#include <QStandardPaths>

class Printer : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY_MOVE(Printer) // Needed for Singleton

public:
    explicit Printer(QObject *parent = Q_NULLPTR, const QString& name = "No name");
    ~Printer();

    static Printer *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);
    static Printer *cppInstance(QObject *parent = Q_NULLPTR);

private:
    static Printer *m_Instance;

    // Fields
private:
    unsigned int m_PatientID;
    QString m_TemplateFilePath;
    QString m_OutputFilePath;

    // Signals
signals:
    void printStateChanged(bool success, const QString &message);

    // PUBLIC Methods
public:
    Q_INVOKABLE void printPatientData();

    // PRIVATE Methods
private:

    // PUBLIC Getters
public:

    // PUBLIC Setters
public:
    Q_INVOKABLE void setPatientID(unsigned int newPatientID);
};

#endif // PRINTER_H
