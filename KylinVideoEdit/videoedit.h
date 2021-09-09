#ifndef VIDEOEDIT_H
#define VIDEOEDIT_H

#include <iostream>
#include <QObject>
#include <QDebug>
#include <QProcess>

class VideoEdit:public QObject
{
    Q_OBJECT
public slots:
    //视频剪辑
    //in_filename: input video's path.
    //out_filename: the video's path after intercept.
    //start_time: the start time of intercept.
    //end_time: the end time of intercept.
    int videoIntercept(QString inputFilePath,const double startTime, const double endTime);

    //视频合并
    int videoMerge(QList<QString> filelist);

    //添加背景音乐
    //file1: input video file path.
    //file2: input photo file path.
    //duration: video's duration.
    //file3: output file path;
    int videoAddBackgroundMusic(QString inputVideoFilePath, QString inputAudioFilePath, double duration, QString outputFilePath);


    int addBackGroundMusic(QString inputVideoFilePath,QString inputMusicFilePath,QString outputFilePath);
    //给视频添加背景音乐，不改变视频原来的音频
    //参数1：导入的视频资源文件
    //参数2：导入的音频资源文件
    //参数3：输出的文件路径

    //截图
    //filepath1: input video file path.
    //start_time: the screenshot's time.
    //filepath2: the path that save the screenshot.
    int screenshot(QString inputFilePath, double startTime, QString outputFilePath);

    //添加水印
    //filepath1: input video's filepath;
    //filepath2: input watermark's filepath;
    //x,y: the position of watermark.
    //filepath3: output file path after add watermark.
    int addWatermark(QString inputVideoFilePath, QString inputImgFilePath, double x, double y, QString outFilePath);

    //视频拆分
    //filepath1: input video's path;
    //filepath2: ourtput video1's path after split.
    //filepath3: output video2's path after split.
    //split_time: split time.
    int videoSplit(QString inputFilePath, QString outputFilePath1, QString outputFilePath2, double splitTime, double duration);

    //执行命
    //command: the command that needs process.
    void process(QString command);
private:
    QString cmd;
};


#endif // VIDEOEDIT_H
