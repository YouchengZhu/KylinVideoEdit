//----------新增 画中画对话框
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2 as QQD

Item {
    signal accepted(var path);//点击确认按钮发送信号，传递图片文件路径

    //--------------------
    property var targetVideoIndex //记录选择画中画的视频索引
    property alias selectBtn: selectBtn
    property alias acceptBtn: acceptBtn
    property alias cancelBtn: cancelBtn
    property var finalPic;
    property var fileNames: ["/PicInPic/1.gif", "/PicInPic/2.gif", "/PicInPic/3.gif","/PicInPic/4.gif","/PicInPic/5.gif","/PicInPic/6.png","/PicInPic/7.jpg","/PicInPic/8.jpg"]
    function open()
    {
        picInPicDialog.open()
    }
    function close()
    {
        picInPicDialog.close();
    }
    function displayImageByGrid()
    {
        element.clear();
        for(var i = 0; i < fileNames.length; i++)
        {
            element.append({"pic":fileNames[i]})
        }
    }

    QQD.Dialog{
        id: picInPicDialog
        contentItem: Rectangle{
            implicitWidth: 800
            implicitHeight: 1000
            Text{
                id: title;
                text:qsTr("选择图片")
                anchors.left: parent.left;
                anchors.leftMargin: 10
                anchors.top: parent.top;
                anchors.topMargin: 10
                anchors.right: parent.right;
                anchors.rightMargin: 10
                font.family: "Arial"
                font.weight: Font.Thin
                font.pixelSize: 25
                font.bold: true
            }
            Text{
                id: tip;
                anchors.left: parent.left;
                anchors.leftMargin: 10
                anchors.top: title.bottom;
                anchors.topMargin: 25
                anchors.right: parent.right;
                anchors.rightMargin: 10
                text: qsTr("选择画中画。此项可导入并添加本地图片")
                font.family: "Arial"
                font.weight: Font.Thin
                font.pixelSize: 17

            }
            Rectangle{
                id: lineTop
                width: parent.width;
                height: 3
                color: "gray"
                anchors.top: tip.bottom;
                anchors.topMargin: 25
                anchors.right: parent.right;
                anchors.rightMargin: 10
            }
            GridView{
                id: gridView
                anchors.top: lineTop.bottom;
                anchors.topMargin: 20
                height: 600;
                anchors.left: parent.left;
                anchors.leftMargin: 10
                anchors.right: parent.right;
                anchors.rightMargin: 10
                model: element
                clip: true;
                currentIndex: -1;
                //设置项大小
                cellWidth: 195;
                cellHeight: 175;
                delegate: Rectangle{
                    width: gridView.cellWidth;
                    height: gridView.cellHeight;
                    color: GridView.isCurrentItem?"black":"white"
                    AnimatedImage{
                        anchors.top: parent.top;
                        anchors.bottom: parent.bottom;
                        anchors.left: parent.left;
                        anchors.leftMargin: 5;
                        anchors.right: parent.right;
                        anchors.rightMargin: 5;
                        source: pic
                        fillMode: AnimatedImage.PreserveAspectFit
                        TapHandler{
                            onTapped: {
                                gridView.currentIndex = index;
                                finalPic = fileNames[index]
                                console.log("finalPic" + finalPic);
                            }
                        }
                    }
                    focus: true;
                }
            }
            ListModel {
                id: element
            }
            Rectangle{
                id: lineBottom
                width: parent.width;
                height: 3
                color: "gray"
                anchors.top: gridView.bottom;
                anchors.topMargin: 25
                anchors.right: parent.right;
                anchors.rightMargin: 10
            }
            Button{
                id: selectBtn
                anchors.top:lineBottom.bottom;
                anchors.topMargin: 20
                anchors.left: parent.left;
                anchors.leftMargin: 10
                text: qsTr("选择本地图片")
                font.family: "Arial"
                font.weight: Font.Thin
                font.pixelSize: 17
            }
            Button{
                id: acceptBtn
                width: 100;
                text: qsTr("确认")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.left: parent.left;
                anchors.leftMargin: 10
                onClicked:{
                    picInPicDialog.close()
                    accepted(finalPic)//传递当前图片文件的路径
                }
                font.family: "Arial"
                font.weight: Font.Thin
                font.pixelSize: 17
            }
            Button{
                id: cancelBtn
                text: qsTr("取消")
                width: 100;
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.right: lineBottom.right;
                anchors.rightMargin: 10
                onClicked:{
                    picInPicDialog.close();
                }
                font.family: "Arial"
                font.weight: Font.Thin
                font.pixelSize: 17
            }
        }
    }
}

