#include "videoedit.h"
#include <QProcess>
#include <unistd.h>
#include <QFile>

extern "C" {
#include <libavutil/timestamp.h>
#include <libavformat/avformat.h>
}

std::string doubleToString(double num)
{
    char str[256];
    sprintf(str, "%lf", num);
    std::string result = str;
    return result;
}
int VideoEdit::videoIntercept(QString in_file, QString out_file, const double start_time, const double end_time)
{
    AVFormatContext *ifmt_ctx = NULL, *ofmt_ctx = NULL;
    AVPacket pkt;
    int ret, i;

    std::string tr;
    tr= in_file.toStdString();
    const char *in_filename = tr.data();

    std::string tr2;
    tr2 = out_file.toStdString();
    const char *out_filename = tr2.data();

    //先将视频转换为全部为关键帧的视频
    std::string cmd = "ffmpeg -i " + tr + " -strict -2 -qscale 0 -input " + "./intercept.mp4";
    QString Qcmd = QString::fromStdString(cmd);
    QProcess *proc = new QProcess;
    if(proc->state() != proc->NotRunning) {
        proc->waitForFinished(20000);
    }
    proc->start(Qcmd);

//    cmd = "ffmpeg -ss " +  doubleToString(start_time) + " -t "+ doubleToString(end_time - start_time)+ " -i " + tr +" -vcodec copy -acodec copy " + tr2;
    cmd = "ffmpeg -ss " +  doubleToString(start_time) + " -i " + tr + " -t " + doubleToString(end_time - start_time) + " -c copy " + tr2;
    Qcmd = QString::fromStdString(cmd);
    qDebug()<< Qcmd;
    if(proc->state() != proc->NotRunning) {
        proc->waitForFinished(20000);
    }
    proc->start(Qcmd);

    cmd = "rm ./intercept.mp4";
    Qcmd = QString::fromStdString(cmd);
    if(proc->state() != proc->NotRunning) {
        proc->waitForFinished(20000);
    }
    proc->start(Qcmd);

    return 0;
}


int VideoEdit::videoMerge(QList<QString> fileList,QString dstName,QString dstPath)
{
    QList<QString> filelist;
    for(int i = 0; i < fileList.length(); i++)
    {
        filelist.push_back(fileList[i].right(fileList[i].length()-7));
        qDebug()<<"filelist[i] = "<<filelist[i];
    }
    QString temp = filelist[0];
    AVFormatContext *fmtCtx = nullptr;

    QList<QString> outpathNames;/* = {"out1.mp4", "out2.mp4", "out3.mp4"};*/

    for (int i = 0;i < filelist.length();i++)
    {
        QString fileName = "out" + QString::number(i,10) + ".mp4";
        outpathNames.push_back(fileName);
        qDebug()<<fileName;
    }

    QList<QString> outFinalPath;/* = {"final1.mp4", "final2.mp4", "final3.mp4"};*/
    for (int i = 0;i < filelist.length()-1;i++)
    {
        QString fileName = "final" + QString::number(i,10) + ".mp4";
        outFinalPath.push_back(fileName);
    }
    outFinalPath.push_back(dstName);
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

    QList<QString> tempInputFiles;
    QString width1 = QString::number(width, 10);
    QString height1 = QString::number(height, 10);

    //在转换之前将之前out1,ou2,...文件给删掉 第一次执行不会删
        for(int del = 0; del < filelist.length(); del++)
        {
            QString file = "rm ./out" + QString::number(del, 10) + ".mp4";
            const char *rmFile = file.toStdString().c_str();
            system(rmFile);
        }
    for(int i = 0; i < filelist.length();i++)
    {
        std::string cmd = "ffmpeg -i " + (filelist[i]).toStdString() + "  -vf scale="+ (width1).toStdString()+ ":" + (height1).toStdString() + " ./" + (outpathNames[i]).toStdString();
        const char* cmd1 = cmd.c_str();
        system(cmd1);
        tempInputFiles.push_back(outpathNames[i]);
    }

    QList<QString> finalfileList = tempInputFiles;
    QFile file("in.txt");

    if(!file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        return -1;
    }
    QTextStream stream(&file);

    QProcess *process =  new QProcess{};
    for(int i = 0; i < finalfileList.length(); i++)
    {
        stream << "file \'" <<"./"<< finalfileList[i] << "\'"<< "\n";
    }

    QString cmd = "ffmpeg -f concat -safe 0 -i ./in.txt -c copy  " + dstPath.right(dstPath.length()-7) +
            outFinalPath[fileList.length()-1];

    process->start(cmd);
    return 0;
}

