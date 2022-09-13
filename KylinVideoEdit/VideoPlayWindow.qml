import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.12

Item{
    //--------------
    property alias picInPicWindow: picInPicWindow
    property alias mediaPlayer: player
    property alias playbackState: player.playbackState
    property alias playlists: player.playlists
    property alias playBtn: playBtn
    property alias backBtn: backBtn
    property alias forwardBtn: forwardBtn
    property alias speedBtn: speedBtn
    property alias fullScreenBtn: fullScreenBtn
    property alias volumnBtn: volumnBtn
    property alias image: image
    property alias slider: slider
    property alias rangeSlider:rangeSlider

    property alias timeText: curText.text
    //时间格式转换函数
    function currentTime(time)
    {
        var sec= Math.floor(time/1000);
        var hours=Math.floor(sec/3600);
        var minutes=Math.floor((sec-hours*3600)/60);
        var seconds=sec-hours*3600-minutes*60;
        var hh,mm,ss;
        if(hours.toString().length<2)
            hh="0"+hours.toString();
        else
            hh=hours.toString();
        if(minutes.toString().length<2)
            mm="0"+minutes.toString();
        else
            mm=minutes.toString();
        if(seconds.toString().length<2)
            ss="0"+seconds.toString();
        else
            ss=seconds.toString();
        return hh+":"+mm+":"+ss
    }
    //1.视频播放窗口
    Rectangle{
        id: video
        width: parent.width
        height: parent.height / 9 * 7
        anchors.top: parent.top
        MediaPlayer {
            id: player
            //播放列表
            property alias playlists: playlists
            playlist: Playlist{
                id: playlists
            }
            loops: 4
            onPositionChanged: {
                if(slider.visible === true)//播放状态
                {
                    curText.text = currentTime(player.position) + " / " + currentTime(player.duration)

                }else{//裁剪状态
                    curText.text = currentTime(first.value) + " / " + currentTime(second.value)
                }
            }
        }
        VideoOutput{
            id: videoOutput;
            width: parent.width
            height: parent.height
            anchors.top: parent.top
            source: player
        }
        Rectangle{
            id:image
            width: parent.width
            height: parent.height
            anchors.top: parent.top
            Image {
                anchors.fill: parent
                id: name
                source: "images/壁纸.png"
            }
        }
        //增加画中画
        MyDragRectangle{
            id: picInPicWindow
            z:10
            visible: false;
            width: 480;
            height: 240;
            dragBackground: video;
        }
    }
    //2.进度 播放控制
    Rectangle{
        width: parent.width
        height: parent.height / 9 * 2
        anchors.top: video.bottom
        //进度条
        MySlider{
            id: slider
            visible: true
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top + 5;
            from: 0
            to: player.duration
            stepSize: 1
            value: player.position
            onValueChanged: {
                player.seek(slider.value)
            }
        }
        MyRangeSlider{ //裁剪进度条
            id: rangeSlider
            visible: false
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top + 5;
            from: 0
            to: player.duration
            first.value: player.duration / 3
            second.value: player.duration / 3 * 2
            first.onMoved: {
                player.seek(first.value)
                curText.text = currentTime(first.value) + " / " + currentTime(second.value)
                timer.interval = second.value - first.value
                timer.running = true
            }
            second.onMoved: {        
                player.seek(second.value)
                curText.text = currentTime(first.value) + " / " + currentTime(second.value)
            }
        }
        Timer{ //用于选择时间段播放的定时器
            id: timer
            running: false;
            repeat: false;
            onTriggered: player.pause();
        }
        //时间 播放控制
        Rectangle{
            anchors.top: slider.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            //时间显示
            Rectangle{
                anchors.left: parent.left
                height: 48
                width: parent.width / 3
                MySquareButton{
                    id: curText
                    anchors.left: parent.left;
                    text: currentTime(player.position) + " / " + currentTime(player.duration)
                    textColor: "black"
                    width: 220
                    height: 60
                    defaultColor: "gray"
                    opacity: 0.5
                }
            }
            Rectangle{
                id: playControl
                anchors.right: parent.right
                anchors.rightMargin: 25
                height: 48
                width: parent.width / 3 * 2
                MySquareButton{
                    id:backBtn
                    anchors.right: playBtn.left
                    anchors.rightMargin: 10
                    width: 50
                    height: 60
                    defaultColor: "gray"
                    opacity: 0.5
                    imgSource: "images/后退.svg"
                    onClicked:
                    {
                        player.seek(player.position - 5000)
                    }
                }
                MySquareButton{
                    id: forwardBtn
                    anchors.right: speedBtn.left
                    anchors.rightMargin: 10
                    width: 50
                    height: 60
                    defaultColor: "gray"
                    opacity: 0.5
                    imgSource: "images/快进.svg"
                    onClicked:
                    {
                        player.seek(player.position + 5000)
                    }
                }
                MySquareButton{
                    id: playBtn
                    anchors.right: forwardBtn.left
                    anchors.rightMargin: 10
                    width: 50
                    height: 60
                    defaultColor: "gray"
                    opacity: 0.5
                    imgSource: "images/播放.svg"
                    onClicked:
                    {
                        if(player.playbackState == 1)
                        {
                            player.pause()
                            playBtn.imgSource = "images/播放.svg"
                        }
                        else
                        {
                            player.play()
                            playBtn.imgSource = "images/暂停.svg"
                        }

                    }
                }
                MySquareButton{
                    id: speedBtn
                    anchors.right: fullScreenBtn.left
                    anchors.rightMargin: 10
                    width: 50
                    height: 60
                    defaultColor: "gray"
                    opacity: 0.5
                    text: "倍速"
                    textColor: "black"
                    onClicked:
                    {
                        if(speedRec.visible === false)
                        {
                            speedRec.visible = true
                        }
                        else
                        {
                            speedRec.visible = false
                        }
                    }
                    Rectangle
                    {
                        id: speedRec
                        width: speedBtn.width
                        height: 75
                        visible: false
                        Column
                        {
                            anchors.bottom: parent.top
                            Rectangle
                            {
                                id: speed_half
                                width: speedBtn.width
                                height: 25
                                color: "gray"
                                Text
                                {
                                    anchors.centerIn: parent
                                    text: qsTr("0.5")
                                }
                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        player.playbackRate = 0.5
                                        speedRec.visible = false
                                    }
                                }
                            }
                            Rectangle
                            {
                                id: speed_one
                                width: speedBtn.width
                                height: 25
                                color: "gray"
                                Text
                                {
                                    anchors.centerIn: parent
                                    text: qsTr("1")
                                }
                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        player.playbackRate = 1
                                        speedRec.visible = false
                                    }
                                }
                            }
                            Rectangle
                            {
                                id: speed_two
                                width: speedBtn.width
                                height: 25
                                color: "gray"
                                Text
                                {
                                    anchors.centerIn: parent
                                    text: qsTr("2")
                                }
                                MouseArea
                                {
                                    anchors.fill: parent
                                    onClicked:
                                    {
                                        player.playbackRate = 2
                                        speedRec.visible = false
                                    }
                                }
                            }
                        }
                    }
                }
                MySquareButton{
                    id: fullScreenBtn
                    anchors.right: volumnBtn.left
                    anchors.rightMargin: 10
                    width: 50
                    height: 60
                    defaultColor: "gray"
                    opacity: 0.5
                    imgSource: "images/全屏.svg"
                }
                MySquareButton{
                    id: volumnBtn
                    anchors.right: playControl.right
                    width: 50
                    height: 60
                    defaultColor: "gray"
                    opacity: 0.5
                    imgSource: "images/音量.svg"
                    onClicked:
                    {
                        if(audioSlider.visible == true)
                        {
                            audioSlider.visible = false
                        }
                        else
                        {
                            audioSlider.visible = true
                        }
                    }
                    Slider{//进度条
                        id: audioSlider
                        visible: false
                        orientation: Qt.Vertical
                        height: 100
                        width: 10
                        anchors.bottom: volumnBtn.top
                        anchors.left: volumnBtn.left
                        anchors.leftMargin: (volumnBtn.width - width) / 2
                        to:100
                        from: 0
                        stepSize: 1
                        value: 100
                        onValueChanged:
                        {
                            player.volume = audioSlider.value / 100
                        }
                    }
                }
            }
        }
    }
}
