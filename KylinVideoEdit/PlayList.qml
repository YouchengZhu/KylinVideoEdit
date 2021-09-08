import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.12

Item {
    property alias view: view
    signal play();
    signal pauseVideo()
    signal pauseAudio()
    property var sum: []
    property var chosedSource: []
    property alias listModel: view.model//对应两个音视频播放窗口
    property var currentPlayWindow;//当前列表对应播放窗口
    signal click();//列表数据项点击激发信号

    //函数一: 判断当前列表项中是否有不少于两个列表项被点击
    function isHasChecked()
    {
        var count = 0;
        for(var i = 0; i < sum.length;i++)
        {
            if(sum[i] % 2 == 0) {
                sum[i] = 0;
                continue;
            }
            count++;
            if(count >= 2) return true;
        }
        return false;
    }
    function selectFiles(fileNames)
    {
        currentPlayWindow.playlists.clear();
        for(var i = 0; i < fileNames.length; i++)
        {
            currentPlayWindow.playlists.addItem(fileNames[i])
        }
    }

    //函数二：判断当前列表项中是否有列表项被点击
    function isChecked()
    {
        var count = 0;
        for(var i = 0; i < sum.length;i++)
        {
            if(sum[i] % 2 == 0) {
                sum[i] = 0;
                continue;
            }
            count++;
            if(count > 0) return true;
        }
        return false;
    }

    //转换文件路径名
    function convertFileName(source)
    {
        var pos = JSON.stringify(source).lastIndexOf('/');
        var name = JSON.stringify(source).substr(pos + 1);
        var finalName = name.substr(0, name.length - 1);
        return finalName;
    }
    Rectangle{
        anchors.fill: parent
        color: "#F7F7F7"
        ListView{
            id: view
            anchors.fill: parent
            //显示播放列表中的文件路径
            model: currentPlayWindow.playlists
            clip: true
            spacing: 3
            focus: true
            currentIndex: -1
            property var lastCurrentIndex: -1;
            delegate: Rectangle{
                id: rect;
                height: 50
                width: parent.width;
                radius: 5;
                border.color: Qt.lighter(color, 1.1)
                border.width: 5
                color: "#EEEEEE"
                //可选择项
                CheckDelegate
                {
                    id: box;
                    height: 50
                    width: parent.width
                    text: "         ";
                    checked: false
                    //设置字体
                    Text{
                        anchors.fill: parent
                        anchors.leftMargin: 15;
                        anchors.rightMargin: 50
                        anchors.centerIn: parent
                        font.pixelSize: 20
                        verticalAlignment: Text.AlignVCenter
                        color: "black"
                        elide: Text.ElideRight
                        text: convertFileName(source);
                        font.family: "Arial"
                        font.weight: Font.Thin
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: {
                        console.log(source)
                        //点击列表项为视频
                        if(currentPlayWindow === videoPlayWindow)
                        {
                            //1.调整窗口可见性
                            audioPlayWindow.visible = false;
                            videoPlayWindow.visible = true
                            //2.将音频暂停
                            pauseAudio();
                        }else//点击列表项为音频
                        {
                            //1.调整窗口可见性
                            audioPlayWindow.visible = true;
                            videoPlayWindow.visible = false;
                            //2.将视频暂停
                            pauseVideo();
                        }
                        //当前列表项为点击列表项
                        currentPlayWindow.playlists.currentIndex = index
                        //调整播放图标 未写代码
                        //设置播放
                        if(currentPlayWindow.playbackState !== MediaPlayer.PlayingState){
                            play();
                         }
                        if (view.lastCurrentIndex != -1) {
                            if(view.itemAtIndex(view.lastCurrentIndex)){
                                view.itemAtIndex(view.lastCurrentIndex).color = "#EEEEEE"
                            }
                        }
                        view.currentIndex = index
//                        if(view.lastCurrentIndex != index)
//                        {
//                            videoDisplay.rangeSlider.visible = false
//                            videoDisplay.slider.visible = true
//                            videoDisplay.rangeSlider.first.value = 0
//                            videoDisplay.rangeSlider.second.value = 0
//                        }
                        color = "#CCCCCC"
                        view.lastCurrentIndex = index

                        box.checked = !(box.checked)
                        sum[view.currentIndex]++;//当前列表项点击数++
                        //记录点击顺序
                        if(sum[view.currentIndex] % 2 != 0) {
                            console.log(view.currentIndex)
                            chosedSource.push(view.currentIndex)
                        }
                    }
                    onEntered:{
                        if(view.currentIndex == index)
                        {
                            return
                        }
                        color = "#D5D5D5"
                    }
                    onExited: {
                        if(view.currentIndex == index)
                        {
                            return
                        }
                        color = "#EEEEEE"
                    }
                }
            }
        }
    }

}
