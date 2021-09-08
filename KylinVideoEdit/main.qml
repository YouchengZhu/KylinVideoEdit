import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.0
import VideoEdit 1.0
import AudioEdit 1.0

Window {
    property var inPutFilePath: []
    width: 1280
    height: 900
    visible: true
    minimumWidth: 1480;//界面最小宽
    minimumHeight: 900;//界面最小高

    title: qsTr("麒麟剪辑器")

    Header{
        id: header
        width: parent.width
        finishBtn.onClicked: {
            dialogs.openSaveDialog();
        }
        musicBtn.onClicked: {
//            console.log("music")
//            videoEdit.videoAddBackgroundMusic(videoPlayWindow.mediaPlayer.playlist.currentItemSource, "/root/tmp/test11.mp3", videoPlayWindow.mediaPlayer.duration / 1000, "/root/6.mp4")
            dialogs.openAddBackgroundMusicDialog()
        }
    }
    FileDrawer{
        id: drawer
        height: parent.height
    }
    Dialogs{
        id: dialogs
        //1.视频文件对话框
        videoFileDialog.onAccepted: {
            videoPlayWindow.image.visible = false

            var fileNames = dialogs.videoFileDialog.fileUrls;
            //1.定义显示的数据模型
            videoPlayList.selectFiles(fileNames)
            //2.初始化数据项个数
            videoPlayList.sum.length = fileNames.length
            for(var j = 0; j < videoPlayList.sum.length; j++)
                videoPlayList.sum[j] = 0;
        }
        //2.音频文件对话框
        audioFileDialog.onAccepted: {
            videoPlayWindow.image.visible = false

            var fileNames = dialogs.audioFileDialog.fileUrls
            //1.定义显示的数据模型
            audioPlayList.selectFiles(fileNames)
            //2.初始化数据项个数
            audioPlayList.sum.length = fileNames.length
            for(var j = 0; j < audioPlayList.sum.length; j++)
                audioPlayList.sum[j] = 0;

            audioPlayWindow.mediaPlayer.playbackState
        }
        //3.保存文件对话框
        saveDialog.onAccepted:{

        }
    }
    //左侧文件播放列表
    MySquareButton{
        id: fileListBtn
        text: qsTr("文件列表")
        textColor: "black"
        defaultColor: "gray"
        opacity: 0.5
        anchors.top: header.bottom
        anchors.topMargin: 20
        width: parent.width / 5 * 1;
    }
    MySquareButton{
        id: vidioButton
        text: qsTr("视频")
        textColor: "black";
        defaultColor: "gray"
        opacity: 0.5
        anchors.top: fileListBtn.bottom;
        height: fileListBtn.height - 6
        onClicked:
        {
            dialogs.openVideoFileDialog()
        }
    }
    PlayList{
        id: videoPlayList
        currentPlayWindow: videoPlayWindow
        width: fileListBtn.width
        anchors.left: parent.left;
        anchors.top: header.bottom;
        anchors.topMargin: 110
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 110 + videoPlayWindow.height / 2 - 70;
        onPlay: {
            //currentPlayWindow.mediaPlayer.play();
            console.log("视频播放")
            videoPlayWindow.mediaPlayer.play();
            videoPlayWindow.playBtn.imgSource = "images/暂停.svg"

        }
        onPauseAudio: {
            audioPlayWindow.mediaPlayer.pause()
        }
    }
    MySquareButton{
        id: audioButton
        text: qsTr("音频")
        textColor: "black";
        defaultColor: "gray"
        opacity: 0.5
        anchors.top: videoPlayList.bottom;
        height: fileListBtn.height - 6
        onClicked:
        {
            dialogs.openAudioFileDialog()
        }
    }
    PlayList{
        id: audioPlayList
        currentPlayWindow: audioPlayWindow
        width: fileListBtn.width
        anchors.left: parent.left;
        anchors.top: videoPlayList.bottom;
        anchors.topMargin: 50;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 110;
        onPlay: {
            console.log("音频播放")
            audioPlayWindow.mediaPlayer.play();
            audioPlayWindow.playBtn.imgSource = "images/暂停.svg"
        }
        onPauseVideo: {
            videoPlayWindow.mediaPlayer.pause()
        }
    }
    //视频播放窗口
    VideoPlayWindow{
        id: videoPlayWindow;
        height: parent.height / 8 * 7;
        anchors.left: videoPlayList.right
        anchors.leftMargin: 10
        anchors.top: header.bottom;
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.bottom: audioPlayList.bottom
    }
    //音频播放窗口 默认为不可见
    AudioPlayWindow{
        id: audioPlayWindow;
        visible: false
        height: parent.height / 8 * 7;
        anchors.left: videoPlayList.right
        anchors.leftMargin: 10
        anchors.top: header.bottom;
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.bottom: audioPlayList.bottom
    }
    //合并按钮
    MyRadioButton{
        id: mergeBtn
        radius: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        anchors.left: parent.left;
        anchors.leftMargin: (videoPlayList.width - width)/2
        imgSource: "images/合并.svg"
        opacity: 0.2
        imgWidth: 40
        imgHeight: 40
        color: "gray"
        onClicked: {
            inPutFilePath = []
            //用户没有导入任何文件
            if(dialogs.videoFileDialog.fileUrls.length === 0 && dialogs.audioFileDialog.fileUrls.length === 0)
            {
                dialogs.messageDialog.mytext = "请导入一些文件"
                dialogs.openMessageBox();
            }
            //用户没有选择任何资源文件或者选择的资源文件数量少于两个
            if((!videoPlayList.isHasChecked() && !audioPlayList.isHasChecked()) && (dialogs.videoFileDialog.fileUrls.length !== 0 || dialogs.audioFileDialog.fileUrls.length !== 0) )
            {
                dialogs.messageDialog.mytext = "合并前请选择需要进行合并的两个及以上视频或者选择两个及以上的音频！"
                dialogs.openMessageBox()
            }

            //用户同时选择了视频资源文件和音频资源文件的情况
            if(videoPlayList.isChecked() && audioPlayList.isChecked())
            {
                dialogs.messageDialog.mytext = "音视频不可以混选，请重新选择"
                dialogs.openMessageBox()
            }
            //用户只选择了视频资源文件
            if(videoPlayList.isHasChecked() && !audioPlayList.isChecked())
            {
                var fileNames = dialogs.videoFileDialog.fileUrls

                for (var i = 0; i < videoPlayList.chosedSource.length;i++)
                {
                    inPutFilePath.push(fileNames[videoPlayList.chosedSource[i]])
                    console.log(inPutFilePath[i])
                }
                videoEdit.videoMerge(inPutFilePath,"1.mp4","file:///root/")
            }
            //用户只选择了音频资源文件
            if(audioPlayList.isHasChecked() && !videoPlayList.isChecked())
            {
                var fileNames = dialogs.audioFileDialog.fileUrls

                for (var i = 0; i < audioPlayList.chosedSource.length;i++)
                {
                    inPutFilePath.push(fileNames[audioPlayList.chosedSource[i]])
                    console.log(inPutFilePath[i])
                }
                audioEdit.audioMerge(inPutFilePath,"file:///root/1.mp3")
            }
        }
    }

    //底部剪辑工具栏
    EditToolBar{
        id: editToolBar
        width: 499
        height: 85
        anchors.left: videoPlayWindow.left
        anchors.top: mergeBtn.top
        anchors.leftMargin: (videoPlayWindow.width - width)/2
        //拆分
        splitBtn.onClicked:
        {
            //用户没有导入任何文件
            if(dialogs.videoFileDialog.fileUrls.length === 0 && dialogs.audioFileDialog.fileUrls.length === 0)
            {
                dialogs.messageDialog.mytext = "请导入一些文件"
                dialogs.openMessageBox();
            }

            //用户导入了资源文件但是没有选中需要进行操作的文件
            if((!videoPlayList.isChecked() && !audioPlayList.isChecked())&& (dialogs.videoFileDialog.fileUrls.length !== 0 || dialogs.audioFileDialog.fileUrls.length !== 0) )
            {
                dialogs.messageDialog.mytext = "请选择需要进行操作的视频或者音频"
                dialogs.openMessageBox()
            }else{
                //用户选中了需要进行操作的资源文件
                //视频
                if(videoPlayWindow.visible === true && videoPlayList.isChecked())
                {
                    console.log("视频拆分")
                    console.log(videoPlayWindow.mediaPlayer.playlist.currentItemSource)
                    videoEdit.videoSplit(videoPlayWindow.mediaPlayer.playlist.currentItemSource,"/root/1.mp4","/root/2.mp4",5,videoPlayWindow.mediaPlayer.duration)
                }
                //音频
                if(audioPlayWindow.visible === true && audioPlayList.isChecked()){
                    console.log("音频拆分")
                    console.log(videoPlayWindow.mediaPlayer.playlist.currentItemSource)
                    audioEdit.audioSplit(audioPlayWindow.mediaPlayer.playlist.currentItemSource,"/root/1.mp3","/root/2.mp3",5,audioPlayWindow.mediaPlayer.duration)
                }
            }

        }
        //剪辑
        cutBtn.onClicked:
        {

            //用户没有导入任何文件
            if(dialogs.videoFileDialog.fileUrls.length === 0 && dialogs.audioFileDialog.fileUrls.length === 0)
            {
                dialogs.messageDialog.mytext = "请导入一些文件"
                dialogs.openMessageBox();
            }

            //用户导入了文件但是没有进行文件选择
            if ((!videoPlayList.isChecked() && !audioPlayList.isChecked())&& (dialogs.videoFileDialog.fileUrls.length !== 0 || dialogs.audioFileDialog.fileUrls.length !== 0))
            {
                dialogs.messageDialog.mytext = "请选择需要进行操作的视频或者音频"
                dialogs.openMessageBox()
            }else{
                //用户选中了需要进行操作的资源文件
                //视频
                if(videoPlayWindow.visible === true && videoPlayList.isChecked())
                {
                    videoPlayWindow.slider.visible = false
                    videoPlayWindow.rangeSlider.visible = true
                    console.log(videoPlayWindow.rangeSlider.visible)
                    videoEdit.videoIntercept(videoPlayWindow.mediaPlayer.playlist.currentItemSource, "/root/3.mp4", 10, 20)
                }
                //音频
                if(audioPlayWindow.visible === true && audioPlayList.isChecked())
                {
                    audioPlayWindow.slider.visible = false
                    audioPlayWindow.rangeSlider.visible = true
                    console.log(audioPlayWindow.rangeSlider.visible)
                    audioEdit.audioIntercept(audioPlayWindow.mediaPlayer.playlist.currentItemSource,"/root/3.mp3",5, 10)
                }
            }
        }
        //画中画
        picInPicBtn.onClicked:
        {
            //用户没有导入视频资源文件
            if(dialogs.videoFileDialog.fileUrls.length === 0 )
            {
                dialogs.messageDialog.mytext = "请导入一些文件"
                dialogs.openMessageBox();
            }

            //用户导入了视频资源文件但是没有选择
            if(dialogs.videoFileDialog.fileUrls.length !== 0  && !videoPlayList.isChecked()){
                dialogs.messageDialog.mytext = "请选择需要进行操作的视频"
                dialogs.openMessageBox()
            }else{
                videoEdit.addWatermark(videoPlayWindow.mediaPlayer.playlist.currentItemSource, "/root/4.jpg", 40, 40, "/root/5.mp4")
            }
        }
        //截图
        screenShotBtn.onClicked:
        {
            //用户没有导入视频资源文件
            if(dialogs.videoFileDialog.fileUrls.length === 0 )
            {
                dialogs.messageDialog.mytext = "请导入一些文件"
                dialogs.openMessageBox();
            }

            //用户导入了视频资源文件但是没有选择
            if(dialogs.videoFileDialog.fileUrls.length !== 0  && !videoPlayList.isChecked()){
                dialogs.messageDialog.mytext = "请选择需要进行操作的视频"
                dialogs.openMessageBox()
            }else{
                videoEdit.screenshot(videoPlayWindow.mediaPlayer.playlist.currentItemSource, 8, "/root/4.jpg")
            }
        }

    }


    VideoEdit
    {
        id: videoEdit
    }
    AudioEdit
    {
        id:audioEdit
    }
}


