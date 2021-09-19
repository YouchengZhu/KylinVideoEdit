import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2 as QQD

Item {
    property alias bgMusicPlayList: bgMusicPlayList
    property alias bgMusicPlayWindow: bgMusicPlayWindow
    property alias selectBtn: selectBtn
    property alias bgmAcceptBtn: acceptBtn
    property alias bgmCancelBtn: cancelBtn
    property var  checkBoxState : true

    //确认信号操作（点击确认按钮确定添加背景音乐）
    signal confirm()

    function open()
    {
        bgMusicDialog.open()
    }

    function close()
    {
        bgMusicDialog.close();
    }

    QQD.Dialog{
        id: bgMusicDialog
        title: qsTr("选择背景音乐")
        property alias bgMusicPlayList: bgMusicPlayList
        property alias selectBtn: selectBtn
        contentItem: Rectangle{
            implicitWidth: 500
            implicitHeight: 800
            Text{
                id: title;
                text:qsTr("选择背景音乐")
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
                text: qsTr("选择音乐曲目，音乐将根据视频的长度自动调整。此项可导入并\n添加自己的音频曲目")
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
            ScrollView {
                id: scrollView
                anchors.top: lineTop.bottom;
                anchors.topMargin: 20
                height: 400;
                anchors.left: parent.left;
                anchors.leftMargin: 10
                anchors.right: parent.right;
                anchors.rightMargin: 10
                PlayList{
                    id: bgMusicPlayList
                    anchors.fill: parent
                    currentPlayWindow: bgMusicPlayWindow
                    onPlay: {
                        console.log("背景音乐播放")
                        bgMusicPlayWindow.mediaPlayer.play();
                    }
                }
            }
            Rectangle{
                id: lineBottom
                width: parent.width;
                height: 3
                color: "gray"
                anchors.top: scrollView.bottom;
                anchors.topMargin: 25
                anchors.right: parent.right;
                anchors.rightMargin: 10
            }
            CheckBox{
                id: checkBox;
                anchors.top: lineBottom.bottom;
                anchors.topMargin: 25;
                checked: true
                text: "是否去除视频原音"
                onCheckedChanged: {
                    if(checked === false)
                        checkBoxState = false
                    else
                        checkBoxState = true

                }
                font.family: "Arial"
                font.weight: Font.Thin
                font.pixelSize: 17
            }
            Button{
                id: selectBtn
                anchors.top:checkBox.bottom
                anchors.topMargin: 20
                anchors.left: parent.left;
                anchors.leftMargin: 10
                text: qsTr("选择本地背景音乐")
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
                    confirm();//发送信号确认进行添加背景音乐的操作
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
                    bgMusicDialog.close();//关闭背景音乐选择窗口
                }
                font.family: "Arial"
                font.weight: Font.Thin
                font.pixelSize: 17
            }

        }
    }
    BgmPlayWindow{
        id: bgMusicPlayWindow
        visible: false
    }
}

