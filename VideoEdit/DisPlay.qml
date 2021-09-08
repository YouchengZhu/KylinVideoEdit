import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.12

Item {
    property alias video: video
    property alias mediaPlayer: player
    property alias playWindow: playWindow
    property alias slider: slider
    property alias rangeSlider: rangeSlider
    property alias image: image

    //播放进度条时间转换
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


    Rectangle{
        id:video
        width: parent.width;
        height: parent.height / 5 * 4;
        anchors.top: parent.top;
        MediaPlayer {
            id: player
            property alias playlists:playlists
            playlist: Playlist{
                id: playlists
            }
            loops: 4
            //            volume: 0.5
            //存放播放的资源
        }
        //绑定并加载容器中的资源，默认为不播放。
        VideoOutput {
            id:playWindow
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

        MouseArea{
            anchors.fill: parent
            onClicked:{
                player.play()
            }
        }
    }
    Row{
        id: rowMid
        anchors.top: video.bottom
        anchors.topMargin: 5
        width:parent.width
        height: 55
        Rectangle{
            id: start
            color: "#ecf6ff"
            width: playWindow.width / 7 - 46
            height: 48
            anchors.left: parent.left
            anchors.leftMargin: 5
            opacity: 1
            Text{//显示视频播放时间
                text: currentTime(player.position)
                anchors.centerIn: parent;
            }
        }
        Slider{//进度条
            id: slider
            visible: true
            anchors.left: start.right
            anchors.right: finish.left
            to:player.duration
            from: 0
            stepSize: 1
            value: player.position
            onValueChanged: {
                player.seek(slider.value)
                //                player.play()
            }
        }

        Timer{ //用于选择时间段播放的定时器
            id: timer
            running: false;
            repeat: false;
            onTriggered: player.pause();
        }

        RangeSlider{ //裁剪进度条
            id: rangeSlider
            visible: false
            anchors.left: start.right
            anchors.right: finish.left
            from: 0
            to: player.duration
            first.value: 0
            second.value: player.duration
            first.onMoved: {
                console.log(first.value)
                player.seek(first.value)
                //                player.play()
                timer.interval = second.value - first.value
                timer.running = true
            }
            second.onMoved: {
                finishText.text = currentTime(second.value)
                console.log(second.value)
            }
        }

        Rectangle{
            id:finish
            color: "#ecf6ff"
            anchors.right: parent.right
            anchors.rightMargin: 5
            width: playWindow.width / 7 - 46
            height: 48
            Text{//显示视频总时长
                id: finishText
                text:currentTime(player.duration)
                anchors.centerIn: parent
            }
        }
    }
}
