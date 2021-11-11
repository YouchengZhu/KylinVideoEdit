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
#ifndef AUDIOEDIT_H
#define AUDIOEDIT_H

#include <iostream>
#include <QObject>
#include <QDebug>
#include <QProcess>

class AudioEdit: public QObject
{
     Q_OBJECT
signals:
    void finish();//C++调用命令行函数执行结束
    void start();//C++调用命令行函数执行开始
public slots:
    int audioSplit(QString inputFilePath,QString outputFilePath1,QString outputFilePath2,const double startTime,double duration);
    //音频的拆分
    //inputFilePath：输入音频文件路径
    //outputFilePath1：导出音频文件路径1
    //outputFilePath2：导出音频文件路径2
    //startTime：拆分的时间点
    //duration：输入音频文件的总时长

    int audioMerge(QList<QString> filelist);
    //音频文件的连接
    //filelist:待连接的音频文件列表

    int audioIntercept(QString inputFilePath,const double startTime, const double endTime);
    //音频文件的裁剪
    //inputFilePath:音频文件路径
    //startTime:开始裁剪时间点
    //endTime:结束裁剪时间点

    void clearAudioFiles();
    //清理所有产生的音频中间文件

    void process(QString command);

    void domove(int exitCode, QProcess::ExitStatus exitStatus);
    //操纵中间文件
private:
    QString cmd;
};

#endif // AUDIOEDIT_H
