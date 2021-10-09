import QtQuick 2.0
import QtQuick.Dialogs 1.2 as QQD
import QtQuick.Layouts 1.0
import Qt.labs.platform 1.1
import QtQuick.Controls 2.0 as QQC
Item{
    property alias saveDialog: saveDialog
    property alias folderDialog: folderDialog
    property var saveFileName
    signal accepted;
    function open()
    {
        saveDialog.open();
    }
    function close()
    {
        saveDialog.close()
    }
    function converFileName(source)
    {
        var finalName = JSON.stringify(source).substr(8, JSON.stringify(source).length - 9)

        return finalName
    }
    QQD.Dialog{
        id: saveDialog;
        title: "save dialog"
        standardButtons: QQD.StandardButton.Yes | QQD.StandardButton.No
        Keys.enabled: true
        contentItem: Rectangle{
            color: "white"
            implicitWidth: 600
            implicitHeight: 230
            RowLayout{
                width: parent.width;
                anchors.top: parent
                anchors.topMargin: 20
                QQC.Label{
                    id: selectLabel
                    text: qsTr("当前路径")
                    font.pixelSize: 20
                }
                QQC.TextArea{
                    id: folderPath
                    anchors.left: selectLabel.right;
                    anchors.leftMargin: 10
                    anchors.right: selectFolder.left;
                    anchors.rightMargin: 10;
                    text: converFileName(folderDialog.currentFolder)
                    background: Rectangle{
                        border.width: 0.7
                        border.color: "#B2B2B2"
                        opacity: 0.5
                    }
                }
                QQC.Button{
                    id: selectFolder
                    anchors.right: parent.right;
                    width: 100;
                    text: qsTr("选择文件夹")
                    MouseArea{
                        anchors.fill: parent;
                        onPressed:{
                            folderDialog.open();
                        }
                    }
                }
            }
            Column{
                anchors.top: selectFolder
                anchors.bottom: parent.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                spacing: 5
                RowLayout{
                    width: parent.width;
                    spacing: 10
                    QQC.Label{
                        id: nameLabel
                        text: qsTr("名称");
                        width: 100
                        height: 60
                        font.pixelSize: 20
                        anchors.verticalCenter: parent.verticalCenter;
                    }
                    QQC.TextField{
                        id: nameField
                        anchors.left: nameLabel.right;
                        anchors.right: parent.right
                        anchors.leftMargin: 10
                        placeholderText: qsTr("请输入文件名")
                        width: parent.width;
                        height: 60
                        wrapMode: Text.WordWrap
                        cursorVisible: true
                        font.family: "Arial"
                        font.weight: Font.Thin
                        font.pixelSize: 17
                        selectByMouse: true
                        background: Rectangle{
                            border.width: 0.7
                            border.color: "#B2B2B2"
                            opacity: 0.5
                        }
                    }
                }
                RowLayout{
                    anchors.right: parent.right
                    QQC.Button{
                        id: okBtn
                        width: 30
                        text: "ok"
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                               saveFileName = "file://" + folderPath.text + "/" + nameField.text +".jpg";
                               accepted();
                            }
                        }
                    }
                    QQC.Button{
                        id: cancelBtn
                        width: 30
                        text: "cancel"
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                saveDialog.close();
                            }
                        }
                    }
                }
            }
        }
    }
    FolderDialog{
        id: folderDialog
        acceptLabel: qsTr("确认")
        rejectLabel: qsTr("取消")
        options: FolderDialog.ShowDirsOnly
        onAccepted: {
            folderPath.text = converFileName(currentFolder);
        }
        modality: Qt.ApplicationModal
    }
}


