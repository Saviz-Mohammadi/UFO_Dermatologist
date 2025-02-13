#ifndef MAIN_H
#define MAIN_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>
#include <QIcon>
#include "app_theme.hpp"
#include "database.hpp"
#include "date.hpp"
#include "filter.hpp"
#include "printer.hpp"
#include "notifier.hpp"
#include "image_provider.hpp"


void registerTypes();
void setupThemeSystem();
void chooseFirstTheme();
void readCustomFonts(const QGuiApplication &application);
void setGlobalFont(const QGuiApplication &application);

#endif  //MAIN_H
