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
    int videoIntercept(QString inputFilePath,QString outputFilePath,const double startTime, const double endTime);
    //视频裁剪
    //参数1：导入视频文件路径
    //参数2：输出文件路径
    //参数3：开始时间点
    //参数4：结束时间点

    int videoMerge(QList<QString> filelist);
    //视频合并
    //参数1：导入视频路径列表

    int videoAddBackgroundMusic(QString inputVideoFilePath, QString inputAudioFilePath, double duration, QString outputFilePath);
    //添加背景音乐,去除视频原音
    //inputVideoFilePath：导入视频文件路径
    //inputAudioFilePath：导入音频文件路径
    //duration：视频总时长
    //outputFilePath:输出文件路径


    int addBackGroundMusic(QString inputVideoFilePath,QString inputMusicFilePath,QString outputFilePath);
    //给视频添加背景音乐，不改变视频原来的音频
    //inputVideoFilePath：导入的视频资源文件
    //inputMusicFilePath：导入的音频资源文件
    //outputFilePath：输出的文件路径


    int screenshot(QString inputFilePath, double shotTime, QString outputFilePath);
    //图像捕获，截图
    //inputFilePath:导入视频文件路径
    //shotTime:截图时间点
    //outputFilePath:输出图片文件路径

    int addPicInPic(QString inputVideoFilePath, QString inputImgFilePath, double x, double y, QString outputFilePath);
    //添加画中画效果
    //inputVideoFilePath:导入视频文件路径
    //inputImgFilePath:导入的图片文件路径
    //x,y: 添加画中画效果的位置
    //outFilePath:输出视频文件路径

    int videoSplit(QString inputFilePath, QString outputFilePath1, QString outputFilePath2, double splitTime, double duration);
    //视频拆分
    //inputFilePath:导入视频文件路径
    //outputFilePath1:输出第一个视频文件路径
    //outputFilePath2:输出第二个视频文件路径
    //splitTime:拆分时间点
    //duration:视频总时长

   // void savePic(QString filePath);
    //截图图片另存为
    //filePath:图片保存路径

    void process(QString command);
    //执行命令
    //command: 命令行指令
private:
    QString m_cmd;
};


#endif // VIDEOEDIT_H
