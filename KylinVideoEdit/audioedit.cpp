#include "audioedit.h"
#include "videoedit.h"
#include <QProcess>
#include <unistd.h>
#include <QFile>

int AudioEdit::audioSplit(QString inputFilePath,QString outputFilePath1,QString outputFilePath2,const double startTime,double duration)
{
    int ret1 = audioIntercept(inputFilePath, outputFilePath1,0,startTime);
    int ret2 = audioIntercept(inputFilePath, outputFilePath2,startTime, duration);
    return (ret1==ret2) && ret1 == 0;
}

int AudioEdit::audioMerge(QList<QString> inputFilePaths,QString outputFilePath)
{

    QFile file("inputList.txt");
    if(!file.open(QIODevice::WriteOnly|QIODevice::Text))
    {
        return -1;
    }
    QTextStream stream(&file);

    for (int i = 0; i < inputFilePaths.length();i++)
    {
        stream << "file \'" << inputFilePaths[i].right(inputFilePaths[i].length()-7) <<"\'"<<"\n";
    }


    QString cmd = "ffmpeg -f concat -safe 0 -i inputList.txt -c copy " + outputFilePath.right(outputFilePath.length()-7);
    process(cmd);

    return 0;

}

int AudioEdit::audioIntercept(QString inputFilePath,QString outputFilePath, const double startTime, const double endTime)
{
    inputFilePath = inputFilePath.right(inputFilePath.length() - 7);
    outputFilePath = outputFilePath.right(outputFilePath.length() - 7);

//    QString str = "hello" + filepath1;
    cmd = "ffmpeg -i " + inputFilePath + " -ss " + QString::number(startTime,10,4) + " -t " + QString::number(endTime - startTime,10,4) + " -acodec copy "  +  outputFilePath + " -y";
    process(cmd);
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

