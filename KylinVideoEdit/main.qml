import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import VideoEdit 1.0
import AudioEdit 1.0
import QtQml 2.15

Window {
    property var inputFilepaths: []
    property var fileUrls: []
    property var musicFile//背景音乐文件路径
    property var picFile//画中画图片文件路径

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
        //打开添加背景音乐窗口
        musicBtn.onClicked: {
            //用户没有导入视频资源文件
            if(dialogs.videoFileDialog.fileUrls.length === 0){
                dialogs.messageDialog.mytext = "请导入视频资源"
                dialogs.openMessageBox();
            }

            //用户导入了视频资源文件但是没有选中视频
            if(dialogs.videoFileDialog.fileUrls.length !== 0 && !videoPlayList.isChecked())
            {
                dialogs.messageDialog.mytext = "请选择视频"
                dialogs.openMessageBox();
            }

            //用户导入了视频资源文件且选中了视频
            if(dialogs.videoFileDialog.fileUrls.length !== 0 && videoPlayList.isChecked())
            {
                //1.打开背景音乐对话框
                dialogs.openAddBackgroundMusicDialog()
                //2.初始化背景音乐列表
                dialogs.bgMusicPlayList.selectMusicFiles(fileUrls)
                //3.视频终止
                videoPlayWindow.mediaPlayer.pause()
                //4.音频终止
                audioPlayWindow.mediaPlayer.pause()
            }
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
            videoPlayList.sum.length = videoPlayWindow.playlists.itemCount
            for(var j = 0; j < videoPlayList.sum.length; j++){
                videoPlayList.sum[j] = 0;
                audioPlayList.sum[j] = 0;
            }
            //3.画中画清除
            dialogs.addPicInPicDialog.targetVideoIndex = -1;

        }
        //2.音频文件对话框
        audioFileDialog.onAccepted: {
            videoPlayWindow.image.visible = false

            var fileNames = dialogs.audioFileDialog.fileUrls


            //1.定义显示的数据模型
            audioPlayList.selectFiles(fileNames)

            //2.初始化数据项个数
            audioPlayList.sum.length = audioPlayWindow.playlists.itemCount
            for(var j = 0; j < audioPlayList.sum.length; j++){
                audioPlayList.sum[j] = 0;
                videoPlayList.sum[j] = 0;
            }
        }
        //3.保存文件对话框
        saveDialog.onAccepted:{
            videoPlayWindow.mediaPlayer.pause()
            audioPlayWindow.mediaPlayer.pause()
            videoEdit.finishFile(dialogs.saveDialog.saveFileName)
            dialogs.saveDialog.saveDialog.close()
        }

        //4.背景音乐选择对话框
        musicSelectDialog.onAccepted: {
            //1）被点击背景音乐停止播放
            dialogs.addBackgroundMusicDialog.bgMusicPlayWindow.mediaPlayer.pause();
            //2)显示选择列表项
            dialogs.addBackgroundMusicDialog.bgMusicPlayWindow.playlists.addItems(musicSelectDialog.fileUrls)
            musicFile = dialogs.musicSelectDialog.fileUrl//获取背景音乐的文件路径
        }

        //选择背景音乐窗口
        addBackgroundMusicDialog.onAccepted: {
            if(dialogs.addBackgroundMusicDialog.checkBoxState){//添加背景音乐，去除视频原声
                videoEdit.addBackgroundMusic_1(videoPlayWindow.mediaPlayer.playlist.currentItemSource, musicFile,videoPlayWindow.mediaPlayer.duration / 1000)

                var sumLen = videoPlayList.sum.length
                for (var i = 0;i < sumLen;i++){
                    videoPlayList.sum[i] = 0
                    audioPlayList.sum[i] = 0
                }
                videoPlayWindow.mediaPlayer.playlist.clear()
                videoPlayWindow.mediaPlayer.playlist.addItem("file://" + appPath + "/新视频.mp4")
                dialogs.addBackgroundMusicDialog.close()
            }else{
                //添加背景音乐，不去除视频原音
                videoEdit.addBackGroundMusic_2(videoPlayWindow.mediaPlayer.playlist.currentItemSource, musicFile)
                var sumLen = videoPlayList.sum.length
                for (var i = 0;i < sumLen;i++){
                    videoPlayList.sum[i] = 0
                    audioPlayList.sum[i] = 0
                }
                videoPlayWindow.mediaPlayer.playlist.clear()
                videoPlayWindow.mediaPlayer.playlist.addItem("file://" + appPath + "/新视频.mp4")
                dialogs.addBackgroundMusicDialog.close()
            }
        }

        //5.画中画选择素材库确认选择
        addPicInPicDialog.acceptBtn.onClicked: {
            //1)切换当前目标视频索引
            addPicInPicDialog.targetVideoIndex = videoPlayWindow.playlists.currentIndex//当前列表项为画中画显示列表
            //2)画中画窗口显示
            videoPlayWindow.picInPicWindow.visible = true;
            videoPlayWindow.picInPicWindow.selectPicSource = addPicInPicDialog.finalPic
        }

        //6.画中画选择本地
        picInPicSelectDialog.onAccepted: {
            for(var i = 0; i < picInPicSelectDialog.fileUrls.length; i++)
            {
                dialogs.addPicInPicDialog.fileNames.push(dialogs.picInPicSelectDialog.fileUrls[i])
            }
            dialogs.addPicInPicDialog.displayImageByGrid()

            addPicInPicDialog.targetVideoIndex = videoPlayWindow.playlists.currentIndex//当前列表项为画中画显示列表

        }

        //7.截图
        screenShotDialog.onAccepted: {
            videoEdit.screenshot(videoPlayWindow.mediaPlayer.playlist.currentItemSource, 8,dialogs.screenShotDialog.saveFileName)
            dialogs.screenShotDialog.close()
        }

        //8.视频拆分
        videoSplitDialog.onAccepted: {
            var outputPath1 = dialogs.videoSplitDialog.saveFileName1 + ".mp4";
            var outputPath2 = dialogs.videoSplitDialog.saveFileName2 + ".mp4";

            videoEdit.videoSplit(videoPlayWindow.mediaPlayer.playlist.currentItemSource,outputPath1,outputPath2,videoPlayWindow.mediaPlayer.position/1000,videoPlayWindow.mediaPlayer.duration)
            dialogs.videoSplitDialog.close()
        }

        //9.音频拆分
        audioSplitDialog.onAccepted: {
            var outputPath1 = dialogs.audioSplitDialog.saveFileName1 + ".mp3";
            var outputPath2 = dialogs.audioSplitDialog.saveFileName2 + ".mp3";

            audioEdit.audioSplit(audioPlayWindow.mediaPlayer.playlist.currentItemSource,outputPath1,outputPath2,audioPlayWindow.mediaPlayer.position/1000,audioPlayWindow.mediaPlayer.duration)
            dialogs.audioSplitDialog.close()
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
        id: videoButton
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
    //定位修改
    PlayList{
        id: videoPlayList
        currentPlayWindow: videoPlayWindow
        width: fileListBtn.width
        anchors.left: parent.left;
        anchors.top: videoButton.bottom;
        anchors.topMargin: 5
        height: (videoPlayWindow.height - fileListBtn.height - videoButton.height * 2)/2 - 20
        onPlay: {
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
        anchors.topMargin: 10
        height: fileListBtn.height - 6
        onClicked:
        {
            dialogs.openAudioFileDialog()
        }
    }
    //定位修改
    PlayList{
        id: audioPlayList
        currentPlayWindow: audioPlayWindow
        width: fileListBtn.width
        anchors.left: parent.left;
        anchors.top: audioButton.bottom;
        anchors.topMargin: 5;
        height: videoPlayList.height
        onPlay: {
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
        anchors.left: videoPlayList.right
        anchors.leftMargin: 10
        anchors.top: header.bottom;
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.bottom: editToolBar.top
        anchors.bottomMargin: 15

    }
    //音频播放窗口 默认为不可见
    AudioPlayWindow{
        id: audioPlayWindow;
        visible: false
        anchors.left: videoPlayList.right
        anchors.leftMargin: 10
        anchors.top: header.bottom;
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.bottom: editToolBar.top
        anchors.bottomMargin: 15
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
            inputFilepaths = []
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

                videoPlayList.chosedSource = videoPlayList.reverse(videoPlayList.chosedSource);
                videoPlayList.chosedSource =  videoPlayList.unique(videoPlayList.chosedSource);
                videoPlayList.chosedSource = videoPlayList.reverse(videoPlayList.chosedSource);
                videoPlayList.chosedSource = videoPlayList.check(videoPlayList.chosedSource)

                var fileNames = []
                for(var i = 0; i < videoPlayWindow.playlists.itemCount; i++)
                {
                    fileNames.push(videoPlayWindow.playlists.itemSource(i))
                }

                for (i = 0; i < videoPlayList.chosedSource.length;i++)
                {
                    inputFilepaths.push(fileNames[videoPlayList.chosedSource[i]])
                }
                videoPlayWindow.mediaPlayer.pause()
                videoEdit.videoMerge(inputFilepaths)

                var sumLen = videoPlayList.sum.length
                for (var i = 0;i < sumLen;i++){
                    videoPlayList.sum[i] = 0
                    audioPlayList.sum[i] = 0
                }
                videoPlayWindow.mediaPlayer.playlist.clear()
                videoPlayWindow.mediaPlayer.playlist.addItem("file://" + appPath + "/新视频.mp4")//生成临时文件

            }
            //用户只选择了音频资源文件
            if(audioPlayList.isHasChecked() && !videoPlayList.isChecked())
            {
                audioPlayList.chosedSource = audioPlayList.reverse(audioPlayList.chosedSource);
                audioPlayList.chosedSource =  audioPlayList.unique(audioPlayList.chosedSource);
                audioPlayList.chosedSource = audioPlayList.reverse(audioPlayList.chosedSource);
                audioPlayList.chosedSource =  audioPlayList.check(audioPlayList.chosedSource)

                //                var fileNames = dialogs.audioFileDialog.fileUrls
                var fileNames = []
                for(var i = 0; i < audioPlayWindow.playlists.itemCount; i++)
                {
                    fileNames.push(audioPlayWindow.playlists.itemSource(i))
                }

                for (var i = 0; i < audioPlayList.chosedSource.length;i++)
                {
                    inputFilepaths.push(fileNames[audioPlayList.chosedSource[i]])
                }
                audioPlayWindow.mediaPlayer.pause();
                audioEdit.audioMerge(inputFilepaths);

                var sumLen = audioPlayList.sum.length
                for (var i = 0;i < sumLen;i++){
                    audioPlayList.sum[i] = 0
                    videoPlayList.sum[i] = 0
                }
                audioPlayWindow.mediaPlayer.playlist.clear();
                audioPlayWindow.mediaPlayer.playlist.addItem("file://" + appPath + "/新音频.mp3")//生成临时文件
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
                    videoPlayWindow.playBtn.imgSource = "images/播放.svg"
                    videoPlayWindow.mediaPlayer.pause()
                    dialogs.videoSplitDialog.open()
                }
                //音频
                if(audioPlayWindow.visible === true && audioPlayList.isChecked())
                {
                    audioPlayWindow.playBtn.imgSource = "images/播放.svg"
                    audioPlayWindow.mediaPlayer.pause()
                    dialogs.audioSplitDialog.open()
                }
            }

        }
        //裁剪
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
                    videoPlayWindow.slider.focus = false //#####
                    videoPlayWindow.rangeSlider.visible = true
                    videoPlayWindow.mediaPlayer.pause();
                }
                //音频
                if(audioPlayWindow.visible === true && audioPlayList.isChecked())
                {
                    audioPlayWindow.slider.focus = false //####
                    audioPlayWindow.slider.visible = false
                    audioPlayWindow.rangeSlider.visible = true
                    audioPlayWindow.mediaPlayer.pause();
                }
                cutBtn.visible = false;
                finishBtn.visible = true
            }
        }
        //完成
        finishBtn.onClicked: {
            if(videoPlayWindow.visible === true)
            {
                videoPlayWindow.slider.visible = true
                videoPlayWindow.slider.focus = true//####
                videoPlayWindow.rangeSlider.visible = false

                videoEdit.videoIntercept(videoPlayWindow.mediaPlayer.playlist.currentItemSource,videoPlayWindow.rangeSlider.first.value/1000, videoPlayWindow.rangeSlider.second.value/ 1000)

                var sumLen = videoPlayList.sum.length
                for (var i = 0;i < sumLen;i++){
                    videoPlayList.sum[i] = 0
                    audioPlayList.sum[i] = 0
                }
                videoPlayWindow.mediaPlayer.playlist.clear()
                videoPlayWindow.mediaPlayer.playlist.addItem("file://" + appPath + "/新视频.mp4")//生成临时文件


                //播放时间显示调整 显示裁剪的时长
                videoPlayWindow.timeText = videoPlayWindow.currentTime(0) + " / " + videoPlayWindow.currentTime( videoPlayWindow.rangeSlider.second.value - videoPlayWindow.rangeSlider.first.value)

            }else{
                audioPlayWindow.slider.focus = true//####
                audioPlayWindow.slider.visible = true
                audioPlayWindow.rangeSlider.visible = false

                audioEdit.audioIntercept(audioPlayWindow.mediaPlayer.playlist.currentItemSource,audioPlayWindow.rangeSlider.first.value/1000, audioPlayWindow.rangeSlider.second.value/1000)

                var sumLen = audioPlayList.sum.length
                for (var i = 0;i < sumLen;i++){
                    videoPlayList.sum[i] = 0
                    audioPlayList.sum[i] = 0
                }
                audioPlayWindow.mediaPlayer.playlist.clear()
                audioPlayWindow.mediaPlayer.playlist.addItem("file://" + appPath + "/新音频.mp3")//生成临时文件

                //播放时间显示调整 显示裁剪的时长
                audioPlayWindow.timeText = audioPlayWindow.currentTime(0) + " / " + audioPlayWindow.currentTime(audioPlayWindow.rangeSlider.second.value - audioPlayWindow.rangeSlider.first.value)
            }
            finishBtn.visible = false
            cutBtn.visible = true
        }

        //画中画 (新增对话框)
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
                //弹出画中画对话框
                videoPlayWindow.mediaPlayer.pause();
                dialogs.addPicInPicDialog.open()
                dialogs.addPicInPicDialog.displayImageByGrid()
            }
        }

        Connections{
            target: dialogs.addPicInPicDialog
            onAccepted:{
                picFile = path//获取画中画图片文件的路径
            }
        }

        Connections{
            target: videoPlayWindow.picInPicWindow
            onAccepted:{

                videoEdit.addPicInPic(videoPlayWindow.mediaPlayer.playlist.currentItemSource,picFile,videoPlayWindow.picInPicWindow.x,videoPlayWindow.picInPicWindow.y)//进行添加画中画的操作

                var sumLen = videoPlayList.sum.length
                for (var i = 0;i < sumLen;i++){
                    videoPlayList.sum[i] = 0
                    audioPlayList.sum[i] = 0
                }

                videoPlayWindow.mediaPlayer.playlist.clear()
                videoPlayWindow.mediaPlayer.playlist.addItem("file://" + appPath + "/新视频.mp4")//生成临时文件
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
                videoPlayWindow.mediaPlayer.pause();
                dialogs.screenShotDialog.open();
            }
        }
    }

    onClosing:{
        videoEdit.clearVideoFiles();
        audioEdit.clearAudioFiles();
    }

    VideoEdit
    {
        id: videoEdit
    }
    Component.onCompleted: {
        videoEdit.start.connect(openWaitFinishDialog)
        videoEdit.finish.connect(closeWaitFinishDialog)
        audioEdit.start.connect(openWaitFinishDialog)
        audioEdit.finish.connect(closeWaitFinishDialog)
    }
    AudioEdit
    {
        id:audioEdit
    }
    function openWaitFinishDialog()
    {
        waitFinishDialog.open();
    }
    function closeWaitFinishDialog()
    {
        waitFinishDialog.close()
    }
    Dialog{
        id: waitFinishDialog
        anchors.centerIn: parent
        contentItem: Text{
            id: text
            text: qsTr("当前操作完成, 请进行后续操作")
            anchors.fill: parent
            wrapMode: Text.WordWrap
            font.family: "Arial"
            font.weight: Font.Thin
            font.pixelSize: 17
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}


