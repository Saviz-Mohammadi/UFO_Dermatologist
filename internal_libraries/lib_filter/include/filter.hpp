#ifndef FILTER_H
#define FILTER_H

#include <QObject>
#include <QSortFilterProxyModel>

class CustomProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QString filterText READ filterText WRITE setFilterText NOTIFY filterTextChanged)
    Q_PROPERTY(QString filterRole READ filterRole WRITE setFilterRole NOTIFY filterRoleChanged)

public:
    explicit CustomProxyModel(QObject *parent = nullptr);

private:
    QString m_filterText = "";
    QString m_filterRole = "";

signals:
    void filterTextChanged();
    void filterRoleChanged();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

public:
    Q_INVOKABLE int mapToSourceIndex(int proxyIndex) const;
    Q_INVOKABLE int getRole(const QString &role) const;

public:
    QString filterText() const;
    void setFilterText(const QString &text);

    QString filterRole() const;
    void setFilterRole(const QString &role);
};

#endif // FILTER_H
