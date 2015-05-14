#include "UnlockDatabaseDialog.h"
#include "UnlockDatabaseWidget.h"

#include "autotype/AutoType.h"
#include <core/Database.h>
#include <gui/DatabaseTabWidget.h>


UnlockDatabaseDialog::UnlockDatabaseDialog(QWidget *parent)
    : QDialog(parent)
    , m_view(new UnlockDatabaseWidget(this))
{
    connect(m_view, SIGNAL(editFinished(bool)), this, SLOT(Done(bool)));
    connect(this, SIGNAL(performAutoType(QList<Database*>)), autoType(), SLOT(performGlobalAutoType(QList<Database*>)));
}

void UnlockDatabaseDialog::setDBFilename(const QString &filename)
{
    m_view->load(filename);
}

void UnlockDatabaseDialog::clearForms()
{
    m_view->clearForms();
}

Database *UnlockDatabaseDialog::database()
{
    return m_view->database();
}

void UnlockDatabaseDialog::Done(bool r)
{
    if (r) {
        QList<Database*> dbList;
        m_db = static_cast<DatabaseOpenWidget*>(sender())->database();
        dbList.append(m_db);
        accept();
        Q_EMIT unlockDone(true);
        Q_EMIT performAutoType(dbList);
    } else {
        reject();
    }
}