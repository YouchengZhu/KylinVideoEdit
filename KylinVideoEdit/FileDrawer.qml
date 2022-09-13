import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
Item {
    function open()
    {
        drawer.open();
        console.log("open")
    }
    Drawer{
        id: drawer
        width: 300;
        height: parent.height;
        dragMargin: 30
        Column{
            width: drawer.width
            spacing: 5
            padding:0
            MySquareButton{
                id: openVideoBtn
                width: parent.width
                height: 60
                text: qsTr("打开视频文件")
                onClicked: {
                    dialogs.openVideoFileDialog();
                    drawer.close();
                }
            }
            MySquareButton{
                id: openAudioBtn
                width: parent.width;
                height: 60
                text: qsTr("打开音频文件")
                onClicked:{
                    dialogs.openAudioFileDialog();
                    drawer.close();
                }
            }
            MySquareButton{
                id: closeBtn
                width: parent.width
                height: 60
                text: qsTr("关闭")
                onClicked: Qt.quit()
            }
            MySquareButton{
                id: aboutBtn
                width: parent.width;
                height: 60
                text: qsTr("关于")
                onClicked: {
                    drawer.close()
                    dialogs.openAboutDialog();
                }
            }
        }
    }
}

