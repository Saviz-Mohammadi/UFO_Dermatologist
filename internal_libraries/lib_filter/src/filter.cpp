#ifdef QT_DEBUG
    #include <QDebug>
#endif

#include "filter.hpp"

// Constructors, Initializers, Destructor
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

CustomProxyModel::CustomProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
    setFilterCaseSensitivity(Qt::CaseInsensitive);

#ifdef QT_DEBUG
    qDebug() << "objectName           :" << this->objectName();
    qDebug() << "Arguments            :" << "None";
    qDebug() << "Log Output           :" << "None";
#endif
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]





// PUBLIC Methods
// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]

QString CustomProxyModel::filterText() const
{
    return m_filterText;
}

void CustomProxyModel::setFilterText(const QString &text)
{
    if (m_filterText != text) {
        m_filterText = text;
        emit filterTextChanged();
        invalidateFilter(); // Reapply the filter
    }
}

QString CustomProxyModel::filterRole() const
{
    return m_filterRole;
}

void CustomProxyModel::setFilterRole(const QString &role)
{
    if (m_filterRole != role) {
        m_filterRole = role;
        emit filterRoleChanged();
        invalidateFilter(); // Reapply the filter
    }
}

bool CustomProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if (m_filterText.isEmpty()) {
        return true; // Accept all rows if no filter text is set
    }

    int roleIndex = sourceModel()->roleNames().key(m_filterRole.toUtf8(), -1);

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
    QVariant data = sourceModel()->data(index, roleIndex);

    qDebug() << "Data for filtering:" << data << "Type:" << data.typeName();

    return data.toString().contains(m_filterText, Qt::CaseInsensitive);
}

QVariant CustomProxyModel::sourceData(int proxyRow, const QString &roleName) const {
    QModelIndex sourceIndex = mapToSource(index(proxyRow, 0));
    if (!sourceIndex.isValid()) return QVariant();

    QAbstractItemModel *sourceModel = this->sourceModel();
    if (!sourceModel) return QVariant();

    int role = sourceModel->roleNames().key(roleName.toUtf8(), -1);
    return role != -1 ? sourceModel->data(sourceIndex, role) : QVariant();
}

int CustomProxyModel::getRole(const QString &role) const
{
    int roleIndex = sourceModel()->roleNames().key(m_filterRole.toUtf8(), -1);

    return (roleIndex);
}

// [[------------------------------------------------------------------------]]
// [[------------------------------------------------------------------------]]
