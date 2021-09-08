#include "audioedit.h"
#include "videoedit.h"
#include <QProcess>
#include <unistd.h>
#include <QFile>

std::string doubleToString1(double num)
{
    char str[256];
    sprintf(str, "%lf", num);
    std::string result = str;
    return result;
}

int AudioEdit::audioSplit(QString inputPath, QString outputPath1, QString outputPath2, const double time,double duration)
{
    int ret1 = audioIntercept(inputPath, outputPath1,0,time);
    int ret2 = audioIntercept(inputPath, outputPath2,time, duration);
    return (ret1==ret2) && ret1 == 0;

}

int AudioEdit::audioMerge(QList<QString> inputPaths, QString outputPath)
{

    QFile file("inputList.txt");
    if(!file.open(QIODevice::WriteOnly|QIODevice::Text))
    {
        return -1;
    }
    QTextStream stream(&file);

    for (int i = 0; i < inputPaths.length();i++)
    {
        stream << "file \'" << inputPaths[i].right(inputPaths[i].length()-7) <<"\'"<<"\n";
    }

    QProcess *process = new QProcess();
    QString cmd = "ffmpeg -f concat -safe 0 -i inputList.txt -c copy " + outputPath.right(outputPath.length()-7);
    qDebug()<<cmd;
    process->start(cmd);

    return 0;

}

int AudioEdit::audioIntercept(const QString filepath1, const QString filepath2, const double start_time, const double end_time)
{
    std::string str1 = filepath1.toStdString();
    std::string str2 = filepath2.toStdString();
    QString str = "hello" + filepath1;
    cmd = "ffmpeg -i " + str1 + " -ss " + doubleToString1(start_time) + " -t " + doubleToString1(end_time-start_time) + " -acodec copy "  +  str2 + " -y";
    processingCommand(cmd);
}

void AudioEdit::processingCommand(std::string command)
{
    QString Qcmd = QString::fromStdString(command);
    QProcess* proc = new QProcess;
    qDebug()<< "cmd is "<< Qcmd;
    if(proc->state() != proc->NotRunning)
    {
        proc->waitForFinished(20000);
    }
    proc->start(Qcmd);
}
