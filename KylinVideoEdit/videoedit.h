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
    int videoIntercept(QString in_filename, QString out_filename, const double start_time, const double end_time);
    //视频合并
    int videoMerge(QList<QString> filelist,QString dstName,QString dstPath);
    //添加背景音乐
    //file1: input video file path.
    //file2: input photo file path.
    //duration: video's duration.
    //file3: output file path;
    int videoAddBackgroundMusic(QString file1, QString file2, double duration, QString file3);
    //截图
    //filepath1: input video file path.
    //start_time: the screenshot's time.
    //filepath2: the path that save the screenshot.
    int screenshot(QString filepath1, double start_time, QString filepath2);
    //添加水印
    //filepath1: input video's filepath;
    //filepath2: input watermark's filepath;
    //x,y: the position of watermark.
    //filepath3: output file path after add watermark.
    int addWatermark(QString filepath1, QString filepath2, double x, double y, QString filepath3);
    //视频拆分
    //filepath1: input video's path;
    //filepath2: ourtput video1's path after split.
    //filepath3: output video2's path after split.
    //split_time: split time.
    int videoSplit(QString filepath1, QString filepath2, QString filepath3, double split_time, double duration);
    //执行命
    //command: the command that needs process.
    void processingCommand(std::string command);
private:
    std::string cmd;
};


#endif // VIDEOEDIT_H
