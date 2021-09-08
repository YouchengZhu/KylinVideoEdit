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
    int audioSplit(QString inputPath,QString outputPath1,QString outputPath2,const double time,double duration);
    int audioMerge(QList<QString> inputPaths,QString outputPath);
    //两段音频文件的连接
    //参数1：需要进行合并的多个音频文件路径
    //参数2：输出的文件路径
    int audioIntercept(const QString filepath1, const QString filepath2, const double start_time, const double end_time);
    void processingCommand(std::string command);
private:
    std::string cmd;
};

#endif // AUDIOEDIT_H
