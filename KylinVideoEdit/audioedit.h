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
    //音频拆分
    //inputFilePath：输入音频文件路径
    //outputFilePath1：导出音频文件路径1
    //outoutFilePath2：导出音频文件路径2
    //startTime：拆分的时间点
    //duration：输入音频文件的总时长

    int audioMerge(QList<QString> inputFilePaths,QString outputFilePath);
    //音频连接
    //inputFilePaths：需要进行合并的多个音频文件路径
    //outputFilePath：输出的音频文件路径

    int audioIntercept(QString inputFilePath, QString outputFilePath, const double startTime, const double endTime);
    //音频裁剪
    //inputFilePath：输入音频文件路径
    //outputFilePath：导出音频文件路径
    //startTime：开始截取时间
    //endTime：结束截取时间

    void process(QString command);
    //执行命令行
    //command:命令行指令

private:
    QString m_cmd;
};

#endif // AUDIOEDIT_H
