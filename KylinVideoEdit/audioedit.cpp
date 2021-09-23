#include "audioedit.h"
#include "videoedit.h"
#include <QProcess>
#include <unistd.h>
#include <QFile>

int AudioEdit::audioSplit(QString inputFilePath,QString outputFilePath1,QString outputFilePath2,const double startTime,double duration)
{
    outputFilePath1 = outputFilePath1.right(outputFilePath1.length()- 7);
    outputFilePath2 = outputFilePath2.right(outputFilePath2.length()- 7);

    cmd = "ffmpeg -i " + inputFilePath + " -ss " + QString::number(0,10,4) + " -t " + QString::number(startTime,10,4) + " -acodec copy " + outputFilePath1 + " -y";

    process(cmd);

    cmd = "ffmpeg -i " + inputFilePath + " -ss " + QString::number(startTime,10,4) + " -t " + QString::number(duration-startTime,10,4) + " -acodec copy " +  outputFilePath2 + " -y";

    process(cmd);

    return 0;
}

int AudioEdit::audioMerge(QList<QString> filelist)
{

    QFile file("inputList.txt");
    if(!file.open(QIODevice::WriteOnly|QIODevice::Text))
    {
        return -1;
    }
    QTextStream stream(&file);

    for (int i = 0; i < filelist.length();i++)
    {
        stream << "file \'" << filelist[i].right(filelist[i].length()-7) <<"\'"<<"\n";
    }

    QString cmd = "ffmpeg -f concat -safe 0 -i inputList.txt -c copy ./新音频1.mp3 -y";

    char* ch;
    QByteArray ba = cmd.toLatin1(); // must
    ch=ba.data();
    QProcess *process = new QProcess;
    connect(process, SIGNAL(finished(int, QProcess::ExitStatus)), this, SLOT(domove(int, QProcess::ExitStatus)));
    qDebug()<<"cmd is "<< cmd;
    if(process-> state() != process->NotRunning)
    {
        process->waitForFinished();
    }

    process->start(cmd);

    return 0;
}

int AudioEdit::audioIntercept(QString inputFilePath,const double startTime, const double endTime)
{
    inputFilePath = inputFilePath.right(inputFilePath.length() - 7);

    //    QString str = "hello" + filepath1;
    cmd = "ffmpeg -i " + inputFilePath + " -ss " + QString::number(startTime,10,4) + " -t " + QString::number(endTime - startTime,10,4) + " -acodec copy ./新音频1.mp3 -y";

    char* ch;
    QByteArray ba = cmd.toLatin1(); // must
    ch=ba.data();
    QProcess *process = new QProcess;
    connect(process, SIGNAL(finished(int, QProcess::ExitStatus)), this, SLOT(domove(int, QProcess::ExitStatus)));
    qDebug()<<"cmd is "<< cmd;
    if(process-> state() != process->NotRunning)
    {
        process->waitForFinished();
    }

    process->start(cmd);

    return 0;
}


void AudioEdit::process(QString command)
{
    QProcess *process = new QProcess;
    qDebug()<<"cmd is "<< command;
    if(process-> state() != process->NotRunning)
    {
        process->waitForFinished(20000);
    }
    process->start(command);
}

void AudioEdit::domove(int exitCode, QProcess::ExitStatus exitStatus)
{
    qDebug()<< "connect success";
    sleep(1);
    QProcess* process = new QProcess;
    cmd = "mv ./新音频1.mp3  ./新音频.mp3";
    process->start(cmd);
    process->waitForFinished(-1);
}

