/*
 * author: 朱有成 冉杨 张新蕾
 * email: 2025221556@qq.com 2578874882@qq.com 2548742654@qq.com
 * time: 2021.10

 * Copyright (C) <2021> < Youcheng Zhu, Yang Ran, Xinlei zhang >

 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License  as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful.
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURP0SE. See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see < https://www.gnu.org/licenses/>.
 */
#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "videoedit.h"
#include "audioedit.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QString applicationDirPath = QCoreApplication::applicationDirPath();
//    qDebug() << "applicationDirPath: " << applicationDirPath;

    engine.rootContext()->setContextProperty("appPath", applicationDirPath);


    const QUrl url(QStringLiteral("qrc:/main.qml"));
    qmlRegisterType<VideoEdit>("VideoEdit", 1, 0, "VideoEdit");
    qmlRegisterType<AudioEdit>("AudioEdit", 1, 0, "AudioEdit");


    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
