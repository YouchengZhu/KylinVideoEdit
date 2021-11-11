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
#ifndef VIDEOEDIT_H
#define VIDEOEDIT_H

#include <iostream>
#include <QObject>
#include <QDebug>
#include <QProcess>

class VideoEdit:public QObject
{
    Q_OBJECT
signals:
    void finish();//C++调用命令行函数执行结束
    void start();//C++调用命令行函数执行开始
public slots:
    int videoIntercept(QString inputFilePath,const double startTime, const double endTime);
    //视频剪辑
    //inputFilePath: 导入视频文件路径
    //startTime:开始裁剪时间
    //endTime:结束裁剪时间

    int videoMerge(QList<QString> filelist);
    //视频合并
    //filelist:合并视频文件列表

    int addBackgroundMusic_1(QString inputVideoFilePath, QString inputAudioFilePath, double duration);
    //添加背景音乐（去除视频原音）
    //inputVideoFilePath:视频文件路径
    //inputAudioFilePath:音频文件路径
    //duration:视频总时长

    int addBackGroundMusic_2(QString inputVideoFilePath,QString inputAudioFilePath);
    //给视频添加背景音乐，不改变视频原来的音频
    //inputVideoFilePath：视频文件路径
    //inputAudioFilePath:音频文件路径

    int screenshot(QString inputFilePath, double startTime, QString outputFilePath);
    //截图
    //inputFilePath:视频文件路径
    //startTime:截图时间点
    //outputFilePath:截图文件保存路径

    int addPicInPic(QString inputVideoFilePath, QString inputImgFilePath, double x, double y);
    //添加画中画
    //inputVideoFilePath:导入视频文件路径
    //inputImageFilePath:导入图片文件路径
    //x:画中画横坐标
    //y:画中画纵坐标

    int videoSplit(QString inputFilePath, QString outputFilePath1, QString outputFilePath2, double splitTime, double duration);
    //视频拆分
    //inputFilePath:导入视频文件路径
    //outputFilePath1:输出视频文件路径1
    //outputFilePath2:输出视频文件路径2
    //splitTime:拆分时间点
    //duration:视频总时长


    void finishFile(QString outputFilePath);
    //完成视频，导出最后的视频文件
    //outputFilePath:导出视频文件路i经

    void clearVideoFiles();
    //当用户关闭界面后处理所有产生的中间文件

    void process(QString command);
    //执行命令行
    //command: 命令

    void domove(int exitCode, QProcess::ExitStatus exitStatus);
    //操纵中间文件
private:
    QString cmd;
};


#endif // VIDEOEDIT_H
