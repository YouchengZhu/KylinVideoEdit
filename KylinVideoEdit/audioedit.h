#ifndef AUDIOEDIT_H
#define AUDIOEDIT_H

#include <iostream>
#include <QObject>
#include <QDebug>
#include <QProcess>

class AudioEdit: public QObject
{
     Q_OBJECT
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

    void process(QString command);

    void domove(int exitCode, QProcess::ExitStatus exitStatus);
    //操纵中间文件
private:
    QString cmd;
};

#endif // AUDIOEDIT_H
