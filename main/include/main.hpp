#ifndef MAIN_H
#define MAIN_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QFontDatabase>
#include <QIcon>
#include "app_theme.hpp"
#include "database.hpp"


void registerTypes();
void registerTranslations(QTranslator &translator, QGuiApplication &application);
void setupThemeSystem();
void chooseFirstTheme();
void readCustomFonts(const QGuiApplication &application);
void setGlobalFont(const QGuiApplication &application);

#endif  //MAIN_H
