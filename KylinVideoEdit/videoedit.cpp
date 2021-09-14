#include "videoedit.h"
#include <unistd.h>
#include <QFile>

extern "C" {
#include <libavutil/timestamp.h>
#include <libavformat/avformat.h>
}

int VideoEdit::videoIntercept(QString inputFilePath,QString outputFilePath,const double startTime, const double endTime)
{
    inputFilePath = inputFilePath.right(inputFilePath.length() - 7);
    outputFilePath = outputFilePath.right(outputFilePath.length() - 7);

    //先将视频转换为全部为关键帧的视频
    m_cmd = "ffmpeg -i " + inputFilePath + " -strict -2 -qscale 0 -input " + "./intercept.mp4";
    process(m_cmd);

    m_cmd = "ffmpeg -ss " +  QString::number(startTime,10,4) + " -i " + inputFilePath  + " -t " + QString::number(endTime - startTime,10,4) + " -c copy  "+ outputFilePath  + " -y";
    process(m_cmd);

    m_cmd = "rm ./intercept.mp4";
    process(m_cmd);

    return 0;
}

int VideoEdit::videoMerge(QList<QString> fileList)
{
    //处理导入文件的路径
    QList<QString> filelist;
    for(int i = 0; i < fileList.length(); i++)
    {
        filelist.push_back(fileList[i].right(fileList[i].length()-7));
        qDebug()<<"filelist[i] = "<<filelist[i];
    }

    //生成临时文件名
    QList<QString> outpathNames;
    for (int i = 0;i < filelist.length();i++)
    {
        QString fileName = "out" + QString::number(i,10) + ".mp4";
        outpathNames.push_back(fileName);
        qDebug()<<fileName;
    }

    //获取第一个视频的宽高
    QString temp = filelist[0];
    AVFormatContext *fmtCtx = nullptr;
    int width, height;
    std::string tr;
    QString fileFormat;
    tr= temp.toStdString();
    const char *in_filename = tr.data();
    int ret = avformat_open_input(&fmtCtx, in_filename, NULL, NULL);
    if(ret) {
        qDebug()<<"open input failed";
    }
    ret = avformat_find_stream_info(fmtCtx, NULL);
    int videoIndex = av_find_best_stream(fmtCtx,  AVMEDIA_TYPE_VIDEO, -1, -1, nullptr, 0);
    width = fmtCtx->streams[videoIndex]->codec->width;
    height = fmtCtx->streams[videoIndex]->codec->height;
    fileFormat = fmtCtx->streams[videoIndex]->codecpar->format;

    //存储临时文件
    QString width1 = QString::number(width, 10);
    QString height1 = QString::number(height, 10);

    //在转换之前将之前out1,ou2,...文件给删掉 第一次执行不会删
    for(int del = 0; del < filelist.length(); del++)
    {
        QString file = "rm ./out" + QString::number(del, 10) + ".mp4";
        const char *rmFile = file.toStdString().c_str();
        system(rmFile);
    }

    //进行格式转换，存储为临时文件
    for(int i = 0; i < filelist.length();i++)
    {
        std::string cmd = "ffmpeg -i " + (filelist[i]).toStdString() + "  -vf scale="+ (width1).toStdString()+ ":" + (height1).toStdString() + " ./" + (outpathNames[i]).toStdString();
        const char* cmd1 = cmd.c_str();
        system(cmd1);
    }

    QFile file("in.txt");

    if(!file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        return -1;
    }
    QTextStream stream(&file);

    for(int i = 0; i < outpathNames.length(); i++)
    {
        stream << "file \'" <<"./"<< outpathNames[i] << "\'"<< "\n";
        qDebug()<<"file \'" <<"./"<< outpathNames[i] << "\'";
    }


    m_cmd = "ffmpeg -f concat -safe 0 -i ./in.txt -c copy  ./新视频1.mp4 -y" ;
    process(m_cmd);

//    cmd = "mv ./新视频1.mp4 ./新视频.mp4";

    return 0;
}


int VideoEdit::videoAddBackgroundMusic(QString inputVideoFilePath, QString inputAudioFilePath, double duration, QString outputFilePath)
{
    inputVideoFilePath = inputVideoFilePath.right(inputVideoFilePath.length() - 7);
    inputAudioFilePath = inputAudioFilePath.right(inputAudioFilePath.length() - 7);
    outputFilePath = outputFilePath.right(outputFilePath.length() - 7);

    m_cmd = "ffmpeg -an -i " + inputVideoFilePath + " -stream_loop -1 -i " + inputAudioFilePath + " -t " + QString::number(duration,10,4) + " -y " + outputFilePath;
    process(m_cmd);
    return 0;
}

int VideoEdit::addBackGroundMusic(QString inputVideoFilePath, QString inputMusicFilePath,QString outputFilePath)
{
    m_cmd = "ffmpeg -i " + inputVideoFilePath.right(inputVideoFilePath.length()-7) + " -i " + inputMusicFilePath.right(inputMusicFilePath.length()-7) +
            " -filter_complex amix=inputs=2:duration=first:dropout_transition=2 " + outputFilePath.right(outputFilePath.length()-7);

    process(m_cmd);

    return 0;

}

int VideoEdit::screenshot(QString inputFilePath, double shotTime, QString outputFilePath)
{
    inputFilePath = inputFilePath.right(inputFilePath.length() - 7);
    outputFilePath = outputFilePath.right(outputFilePath.length() - 7);

    m_cmd = "ffmpeg -i " + inputFilePath + " -y -f image2 -ss " + QString::number(shotTime,10,4) + " -vframes 1 -s " + "640x360 " + outputFilePath;
    process(m_cmd);
}

int VideoEdit::addPicInPic(QString inputVideoFilePath, QString inputImgFilePath, double x, double y, QString outputFilePath)
{
    inputVideoFilePath = inputVideoFilePath.right(inputVideoFilePath.length() - 7);
    inputImgFilePath = inputImgFilePath.right(inputImgFilePath.length() - 7);
    outputFilePath = outputFilePath.right(outputFilePath.length() - 7);

    m_cmd = "ffmpeg -i " + inputImgFilePath + " -vf scale=100:-1" + " /root/tmp.jpg";
    process(m_cmd);
    m_cmd = "ffmpeg -i " + inputVideoFilePath + " -i " + "/root/tmp.jpg" + " -filter_complex overlay=" + QString::number(x,10,4) + ":" + QString::number(y,10,4) + " -y " + outputFilePath;
    process(m_cmd);
    m_cmd = "rm /root/tmp.jpg";
    process(m_cmd);

    return 0;
}

int VideoEdit::videoSplit(QString inputFilePath, QString outputFilePath1, QString outputFilePath2, double splitTime, double duration)
{
    inputFilePath = inputFilePath.right(inputFilePath.length() - 7);

    //先将视频转换为全部为关键帧的视频
    m_cmd = "ffmpeg -i " + inputFilePath + " -strict -2 -qscale 0 -input " + "./intercept.mp4";
    process(m_cmd);

    m_cmd = "ffmpeg -ss " +  QString::number(0,10,4) + " -i " + inputFilePath  + " -t " + QString::number(splitTime,10,4) + " -c copy " + outputFilePath1.right(outputFilePath1.length()-7)  + " -y";
    process(m_cmd);

    m_cmd = "rm ./intercept.mp4";
    process(m_cmd);

    m_cmd = "ffmpeg -ss " +  QString::number(splitTime,10,4) + " -i " + inputFilePath  + " -t " + QString::number(duration-splitTime,10,4) + " -c copy " + outputFilePath2.right(outputFilePath2.length() - 7)  + " -y";
    process(m_cmd);

    m_cmd = "rm ./intercept.mp4";
    process(m_cmd);

    return 0;
}

void VideoEdit::process(QString command)
{
    QProcess *process = new QProcess;
    qDebug()<<"cmd is "<< command;
    if(process-> state() != process->NotRunning)
    {
        process->waitForFinished();
    }

    process->start(command);
}
