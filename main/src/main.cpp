#ifdef QT_DEBUG
    #include <QDebug>
#endif

#include "main.hpp"

int main(int argc, char *argv[])
{
    qSetMessagePattern("%{function} (Line: %{line}) >> %{message}");

    QGuiApplication application(argc, argv);
    QQmlApplicationEngine engine;

    registerTypes();
    setupThemeSystem();
    chooseFirstTheme();
    readCustomFonts(application);
    setGlobalFont(application);

    QCalendar::YearMonthDay gregorianYMD(QDate::currentDate().year(), QDate::currentDate().month(), QDate::currentDate().day());
    QCalendar::YearMonthDay jalaliYMD(1379, 1, 20);


    QCalendar::YearMonthDay newJalili = Date::cppInstance()->gregorianToJalali(gregorianYMD);
    QCalendar::YearMonthDay newGregorian = Date::cppInstance()->jalaliToGregorian(jalaliYMD);

    QDate gregorianDate(newGregorian.year, newGregorian.month, newGregorian.day);
    QDate jaliliDate(newJalili.year, newJalili.month, newJalili.day);


    qDebug() << gregorianDate.toString("dd.MM.yyyy");
    qDebug() << jaliliDate.toString("dd.MM.yyyy");

    // WARNING (SAVIZ): This function does not work correctly under Wayland.
    QGuiApplication::setWindowIcon(QIcon("./resources/icons/Application icons/ufo.png"));

    engine.load("./resources/qml/main.qml");

    return application.exec();
}

void registerTypes()
{
    qmlRegisterSingletonType<AppTheme>("AppTheme", 1, 0, "AppTheme", &AppTheme::qmlInstance);
    qmlRegisterSingletonType<Database>("Database", 1, 0, "Database", &Database::qmlInstance);
    qmlRegisterSingletonType<Date>("Date", 1, 0, "Date", &Date::qmlInstance);
    qmlRegisterType<CustomProxyModel>("CustomProxyModel", 1, 0, "CustomProxyModel");
    qmlRegisterSingletonType<Printer>("Printer", 1, 0, "Printer", &Printer::qmlInstance);
}

void setupThemeSystem()
{
    AppTheme *appTheme = AppTheme::cppInstance();

    appTheme->addThemes("./resources/json/themes");
}

void chooseFirstTheme()
{
    AppTheme *appTheme = AppTheme::cppInstance();

    QString lastUsedThemeKey = appTheme->getCachedTheme();


    if(!lastUsedThemeKey.isEmpty())
    {
        appTheme->loadColorsFromTheme(lastUsedThemeKey);

        return;
    }

    appTheme->loadColorsFromTheme("ufo_light");
}

void readCustomFonts(const QGuiApplication &application)
{
    QStringList fontPaths;

    fontPaths << "./resources/fonts/Titillium_Web/TitilliumWeb-Black.ttf"
              << "./resources/fonts/Titillium_Web/TitilliumWeb-Bold.ttf"
              << "./resources/fonts/Titillium_Web/TitilliumWeb-BoldItalic.ttf"
              << "./resources/fonts/Titillium_Web/TitilliumWeb-ExtraLight.ttf"
              << "./resources/fonts/Titillium_Web/TitilliumWeb-ExtraLightItalic.ttf"
              << "./resources/fonts/Titillium_Web/TitilliumWeb-Italic.ttf"
              << "./resources/fonts/Titillium_Web/TitilliumWeb-Light.ttf"
              << "./resources/fonts/Titillium_Web/TitilliumWeb-LightItalic.ttf"
              << "./resources/fonts/Titillium_Web/TitilliumWeb-Regular.ttf"
              << "./resources/fonts/Titillium_Web/TitilliumWeb-SemiBold.ttf"
              << "./resources/fonts/Titillium_Web/TitilliumWeb-SemiBoldItalic.ttf";

    foreach (const QString &fontPath, fontPaths)
    {
        int fontId = QFontDatabase::addApplicationFont(fontPath);

        if (fontId == -1)
        {
#ifdef QT_DEBUG
            QString logOutput = QString("Failed to load font file: %1").arg(fontPath);

            qDebug() << "[DEBUG]";
            qDebug() << "--------------------------------------------------------------------------------";
            qDebug() << "objectName           :" << "Main";
            qDebug() << "function Information :" << Q_FUNC_INFO;
            qDebug() << "Arguments            :" << "QGuiApplication";
            qDebug() << "Log Output           :" << logOutput;
            qDebug() << "--------------------------------------------------------------------------------";
#endif
        }
    }
}

void setGlobalFont(const QGuiApplication &application)
{
    // NOTE (SAVIZ): The name is automatically set by Qt and depends on the metadata of the file. Refer to "Google Fonts" to find out the correct name to use.
    QString fontFamilyName = "Titillium Web";


    if (QFontDatabase::families().contains(fontFamilyName))
    {
        QFont customFont(fontFamilyName, 10);

        QGuiApplication::setFont(customFont);
    }

    else
    {
#ifdef QT_DEBUG
        QString logOutput = QString("Font family %1 is not available.").arg(fontFamilyName);

        qDebug() << "[DEBUG]";
        qDebug() << "--------------------------------------------------------------------------------";
        qDebug() << "objectName           :" << "Main";
        qDebug() << "function Information :" << Q_FUNC_INFO;
        qDebug() << "Arguments            :" << "QGuiApplication";
        qDebug() << "Log Output           :" << logOutput;
        qDebug() << "--------------------------------------------------------------------------------";
#endif
    }
}
