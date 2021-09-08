import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtMultimedia 5.12
import VideoEdit 1.0

ApplicationWindow {
    property var nowFilePath: []
    property var cutflag: 0
    width: 1280
    height: 900
    visible: true
    minimumWidth: 1480;//界面最小宽
    minimumHeight: 900;//界面最小高

    title: qsTr("麒麟剪辑器")

    MyRadioButton{
        id: radioBtn
        x: 15; y: 15
        radius: 30
        opacity: 0.1
        color: "gray"
        text: qsTr("\u2630")
        onClicked: drawer.open()
    }
    //抽屉式左侧菜单栏
    Drawer{
        id: drawer
        width: 300
        height: parent.height;
        dragMargin: 30
        Column{
            spacing: 5
            padding:0
            MySquareButton{
                id: openBtn
                width: drawer.width
                height: 60
                text: "打开"
                onClicked: {
                    dialogs.openFileDialog();
                    drawer.close();
                }
            }
            MySquareButton{
                id: closeBtn
                width: drawer.width
                height: 60
                text: "关闭"
                onClicked: Qt.quit()
            }
            MySquareButton{
                id: aboutBtn
                width: drawer.width
                height: 60
                text: "关于"
                onClicked: {
                    drawer.close();
                    dialogs.aboutDialog.open()
                }
            }
        }
    }

    Rectangle{
        width: 100
        height: 45
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.rightMargin: 40
        color: "red"
        Text {
            id: name
            text: qsTr("添加背景音乐")
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {

            }
        }
    }

    Dialogs{
        id:dialogs
        fileOpenDialog.onAccepted:
        {
            display.image.visible = false
            var fileNames = dialogs.fileOpenDialog.fileUrls;
            playlist.selectFiles(fileNames);
            playlist.sum.length = fileNames.length
            for(var i = 0; i < playlist.sum.length; i++)
                playlist.sum[i] = 0;
            display.rangeSlider.visible = false
            display.slider.visible = true
        }
        //保存裁剪文件
        saveCutDialog.onAccepted: {
            openInputCutFileNameDialog();
        }
        inputCutFileNameDialog.onYes: {//从用户处获取文件名
            console.log("inputFileNameDialog.onYes")
            var dstSource = saveCutDialog.folder +"/" +inputCutName.text + ".mp4";
            console.log("dstSource"+dstSource)
            videoEdit.videoIntercept(display.mediaPlayer.playlist.currentItemSource, dstSource, display.rangeSlider.first.value/1000, display.rangeSlider.second.value/1000);
            inputCutName.text = ""
        }

        //保存合并文件
        saveMergeDialog.onAccepted: {
            openInputMergeFileNameDialog();
        }
        inputMergeFileNameDialog.onYes: {//从用户处获取文件名
            var dstSource = saveMergeDialog.folder +"/" +inputMergeName.text + ".mp4";
            var dstName = inputMergeName.text + ".mp4"
            var dstPath = saveMergeDialog.folder + "/";

            var path = dstPath + dstName;
            console.log(path)


            videoEdit.addBackGroundMusic("file:///root/麒麟/testvideo/那些年，我们一起追的女孩.mp4","file:///root/麒麟/testvideo/test.mp3",path)
            inputCutName.text = ""
        }
    }
    MySquareButton{
        text: qsTr("文件列表")
        textColor: "black"
        defaultColor: "gray"
        opacity: 0.5
        anchors.top: radioBtn.bottom
        anchors.topMargin: 20
        width: playlist.width
    }
    PlayList{
        id: playlist
        width: parent.width / 5 * 1;
        anchors.left: parent.left;
        anchors.top: radioBtn.bottom;
        anchors.topMargin: 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 110
    }
    //合并按钮
    MyRadioButton{
        radius: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        anchors.left: parent.left;
        anchors.leftMargin: (playlist.width - width)/2
        imgSource: "images/合并.svg"
        opacity: 0.2
        imgWidth: 40
        imgHeight: 40
        color: "gray"

        onClicked:{
            if(dialogs.fileOpenDialog.fileUrls.length === 0)
            {
                dialogs.messageDialog.mytext = "请导入视频资源!"
                dialogs.openMessageDialog()
            }else{
                nowFilePath.length = 0
                if(!playlist.isHasChecked())
                {
                    dialogs.openMessageDialog();
                }
                var fileNames = dialogs.fileOpenDialog.fileUrls

                for (var i = 0;i < playlist.sum.length;i++)
                {
                    if(playlist.sum[i] !== 0)
                    {
                        nowFilePath.push(fileNames[i]);
                    }
                }
                for (var i = 0;i < playlist.queue.length;i++)
                {
                    console.log("queue[" + i + "] = " + fileNames[playlist.queue[i]]);
                }
                dialogs.openSaveMergeDialog()
            }


        }
    }
    DisPlay{
        id: display
        height: parent.height / 8 * 7;
        anchors.left: playlist.right
        anchors.leftMargin: 10
        anchors.top: radioBtn.bottom;
        anchors.topMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 30
    }

    Rectangle{
        anchors.top: display.bottom
        anchors.bottom: parent.bottom
        anchors.left: playlist.right
        BottomContainer{
            id: bottomContainer
            x: 269
            y: -102
            width: 499
            height: 85

            playButton.onClicked: {
                console.log("play")
                if(display.mediaPlayer.playbackState === 1) {
                    display.mediaPlayer.pause()
                    playButton.imgSource = "images/播放 三角形.svg"
                }else {
                    display.mediaPlayer.play()
                    playButton.imgSource = "images/暂停2.svg"
                }
            }
            cutButton.onClicked: {
                if(display.slider.visible == true)//当前在播放模式 切换到裁剪模式
                {
                    cutflag = 1
                    display.slider.visible = false
                    display.rangeSlider.visible = true

                    console.log("cutButton.onClicked 当前已切换成裁剪模式")
                    console.log("display.slider.visible" + display.slider.visible)
                    console.log("display.rangeSlider.visible" + display.rangeSlider.visible)

                    cutButton.imgSource = "images/裁剪1"
                }
                else//当前在裁剪模式 切换到播放模式
                {
                    cutflag = 0
                    display.rangeSlider.visible = false
                    display.slider.visible = true
                    console.log("cutButton.onClicked 当前已切换成播放模式")
                    console.log("display.slider.visible" + display.slider.visible)
                    console.log("display.rangeSlider.visible" + display.rangeSlider.visible)

                    cutButton.imgSource = "images/等待.svg"
                }
                display.mediaPlayer.pause()
                playButton.imgSource = "images/播放 三角形.svg"
            }
            finishButton.onClicked: {
                if(cutflag === 1)
                {
                    console.log("finishButton")
                    dialogs.openSaveCutDialog();
                }
                else {
                    dialogs.messageDialog.title = "提醒"
                    dialogs.messageDialog.mytext = "完成视频前请再次点击裁剪按钮切换到视频裁剪模式"
                    dialogs.openMessageDialog()
                }
            }
        }
    }

    VideoEdit{
        id: videoEdit
    }
}

