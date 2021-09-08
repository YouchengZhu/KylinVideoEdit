import QtQuick 2.0
import QtQuick.Dialogs 1.2 as QQD
import QtQuick.Controls 2.0 as QQC
Item {
//1.打开视频文件对话框
    property alias videoFileDialog: videoFileDialog
    function openVideoFileDialog()
    {
        videoFileDialog.open();
    }
    QQD.FileDialog{
        id: videoFileDialog
        title: qsTr("select the video files")
        folder: shortcuts.documents
        nameFilters: ["video files(*.mp4 *.mkv *.avi *.mpg *.ts *.mov)"]
        selectMultiple: true
    }

//2.打开音频文件对话框
    property alias audioFileDialog: audioFileDialog
    function openAudioFileDialog()
    {
        audioFileDialog.open();
    }
    QQD.FileDialog{
        id: audioFileDialog
        title: qsTr("select the audio files")
        folder: shortcuts.documents
        nameFilters: ["audio files(*.mp3 *.aac *.wav)"]
        selectMultiple: true
    }

//3.关于对话框
    property alias aboutDialog: aboutDialog
    function openAboutDialog()
    {
        aboutDialog.open();
    }
    QQD.Dialog{
        id: aboutDialog
        title: qsTr("About KylinVideoEdit")
        contentItem: Rectangle {
            color: "white"
            implicitWidth: 400
            implicitHeight: 230
            Text {
                text: "\n  Qt Creator: 5.15.2\n  ffmpeg: n4.3.1\n\n       这是一款简易的视频剪辑软件,可以完成一般的视频剪辑功能,满足用户的基本需求。\n      本软件按原样提供，不提供任何形式的担保，包括对设计、适销性和特定用途适用性的担保。"
                anchors.fill: parent
                wrapMode: Text.WordWrap
                font.family: "Arial"
                font.weight: Font.Thin
                font.pixelSize: 17
            }
            QQC.Button{
                text: qsTr("确认")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                onClicked:{
                    aboutDialog.close();
                }
            }
        }
    }
    //4.文件保存对话框
    property alias saveDialog: saveDialog
    function openSaveDialog()
    {
        saveDialog.open();
    }
    MySaveDialog{
        id: saveDialog
    }

    //5.提醒对话框（提醒用户各种注意事项）
    property alias messageDialog: messageDialog;
    function openMessageBox()
    {
        messageDialog.open();
    }
    QQD.MessageDialog {
        id: messageDialog
        property alias mytext: text.text
        title: "提醒"
        onAccepted: {
            messageDialog.close();
        }
        contentItem: Rectangle {
            color: "white"
            implicitWidth: 395
            implicitHeight: 120
            Text{
                id: text
                text: ""
                anchors.fill: parent
                wrapMode: Text.WordWrap
                font.family: "Arial"
                font.weight: Font.Thin
                font.pixelSize: 17
            }
            QQC.Button{
                text: qsTr("确认")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                onClicked:{
                    messageDialog.close();
                }
            }
        }
    }

    //6.背景音乐选择对话框
    property alias addBackgroundMusicDialog: addBackgroundMusicDialog
    function openAddBackgroundMusicDialog()
    {
        addBackgroundMusicDialog.open();
    }
    QQD.Dialog{
        id:addBackgroundMusicDialog
        title: "选择"
        contentItem: Rectangle{
            color: "white"
            implicitWidth: 400
            implicitHeight: 230
            QQC.CheckBox{
                id:checkBox
                anchors.centerIn:parent
                text: "是否去除视频原音"
            }

            QQC.Button{
                anchors.top:checkBox.bottom
                anchors.topMargin: 20
                anchors.left: checkBox.left
                text:"选择背景音乐"
                onClicked: {
                    musicSDialog.open()

                }
            }
        }
    }

    //7.背景音乐选择对话框
    QQD.FileDialog{
        id: musicSDialog
        title: qsTr("select the backgroundMusic files")
        folder: shortcuts.documents
        nameFilters: ["audio files(*.mp3 *.aac *.wav)"]
    }
}
