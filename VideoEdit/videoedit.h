#ifndef VIDEOEDIT_H
#define VIDEOEDIT_H

#include <iostream>
#include <QObject>
#include <QDebug>

class VideoEdit:public QObject
{
    Q_OBJECT
public slots:
    int videoIntercept(QString in_filename, QString out_filename, const double start_time, const double end_time);
    int videoMerge(QList<QString> filelist,QString dstName,QString dstPath);

};


#endif // VIDEOEDIT_H
