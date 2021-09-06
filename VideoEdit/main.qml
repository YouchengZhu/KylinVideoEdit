import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtMultimedia 5.12
import VideoEdit 1.0
import QtQuick.Window 2.0
Window {
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
                    dialogs.openVideoFileDialog();
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
    Dialogs{
        id:dialogs
        videoFileDialog.onAccepted:
        {
            videoDisplay.image.visible = false
            var fileNames = dialogs.videoFileDialog.fileUrls;
            videoPlaylist.selectFiles(fileNames);
            videoPlaylist.sum.length = fileNames.length
            for(var i = 0; i < videoPlaylist.sum.length; i++)
                videoPlaylist.sum[i] = 0;
            videoDisplay.rangeSlider.visible = false
            videoDisplay.slider.visible = true
        }
        //保存裁剪文件
        saveCutDialog.onAccepted: {
            openInputCutFileNameDialog();
        }
        inputCutFileNameDialog.onYes: {//从用户处获取文件名
            console.log("inputFileNameDialog.onYes")
            var dstSource = saveCutDialog.folder +"/" +inputCutName.text + ".mp4";
            console.log("dstSource"+dstSource)
            videoEdit.videoIntercept(videoDisplay.mediaPlayer.playlist.currentItemSource, dstSource, videoDisplay.rangeSlider.first.value/1000, videoDisplay.rangeSlider.second.value/1000);
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
            videoEdit.videoMerge(nowFilePath,dstName,dstPath)
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
        width: videoPlaylist.width
    }
    VideoPlayList{
        id: videoPlaylist
        width: parent.width / 5 * 1;
        anchors.left: parent.left;
        anchors.top: radioBtn.bottom;
        anchors.topMargin: 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 110
    }
    //视频合并按钮
    MyRadioButton{
        id: mergeBtn
        radius: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        anchors.left: parent.left;
        anchors.leftMargin: (videoPlaylist.width - width)/2
        imgSource: "images/合并.svg"
        opacity: 0.2
        imgWidth: 40
        imgHeight: 40
        color: "gray"

        onClicked:{
            if(dialogs.videoFileDialog.fileUrls.length === 0)
            {
                dialogs.messageDialog.mytext = "请导入视频资源!"
                dialogs.openMessageDialog()
            }else{
                nowFilePath.length = 0
                if(!videoPlaylist.isHasChecked())
                {
                    dialogs.openMessageDialog();
                }
                var fileNames = dialogs.videoFileDialog.fileUrls

                for (var i = 0;i < videoPlaylist.sum.length;i++)
                {
                    if(videoPlaylist.sum[i] !== 0)
                    {
                        nowFilePath.push(fileNames[i]);
                    }
                }
                dialogs.openSaveMergeDialog()
            }
        }
    }
    VideoDisPlay{
        id: videoDisplay
        height: parent.height / 8 * 7;
        anchors.left: videoPlaylist.right
        anchors.leftMargin: 10
        anchors.top: radioBtn.bottom;
        anchors.topMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 30
    }

    Rectangle{

        anchors.top: mergeBtn.top
        anchors.bottom: parent.bottom
        anchors.left: videoPlaylist.right
        VideoBottomContainer{
            id:videoBottomContainer
            width: 499
            height: 85
            x: (videoDisplay.width - width)/2
            playButton.onClicked: {
                console.log("play")
                if(videoDisplay.mediaPlayer.playbackState === 1) {
                    videoDisplay.mediaPlayer.pause()
                    playButton.imgSource = "images/播放 三角形.svg"
                }else {
                    videoDisplay.mediaPlayer.play()
                    playButton.imgSource = "images/暂停2.svg"
                }
            }
            cutButton.onClicked: {
                if(videoDisplay.slider.visible == true)//当前在播放模式 切换到裁剪模式
                {
                    cutflag = 1
                    videoDisplay.slider.visible = false
                    videoDisplay.rangeSlider.visible = true

                    console.log("cutButton.onClicked 当前已切换成裁剪模式")
                    console.log("display.slider.visible" + videoDisplay.slider.visible)
                    console.log("display.rangeSlider.visible" + videoDisplay.rangeSlider.visible)

                    cutButton.imgSource = "images/裁剪1"
                }
                else//当前在裁剪模式 切换到播放模式
                {
                    cutflag = 0
                    videoDisplay.rangeSlider.visible = false
                    videoDisplay.slider.visible = true
                    console.log("cutButton.onClicked 当前已切换成播放模式")
                    console.log("videodisplay.slider.visible" + videoDisplay.slider.visible)
                    console.log("videodisplay.rangeSlider.visible" + videoDisplay.rangeSlider.visible)

                    cutButton.imgSource = "images/等待.svg"
                }
                videoDisplay.mediaPlayer.pause()
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


/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
