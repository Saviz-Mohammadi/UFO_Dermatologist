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
#include <QFileInfo>
#include <QTextStream>
#include <optional>

#include "patient.hpp"

class Database : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY_MOVE(Database) // Needed for Singleton

    // Q_PROPERTY
    Q_PROPERTY(bool connectionStatus READ getConnectionStatus NOTIFY connectionStatusChanged FINAL)
    Q_PROPERTY(QVariantList searchModel READ getSearchModel NOTIFY searchModelChanged FINAL)

public:
    explicit Database(QObject *parent = Q_NULLPTR, const QString& name = "No name");
    ~Database();

    static Database *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);
    static Database *cppInstance(QObject *parent = Q_NULLPTR);

    // Fields
private:
    static Database *m_Instance;
    QSqlDatabase m_QSqlDatabase;
    bool m_ConnectionStatus;
    QVariantList m_SearchListModel;
    Patient m_EditPatient;


    // Signals
signals:
    void connectionStatusChanged();
    void searchModelChanged();
    void editPatientReadied();

    // PUBLIC Methods
public:
    Q_INVOKABLE void establishConnection(const QString &ipAddress, qint16 port, const QString &schema, const QString &username, const QString &password);
    Q_INVOKABLE void disconnect();
    Q_INVOKABLE bool search(const QString &first_name,
                            const QString &last_name,
                            quint8 age,
                            const QString &phone_number,
                            const QString &gender,
                            const QString &marital_status);
    Q_INVOKABLE void readyPatientForEditing(const quint64 index);

    Q_INVOKABLE QVariant addTask(const QString &text);
    Q_INVOKABLE bool removeTask(QVariant id);
    Q_INVOKABLE QVariantList obtainAllTasks();

    // PUBLIC Getters
public:
    bool getConnectionStatus() const;
    QVariantList getSearchModel() const;

    // PRIVATE Setters
private:
    void setConnectionStatus(const bool newStatus);
};

#endif // DATABASE_H
