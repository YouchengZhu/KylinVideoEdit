import QtQuick 2.0
import QtQuick.Dialogs 1.2 as QQD
import QtQuick.Controls 2.0 as QQC

Item {
    property alias fileOpenDialog:fileOpen
    property alias messageDialog: messageDialog
    property alias saveCutDialog: saveCutDialog
    property alias aboutDialog:aboutDialog
    property alias inputCutFileNameDialog: inputCutFileName
    property alias inputCutName: inputCutName

    property alias saveMergeDialog: saveMergeDialog
    property alias inputMergeFileNameDialog: inputMergeFileName
    property alias inputMergeName: inputMergeName

    function openFileDialog() {
        fileOpen.open();
    }
    function openMessageDialog() {
        messageDialog.open();
    }
    function openSaveCutDialog() {
        saveCutDialog.open();
    }
    function openInputCutFileNameDialog() {
        inputCutFileNameDialog.open()
    }

    function openSaveMergeDialog() {
        saveMergeDialog.open();
    }
    function openInputMergeFileNameDialog() {
        inputMergeFileNameDialog.open()
    }
    //文件窗口
    QQD.FileDialog{
        id:fileOpen
        title: "select the file"
        folder: shortcuts.documents
        //nameFilters: ["video files(*.mp4 *.mkv *.avi *.mpg *.ts *.mov)"]
        selectMultiple: true
    }
    //提醒窗口
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
                text: "合并前请选择需要进行合并的两个及以上视频！"
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
    //裁剪文件保存窗口
    QQD.FileDialog{
        id: saveCutDialog;
        title: "Save file"
        selectExisting: false
        folder: shortcuts.documents
        selectFolder: true;
    }

    //读取保存裁剪文件名窗口
    QQD.Dialog{
        id: inputCutFileName
        title: "请输入文件名"
        Row{
            QQC.Label{
                text:qsTr("请输入需要的保存文件名：")
            }
            QQC.TextField{
                id: inputCutName
            }
        }
        standardButtons: QQD.StandardButton.Yes | QQD.StandardButton.No
        Keys.enabled: true
        Keys.onEnterPressed: yes()
    }
    //合并文件保存窗口
    QQD.FileDialog{
        id: saveMergeDialog;
        title: "Save file"
        selectExisting: false
        folder: shortcuts.documents
        selectFolder: true;
    }
    //读取保存合并文件名窗口
    QQD.Dialog{
        id: inputMergeFileName
        title: "请输入文件名"
        Row{
            QQC.Label{
                text:qsTr("请输入需要的保存文件名：")
            }
            QQC.TextField{
                id: inputMergeName
            }
        }
        standardButtons: QQD.StandardButton.Yes | QQD.StandardButton.No
        Keys.enabled: true
        Keys.onEnterPressed: yes()
    }
    QQD.Dialog {
        id: aboutDialog
        title: "About KylinCutter"
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
}
