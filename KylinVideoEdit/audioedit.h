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
    //参数1：输入音频文件路径
    //参数2：导出音频文件路径1
    //参数3：导出音频文件路径2
    //参数4：拆分的时间点
    //参数5：输入音频文件的总时长

    int audioMerge(QList<QString> inputFilePaths,QString outputFilePath);
    //两段音频文件的连接
    //参数1：需要进行合并的多个音频文件路径
    //参数2：输出的音频文件路径

    int audioIntercept(QString inputFilePath, QString outputFilePath, const double startTime, const double endTime);
    //音频文件的裁剪
    //参数1：输入音频文件路径
    //参数2：导出音频文件路径
    //参数3：开始截取时间
    //参数4：结束截取时间
    void process(QString command);
private:
    QString cmd;
};

#endif // AUDIOEDIT_H
