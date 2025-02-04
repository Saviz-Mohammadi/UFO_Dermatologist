#ifndef FILTER_H
#define FILTER_H

#include <QObject>
#include <QSortFilterProxyModel>

class CustomProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    // Q_PROPERTY
    Q_PROPERTY(QString filterText READ filterText WRITE setFilterText NOTIFY filterTextChanged)
    Q_PROPERTY(QString filterRole READ filterRole WRITE setFilterRole NOTIFY filterRoleChanged)

    // PUBLIC Enums
public:

public:
    explicit CustomProxyModel(QObject *parent = nullptr);
    ~CustomProxyModel();

    // Fields
private:
    QString m_filterText = "";
    QString m_filterRole = "";

    // Signals
signals:
    void filterTextChanged();
    void filterRoleChanged();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

    // PUBLIC Slots:
public slots:

    // PRIVATE Slots:
private slots:

    // PUBLIC Methods
public:
    Q_INVOKABLE QVariant sourceData(int proxyRow, const QString &roleName) const;
    Q_INVOKABLE int getRole(const QString &role) const;

    // PRIVATE Methods
private:

    // PUBLIC Getters
public:
    QString filterText() const;
    QString filterRole() const;

    // PRIVATE Getters
public:

    // PUBLIC Setters
public:
    void setFilterText(const QString &text);
    void setFilterRole(const QString &role);

    // PRIVATE Setters
private:
};

#endif // FILTER_H
